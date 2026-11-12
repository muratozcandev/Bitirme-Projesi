import '../../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/notification_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../domain/notification_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LocalNotificationRepository implements NotificationRepository { // LocalNotificationRepository veri erişim (repository) sınıfını tanımlar
  final AppDatabase appDatabase; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  LocalNotificationRepository({required this.appDatabase}); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<NotificationModel>> getUserNotifications(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'notifications', // İlgili kod satırını ve işlemi yürütür
      where: 'receiverId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt DESC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final result = <NotificationModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in rows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final senderId = row['senderId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final senderRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'users', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [senderId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      final senderName = senderRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
          ? '${senderRows.first['firstName']} ${senderRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
              .trim() // İlgili kod satırını ve işlemi yürütür
          : ''; // İlgili kod satırını ve işlemi yürütür
      result.add(NotificationModel.fromMap(row, senderName: senderName)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return result; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<int> getUnreadCount(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'notifications', // İlgili kod satırını ve işlemi yürütür
      columns: ['id'], // columns özelliğini yapılandırır
      where: 'receiverId = ? AND isRead = 0', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    return rows.length; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<void> markAsRead(String notificationId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    await db.update( // Veritabanındaki mevcut kaydı günceller
      'notifications', // İlgili kod satırını ve işlemi yürütür
      {'isRead': 1}, // {'isRead' özelliğini yapılandırır
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [notificationId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<void> markAllAsRead(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    await db.update( // Veritabanındaki mevcut kaydı günceller
      'notifications', // İlgili kod satırını ve işlemi yürütür
      {'isRead': 1}, // {'isRead' özelliğini yapılandırır
      where: 'receiverId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
