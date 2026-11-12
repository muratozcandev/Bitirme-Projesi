// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hali_saha_7v7/core/errors/app_exception.dart';
import 'package:hali_saha_7v7/core/utils/firebase_auth_import_preparer.dart';
import 'package:hali_saha_7v7/data/database/app_database.dart';
import 'package:hali_saha_7v7/features/authentication/data/firebase_auth_repository.dart';
import 'package:hali_saha_7v7/features/authentication/data/local_auth_repository.dart';
import 'package:hali_saha_7v7/features/chat/data/local_chat_repository.dart';
import 'package:hali_saha_7v7/features/notifications/data/local_invitation_repository.dart';
import 'package:hali_saha_7v7/features/notifications/data/local_notification_repository.dart';
import 'package:hali_saha_7v7/features/team_creation/data/local_team_repository.dart';
import 'package:hali_saha_7v7/firebase_options.dart';
import 'package:hali_saha_7v7/shared/models/formation.dart';
import 'package:hali_saha_7v7/shared/models/invitation_model.dart';
import 'package:hali_saha_7v7/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide Transaction;

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase db;
  late LocalAuthRepository authRepo;
  late LocalTeamRepository teamRepo;
  late LocalInvitationRepository invitationRepo;
  late LocalNotificationRepository notificationRepo;
  late LocalChatRepository chatRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting('test_${DateTime.now().microsecondsSinceEpoch}');
    await db.database;

    authRepo = LocalAuthRepository(appDatabase: db, prefs: prefs);
    teamRepo = LocalTeamRepository(appDatabase: db);
    invitationRepo = LocalInvitationRepository(
      appDatabase: db,
      teamRepository: teamRepo,
    );
    notificationRepo = LocalNotificationRepository(appDatabase: db);
    chatRepo = LocalChatRepository(
      appDatabase: db,
      teamRepository: teamRepo,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('1-4. Giriş İşlemleri ve 10 Hazır Test Hesabı', () {
    test('E-posta ile giriş başarılı olmalı (Cristiano Ronaldo)', () async {
      final user = await authRepo.login(
        identifier: 'cr7@gmail.com',
        password: 'cris7',
      );
      expect(user.firstName, 'cristiano');
      expect(user.lastName, 'Ronaldo');
      expect(user.phone, '05111111111');

      final sessionUser = await authRepo.getCurrentUser();
      expect(sessionUser?.id, user.id);
    });

    test('Telefon numarası ile giriş aynı kullanıcıyı döndürmeli', () async {
      final byEmail = await authRepo.login(
        identifier: 'm10@gmail.com',
        password: 'messi10',
      );
      await authRepo.logout();

      final byPhone = await authRepo.login(
        identifier: '05222222222',
        password: 'messi10',
      );
      expect(byPhone.id, byEmail.id);
      expect(byPhone.email, 'm10@gmail.com');
    });

    test('Yanlış şifre ile giriş AppException fırlatmalı', () async {
      expect(
        () => authRepo.login(
          identifier: 'cr7@gmail.com',
          password: 'wrong_password',
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('10 test hesabının tamamı benzersiz olmalı ve önerilerde kendi hesabı hariç 9 kişi gelmeli', () async {
      final cr7 = await authRepo.login(
        identifier: 'cr7@gmail.com',
        password: 'cris7',
      );
      final suggestions = await authRepo.getSuggestedPlayers(cr7.id);
      expect(suggestions.length, 9);
      expect(suggestions.any((u) => u.id == cr7.id), isFalse);
    });
  });

  group('5-6. Kayıt Formu Doğrulama, Sözleşme Onayları ve Yinelenen Hesap Kontrolü', () {
    test('Sözleşme veya KVKK onayı olmadan kayıt engellenmeli', () async {
      expect(
        () => authRepo.register(
          firstName: 'Arda',
          lastName: 'Güler',
          email: 'arda@gmail.com',
          phone: '05412345678',
          password: 'arda10',
          acceptedUserAgreement: true,
          acceptedKvkk: false,
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('Yeni kullanıcı kaydı ve yinelenen e-posta/telefon kontrolü çalışmalı', () async {
      final registered = await authRepo.register(
        firstName: 'Arda',
        lastName: 'Güler',
        email: 'arda@gmail.com',
        phone: '05412345678',
        password: 'arda10',
        acceptedUserAgreement: true,
        acceptedKvkk: true,
      );
      expect(registered.email, 'arda@gmail.com');

      // Aynı e-posta ile tekrar kayıt engellenmeli
      expect(
        () => authRepo.register(
          firstName: 'Başka',
          lastName: 'Oyuncu',
          email: 'arda@gmail.com',
          phone: '05499999999',
          password: 'pass123',
          acceptedUserAgreement: true,
          acceptedKvkk: true,
        ),
        throwsA(isA<AppException>()),
      );

      // Aynı telefon ile tekrar kayıt engellenmeli
      expect(
        () => authRepo.register(
          firstName: 'Başka',
          lastName: 'Oyuncu',
          email: 'baska@gmail.com',
          phone: '05412345678',
          password: 'pass123',
          acceptedUserAgreement: true,
          acceptedKvkk: true,
        ),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('7. Diziliş Pozisyon Hesaplama (6 Farklı Diziliş)', () {
    test('6 dizilişin tamamı Kaleci dahil tam 7 oyuncudan oluşmalı', () {
      for (final formation in Formation.values) {
        final positions = formation.positions;
        expect(positions.length, 7);
        expect(positions.first.key, 'GK_1');
        expect(positions.first.label, 'Kaleci');
      }

      expect(Formation.threeThree.midfielderCount, 0);
      expect(Formation.threeThree.defenderCount, 3);
      expect(Formation.threeThree.forwardCount, 3);
    });

    test('Diziliş değiştiğinde yalnızca karşılığı olan mevkiler korunmalı, olmayanlar sessizce aktarılmamalı', () {
      final oldLineup = {
        'GK_1': 'Manuel neur',
        'DEF_1': 'Sergio Ramos',
        'DEF_3': 'Üçüncü Defans',
      };
      // 2-3-1 dizilişinde DEF_3 yoktur (yalnızca DEF_1 ve DEF_2 vardır)
      final migrated = Formation.twoThreeOne.migrateLineup(oldLineup);
      expect(migrated['GK_1'], 'Manuel neur');
      expect(migrated['DEF_1'], 'Sergio Ramos');
      expect(migrated.containsKey('DEF_3'), isFalse);
      expect(migrated.containsKey('MID_1'), isFalse);
    });
  });

  group('8-15. Takım Kurma, Davet Gönderme/Kabul/Ret, Bildirim, Sohbet, Tema ve Randevu Silme', () {
    test('Takım oluşturma, davet gönderme, kabul etme, takım üyeliği ve sohbet akışı', () async {
      final cr7 = await authRepo.login(
        identifier: 'cr7@gmail.com',
        password: 'cris7',
      );
      final messi = (await authRepo.getSuggestedPlayers(cr7.id))
          .firstWhere((u) => u.email == 'm10@gmail.com');
      final ramos = (await authRepo.getSuggestedPlayers(cr7.id))
          .firstWhere((u) => u.email == 'ramos4@gmail.com');

      // 8. Takım oluşturma
      final team = await teamRepo.createTeam(
        captainId: cr7.id,
        captainName: cr7.fullName,
        formation: Formation.threeTwoOne,
        province: 'İstanbul',
        district: 'Kadıköy',
        venueName: 'Kadıköy Arena 7v7 Halı Saha (Test)',
        matchDate: '2027-05-20',
        startTime: '20.00',
        endTime: '21.00',
        lineup: {'FWD_1': cr7.fullName},
        captainPositionKey: 'FWD_1',
      );

      expect(team.captainId, cr7.id);
      expect(team.members.length, 1);
      expect(team.emptyPositions.length, 6);

      // Aynı maç için tekrar takım oluşturma engellenmeli
      expect(
        () => teamRepo.createTeam(
          captainId: cr7.id,
          captainName: cr7.fullName,
          formation: Formation.threeTwoOne,
          province: 'İstanbul',
          district: 'Kadıköy',
          venueName: 'Kadıköy Arena 7v7 Halı Saha (Test)',
          matchDate: '2027-05-20',
          startTime: '20.00',
          endTime: '21.00',
          lineup: {},
        ),
        throwsA(isA<AppException>()),
      );

      // 9. Davet gönderme (CR7 -> Messi, MID_1 mevkisi)
      final invite = await invitationRepo.sendInvitation(
        teamId: team.id,
        senderId: cr7.id,
        receiverId: messi.id,
        positionKey: 'MID_1',
      );
      expect(invite.status, InvitationStatus.pending);

      // Aynı kullanıcıya aynı takıma tekrar bekleyen davet engellenmeli
      expect(
        () => invitationRepo.sendInvitation(
          teamId: team.id,
          senderId: cr7.id,
          receiverId: messi.id,
          positionKey: 'MID_2',
        ),
        throwsA(isA<AppException>()),
      );

      // Messi'nin bildirimlerine davet isteği düşmüş olmalı
      final messiNotifications =
          await notificationRepo.getUserNotifications(messi.id);
      expect(messiNotifications.length, 1);

      // 10 & 12. Davet kabul etme ve takım üyeliği
      final accepted = await invitationRepo.acceptInvitation(
        invitationId: invite.id,
        currentUserId: messi.id,
      );
      expect(accepted.status, InvitationStatus.accepted);

      // Aynı davet ikinci kez kabul edilememeli
      expect(
        () => invitationRepo.acceptInvitation(
          invitationId: invite.id,
          currentUserId: messi.id,
        ),
        throwsA(isA<AppException>()),
      );

      // Messi'nin Randevularım listesine maç eklenmiş olmalı
      final messiAppointments = await teamRepo.getUserAppointments(messi.id);
      expect(messiAppointments.length, 1);
      expect(messiAppointments.first.id, team.id);

      // CR7'ye davet kabul bildirimi gitmiş olmalı
      final cr7Notifications =
          await notificationRepo.getUserNotifications(cr7.id);
      expect(cr7Notifications.any((n) => n.title == 'Davet Kabul Edildi'), isTrue);

      // 11. Davet reddetme (CR7 -> Ramos, DEF_1 mevkisi)
      final ramosInvite = await invitationRepo.sendInvitation(
        teamId: team.id,
        senderId: cr7.id,
        receiverId: ramos.id,
        positionKey: 'DEF_1',
      );
      final rejected = await invitationRepo.rejectInvitation(
        invitationId: ramosInvite.id,
        currentUserId: ramos.id,
      );
      expect(rejected.status, InvitationStatus.rejected);

      // Ramos takıma eklenmemiş olmalı ve DEF_1 boş kalmalı
      final isRamosMember = await teamRepo.isUserMemberOfTeam(
        teamId: team.id,
        userId: ramos.id,
      );
      expect(isRamosMember, isFalse);

      // 13. Takım sohbeti: Üye olmayan (Ramos) mesaj gönderememeli, üye olan (Messi & CR7) gönderebilmeli
      expect(
        () => chatRepo.sendMessage(
          teamId: team.id,
          senderId: ramos.id,
          content: 'Merhaba',
        ),
        throwsA(isA<AppException>()),
      );

      await chatRepo.sendMessage(
        teamId: team.id,
        senderId: cr7.id,
        content: 'Maça hazır mıyız?',
      );
      await chatRepo.sendMessage(
        teamId: team.id,
        senderId: messi.id,
        content: 'Hazırım kaptan!',
      );

      final messages = await chatRepo.getTeamMessages(
        teamId: team.id,
        requesterId: messi.id,
      );
      expect(messages.length, 2);
      expect(messages.first.content, 'Maça hazır mıyız?');
      expect(messages.last.content, 'Hazırım kaptan!');

      // 14. Kullanıcı bazlı tema tercihi diğer kullanıcının temasını değiştirmemeli
      final updatedCr7 = await authRepo.updateThemeMode(
        userId: cr7.id,
        themeMode: 'dark',
      );
      final freshMessi = await authRepo.getUserById(messi.id);
      expect(updatedCr7.themeMode, 'dark');
      expect(freshMessi?.themeMode, 'light');

      // 15. Randevu silme: Messi kendi randevu listesinden sildiğinde CR7'nin randevusu silinmemeli
      await teamRepo.deleteAppointmentForUser(
        teamId: team.id,
        userId: messi.id,
      );
      final messiAfterDelete = await teamRepo.getUserAppointments(messi.id);
      final cr7AfterDelete = await teamRepo.getUserAppointments(cr7.id);
      expect(messiAfterDelete, isEmpty);
      expect(cr7AfterDelete.length, 1);
    });

    test('Firebase yapılandırma seçenekleri (DefaultFirebaseOptions) doğrulanmalı', () {
      expect(DefaultFirebaseOptions.android.projectId, 'v7-app-341ae');
      expect(DefaultFirebaseOptions.web.projectId, 'v7-app-341ae');
      expect(DefaultFirebaseOptions.windows.projectId, 'v7-app-341ae');
      expect(DefaultFirebaseOptions.android.apiKey.isNotEmpty, isTrue);
    });

    test('UserModel Firestore serileştirmesi şifre içermemeli ve zorunlu alanları korumalı', () {
      final now = DateTime.utc(2026, 11, 12, 4, 30);
      final user = UserModel(
        id: 'firebase_uid_123',
        firstName: 'Hakan',
        lastName: 'Çalhanoğlu',
        email: 'hakan@gmail.com',
        phone: '05321112233',
        passwordHash: 'GIZLI_HASH_FIRESTORE_GITMEMELI',
        createdAt: now,
        termsAccepted: true,
        kvkkAccepted: true,
      );

      final firestoreMap = user.toFirestoreMap();
      expect(firestoreMap['uid'], 'firebase_uid_123');
      expect(firestoreMap['firstName'], 'Hakan');
      expect(firestoreMap['lastName'], 'Çalhanoğlu');
      expect(firestoreMap['email'], 'hakan@gmail.com');
      expect(firestoreMap['phone'], '05321112233');
      expect(firestoreMap['createdAt'], isA<Timestamp>());
      expect(firestoreMap['termsAccepted'], isTrue);
      expect(firestoreMap['kvkkAccepted'], isTrue);
      // Şifre veya passwordHash kesinlikle Firestore haritasında bulunmamalı
      expect(firestoreMap.containsKey('password'), isFalse);
      expect(firestoreMap.containsKey('passwordHash'), isFalse);

      final parsed = UserModel.fromFirestore(
        firestoreMap,
        docId: 'firebase_uid_123',
      );
      expect(parsed.id, 'firebase_uid_123');
      expect(parsed.fullName, 'Hakan Çalhanoğlu');
      expect(parsed.passwordHash, isEmpty);
    });

    test('FirebaseAuthRepository kayıt ve giriş doğrulamaları zorunlu kuralları denetlemeli', () async {
      final prefs = await SharedPreferences.getInstance();
      final fbRepo = FirebaseAuthRepository(
        firebaseAuth: null,
        firestore: null,
        appDatabase: db,
        prefs: prefs,
      );

      // Sözleşme ve KVKK onayı zorunlu
      expect(
        () => fbRepo.register(
          firstName: 'Kerem',
          lastName: 'Aktürkoğlu',
          email: 'kerem@gmail.com',
          phone: '05334445566',
          password: 'password123',
          acceptedUserAgreement: false,
          acceptedKvkk: true,
        ),
        throwsA(isA<AppException>()),
      );

      // 6 karakterden kısa şifre engellenmeli
      expect(
        () => fbRepo.register(
          firstName: 'Kerem',
          lastName: 'Aktürkoğlu',
          email: 'kerem@gmail.com',
          phone: '05334445566',
          password: '12345',
          acceptedUserAgreement: true,
          acceptedKvkk: true,
        ),
        throwsA(isA<AppException>()),
      );
    });

    test(
        'Firestore güvenlik kuralları (firestore.rules) ile kayıt, e-posta girişi, telefon benzersizliği ve izolasyon uyumlu çalışmalı',
        () async {
      final prefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeFirebaseAuth();
      final fakeFirestore = RuleEnforcingFakeFirestore(auth: fakeAuth);
      final fbRepo = FirebaseAuthRepository(
        firebaseAuth: fakeAuth,
        firestore: fakeFirestore,
        appDatabase: db,
        prefs: prefs,
      );

      // 1. Kimlik doğrulaması olmadan (`request.auth == null`) phone_lookup veya users okunamamalı
      expect(
        () => fakeFirestore.collection('phone_lookup').doc('05334445566').get(),
        throwsA(
          isA<FirebaseException>()
              .having((e) => e.code, 'code', 'permission-denied'),
        ),
      );
      expect(
        () => fakeFirestore.collection('users').doc('any_uid').get(),
        throwsA(
          isA<FirebaseException>()
              .having((e) => e.code, 'code', 'permission-denied'),
        ),
      );

      // 2. Yeni kullanıcı kaydı (`register`) güvenlik kurallarıyla tam uyumlu çalışmalı
      final registeredUser = await fbRepo.register(
        firstName: 'Kerem',
        lastName: 'Aktürkoğlu',
        email: 'kerem@gmail.com',
        phone: '05334445566',
        password: 'password123',
        acceptedUserAgreement: true,
        acceptedKvkk: true,
      );

      expect(registeredUser.email, 'kerem@gmail.com');
      expect(registeredUser.phone, '05334445566');
      // Kayıt sonrası geçici oturum kapatılmış olmalı (giriş ekranına yönlendirme için)
      expect(fakeAuth.currentUser, isNull);

      // phone_lookup belgesinde e-posta veya şifre yer almamalı, yalnızca uid, phone, createdAt bulunmalı
      final rawPhoneDoc = fakeFirestore.rawDoc('phone_lookup', '05334445566');
      expect(rawPhoneDoc, isNotNull);
      expect(rawPhoneDoc!.keys.toSet(), {'uid', 'phone', 'createdAt'});
      expect(rawPhoneDoc.containsKey('email'), isFalse);

      // 3. Aynı telefon numarasıyla (`05334445566`) ikinci bir hesap oluşturulması engellenmeli ve Auth hesabı geri alınmalı (rollback)
      await expectLater(
        () => fbRepo.register(
          firstName: 'Barış Alper',
          lastName: 'Yılmaz',
          email: 'baris@gmail.com',
          phone: '05334445566',
          password: 'password123',
          acceptedUserAgreement: true,
          acceptedKvkk: true,
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', 'phone-already-in-use'),
        ),
      );
      // Rollback sonrasında 'baris@gmail.com' Firebase Auth üzerinde kalmamalı
      expect(fakeAuth.hasEmail('baris@gmail.com'), isFalse);

      // 4. Telefon numarasıyla giriş geçici olarak devre dışı olmalı (phone-login-disabled)
      await expectLater(
        () => fbRepo.login(
          identifier: '05334445566',
          password: 'password123',
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', 'phone-login-disabled'),
        ),
      );

      // 5. E-posta ve şifre ile giriş (`login`) güvenlik kurallarıyla uyumlu çalışmalı
      final loggedInUser = await fbRepo.login(
        identifier: 'kerem@gmail.com',
        password: 'password123',
      );
      expect(loggedInUser.id, registeredUser.id);
      expect(loggedInUser.fullName, 'Kerem Aktürkoğlu');
      expect(fakeAuth.currentUser?.uid, registeredUser.id);

      // 6. İkinci bir kullanıcı kaydedip oturum açtığında, ilk kullanıcının profilini okuyamamalı ve değiştirememeli
      await fbRepo.logout();
      final secondUser = await fbRepo.register(
        firstName: 'Ferdi',
        lastName: 'Kadıoğlu',
        email: 'ferdi@gmail.com',
        phone: '05445556677',
        password: 'password123',
        acceptedUserAgreement: true,
        acceptedKvkk: true,
      );
      await fbRepo.login(
        identifier: 'ferdi@gmail.com',
        password: 'password123',
      );
      expect(fakeAuth.currentUser?.uid, secondUser.id);

      // Ferdi (secondUser), Kerem'in (registeredUser) `users/{uid}` belgesini OKUYAMAZ
      expect(
        () => fakeFirestore.collection('users').doc(registeredUser.id).get(),
        throwsA(
          isA<FirebaseException>()
              .having((e) => e.code, 'code', 'permission-denied'),
        ),
      );

      // Ferdi, `users` koleksiyonunu LİSTELEYEMEZ (`allow list: if false`)
      expect(
        () => fakeFirestore.collection('users').get(),
        throwsA(
          isA<FirebaseException>()
              .having((e) => e.code, 'code', 'permission-denied'),
        ),
      );

      // Ferdi, Kerem'in profilini DEĞİŞTİREMEZ (`allow update: if isOwner(uid)`)
      expect(
        () => fakeFirestore
            .collection('users')
            .doc(registeredUser.id)
            .update({'firstName': 'Yetkisiz'}),
        throwsA(
          isA<FirebaseException>()
              .having((e) => e.code, 'code', 'permission-denied'),
        ),
      );

      // Ferdi kendi profilinin temasını güncelleyebilir (`isOwner(uid)`)
      final updatedFerdi = await fbRepo.updateThemeMode(
        userId: secondUser.id,
        themeMode: 'dark',
      );
      expect(updatedFerdi.themeMode, 'dark');
    });

    test(
        'Firestore profili bulunmayan seed kullanıcısının SQLite profilinden senkronizasyonu, telefon/UID korunumu ve çakışma engeli',
        () async {
      final prefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeFirebaseAuth();
      final fakeFirestore = RuleEnforcingFakeFirestore(auth: fakeAuth);
      final fbRepo = FirebaseAuthRepository(
        firebaseAuth: fakeAuth,
        firestore: fakeFirestore,
        appDatabase: db,
        prefs: prefs,
      );

      // Hazırlık: `seed_user_1` (Cristiano Ronaldo) ve `seed_user_2` (Lionel Messi)
      // yalnızca Firebase Auth'ta mevcut olsun, Firestore'da henüz `users/{uid}` belgesi bulunmasın.
      fakeAuth.seedImportedAccount(
        uid: 'seed_user_1',
        email: 'cr7@gmail.com',
        password: 'cris7',
        displayName: 'cristiano Ronaldo',
      );
      fakeAuth.seedImportedAccount(
        uid: 'seed_user_2',
        email: 'm10@gmail.com',
        password: 'messi10',
        displayName: 'lionel messi',
      );

      expect(fakeFirestore.rawDoc('users', 'seed_user_1'), isNull);
      expect(fakeFirestore.rawDoc('phone_lookup', '05111111111'), isNull);

      // 1, 2 & 3. Firestore profili bulunmayan `seed_user_1` giriş yaptığında SQLite profilinden senkronize edilmeli,
      // telefon numarası (`05111111111`) boş değerle ezilmemeli ve UID (`seed_user_1`) korunmalı.
      final cr7LoggedIn = await fbRepo.login(
        identifier: 'cr7@gmail.com',
        password: 'cris7',
      );

      expect(cr7LoggedIn.id, 'seed_user_1');
      expect(cr7LoggedIn.firstName, 'cristiano');
      expect(cr7LoggedIn.lastName, 'Ronaldo');
      expect(cr7LoggedIn.email, 'cr7@gmail.com');
      expect(cr7LoggedIn.phone, '05111111111');
      expect(cr7LoggedIn.themeMode, 'light');
      expect(cr7LoggedIn.createdAt, DateTime.utc(2026, 1, 1, 12, 0));
      // Gerçek kullanıcı onayı (consents kaydı) olmadığı için onay verilmiş gibi gösterilmemeli
      expect(cr7LoggedIn.termsAccepted, isFalse);
      expect(cr7LoggedIn.kvkkAccepted, isFalse);

      // Firestore `users/seed_user_1` ve `phone_lookup/05111111111` belgeleri oluşmuş olmalı
      final syncedUserDoc = fakeFirestore.rawDoc('users', 'seed_user_1');
      expect(syncedUserDoc, isNotNull);
      expect(syncedUserDoc!['uid'], 'seed_user_1');
      expect(syncedUserDoc['phone'], '05111111111');
      expect(syncedUserDoc['termsAccepted'], isFalse);
      expect(syncedUserDoc['kvkkAccepted'], isFalse);

      final syncedPhoneDoc =
          fakeFirestore.rawDoc('phone_lookup', '05111111111');
      expect(syncedPhoneDoc, isNotNull);
      expect(syncedPhoneDoc!['uid'], 'seed_user_1');
      expect(syncedPhoneDoc['phone'], '05111111111');

      // SQLite tablosunda da telefon numarası ve ID korunmuş olmalı (boş değerle ezilmemeli)
      final sqlite = await db.database;
      final sqliteRows = await sqlite.query(
        'users',
        where: 'id = ?',
        whereArgs: ['seed_user_1'],
      );
      expect(sqliteRows.length, 1);
      expect(sqliteRows.first['id'], 'seed_user_1');
      expect(sqliteRows.first['phone'], '05111111111');

      // 4. Firestore belgesi zaten varsa (`users/seed_user_1`) tekrar girişte yeniden transaction çalıştırılmamalı ve üzerine yazılmamalı
      final txCountAfterFirstLogin = fakeFirestore.transactionCount;
      expect(txCountAfterFirstLogin, 1);

      await fbRepo.logout();
      final cr7SecondLogin = await fbRepo.login(
        identifier: 'cr7@gmail.com',
        password: 'cris7',
      );
      expect(cr7SecondLogin.id, 'seed_user_1');
      expect(cr7SecondLogin.phone, '05111111111');
      // İkinci girişte Firestore belgesi zaten var olduğu için yeni bir transaction çalışmamış olmalı
      expect(fakeFirestore.transactionCount, txCountAfterFirstLogin);
      await fbRepo.logout();

      // 5. Başka bir kullanıcıya ait telefon numarası kullanılıyorsa işlem durdurulmalı ve anlaşılır hata verilmeli
      // Önce normal bir kullanıcı `05222222222` (Messi'nin telefon numarası) ile kayıt olsun:
      await fbRepo.register(
        firstName: 'Başka',
        lastName: 'Kullanıcı',
        email: 'baska_kullanici@gmail.com',
        phone: '05222222222',
        password: 'password123',
        acceptedUserAgreement: true,
        acceptedKvkk: true,
      );

      // Şimdi Firestore'da henüz profili olmayan `seed_user_2` (Messi - 05222222222) giriş yapmayı denediğinde
      // telefon numarası başka bir UID tarafından kullanıldığı için işlem durdurulmalı:
      await expectLater(
        () => fbRepo.login(
          identifier: 'm10@gmail.com',
          password: 'messi10',
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', 'phone-already-in-use'),
        ),
      );
      expect(fakeAuth.currentUser, isNull);
      expect(fakeFirestore.rawDoc('users', 'seed_user_2'), isNull);

      // 6. Normal Firebase kullanıcılarının girişi sorunsuz çalışmaya devam etmeli
      final normalLogin = await fbRepo.login(
        identifier: 'baska_kullanici@gmail.com',
        password: 'password123',
      );
      expect(normalLogin.email, 'baska_kullanici@gmail.com');
      expect(normalLogin.phone, '05222222222');
      expect(normalLogin.termsAccepted, isTrue);
      expect(normalLogin.kvkkAccepted, isTrue);
    });

    test(
        'FirebaseAuthImportPreparer 10 hazır test hesabının SHA256 (SALT_FIRST, rounds=1) Base64 değerlerini ve çakışma kontrolünü doğrulamalı',
        () {
      final verified = FirebaseAuthImportPreparer.verifyAllTenSeedUsers();
      expect(verified.length, 10);
      expect(
        FirebaseAuthImportPreparer.effectiveSaltBase64,
        'N3Y3X2hhbGlfc2FoYV9zZWN1cmVfc2FsdF92MTo=',
      );

      final payload = FirebaseAuthImportPreparer.buildImportJsonPayload();
      final users = payload['users'] as List<dynamic>;
      expect(users.length, 10);
      expect(
        users.map((e) => (e as Map)['localId']).toList(),
        [
          'seed_user_1',
          'seed_user_2',
          'seed_user_3',
          'seed_user_4',
          'seed_user_5',
          'seed_user_6',
          'seed_user_7',
          'seed_user_8',
          'seed_user_9',
          'seed_user_10',
        ],
      );

      // Mevcut 1 yabancı Firebase kullanıcısı varken çakışma olmamalı
      final noCollisions =
          FirebaseAuthImportPreparer.checkCollisionsWithExistingUsers([
        {
          'localId': 'existing_real_user_uid_abc123',
          'email': 'gercek.kullanici@example.com',
        },
      ]);
      expect(noCollisions, isEmpty);

      // Çakışma senaryosu doğru yakalanmalı
      final withCollisions =
          FirebaseAuthImportPreparer.checkCollisionsWithExistingUsers([
        {
          'localId': 'seed_user_1',
          'email': 'cr7@gmail.com',
        },
      ]);
      expect(withCollisions.length, 2);
    });

    test(
        '10 hazır test hesabının tamamı (seed_user_1 .. seed_user_10) ve mevcut orkun@gmail.com hesabı ilk girişte Firestore ile uyumlu çalışmalı ve SQLite verilerini korumalı',
        () async {
      final prefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeFirebaseAuth();
      final fakeFirestore = RuleEnforcingFakeFirestore(auth: fakeAuth);
      final fbRepo = FirebaseAuthRepository(
        firebaseAuth: fakeAuth,
        firestore: fakeFirestore,
        appDatabase: db,
        prefs: prefs,
      );

      // 1. Mevcut `orkun@gmail.com` hesabını oluştur ve doğrula
      final orkunReg = await fbRepo.register(
        firstName: 'orkun',
        lastName: 'kokcu',
        email: 'orkun@gmail.com',
        phone: '05309998877',
        password: 'password123',
        acceptedUserAgreement: true,
        acceptedKvkk: true,
      );

      // 2. 10 hazır test hesabını (`seed_user_1` .. `seed_user_10`) Firebase Auth'a aktarılmış olarak ekle
      for (final spec in FirebaseAuthImportPreparer.seedUserSpecs) {
        fakeAuth.seedImportedAccount(
          uid: spec.id,
          email: spec.email,
          password: spec.plainPasswordForVerification,
          displayName: spec.fullName,
        );
      }

      // 3. Senkronizasyon öncesinde SQLite üzerinde `seed_user_1` (CR7) ve `seed_user_2` (Messi)
      // arasında bir takım, davet, randevu, bildirim ve sohbet mesajı oluştur
      final preTeam = await teamRepo.createTeam(
        captainId: 'seed_user_1',
        captainName: 'cristiano Ronaldo',
        formation: Formation.twoThreeOne,
        province: 'İstanbul',
        district: 'Beşiktaş',
        venueName: 'Beşiktaş Arena 7v7 Halı Saha (Test)',
        matchDate: '2027-06-15',
        startTime: '21.00',
        endTime: '22.00',
        lineup: {'FWD_1': 'cristiano Ronaldo'},
        captainPositionKey: 'FWD_1',
      );
      final preInvite = await invitationRepo.sendInvitation(
        teamId: preTeam.id,
        senderId: 'seed_user_1',
        receiverId: 'seed_user_2',
        positionKey: 'MID_1',
      );
      await invitationRepo.acceptInvitation(
        invitationId: preInvite.id,
        currentUserId: 'seed_user_2',
      );
      await chatRepo.sendMessage(
        teamId: preTeam.id,
        senderId: 'seed_user_1',
        content: 'Senkronizasyon öncesi mesaj',
      );

      // 4. 10 hazır test hesabının tamamıyla sırayla ilk giriş yap ve Firestore atomik transaction senkronizasyonunu doğrula
      for (final spec in FirebaseAuthImportPreparer.seedUserSpecs) {
        final loggedIn = await fbRepo.login(
          identifier: spec.email,
          password: spec.plainPasswordForVerification,
        );

        expect(loggedIn.id, spec.id);
        expect(loggedIn.firstName, spec.firstName);
        expect(loggedIn.lastName, spec.lastName);
        expect(loggedIn.email, spec.email);
        expect(loggedIn.phone, spec.phone);
        expect(loggedIn.termsAccepted, isFalse);
        expect(loggedIn.kvkkAccepted, isFalse);

        final userDoc = fakeFirestore.rawDoc('users', spec.id);
        expect(userDoc, isNotNull);
        expect(userDoc!['uid'], spec.id);
        expect(userDoc['phone'], spec.phone);
        expect(userDoc.containsKey('password'), isFalse);
        expect(userDoc.containsKey('passwordHash'), isFalse);

        final phoneDoc = fakeFirestore.rawDoc('phone_lookup', spec.phone);
        expect(phoneDoc, isNotNull);
        expect(phoneDoc!['uid'], spec.id);
        expect(phoneDoc['phone'], spec.phone);

        await fbRepo.logout();
      }

      // 5. Mevcut `orkun@gmail.com` hesabının girişi ve profili bozulmadan çalışmalı
      final orkunLogin = await fbRepo.login(
        identifier: 'orkun@gmail.com',
        password: 'password123',
      );
      expect(orkunLogin.id, orkunReg.id);
      expect(orkunLogin.email, 'orkun@gmail.com');
      expect(orkunLogin.phone, '05309998877');
      expect(orkunLogin.termsAccepted, isTrue);
      expect(orkunLogin.kvkkAccepted, isTrue);
      await fbRepo.logout();

      // 6. SQLite üzerindeki mevcut takım, randevu, davet, bildirim ve sohbet verileri eksiksiz korunmuş olmalı
      final cr7After = await fbRepo.login(
        identifier: 'cr7@gmail.com',
        password: 'cris7',
      );
      expect(cr7After.id, 'seed_user_1');

      final cr7Appointments = await teamRepo.getUserAppointments('seed_user_1');
      final messiAppointments =
          await teamRepo.getUserAppointments('seed_user_2');
      expect(cr7Appointments.length, 1);
      expect(messiAppointments.length, 1);

      final chatMessages = await chatRepo.getTeamMessages(
        teamId: preTeam.id,
        requesterId: 'seed_user_1',
      );
      expect(chatMessages.length, 1);
      expect(chatMessages.first.content, 'Senkronizasyon öncesi mesaj');
      expect(chatMessages.first.senderName, 'cristiano Ronaldo');

      final cr7Notifications =
          await notificationRepo.getUserNotifications('seed_user_1');
      expect(cr7Notifications, isNotEmpty);
    });
  });
}

// =============================================================================
// FIRESTORE GÜVENLİK KURALLARI SİMÜLATÖRÜ VE FAKE FIREBASE AUTH
// (`firestore.rules` dosyasındaki kuralları birebir uygular)
// =============================================================================

class AuthAccount {
  final String uid;
  final String email;
  final String password;
  String? displayName;

  AuthAccount({
    required this.uid,
    required this.email,
    required this.password,
  });
}

class FakeUser extends Fake implements User {
  final AuthAccount _account;
  final FakeFirebaseAuth _auth;

  FakeUser(this._account, this._auth);

  @override
  String get uid => _account.uid;

  @override
  String? get email => _account.email;

  @override
  String? get displayName => _account.displayName;

  @override
  Future<void> updateDisplayName(String? displayName) async {
    _account.displayName = displayName;
  }

  @override
  Future<void> delete() async {
    _auth._deleteAccount(_account.uid);
  }
}

class FakeUserCredential extends Fake implements UserCredential {
  @override
  final User? user;

  FakeUserCredential(this.user);
}

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  final Map<String, AuthAccount> _byUid = {};
  FakeUser? _currentUser;
  int _counter = 0;

  @override
  User? get currentUser => _currentUser;

  bool hasEmail(String email) =>
      _byUid.values.any((a) => a.email == email.toLowerCase().trim());

  void seedImportedAccount({
    required String uid,
    required String email,
    required String password,
    String? displayName,
  }) {
    final account = AuthAccount(
      uid: uid,
      email: email.toLowerCase().trim(),
      password: password,
    )..displayName = displayName;
    _byUid[uid] = account;
  }

  void _deleteAccount(String uid) {
    _byUid.remove(uid);
    if (_currentUser?.uid == uid) {
      _currentUser = null;
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final normalized = email.toLowerCase().trim();
    if (hasEmail(normalized)) {
      throw FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'Email already in use.',
      );
    }
    _counter++;
    final account = AuthAccount(
      uid: 'uid_$_counter',
      email: normalized,
      password: password,
    );
    _byUid[account.uid] = account;
    _currentUser = FakeUser(account, this);
    return FakeUserCredential(_currentUser);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final normalized = email.toLowerCase().trim();
    final match = _byUid.values
        .where((a) => a.email == normalized && a.password == password)
        .toList();
    if (match.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Invalid email or password.',
      );
    }
    _currentUser = FakeUser(match.first, this);
    return FakeUserCredential(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}

class RuleEnforcingFakeFirestore extends Fake implements FirebaseFirestore {
  final FakeFirebaseAuth auth;
  int transactionCount = 0;
  final Map<String, Map<String, Map<String, dynamic>>> _store = {
    'users': {},
    'phone_lookup': {},
  };

  RuleEnforcingFakeFirestore({required this.auth});

  Map<String, dynamic>? rawDoc(String collectionPath, String docId) {
    final col = _store[collectionPath];
    if (col == null || !col.containsKey(docId)) return null;
    return Map<String, dynamic>.from(col[docId]!);
  }

  Never _deny(String reason) {
    throw FirebaseException(
      plugin: 'cloud_firestore',
      code: 'permission-denied',
      message: 'Missing or insufficient permissions: $reason',
    );
  }

  bool get _isSignedIn => auth.currentUser != null;
  String? get _authUid => auth.currentUser?.uid;

  bool _isOwner(String uid) => _isSignedIn && _authUid == uid;

  bool _hasNoPasswordFields(Map<String, dynamic> data) =>
      !data.containsKey('password') && !data.containsKey('passwordHash');

  void _checkGetRule(String collectionPath, String docId) {
    if (collectionPath == 'users') {
      // allow get: if isOwner(uid);
      if (!_isOwner(docId)) {
        _deny('users/{uid} get requires isOwner(uid)');
      }
      return;
    }
    if (collectionPath == 'phone_lookup') {
      // allow get: if isSignedIn();
      if (!_isSignedIn) {
        _deny('phone_lookup/{phone} get requires isSignedIn()');
      }
      return;
    }
    _deny('Unknown collection $collectionPath');
  }

  Never _checkListRule(String collectionPath) {
    // Her iki koleksiyonda da `allow list: if false;`
    _deny('list on $collectionPath is forbidden by firestore.rules');
  }

  void _checkCreateRule(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
    Map<String, Map<String, Map<String, dynamic>>> currentStore,
  ) {
    if (collectionPath == 'users') {
      final phoneRegex = RegExp(r'^05[0-9]{9}$');
      final isLegacySeedUser = RegExp(r'^seed_user_(10|[1-9])$').hasMatch(docId);
      final ok = _isOwner(docId) &&
          _hasNoPasswordFields(data) &&
          data['uid'] == docId &&
          data['firstName'] is String &&
          (data['firstName'] as String).isNotEmpty &&
          data['lastName'] is String &&
          (data['lastName'] as String).isNotEmpty &&
          data['email'] is String &&
          (data['email'] as String).isNotEmpty &&
          data['phone'] is String &&
          phoneRegex.hasMatch(data['phone'] as String) &&
          data['termsAccepted'] is bool &&
          data['kvkkAccepted'] is bool &&
          ((data['termsAccepted'] == true && data['kvkkAccepted'] == true) ||
              isLegacySeedUser) &&
          data['createdAt'] is Timestamp;
      if (!ok) {
        _deny('users/{uid} create rule failed');
      }
      return;
    }
    if (collectionPath == 'phone_lookup') {
      final phoneRegex = RegExp(r'^05[0-9]{9}$');
      final alreadyExists =
          currentStore['phone_lookup']?.containsKey(docId) ?? false;
      final allowedKeys = {'uid', 'phone', 'createdAt'};
      final hasOnlyAllowedKeys =
          data.keys.every(allowedKeys.contains) && data.keys.length == 3;
      final ok = _isSignedIn &&
          phoneRegex.hasMatch(docId) &&
          !alreadyExists &&
          hasOnlyAllowedKeys &&
          data['uid'] == _authUid &&
          data['phone'] == docId &&
          data['createdAt'] is Timestamp;
      if (!ok) {
        _deny('phone_lookup/{phone} create rule failed');
      }
      return;
    }
    _deny('Unknown collection $collectionPath');
  }

  void _checkUpdateRule(
    String collectionPath,
    String docId,
    Map<String, dynamic> existingData,
    Map<String, dynamic> mergedData,
  ) {
    if (collectionPath == 'users') {
      final ok = _isOwner(docId) &&
          _hasNoPasswordFields(mergedData) &&
          mergedData['uid'] == existingData['uid'] &&
          mergedData['email'] == existingData['email'] &&
          mergedData['phone'] == existingData['phone'] &&
          mergedData['termsAccepted'] == existingData['termsAccepted'] &&
          mergedData['kvkkAccepted'] == existingData['kvkkAccepted'];
      if (!ok) {
        _deny('users/{uid} update rule failed');
      }
      return;
    }
    _deny('update on $collectionPath is forbidden by firestore.rules');
  }

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return FakeCollectionRef(this, collectionPath);
  }

  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    transactionCount++;
    final stagedStore = <String, Map<String, Map<String, dynamic>>>{
      for (final entry in _store.entries)
        entry.key: {
          for (final docEntry in entry.value.entries)
            docEntry.key: Map<String, dynamic>.from(docEntry.value),
        },
    };
    final tx = FakeTransaction(this, stagedStore);
    final result = await transactionHandler(tx);
    tx.commitTo(_store);
    return result;
  }
}

class FakeCollectionRef extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  final RuleEnforcingFakeFirestore _firestore;
  final String _path;

  FakeCollectionRef(this._firestore, this._path);

  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) {
    return FakeDocRef(_firestore, _path, path ?? 'auto_id');
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    _firestore._checkListRule(_path);
  }
}

class FakeDocRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  final RuleEnforcingFakeFirestore _firestore;
  final String collectionPath;
  @override
  final String id;

  FakeDocRef(this._firestore, this.collectionPath, this.id);

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([
    GetOptions? options,
  ]) async {
    _firestore._checkGetRule(collectionPath, id);
    final data = _firestore._store[collectionPath]?[id];
    return FakeDocSnap(
      id,
      data == null ? null : Map<String, dynamic>.from(data),
    );
  }

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {
    final col = _firestore._store.putIfAbsent(collectionPath, () => {});
    final existing = col[id];
    if (existing == null) {
      _firestore._checkCreateRule(collectionPath, id, data, _firestore._store);
      col[id] = Map<String, dynamic>.from(data);
    } else {
      final merged = (options?.merge ?? false)
          ? {...existing, ...data}
          : Map<String, dynamic>.from(data);
      _firestore._checkUpdateRule(collectionPath, id, existing, merged);
      col[id] = merged;
    }
  }

  @override
  Future<void> update(Map<Object, Object?> data) async {
    final col = _firestore._store.putIfAbsent(collectionPath, () => {});
    final existing = col[id];
    if (existing == null) {
      _firestore._deny('Document $collectionPath/$id does not exist');
    }
    final patch = <String, dynamic>{
      for (final entry in data.entries) entry.key.toString(): entry.value,
    };
    final merged = {...existing, ...patch};
    _firestore._checkUpdateRule(collectionPath, id, existing, merged);
    col[id] = merged;
  }
}

class FakeDocSnap extends Fake
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final String id;
  final Map<String, dynamic>? _data;

  FakeDocSnap(this.id, this._data);

  @override
  bool get exists => _data != null;

  @override
  Map<String, dynamic>? data() => _data;
}

class FakeTransaction extends Fake implements Transaction {
  final RuleEnforcingFakeFirestore _firestore;
  final Map<String, Map<String, Map<String, dynamic>>> _staged;
  final List<void Function()> _pendingWrites = [];

  FakeTransaction(this._firestore, this._staged);

  @override
  Future<DocumentSnapshot<T>> get<T extends Object?>(
    DocumentReference<T> documentReference,
  ) async {
    final docRef = documentReference as FakeDocRef;
    _firestore._checkGetRule(docRef.collectionPath, docRef.id);
    final data = _staged[docRef.collectionPath]?[docRef.id];
    return FakeDocSnap(
      docRef.id,
      data == null ? null : Map<String, dynamic>.from(data),
    ) as DocumentSnapshot<T>;
  }

  @override
  Transaction set<T>(
    DocumentReference<T> documentReference,
    T data, [
    SetOptions? options,
  ]) {
    final docRef = documentReference as FakeDocRef;
    final mapData = Map<String, dynamic>.from(data as Map);
    _pendingWrites.add(() {
      final col = _staged.putIfAbsent(docRef.collectionPath, () => {});
      final existing = col[docRef.id];
      if (existing == null) {
        _firestore._checkCreateRule(
          docRef.collectionPath,
          docRef.id,
          mapData,
          _staged,
        );
        col[docRef.id] = mapData;
      } else {
        final merged =
            (options?.merge ?? false) ? {...existing, ...mapData} : mapData;
        _firestore._checkUpdateRule(
          docRef.collectionPath,
          docRef.id,
          existing,
          merged,
        );
        col[docRef.id] = merged;
      }
    });
    return this;
  }

  void commitTo(Map<String, Map<String, Map<String, dynamic>>> target) {
    for (final write in _pendingWrites) {
      write();
    }
    target
      ..clear()
      ..addAll(_staged);
  }
}

