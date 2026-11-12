import 'package:flutter_test/flutter_test.dart';
import 'package:hali_saha_7v7/core/errors/app_exception.dart';
import 'package:hali_saha_7v7/data/database/app_database.dart';
import 'package:hali_saha_7v7/features/authentication/data/local_auth_repository.dart';
import 'package:hali_saha_7v7/features/chat/data/local_chat_repository.dart';
import 'package:hali_saha_7v7/features/notifications/data/local_invitation_repository.dart';
import 'package:hali_saha_7v7/features/notifications/data/local_notification_repository.dart';
import 'package:hali_saha_7v7/features/team_creation/data/local_team_repository.dart';
import 'package:hali_saha_7v7/shared/models/formation.dart';
import 'package:hali_saha_7v7/shared/models/invitation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
  });
}

