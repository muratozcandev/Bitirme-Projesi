import '../../../shared/models/notification_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

abstract class NotificationRepository { // NotificationRepository soyut arayüz (interface) sınıfını tanımlar
  Future<List<NotificationModel>> getUserNotifications(String userId); // İlgili kod satırını ve işlemi yürütür
  Future<int> getUnreadCount(String userId); // İlgili kod satırını ve işlemi yürütür
  Future<void> markAsRead(String notificationId); // İlgili kod satırını ve işlemi yürütür
  Future<void> markAllAsRead(String userId); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

