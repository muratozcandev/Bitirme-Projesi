import '../../../shared/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getUserNotifications(String userId);
  Future<int> getUnreadCount(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}

