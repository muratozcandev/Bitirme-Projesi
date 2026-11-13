// Maç ve takım davet işlemleri için soyut arayüzü tanımlar.

import '../../../shared/models/invitation_model.dart';

/// Takıma oyuncu daveti gönderme, daveti kabul etme veya reddetme,
/// gelen ve giden davetleri listeleme işlemlerini soyutlayan depo sözleşmesi.
abstract class InvitationRepository {
  /// Hedef oyuncuya belirli bir takımdaki boş mevki için davet gönderir.
  Future<InvitationModel> sendInvitation({
    required String teamId,
    required String senderId,
    required String receiverId,
    required String positionKey,
  });

  /// Gelen daveti kabul eder; oyuncuyu takıma ekler ve ilgili bildirimleri günceller.
  Future<InvitationModel> acceptInvitation({
    required String invitationId,
    required String currentUserId,
  });

  /// Gelen daveti reddeder ve durumunu 'rejected' olarak günceller.
  Future<InvitationModel> rejectInvitation({
    required String invitationId,
    required String currentUserId,
  });

  /// Kimliği verilen davetin detaylarını döndürür.
  Future<InvitationModel?> getInvitationById(String invitationId);

  /// Kullanıcıya gelen tüm davetleri listeler.
  Future<List<InvitationModel>> getIncomingInvitations(String userId);

  /// Kullanıcının diğer oyunculara gönderdiği giden davetleri listeler.
  Future<List<InvitationModel>> getOutgoingInvitations(String userId);
}
