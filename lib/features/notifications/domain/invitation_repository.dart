import '../../../shared/models/invitation_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

abstract class InvitationRepository { // InvitationRepository soyut arayüz (interface) sınıfını tanımlar
  Future<InvitationModel> sendInvitation({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String senderId, // İlgili kod satırını ve işlemi yürütür
    required String receiverId, // İlgili kod satırını ve işlemi yürütür
    required String positionKey, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<InvitationModel> acceptInvitation({ // İlgili kod satırını ve işlemi yürütür
    required String invitationId, // İlgili kod satırını ve işlemi yürütür
    required String currentUserId, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<InvitationModel> rejectInvitation({ // İlgili kod satırını ve işlemi yürütür
    required String invitationId, // İlgili kod satırını ve işlemi yürütür
    required String currentUserId, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<InvitationModel?> getInvitationById(String invitationId); // İlgili kod satırını ve işlemi yürütür

  Future<List<InvitationModel>> getIncomingInvitations(String userId); // İlgili kod satırını ve işlemi yürütür

  Future<List<InvitationModel>> getOutgoingInvitations(String userId); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

