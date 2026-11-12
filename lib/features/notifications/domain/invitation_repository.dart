import '../../../shared/models/invitation_model.dart';

abstract class InvitationRepository {
  Future<InvitationModel> sendInvitation({
    required String teamId,
    required String senderId,
    required String receiverId,
    required String positionKey,
  });

  Future<InvitationModel> acceptInvitation({
    required String invitationId,
    required String currentUserId,
  });

  Future<InvitationModel> rejectInvitation({
    required String invitationId,
    required String currentUserId,
  });

  Future<InvitationModel?> getInvitationById(String invitationId);

  Future<List<InvitationModel>> getIncomingInvitations(String userId);

  Future<List<InvitationModel>> getOutgoingInvitations(String userId);
}

