import 'package:uuid/uuid.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/models/message_model.dart';
import '../../team_creation/domain/team_repository.dart';
import '../domain/chat_repository.dart';

class LocalChatRepository implements ChatRepository {
  final AppDatabase appDatabase;
  final TeamRepository teamRepository;
  final Uuid _uuid = const Uuid();

  LocalChatRepository({
    required this.appDatabase,
    required this.teamRepository,
  });

  @override
  Future<List<MessageModel>> getTeamMessages({
    required String teamId,
    required String requesterId,
  }) async {
    final isMember = await teamRepository.isUserMemberOfTeam(
      teamId: teamId,
      userId: requesterId,
    );
    if (!isMember) {
      throw const AppException(
        'Bu takımın üyesi olmadığınız için takım sohbetine erişemezsiniz.',
      );
    }

    final db = await appDatabase.database;
    final rows = await db.query(
      'messages',
      where: 'teamId = ?',
      whereArgs: [teamId],
      orderBy: 'createdAt ASC',
    );

    final result = <MessageModel>[];
    for (final row in rows) {
      final senderId = row['senderId'] as String;
      final userRows = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [senderId],
        limit: 1,
      );
      final senderName = userRows.isNotEmpty
          ? '${userRows.first['firstName']} ${userRows.first['lastName']}'
              .trim()
          : 'Oyuncu';
      result.add(MessageModel.fromMap(row, senderName: senderName));
    }
    return result;
  }

  @override
  Future<MessageModel> sendMessage({
    required String teamId,
    required String senderId,
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw const AppException('Boş mesaj gönderilemez.');
    }

    final isMember = await teamRepository.isUserMemberOfTeam(
      teamId: teamId,
      userId: senderId,
    );
    if (!isMember) {
      throw const AppException(
        'Yalnızca takım üyeleri takım sohbetine mesaj gönderebilir.',
      );
    }

    final db = await appDatabase.database;
    final userRows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [senderId],
      limit: 1,
    );
    final senderName = userRows.isNotEmpty
        ? '${userRows.first['firstName']} ${userRows.first['lastName']}'.trim()
        : 'Oyuncu';

    final message = MessageModel(
      id: _uuid.v4(),
      teamId: teamId,
      senderId: senderId,
      senderName: senderName,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    await db.insert('messages', message.toMap());
    return message;
  }
}
