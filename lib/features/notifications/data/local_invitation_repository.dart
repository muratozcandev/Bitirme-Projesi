import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/models/invitation_model.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/models/team_member_model.dart';
import '../../team_creation/domain/team_repository.dart';
import '../domain/invitation_repository.dart';

class LocalInvitationRepository implements InvitationRepository {
  final AppDatabase appDatabase;
  final TeamRepository teamRepository;
  final Uuid _uuid = const Uuid();

  LocalInvitationRepository({
    required this.appDatabase,
    required this.teamRepository,
  });

  @override
  Future<InvitationModel> sendInvitation({
    required String teamId,
    required String senderId,
    required String receiverId,
    required String positionKey,
  }) async {
    if (senderId == receiverId) {
      throw const AppException('Kendi kendinize davet gönderemezsiniz.');
    }

    final db = await appDatabase.database;

    final team = await teamRepository.getTeamById(teamId);
    if (team == null) {
      throw const AppException('Takım bulunamadı.');
    }

    if (team.members.length >= 7) {
      throw const AppException('Bu takımda boş mevki bulunmamaktadır (7/7 dolu).');
    }

    // Hedef kullanıcı zaten takımda mı?
    final alreadyMember = team.members.any((m) => m.userId == receiverId);
    if (alreadyMember || team.captainId == receiverId) {
      throw const AppException('Bu oyuncu zaten seçilen takımın üyesidir.');
    }

    // Seçilen mevki dolu mu?
    final positionOccupied = team.members.any(
      (m) => m.position == positionKey && m.displayName.trim().isNotEmpty,
    );
    if (positionOccupied) {
      throw const AppException(
        'Seçilen mevki dolu. Lütfen boş bir mevki seçiniz.',
      );
    }

    // Aynı kullanıcıya aynı takıma bekleyen davet var mı?
    final existingUserInvite = await db.query(
      'invitations',
      where: 'teamId = ? AND receiverId = ? AND status = ?',
      whereArgs: [teamId, receiverId, InvitationStatus.pending.value],
      limit: 1,
    );
    if (existingUserInvite.isNotEmpty) {
      throw const AppException(
        'Bu oyuncuya bu takım için zaten bekleyen bir davet gönderilmiş.',
      );
    }

    // Aynı mevki için başka bekleyen bir davet var mı?
    final existingPositionInvite = await db.query(
      'invitations',
      where: 'teamId = ? AND position = ? AND status = ?',
      whereArgs: [teamId, positionKey, InvitationStatus.pending.value],
      limit: 1,
    );
    if (existingPositionInvite.isNotEmpty) {
      throw const AppException(
        'Bu mevki için başka bir oyuncuya gönderilmiş bekleyen bir davet bulunuyor.',
      );
    }

    final senderRows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [senderId],
      limit: 1,
    );
    final receiverRows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [receiverId],
      limit: 1,
    );
    if (senderRows.isEmpty || receiverRows.isEmpty) {
      throw const AppException('Gönderen veya alıcı kullanıcı bulunamadı.');
    }

    final senderName =
        '${senderRows.first['firstName']} ${senderRows.first['lastName']}'
            .trim();
    final receiverName =
        '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}'
            .trim();

    final now = DateTime.now();
    final invitationId = _uuid.v4();
    final positionLabel = team.formation.labelForKey(positionKey);

    final invitation = InvitationModel(
      id: invitationId,
      teamId: teamId,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverName: receiverName,
      position: positionKey,
      status: InvitationStatus.pending,
      createdAt: now,
      team: team,
    );

    final notification = NotificationModel(
      id: _uuid.v4(),
      receiverId: receiverId,
      senderId: senderId,
      senderName: senderName,
      type: NotificationType.teamInvitation,
      relatedTeamId: teamId,
      relatedInvitationId: invitationId,
      title: 'Yeni Takım Daveti',
      body:
          '$senderName sizi ${team.venueName} (${team.formattedDate} ${team.timeSlot}) maçında $positionLabel mevkisine davet etti.',
      isRead: false,
      createdAt: now,
    );

    await db.transaction((txn) async {
      await txn.insert('invitations', invitation.toMap());
      await txn.insert('notifications', notification.toMap());
    });

    return invitation;
  }

  @override
  Future<InvitationModel> acceptInvitation({
    required String invitationId,
    required String currentUserId,
  }) async {
    final db = await appDatabase.database;

    await db.transaction((txn) async {
      final invRows = await txn.query(
        'invitations',
        where: 'id = ?',
        whereArgs: [invitationId],
        limit: 1,
      );
      if (invRows.isEmpty) {
        throw const AppException('Davet kaydı bulunamadı.');
      }

      final invMap = invRows.first;
      final status = InvitationStatus.fromValue(invMap['status'] as String);
      if (status != InvitationStatus.pending) {
        throw const AppException(
          'Bu davet daha önce sonuçlandırılmış (yalnızca bir kez yanıtlanabilir).',
        );
      }

      final receiverId = invMap['receiverId'] as String;
      if (receiverId != currentUserId) {
        throw const AppException('Bu daveti yalnızca davet edilen kullanıcı kabul edebilir.');
      }

      final teamId = invMap['teamId'] as String;
      final positionKey = invMap['position'] as String;
      final senderId = invMap['senderId'] as String;

      // Kullanıcının zaten takımda olup olmadığını kontrol et
      final existingUserMember = await txn.query(
        'team_members',
        where: 'teamId = ? AND userId = ?',
        whereArgs: [teamId, receiverId],
        limit: 1,
      );
      if (existingUserMember.isNotEmpty) {
        throw const AppException('Zaten bu takımın üyesisiniz.');
      }

      // Mevkinin hala boş olup olmadığını kontrol et
      final existingPosMember = await txn.query(
        'team_members',
        where: 'teamId = ? AND position = ?',
        whereArgs: [teamId, positionKey],
        limit: 1,
      );
      if (existingPosMember.isNotEmpty) {
        throw const AppException('Bu mevki başka bir oyuncu tarafından doldurulmuş.');
      }

      final allMembers = await txn.query(
        'team_members',
        where: 'teamId = ?',
        whereArgs: [teamId],
      );
      if (allMembers.length >= 7) {
        throw const AppException('Takım kadrosu (7/7) tamamen dolmuş.');
      }

      final receiverRows = await txn.query(
        'users',
        where: 'id = ?',
        whereArgs: [receiverId],
        limit: 1,
      );
      final receiverName = receiverRows.isNotEmpty
          ? '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}'
              .trim()
          : 'Oyuncu';

      final teamRows = await txn.query(
        'teams',
        where: 'id = ?',
        whereArgs: [teamId],
        limit: 1,
      );
      final venueName =
          teamRows.isNotEmpty ? (teamRows.first['venueName'] as String) : 'Maç';

      final now = DateTime.now();

      // 1. Davet durumunu Accepted olarak güncelle
      await txn.update(
        'invitations',
        {
          'status': InvitationStatus.accepted.value,
          'respondedAt': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      // 2. Kullanıcıyı takıma ve ilgili mevkiye ekle
      final member = TeamMemberModel(
        id: _uuid.v4(),
        teamId: teamId,
        userId: receiverId,
        position: positionKey,
        displayName: receiverName,
        role: 'member',
        joinedAt: now,
      );
      await txn.insert('team_members', member.toMap());

      // 3. Eğer kullanıcı daha önce bu randevuyu gizlediyse gizlemeyi kaldır
      await txn.delete(
        'dismissed_appointments',
        where: 'userId = ? AND teamId = ?',
        whereArgs: [receiverId, teamId],
      );

      // 4. Daveti gönderen kaptana kabul bildirimi oluştur
      final acceptedNotification = NotificationModel(
        id: _uuid.v4(),
        receiverId: senderId,
        senderId: receiverId,
        senderName: receiverName,
        type: NotificationType.invitationAccepted,
        relatedTeamId: teamId,
        relatedInvitationId: invitationId,
        title: 'Davet Kabul Edildi',
        body:
            '$receiverName, $venueName maçı için gönderdiğiniz takım davetini kabul etti ve kadroya katıldı!',
        isRead: false,
        createdAt: now,
      );
      await txn.insert('notifications', acceptedNotification.toMap());
    });

    final updated = await getInvitationById(invitationId);
    if (updated == null) {
      throw const AppException('Güncellenen davet bulunamadı.');
    }
    return updated;
  }

  @override
  Future<InvitationModel> rejectInvitation({
    required String invitationId,
    required String currentUserId,
  }) async {
    final db = await appDatabase.database;

    await db.transaction((txn) async {
      final invRows = await txn.query(
        'invitations',
        where: 'id = ?',
        whereArgs: [invitationId],
        limit: 1,
      );
      if (invRows.isEmpty) {
        throw const AppException('Davet kaydı bulunamadı.');
      }

      final invMap = invRows.first;
      final status = InvitationStatus.fromValue(invMap['status'] as String);
      if (status != InvitationStatus.pending) {
        throw const AppException(
          'Bu davet daha önce sonuçlandırılmış (yalnızca bir kez yanıtlanabilir).',
        );
      }

      final receiverId = invMap['receiverId'] as String;
      if (receiverId != currentUserId) {
        throw const AppException('Bu daveti yalnızca davet edilen kullanıcı reddedebilir.');
      }

      final teamId = invMap['teamId'] as String;
      final senderId = invMap['senderId'] as String;

      final receiverRows = await txn.query(
        'users',
        where: 'id = ?',
        whereArgs: [receiverId],
        limit: 1,
      );
      final receiverName = receiverRows.isNotEmpty
          ? '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}'
              .trim()
          : 'Oyuncu';

      final teamRows = await txn.query(
        'teams',
        where: 'id = ?',
        whereArgs: [teamId],
        limit: 1,
      );
      final venueName =
          teamRows.isNotEmpty ? (teamRows.first['venueName'] as String) : 'Maç';

      final now = DateTime.now();

      // 1. Davet durumunu Rejected olarak güncelle (mevki boş kalır)
      await txn.update(
        'invitations',
        {
          'status': InvitationStatus.rejected.value,
          'respondedAt': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      // 2. Daveti gönderen kaptana ret bildirimi oluştur
      final rejectedNotification = NotificationModel(
        id: _uuid.v4(),
        receiverId: senderId,
        senderId: receiverId,
        senderName: receiverName,
        type: NotificationType.invitationRejected,
        relatedTeamId: teamId,
        relatedInvitationId: invitationId,
        title: 'Davet Reddedildi',
        body:
            '$receiverName, $venueName maçı için gönderdiğiniz takım davetini reddetti. Ayrılan mevki tekrar boş durumda.',
        isRead: false,
        createdAt: now,
      );
      await txn.insert('notifications', rejectedNotification.toMap());
    });

    final updated = await getInvitationById(invitationId);
    if (updated == null) {
      throw const AppException('Güncellenen davet bulunamadı.');
    }
    return updated;
  }

  Future<InvitationModel> _hydrateInvitation(
    Database db,
    Map<String, Object?> row,
  ) async {
    final senderId = row['senderId'] as String;
    final receiverId = row['receiverId'] as String;
    final teamId = row['teamId'] as String;

    final senderRows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [senderId],
      limit: 1,
    );
    final receiverRows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [receiverId],
      limit: 1,
    );

    final senderName = senderRows.isNotEmpty
        ? '${senderRows.first['firstName']} ${senderRows.first['lastName']}'
            .trim()
        : 'Kaptan';
    final receiverName = receiverRows.isNotEmpty
        ? '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}'
            .trim()
        : 'Oyuncu';

    final team = await teamRepository.getTeamById(teamId);

    return InvitationModel.fromMap(
      row,
      senderName: senderName,
      receiverName: receiverName,
      team: team,
    );
  }

  @override
  Future<InvitationModel?> getInvitationById(String invitationId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'invitations',
      where: 'id = ?',
      whereArgs: [invitationId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _hydrateInvitation(db, rows.first);
  }

  @override
  Future<List<InvitationModel>> getIncomingInvitations(String userId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'invitations',
      where: 'receiverId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    final list = <InvitationModel>[];
    for (final row in rows) {
      list.add(await _hydrateInvitation(db, row));
    }
    return list;
  }

  @override
  Future<List<InvitationModel>> getOutgoingInvitations(String userId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'invitations',
      where: 'senderId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    final list = <InvitationModel>[];
    for (final row in rows) {
      list.add(await _hydrateInvitation(db, row));
    }
    return list;
  }
}
