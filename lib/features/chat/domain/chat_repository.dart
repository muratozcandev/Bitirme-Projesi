import '../../../shared/models/message_model.dart';

abstract class ChatRepository {
  Future<List<MessageModel>> getTeamMessages({
    required String teamId,
    required String requesterId,
  });

  Future<MessageModel> sendMessage({
    required String teamId,
    required String senderId,
    required String content,
  });
}

