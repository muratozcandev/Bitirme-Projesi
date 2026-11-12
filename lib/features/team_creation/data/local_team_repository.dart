import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // SQLite yerel veritabanı sürücüsünü içe aktarır
import 'package:uuid/uuid.dart'; // Benzersiz kimlik (UUID) üretici paketi içe aktarır
import '../../../core/errors/app_exception.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/match_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/team_member_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/team_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../domain/team_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LocalTeamRepository implements TeamRepository { // LocalTeamRepository veri erişim (repository) sınıfını tanımlar
  final AppDatabase appDatabase; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Uuid _uuid = const Uuid(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  LocalTeamRepository({required this.appDatabase}); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<TeamModel> createTeam({ // İlgili kod satırını ve işlemi yürütür
    required String captainId, // İlgili kod satırını ve işlemi yürütür
    required String captainName, // İlgili kod satırını ve işlemi yürütür
    required Formation formation, // İlgili kod satırını ve işlemi yürütür
    required String province, // İlgili kod satırını ve işlemi yürütür
    required String district, // İlgili kod satırını ve işlemi yürütür
    required String venueName, // İlgili kod satırını ve işlemi yürütür
    required String matchDate, // İlgili kod satırını ve işlemi yürütür
    required String startTime, // İlgili kod satırını ve işlemi yürütür
    required String endTime, // İlgili kod satırını ve işlemi yürütür
    required Map<String, String> lineup, // İlgili kod satırını ve işlemi yürütür
    String? captainPositionKey, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    if (province.trim().isEmpty || // Koşulun sağlanıp sağlanmadığını kontrol eder
        district.trim().isEmpty || // İlgili kod satırını ve işlemi yürütür
        venueName.trim().isEmpty || // İlgili kod satırını ve işlemi yürütür
        matchDate.trim().isEmpty || // İlgili kod satırını ve işlemi yürütür
        startTime.trim().isEmpty || // İlgili kod satırını ve işlemi yürütür
        endTime.trim().isEmpty) { // İlgili kod satırını ve işlemi yürütür
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Takım oluşturmak için il, ilçe, halı saha, tarih, saat ve diziliş seçilmelidir.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    // Aynı kaptan aynı saha, tarih ve saat için tekrar takım oluşturamaz
    final duplicateRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      where: // İlgili kod satırını ve işlemi yürütür
          'captainId = ? AND province = ? AND district = ? AND venueName = ? AND matchDate = ? AND startTime = ? AND status = ?', // İlgili kod satırını ve işlemi yürütür
      whereArgs: [ // İlgili kod satırını ve işlemi yürütür
        captainId, // İlgili kod satırını ve işlemi yürütür
        province, // İlgili kod satırını ve işlemi yürütür
        district, // İlgili kod satırını ve işlemi yürütür
        venueName, // İlgili kod satırını ve işlemi yürütür
        matchDate, // İlgili kod satırını ve işlemi yürütür
        startTime, // İlgili kod satırını ve işlemi yürütür
        'active', // İlgili kod satırını ve işlemi yürütür
      ], // Açık olan kod/bileşen bloğunu kapatır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    if (duplicateRows.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Bu halı saha, tarih ve saat için zaten oluşturulmuş bir takımınız bulunuyor.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final teamId = _uuid.v4(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final matchId = _uuid.v4(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final validPositionKeys = formation.positions.map((e) => e.key).toList(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (validPositionKeys.length != 7) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Diziliş 7 oyuncudan oluşmalıdır.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    // Kaptanın kendi pozisyonunu belirle:
    String resolvedCaptainPos = captainPositionKey ?? ''; // İlgili kod satırını ve işlemi yürütür
    if (resolvedCaptainPos.isEmpty || // Koşulun sağlanıp sağlanmadığını kontrol eder
        !validPositionKeys.contains(resolvedCaptainPos)) { // İlgili kod satırını ve işlemi yürütür
      // Kaptanın adı herhangi bir mevkide yazılıysa o mevkiyi kaptana ata
      final matchedEntry = lineup.entries.where((e) { // Sabit/final değişken veya nesne tanımını başlatır
        return validPositionKeys.contains(e.key) && // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
            e.value.trim().toLowerCase() == captainName.trim().toLowerCase(); // İlgili kod satırını ve işlemi yürütür
      }).firstOrNull; // İlgili kod satırını ve işlemi yürütür

      if (matchedEntry != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        resolvedCaptainPos = matchedEntry.key; // İlgili kod satırını ve işlemi yürütür
      } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
        // Boş olan ilk mevkiyi veya GK_1'i kaptana ata
        resolvedCaptainPos = validPositionKeys.firstWhere( // İlgili kod satırını ve işlemi yürütür
          (k) => (lineup[k] ?? '').trim().isEmpty, // İlgili kod satırını ve işlemi yürütür
          orElse: () => validPositionKeys.first, // orElse özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final membersToInsert = <TeamMemberModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    for (final posKey in validPositionKeys) { // Koleksiyon veya aralık üzerinde döngü başlatır
      if (posKey == resolvedCaptainPos) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        final customText = (lineup[posKey] ?? '').trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
        membersToInsert.add( // İlgili kod satırını ve işlemi yürütür
          TeamMemberModel( // İlgili kod satırını ve işlemi yürütür
            id: _uuid.v4(), // id özelliğini yapılandırır
            teamId: teamId, // teamId özelliğini yapılandırır
            userId: captainId, // userId özelliğini yapılandırır
            position: posKey, // position özelliğini yapılandırır
            displayName: customText.isNotEmpty ? customText : captainName, // displayName özelliğini yapılandırır
            role: 'captain', // role özelliğini yapılandırır
            joinedAt: now, // joinedAt özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
        final playerName = (lineup[posKey] ?? '').trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
        if (playerName.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          membersToInsert.add( // İlgili kod satırını ve işlemi yürütür
            TeamMemberModel( // İlgili kod satırını ve işlemi yürütür
              id: _uuid.v4(), // id özelliğini yapılandırır
              teamId: teamId, // teamId özelliğini yapılandırır
              userId: null, // userId özelliğini yapılandırır
              position: posKey, // position özelliğini yapılandırır
              displayName: playerName, // displayName özelliğini yapılandırır
              role: 'guest', // role özelliğini yapılandırır
              joinedAt: now, // joinedAt özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ); // Açık olan kod/bileşen bloğunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final team = TeamModel( // Sabit/final değişken veya nesne tanımını başlatır
      id: teamId, // id özelliğini yapılandırır
      captainId: captainId, // captainId özelliğini yapılandırır
      captainName: captainName, // captainName özelliğini yapılandırır
      formation: formation, // formation özelliğini yapılandırır
      province: province, // province özelliğini yapılandırır
      district: district, // district özelliğini yapılandırır
      venueName: venueName, // venueName özelliğini yapılandırır
      matchDate: matchDate, // matchDate özelliğini yapılandırır
      startTime: startTime, // startTime özelliğini yapılandırır
      endTime: endTime, // endTime özelliğini yapılandırır
      createdAt: now, // createdAt özelliğini yapılandırır
      status: 'active', // status özelliğini yapılandırır
      members: membersToInsert, // members özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final matchRecord = MatchModel( // Sabit/final değişken veya nesne tanımını başlatır
      id: matchId, // id özelliğini yapılandırır
      teamId: teamId, // teamId özelliğini yapılandırır
      venueName: venueName, // venueName özelliğini yapılandırır
      province: province, // province özelliğini yapılandırır
      district: district, // district özelliğini yapılandırır
      matchDate: matchDate, // matchDate özelliğini yapılandırır
      startTime: startTime, // startTime özelliğini yapılandırır
      endTime: endTime, // endTime özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    await db.transaction((txn) async { // Asenkron işlemin tamamlanmasını bekler
      await txn.insert('teams', team.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
      await txn.insert('matches', matchRecord.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
      for (final member in membersToInsert) { // Koleksiyon veya aralık üzerinde döngü başlatır
        await txn.insert('team_members', member.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
      } // Açık olan kod/bileşen bloğunu kapatır
    }); // İlgili kod satırını ve işlemi yürütür

    return team; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<TeamModel?> getTeamById(String teamId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [teamId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (rows.isEmpty) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
    return _hydrateTeam(db, rows.first); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<TeamModel> _hydrateTeam( // İlgili kod satırını ve işlemi yürütür
    DatabaseExecutor db, // İlgili kod satırını ve işlemi yürütür
    Map<String, Object?> teamRow, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final teamId = teamRow['id'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final captainId = teamRow['captainId'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final userRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [captainId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    String captainName = 'Takım Kaptanı'; // İlgili kod satırını ve işlemi yürütür
    if (userRows.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      final first = userRows.first['firstName'] as String? ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final last = userRows.first['lastName'] as String? ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      captainName = '$first $last'.trim(); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    final memberRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'team_members', // İlgili kod satırını ve işlemi yürütür
      where: 'teamId = ?', // where özelliğini yapılandırır
      whereArgs: [teamId], // whereArgs özelliğini yapılandırır
      orderBy: 'joinedAt ASC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final members = memberRows.map(TeamMemberModel.fromMap).toList(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return TeamModel.fromMap( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      teamRow, // İlgili kod satırını ve işlemi yürütür
      captainName: captainName, // captainName özelliğini yapılandırır
      members: members, // members özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<TeamModel>> getUserAppointments(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    // Kullanıcının sildiği randevuları hariç tut
    final dismissedRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'dismissed_appointments', // İlgili kod satırını ve işlemi yürütür
      where: 'userId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final dismissedTeamIds = // Sabit/final değişken veya nesne tanımını başlatır
        dismissedRows.map((r) => r['teamId'] as String).toSet(); // İlgili kod satırını ve işlemi yürütür

    // Kullanıcının kaptan olduğu veya üye olduğu takımlar
    final memberTeamRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'team_members', // İlgili kod satırını ve işlemi yürütür
      columns: ['teamId'], // columns özelliğini yapılandırır
      where: 'userId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final captainTeamRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      columns: ['id'], // columns özelliğini yapılandırır
      where: 'captainId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final teamIds = <String>{ // Sabit/final değişken veya nesne tanımını başlatır
      ...memberTeamRows.map((r) => r['teamId'] as String), // İlgili kod satırını ve işlemi yürütür
      ...captainTeamRows.map((r) => r['id'] as String), // İlgili kod satırını ve işlemi yürütür
    }.difference(dismissedTeamIds); // İlgili kod satırını ve işlemi yürütür

    if (teamIds.isEmpty) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder

    final placeholders = List.filled(teamIds.length, '?').join(','); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final teamRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      where: 'id IN ($placeholders)', // where özelliğini yapılandırır
      whereArgs: teamIds.toList(), // whereArgs özelliğini yapılandırır
      orderBy: 'matchDate ASC, startTime ASC, createdAt DESC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final result = <TeamModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in teamRows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      result.add(await _hydrateTeam(db, row)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return result; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<TeamModel>> getCaptainTeams(String captainId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final dismissedRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'dismissed_appointments', // İlgili kod satırını ve işlemi yürütür
      where: 'userId = ?', // where özelliğini yapılandırır
      whereArgs: [captainId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final dismissedTeamIds = // Sabit/final değişken veya nesne tanımını başlatır
        dismissedRows.map((r) => r['teamId'] as String).toSet(); // İlgili kod satırını ve işlemi yürütür

    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      where: 'captainId = ? AND status = ?', // where özelliğini yapılandırır
      whereArgs: [captainId, 'active'], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt DESC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final result = <TeamModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in rows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final id = row['id'] as String; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (!dismissedTeamIds.contains(id)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        result.add(await _hydrateTeam(db, row)); // İlgili kod satırını ve işlemi yürütür
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return result; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<TeamModel>> getUserChatTeams(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final memberRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'team_members', // İlgili kod satırını ve işlemi yürütür
      columns: ['teamId'], // columns özelliğini yapılandırır
      where: 'userId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final captainRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      columns: ['id'], // columns özelliğini yapılandırır
      where: 'captainId = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final teamIds = <String>{ // Sabit/final değişken veya nesne tanımını başlatır
      ...memberRows.map((r) => r['teamId'] as String), // İlgili kod satırını ve işlemi yürütür
      ...captainRows.map((r) => r['id'] as String), // İlgili kod satırını ve işlemi yürütür
    }; // Açık olan kod/bileşen bloğunu kapatır

    if (teamIds.isEmpty) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder

    final placeholders = List.filled(teamIds.length, '?').join(','); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      where: 'id IN ($placeholders)', // where özelliğini yapılandırır
      whereArgs: teamIds.toList(), // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt DESC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final result = <TeamModel>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final row in rows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      result.add(await _hydrateTeam(db, row)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return result; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<void> deleteAppointmentForUser({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final now = DateTime.now().toIso8601String(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    await db.transaction((txn) async { // Asenkron işlemin tamamlanmasını bekler
      await txn.insert( // SQLite veritabanı tablosuna yeni kayıt ekler
        'dismissed_appointments', // İlgili kod satırını ve işlemi yürütür
        { // İlgili kod satırını ve işlemi yürütür
          'userId': userId, // 'userId' özelliğini yapılandırır
          'teamId': teamId, // 'teamId' özelliğini yapılandırır
          'dismissedAt': now, // 'dismissedAt' özelliğini yapılandırır
        }, // Açık olan kod/bileşen bloğunu kapatır
        conflictAlgorithm: ConflictAlgorithm.replace, // conflictAlgorithm özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      // Eğer silen kişi kaptan ise ve henüz başka hiçbir kayıtlı üye katılmamışsa bekleyen davetleri iptal et
      final teamRows = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'teams', // İlgili kod satırını ve işlemi yürütür
        where: 'id = ?', // where özelliğini yapılandırır
        whereArgs: [teamId], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (teamRows.isNotEmpty && teamRows.first['captainId'] == userId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        final otherMembers = await txn.query( // SQLite veritabanı tablosundan koşullu veri sorgular
          'team_members', // İlgili kod satırını ve işlemi yürütür
          where: 'teamId = ? AND userId IS NOT NULL AND userId != ?', // where özelliğini yapılandırır
          whereArgs: [teamId, userId], // whereArgs özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
        if (otherMembers.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          await txn.update( // Veritabanındaki mevcut kaydı günceller
            'invitations', // İlgili kod satırını ve işlemi yürütür
            { // İlgili kod satırını ve işlemi yürütür
              'status': 'Cancelled', // 'status' özelliğini yapılandırır
              'respondedAt': now, // 'respondedAt' özelliğini yapılandırır
            }, // Açık olan kod/bileşen bloğunu kapatır
            where: 'teamId = ? AND status = ?', // where özelliğini yapılandırır
            whereArgs: [teamId, 'Pending'], // whereArgs özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    }); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<bool> isUserMemberOfTeam({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final captainRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'teams', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ? AND captainId = ?', // where özelliğini yapılandırır
      whereArgs: [teamId, userId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (captainRows.isNotEmpty) return true; // Koşulun sağlanıp sağlanmadığını kontrol eder

    final memberRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'team_members', // İlgili kod satırını ve işlemi yürütür
      where: 'teamId = ? AND userId = ?', // where özelliğini yapılandırır
      whereArgs: [teamId, userId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    return memberRows.isNotEmpty; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
