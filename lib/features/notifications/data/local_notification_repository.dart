// Kullanıcı bildirimlerinin yerel veritabanında listelenmesi ve okundu olarak işaretlenmesini sağlar.

import '../../../data/database/app_database.dart';
import '../../../shared/models/notification_model.dart';
import '../domain/notification_repository.dart';

class LocalNotificationRepository implements NotificationRepository {
  final AppDatabase appDatabase;

  LocalNotificationRepository({required this.appDatabase});

  @override
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'notifications',
      where: 'receiverId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    final result = <NotificationModel>[];
    for (final row in rows) {
      final senderId = row['senderId'] as String;
      final senderRows = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [senderId],
        limit: 1,
      );
      final senderName = senderRows.isNotEmpty
          ? '${senderRows.first['firstName']} ${senderRows.first['lastName']}'
              .trim()
          : '';
      result.add(NotificationModel.fromMap(row, senderName: senderName));
    }
    return result;
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'notifications',
      columns: ['id'],
      where: 'receiverId = ? AND isRead = 0',
      whereArgs: [userId],
    );
    return rows.length;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final db = await appDatabase.database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final db = await appDatabase.database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'receiverId = ?',
      whereArgs: [userId],
    );
  }
}
