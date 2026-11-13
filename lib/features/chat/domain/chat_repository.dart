// Takım sohbet işlemleri için soyut veri erişim arayüzünü tanımlar.

import '../../../shared/models/message_model.dart';

/// Takım içi mesajlaşma ve mesaj geçmişini sorgulama işlemlerini soyutlayan depo arayüzü.
abstract class ChatRepository {
  /// Belirtilen takıma ait tüm mesajları kronolojik sırayla listeler; istek yapan kullanıcının üyelik yetkisini denetler.
  Future<List<MessageModel>> getTeamMessages({
    required String teamId,
    required String requesterId,
  });

  /// Takım sohbet odasına yeni bir metin mesajı gönderir ve kaydedilen mesaj modelini döndürür.
  Future<MessageModel> sendMessage({
    required String teamId,
    required String senderId,
    required String content,
  });
}
