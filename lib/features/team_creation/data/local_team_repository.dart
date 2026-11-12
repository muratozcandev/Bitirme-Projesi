// Takım oluşturma, kadro yönetimi ve randevu kayıt işlemlerini yerel veritabanında yürütür.

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/models/formation.dart';
import '../../../shared/models/match_model.dart';
import '../../../shared/models/team_member_model.dart';
import '../../../shared/models/team_model.dart';
import '../domain/team_repository.dart';

class LocalTeamRepository implements TeamRepository {
  final AppDatabase appDatabase;
  final Uuid _uuid = const Uuid();

  LocalTeamRepository({required this.appDatabase});

  @override
  Future<TeamModel> createTeam({
    required String captainId,
    required String captainName,
    required Formation formation,
    required String province,
    required String district,
    required String venueName,
    required String matchDate,
    required String startTime,
    required String endTime,
    required Map<String, String> lineup,
    String? captainPositionKey,
  }) async {
    if (province.trim().isEmpty ||
        district.trim().isEmpty ||
        venueName.trim().isEmpty ||
        matchDate.trim().isEmpty ||
        startTime.trim().isEmpty ||
        endTime.trim().isEmpty) {
      throw const AppException(
        'Takım oluşturmak için il, ilçe, halı saha, tarih, saat ve diziliş seçilmelidir.',
      );
    }

    final db = await appDatabase.database;

    final duplicateRows = await db.query(
      'teams',
      where:
          'captainId = ? AND province = ? AND district = ? AND venueName = ? AND matchDate = ? AND startTime = ? AND status = ?',
      whereArgs: [
        captainId,
        province,
        district,
        venueName,
        matchDate,
        startTime,
        'active',
      ],
      limit: 1,
    );

    if (duplicateRows.isNotEmpty) {
      throw const AppException(
        'Bu halı saha, tarih ve saat için zaten oluşturulmuş bir takımınız bulunuyor.',
      );
    }

    final now = DateTime.now();
    final teamId = _uuid.v4();
    final matchId = _uuid.v4();

    final validPositionKeys = formation.positions.map((e) => e.key).toList();
    if (validPositionKeys.length != 7) {
      throw const AppException('Diziliş 7 oyuncudan oluşmalıdır.');
    }

    String resolvedCaptainPos = captainPositionKey ?? '';
    if (resolvedCaptainPos.isEmpty ||
        !validPositionKeys.contains(resolvedCaptainPos)) {
      final matchedEntry = lineup.entries.where((e) {
        return validPositionKeys.contains(e.key) &&
            e.value.trim().toLowerCase() == captainName.trim().toLowerCase();
      }).firstOrNull;

      if (matchedEntry != null) {
        resolvedCaptainPos = matchedEntry.key;
      } else {
        resolvedCaptainPos = validPositionKeys.firstWhere(
          (k) => (lineup[k] ?? '').trim().isEmpty,
          orElse: () => validPositionKeys.first,
        );
      }
    }

    final membersToInsert = <TeamMemberModel>[];

    for (final posKey in validPositionKeys) {
      if (posKey == resolvedCaptainPos) {
        final customText = (lineup[posKey] ?? '').trim();
        membersToInsert.add(
          TeamMemberModel(
            id: _uuid.v4(),
            teamId: teamId,
            userId: captainId,
            position: posKey,
            displayName: customText.isNotEmpty ? customText : captainName,
            role: 'captain',
            joinedAt: now,
          ),
        );
      } else {
        final playerName = (lineup[posKey] ?? '').trim();
        if (playerName.isNotEmpty) {
          membersToInsert.add(
            TeamMemberModel(
              id: _uuid.v4(),
              teamId: teamId,
              userId: null,
              position: posKey,
              displayName: playerName,
              role: 'guest',
              joinedAt: now,
            ),
          );
        }
      }
    }

    final team = TeamModel(
      id: teamId,
      captainId: captainId,
      captainName: captainName,
      formation: formation,
      province: province,
      district: district,
      venueName: venueName,
      matchDate: matchDate,
      startTime: startTime,
      endTime: endTime,
      createdAt: now,
      status: 'active',
      members: membersToInsert,
    );

    final matchRecord = MatchModel(
      id: matchId,
      teamId: teamId,
      venueName: venueName,
      province: province,
      district: district,
      matchDate: matchDate,
      startTime: startTime,
      endTime: endTime,
    );

    await db.transaction((txn) async {
      await txn.insert('teams', team.toMap());
      await txn.insert('matches', matchRecord.toMap());
      for (final member in membersToInsert) {
        await txn.insert('team_members', member.toMap());
      }
    });

    return team;
  }

  @override
  Future<TeamModel?> getTeamById(String teamId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'teams',
      where: 'id = ?',
      whereArgs: [teamId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _hydrateTeam(db, rows.first);
  }

  Future<TeamModel> _hydrateTeam(
    DatabaseExecutor db,
    Map<String, Object?> teamRow,
  ) async {
    final teamId = teamRow['id'] as String;
    final captainId = teamRow['captainId'] as String;

    final userRows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [captainId],
      limit: 1,
    );
    String captainName = 'Takım Kaptanı';
    if (userRows.isNotEmpty) {
      final first = userRows.first['firstName'] as String? ?? '';
      final last = userRows.first['lastName'] as String? ?? '';
      captainName = '$first $last'.trim();
    }

    final memberRows = await db.query(
      'team_members',
      where: 'teamId = ?',
      whereArgs: [teamId],
      orderBy: 'joinedAt ASC',
    );
    final members = memberRows.map(TeamMemberModel.fromMap).toList();

    return TeamModel.fromMap(
      teamRow,
      captainName: captainName,
      members: members,
    );
  }

  @override
  Future<List<TeamModel>> getUserAppointments(String userId) async {
    final db = await appDatabase.database;

    final dismissedRows = await db.query(
      'dismissed_appointments',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final dismissedTeamIds =
        dismissedRows.map((r) => r['teamId'] as String).toSet();

    final memberTeamRows = await db.query(
      'team_members',
      columns: ['teamId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final captainTeamRows = await db.query(
      'teams',
      columns: ['id'],
      where: 'captainId = ?',
      whereArgs: [userId],
    );

    final teamIds = <String>{
      ...memberTeamRows.map((r) => r['teamId'] as String),
      ...captainTeamRows.map((r) => r['id'] as String),
    }.difference(dismissedTeamIds);

    if (teamIds.isEmpty) return [];

    final placeholders = List.filled(teamIds.length, '?').join(',');
    final teamRows = await db.query(
      'teams',
      where: 'id IN ($placeholders)',
      whereArgs: teamIds.toList(),
      orderBy: 'matchDate ASC, startTime ASC, createdAt DESC',
    );

    final result = <TeamModel>[];
    for (final row in teamRows) {
      result.add(await _hydrateTeam(db, row));
    }
    return result;
  }

  @override
  Future<List<TeamModel>> getCaptainTeams(String captainId) async {
    final db = await appDatabase.database;
    final dismissedRows = await db.query(
      'dismissed_appointments',
      where: 'userId = ?',
      whereArgs: [captainId],
    );
    final dismissedTeamIds =
        dismissedRows.map((r) => r['teamId'] as String).toSet();

    final rows = await db.query(
      'teams',
      where: 'captainId = ? AND status = ?',
      whereArgs: [captainId, 'active'],
      orderBy: 'createdAt DESC',
    );

    final result = <TeamModel>[];
    for (final row in rows) {
      final id = row['id'] as String;
      if (!dismissedTeamIds.contains(id)) {
        result.add(await _hydrateTeam(db, row));
      }
    }
    return result;
  }

  @override
  Future<List<TeamModel>> getUserChatTeams(String userId) async {
    final db = await appDatabase.database;
    final memberRows = await db.query(
      'team_members',
      columns: ['teamId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final captainRows = await db.query(
      'teams',
      columns: ['id'],
      where: 'captainId = ?',
      whereArgs: [userId],
    );

    final teamIds = <String>{
      ...memberRows.map((r) => r['teamId'] as String),
      ...captainRows.map((r) => r['id'] as String),
    };

    if (teamIds.isEmpty) return [];

    final placeholders = List.filled(teamIds.length, '?').join(',');
    final rows = await db.query(
      'teams',
      where: 'id IN ($placeholders)',
      whereArgs: teamIds.toList(),
      orderBy: 'createdAt DESC',
    );

    final result = <TeamModel>[];
    for (final row in rows) {
      result.add(await _hydrateTeam(db, row));
    }
    return result;
  }

  @override
  Future<void> deleteAppointmentForUser({
    required String teamId,
    required String userId,
  }) async {
    final db = await appDatabase.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.insert(
        'dismissed_appointments',
        {
          'userId': userId,
          'teamId': teamId,
          'dismissedAt': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final teamRows = await txn.query(
        'teams',
        where: 'id = ?',
        whereArgs: [teamId],
        limit: 1,
      );
      if (teamRows.isNotEmpty && teamRows.first['captainId'] == userId) {
        final otherMembers = await txn.query(
          'team_members',
          where: 'teamId = ? AND userId IS NOT NULL AND userId != ?',
          whereArgs: [teamId, userId],
        );
        if (otherMembers.isEmpty) {
          await txn.update(
            'invitations',
            {
              'status': 'Cancelled',
              'respondedAt': now,
            },
            where: 'teamId = ? AND status = ?',
            whereArgs: [teamId, 'Pending'],
          );
        }
      }
    });
  }

  @override
  Future<bool> isUserMemberOfTeam({
    required String teamId,
    required String userId,
  }) async {
    final db = await appDatabase.database;
    final captainRows = await db.query(
      'teams',
      where: 'id = ? AND captainId = ?',
      whereArgs: [teamId, userId],
      limit: 1,
    );
    if (captainRows.isNotEmpty) return true;

    final memberRows = await db.query(
      'team_members',
      where: 'teamId = ? AND userId = ?',
      whereArgs: [teamId, userId],
      limit: 1,
    );
    return memberRows.isNotEmpty;
  }
}
