// Bildirim işlemleri için soyut veri erişim arayüzünü tanımlar.

import '../../../shared/models/notification_model.dart';

/// Kullanıcı bildirimlerini listeleme, okunmamış bildirim sayısını alma
/// ve bildirimleri okundu olarak işaretleme işlemlerini soyutlayan depo arayüzü.
abstract class NotificationRepository {
  /// Kullanıcıya ait tüm bildirimleri tarihe göre azalan sırada listeler.
  Future<List<NotificationModel>> getUserNotifications(String userId);

  /// Kullanıcının henüz okumadığı bildirimlerin toplam sayısını döndürür.
  Future<int> getUnreadCount(String userId);

  /// Belirtilen bildirimi okundu olarak işaretler.
  Future<void> markAsRead(String notificationId);

  /// Kullanıcının tüm bildirimlerini tek seferde okundu durumuna getirir.
  Future<void> markAllAsRead(String userId);
}
