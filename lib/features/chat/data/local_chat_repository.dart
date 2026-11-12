import 'package:uuid/uuid.dart'; // Benzersiz kimlik (UUID) üretici paketi içe aktarır
import '../../../core/errors/app_exception.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/message_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../team_creation/domain/team_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../domain/chat_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LocalChatRepository implements ChatRepository { // LocalChatRepository veri erişim (repository) sınıfını tanımlar
  final AppDatabase appDatabase; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final TeamRepository teamRepository; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Uuid _uuid = const Uuid(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  LocalChatRepository({ // İlgili kod satırını ve işlemi yürütür
    required this.appDatabase, // appDatabase parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.teamRepository, // teamRepository parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<MessageModel>> getTeamMessages({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String requesterId, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final isMember = await teamRepository.isUserMemberOfTeam( // Sabit/final değişken veya nesne tanımını başlatır
      teamId: teamId, // teamId özelliğini yapılandırır
      userId: requesterId, // userId özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (!isMember) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Bu takımın üyesi olmadığınız için takım sohbetine erişemezsiniz.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'messages', // İlgili kod satırını ve işlemi yürütür
      where: 'teamId = ?', // where özelliğini yapılandırır
      whereArgs: [teamId], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt ASC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final result = <MessageModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in rows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final senderId = row['senderId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final userRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'users', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [senderId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      final senderName = userRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
          ? '${userRows.first['firstName']} ${userRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
              .trim() // İlgili kod satırını ve işlemi yürütür
          : 'Oyuncu'; // İlgili kod satırını ve işlemi yürütür
      result.add(MessageModel.fromMap(row, senderName: senderName)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return result; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<MessageModel> sendMessage({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String senderId, // İlgili kod satırını ve işlemi yürütür
    required String content, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final trimmed = content.trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (trimmed.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Boş mesaj gönderilemez.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final isMember = await teamRepository.isUserMemberOfTeam( // Sabit/final değişken veya nesne tanımını başlatır
      teamId: teamId, // teamId özelliğini yapılandırır
      userId: senderId, // userId özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (!isMember) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Yalnızca takım üyeleri takım sohbetine mesaj gönderebilir.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final userRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [senderId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final senderName = userRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
        ? '${userRows.first['firstName']} ${userRows.first['lastName']}'.trim() // İlgili kod satırını ve işlemi yürütür
        : 'Oyuncu'; // İlgili kod satırını ve işlemi yürütür

    final message = MessageModel( // Sabit/final değişken veya nesne tanımını başlatır
      id: _uuid.v4(), // id özelliğini yapılandırır
      teamId: teamId, // teamId özelliğini yapılandırır
      senderId: senderId, // senderId özelliğini yapılandırır
      senderName: senderName, // senderName özelliğini yapılandırır
      content: trimmed, // content özelliğini yapılandırır
      createdAt: DateTime.now(), // createdAt özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    await db.insert('messages', message.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
    return message; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
