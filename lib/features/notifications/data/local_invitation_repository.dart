import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // SQLite yerel veritabanı sürücüsünü içe aktarır
import 'package:uuid/uuid.dart'; // Benzersiz kimlik (UUID) üretici paketi içe aktarır
import '../../../core/errors/app_exception.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/invitation_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/notification_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/team_member_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../team_creation/domain/team_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../domain/invitation_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LocalInvitationRepository implements InvitationRepository { // LocalInvitationRepository veri erişim (repository) sınıfını tanımlar
  final AppDatabase appDatabase; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final TeamRepository teamRepository; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Uuid _uuid = const Uuid(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  LocalInvitationRepository({ // İlgili kod satırını ve işlemi yürütür
    required this.appDatabase, // appDatabase parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.teamRepository, // teamRepository parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<InvitationModel> sendInvitation({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String senderId, // İlgili kod satırını ve işlemi yürütür
    required String receiverId, // İlgili kod satırını ve işlemi yürütür
    required String positionKey, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    if (senderId == receiverId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Kendi kendinize davet gönderemezsiniz.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final team = await teamRepository.getTeamById(teamId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (team == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Takım bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    if (team.members.length >= 7) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Bu takımda boş mevki bulunmamaktadır (7/7 dolu).'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    // Hedef kullanıcı zaten takımda mı?
    final alreadyMember = team.members.any((m) => m.userId == receiverId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (alreadyMember || team.captainId == receiverId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Bu oyuncu zaten seçilen takımın üyesidir.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    // Seçilen mevki dolu mu?
    final positionOccupied = team.members.any( // Sabit/final değişken veya nesne tanımını başlatır
      (m) => m.position == positionKey && m.displayName.trim().isNotEmpty, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (positionOccupied) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Seçilen mevki dolu. Lütfen boş bir mevki seçiniz.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    // Aynı kullanıcıya aynı takıma bekleyen davet var mı?
    final existingUserInvite = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'invitations', // İlgili kod satırını ve işlemi yürütür
      where: 'teamId = ? AND receiverId = ? AND status = ?', // where özelliğini yapılandırır
      whereArgs: [teamId, receiverId, InvitationStatus.pending.value], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (existingUserInvite.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Bu oyuncuya bu takım için zaten bekleyen bir davet gönderilmiş.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    // Aynı mevki için başka bekleyen bir davet var mı?
    final existingPositionInvite = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'invitations', // İlgili kod satırını ve işlemi yürütür
      where: 'teamId = ? AND position = ? AND status = ?', // where özelliğini yapılandırır
      whereArgs: [teamId, positionKey, InvitationStatus.pending.value], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (existingPositionInvite.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Bu mevki için başka bir oyuncuya gönderilmiş bekleyen bir davet bulunuyor.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final senderRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [senderId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final receiverRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [receiverId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (senderRows.isEmpty || receiverRows.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Gönderen veya alıcı kullanıcı bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final senderName = // Sabit/final değişken veya nesne tanımını başlatır
        '${senderRows.first['firstName']} ${senderRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
            .trim(); // İlgili kod satırını ve işlemi yürütür
    final receiverName = // Sabit/final değişken veya nesne tanımını başlatır
        '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
            .trim(); // İlgili kod satırını ve işlemi yürütür

    final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final invitationId = _uuid.v4(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final positionLabel = team.formation.labelForKey(positionKey); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final invitation = InvitationModel( // Sabit/final değişken veya nesne tanımını başlatır
      id: invitationId, // id özelliğini yapılandırır
      teamId: teamId, // teamId özelliğini yapılandırır
      senderId: senderId, // senderId özelliğini yapılandırır
      senderName: senderName, // senderName özelliğini yapılandırır
      receiverId: receiverId, // receiverId özelliğini yapılandırır
      receiverName: receiverName, // receiverName özelliğini yapılandırır
      position: positionKey, // position özelliğini yapılandırır
      status: InvitationStatus.pending, // status özelliğini yapılandırır
      createdAt: now, // createdAt özelliğini yapılandırır
      team: team, // team özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final notification = NotificationModel( // Sabit/final değişken veya nesne tanımını başlatır
      id: _uuid.v4(), // id özelliğini yapılandırır
      receiverId: receiverId, // receiverId özelliğini yapılandırır
      senderId: senderId, // senderId özelliğini yapılandırır
      senderName: senderName, // senderName özelliğini yapılandırır
      type: NotificationType.teamInvitation, // type özelliğini yapılandırır
      relatedTeamId: teamId, // relatedTeamId özelliğini yapılandırır
      relatedInvitationId: invitationId, // relatedInvitationId özelliğini yapılandırır
      title: 'Yeni Takım Daveti', // title özelliğini yapılandırır
      body: // İlgili kod satırını ve işlemi yürütür
          '$senderName sizi ${team.venueName} (${team.formattedDate} ${team.timeSlot}) maçında $positionLabel mevkisine davet etti.', // İlgili kod satırını ve işlemi yürütür
      isRead: false, // isRead özelliğini yapılandırır
      createdAt: now, // createdAt özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    await db.transaction((txn) async { // Asenkron işlemin tamamlanmasını bekler
      await txn.insert('invitations', invitation.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
      await txn.insert('notifications', notification.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
    }); // İlgili kod satırını ve işlemi yürütür

    return invitation; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<InvitationModel> acceptInvitation({ // İlgili kod satırını ve işlemi yürütür
    required String invitationId, // İlgili kod satırını ve işlemi yürütür
    required String currentUserId, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    await db.transaction((txn) async { // Asenkron işlemin tamamlanmasını bekler
      final invRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'invitations', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [invitationId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (invRows.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Davet kaydı bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final invMap = invRows.first; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final status = InvitationStatus.fromValue(invMap['status'] as String); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (status != InvitationStatus.pending) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
          'Bu davet daha önce sonuçlandırılmış (yalnızca bir kez yanıtlanabilir).', // İlgili kod satırını ve işlemi yürütür
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final receiverId = invMap['receiverId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (receiverId != currentUserId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Bu daveti yalnızca davet edilen kullanıcı kabul edebilir.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final teamId = invMap['teamId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final positionKey = invMap['position'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final senderId = invMap['senderId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      // Kullanıcının zaten takımda olup olmadığını kontrol et
      final existingUserMember = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'team_members', // İlgili kod satırını ve işlemi yürütür
        where: 'teamId = ? AND userId = ?', // where özelliğini yapılandırır
        whereArgs: [teamId, receiverId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (existingUserMember.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Zaten bu takımın üyesisiniz.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      // Mevkinin hala boş olup olmadığını kontrol et
      final existingPosMember = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'team_members', // İlgili kod satırını ve işlemi yürütür
        where: 'teamId = ? AND position = ?', // where özelliğini yapılandırır
        whereArgs: [teamId, positionKey], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (existingPosMember.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Bu mevki başka bir oyuncu tarafından doldurulmuş.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final allMembers = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'team_members', // İlgili kod satırını ve işlemi yürütür
        where: 'teamId = ?', // where özelliğini yapılandırır
        whereArgs: [teamId], // whereArgs özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (allMembers.length >= 7) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Takım kadrosu (7/7) tamamen dolmuş.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final receiverRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'users', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [receiverId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      final receiverName = receiverRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
          ? '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
              .trim() // İlgili kod satırını ve işlemi yürütür
          : 'Oyuncu'; // İlgili kod satırını ve işlemi yürütür

      final teamRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'teams', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [teamId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      final venueName = // Sabit/final değişken veya nesne tanımını başlatır
          teamRows.isNotEmpty ? (teamRows.first['venueName'] as String) : 'Maç'; // İlgili kod satırını ve işlemi yürütür

      final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      // 1. Davet durumunu Accepted olarak güncelle
      await txn.update( // Veritabanındaki mevcut kaydı günceller
        'invitations', // İlgili kod satırını ve işlemi yürütür
        { // İlgili kod satırını ve işlemi yürütür
          'status': InvitationStatus.accepted.value, // 'status' özelliğini yapılandırır
          'respondedAt': now.toIso8601String(), // 'respondedAt' özelliğini yapılandırır
        }, // Açık olan kod/bileşen bloğunu kapatır
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [invitationId], // whereArgs özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      // 2. Kullanıcıyı takıma ve ilgili mevkiye ekle
      final member = TeamMemberModel( // Sabit/final değişken veya nesne tanımını başlatır
        id: _uuid.v4(), // id özelliğini yapılandırır
        teamId: teamId, // teamId özelliğini yapılandırır
        userId: receiverId, // userId özelliğini yapılandırır
        position: positionKey, // position özelliğini yapılandırır
        displayName: receiverName, // displayName özelliğini yapılandırır
        role: 'member', // role özelliğini yapılandırır
        joinedAt: now, // joinedAt özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      await txn.insert('team_members', member.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler

      // 3. Eğer kullanıcı daha önce bu randevuyu gizlediyse gizlemeyi kaldır
      await txn.delete( // Veritabanındaki kaydı veya hesabı siler
        'dismissed_appointments', // İlgili kod satırını ve işlemi yürütür
        where: 'userId = ? AND teamId = ?', // where özelliğini yapılandırır
        whereArgs: [receiverId, teamId], // whereArgs özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      // 4. Daveti gönderen kaptana kabul bildirimi oluştur
      final acceptedNotification = NotificationModel( // Sabit/final değişken veya nesne tanımını başlatır
        id: _uuid.v4(), // id özelliğini yapılandırır
        receiverId: senderId, // receiverId özelliğini yapılandırır
        senderId: receiverId, // senderId özelliğini yapılandırır
        senderName: receiverName, // senderName özelliğini yapılandırır
        type: NotificationType.invitationAccepted, // type özelliğini yapılandırır
        relatedTeamId: teamId, // relatedTeamId özelliğini yapılandırır
        relatedInvitationId: invitationId, // relatedInvitationId özelliğini yapılandırır
        title: 'Davet Kabul Edildi', // title özelliğini yapılandırır
        body: // İlgili kod satırını ve işlemi yürütür
            '$receiverName, $venueName maçı için gönderdiğiniz takım davetini kabul etti ve kadroya katıldı!', // İlgili kod satırını ve işlemi yürütür
        isRead: false, // isRead özelliğini yapılandırır
        createdAt: now, // createdAt özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      await txn.insert('notifications', acceptedNotification.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
    }); // İlgili kod satırını ve işlemi yürütür

    final updated = await getInvitationById(invitationId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (updated == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Güncellenen davet bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return updated; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<InvitationModel> rejectInvitation({ // İlgili kod satırını ve işlemi yürütür
    required String invitationId, // İlgili kod satırını ve işlemi yürütür
    required String currentUserId, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    await db.transaction((txn) async { // Asenkron işlemin tamamlanmasını bekler
      final invRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'invitations', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [invitationId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (invRows.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Davet kaydı bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final invMap = invRows.first; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final status = InvitationStatus.fromValue(invMap['status'] as String); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (status != InvitationStatus.pending) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
          'Bu davet daha önce sonuçlandırılmış (yalnızca bir kez yanıtlanabilir).', // İlgili kod satırını ve işlemi yürütür
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final receiverId = invMap['receiverId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (receiverId != currentUserId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Bu daveti yalnızca davet edilen kullanıcı reddedebilir.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final teamId = invMap['teamId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final senderId = invMap['senderId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      final receiverRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'users', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [receiverId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      final receiverName = receiverRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
          ? '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
              .trim() // İlgili kod satırını ve işlemi yürütür
          : 'Oyuncu'; // İlgili kod satırını ve işlemi yürütür

      final teamRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'teams', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [teamId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      final venueName = // Sabit/final değişken veya nesne tanımını başlatır
          teamRows.isNotEmpty ? (teamRows.first['venueName'] as String) : 'Maç'; // İlgili kod satırını ve işlemi yürütür

      final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      // 1. Davet durumunu Rejected olarak güncelle (mevki boş kalır)
      await txn.update( // Veritabanındaki mevcut kaydı günceller
        'invitations', // İlgili kod satırını ve işlemi yürütür
        { // İlgili kod satırını ve işlemi yürütür
          'status': InvitationStatus.rejected.value, // 'status' özelliğini yapılandırır
          'respondedAt': now.toIso8601String(), // 'respondedAt' özelliğini yapılandırır
        }, // Açık olan kod/bileşen bloğunu kapatır
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [invitationId], // whereArgs özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      // 2. Daveti gönderen kaptana ret bildirimi oluştur
      final rejectedNotification = NotificationModel( // Sabit/final değişken veya nesne tanımını başlatır
        id: _uuid.v4(), // id özelliğini yapılandırır
        receiverId: senderId, // receiverId özelliğini yapılandırır
        senderId: receiverId, // senderId özelliğini yapılandırır
        senderName: receiverName, // senderName özelliğini yapılandırır
        type: NotificationType.invitationRejected, // type özelliğini yapılandırır
        relatedTeamId: teamId, // relatedTeamId özelliğini yapılandırır
        relatedInvitationId: invitationId, // relatedInvitationId özelliğini yapılandırır
        title: 'Davet Reddedildi', // title özelliğini yapılandırır
        body: // İlgili kod satırını ve işlemi yürütür
            '$receiverName, $venueName maçı için gönderdiğiniz takım davetini reddetti. Ayrılan mevki tekrar boş durumda.', // İlgili kod satırını ve işlemi yürütür
        isRead: false, // isRead özelliğini yapılandırır
        createdAt: now, // createdAt özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      await txn.insert('notifications', rejectedNotification.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
    }); // İlgili kod satırını ve işlemi yürütür

    final updated = await getInvitationById(invitationId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (updated == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Güncellenen davet bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return updated; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<InvitationModel> _hydrateInvitation( // İlgili kod satırını ve işlemi yürütür
    Database db, // İlgili kod satırını ve işlemi yürütür
    Map<String, Object?> row, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final senderId = row['senderId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final receiverId = row['receiverId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final teamId = row['teamId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final senderRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [senderId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final receiverRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [receiverId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final senderName = senderRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
        ? '${senderRows.first['firstName']} ${senderRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
            .trim() // İlgili kod satırını ve işlemi yürütür
        : 'Kaptan'; // İlgili kod satırını ve işlemi yürütür
    final receiverName = receiverRows.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
        ? '${receiverRows.first['firstName']} ${receiverRows.first['lastName']}' // İlgili kod satırını ve işlemi yürütür
            .trim() // İlgili kod satırını ve işlemi yürütür
        : 'Oyuncu'; // İlgili kod satırını ve işlemi yürütür

    final team = await teamRepository.getTeamById(teamId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return InvitationModel.fromMap( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      row, // İlgili kod satırını ve işlemi yürütür
      senderName: senderName, // senderName özelliğini yapılandırır
      receiverName: receiverName, // receiverName özelliğini yapılandırır
      team: team, // team özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<InvitationModel?> getInvitationById(String invitationId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'invitations', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [invitationId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (rows.isEmpty) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
    return _hydrateInvitation(db, rows.first); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<InvitationModel>> getIncomingInvitations(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'invitations', // İlgili kod satırını ve işlemi yürütür
      where: 'receiverId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt DESC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final list = <InvitationModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in rows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      list.add(await _hydrateInvitation(db, row)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return list; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<InvitationModel>> getOutgoingInvitations(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'invitations', // İlgili kod satırını ve işlemi yürütür
      where: 'senderId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt DESC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final list = <InvitationModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in rows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      list.add(await _hydrateInvitation(db, row)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return list; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
