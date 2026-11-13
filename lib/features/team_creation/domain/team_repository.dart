// Takım ve kadro yönetimi işlemleri için soyut arayüzü tanımlar.

import '../../../shared/models/formation.dart';
import '../../../shared/models/team_model.dart';

/// Takım oluşturma, kadro yönetimi, kullanıcı randevuları ve sohbet odası
/// takımlarının sorgulanmasını soyutlayan arayüz sözleşmesi.
abstract class TeamRepository {
  /// Yeni bir 7v7 takımı oluşturur, kaptanı ve kadrodaki oyuncuları kaydeder.
  Future<TeamModel> createTeam({
    required String captainId,
    required String captainName,
    required Formation formation,
    required String province,
    required String district,
    required String venueName,
    required String matchDate,
    required String startTime,
    required String endTime,
    required Map<String, String> lineup,
    String? captainPositionKey,
  });

  /// Belirtilen kimliğe sahip takımın detaylarını ve oyuncu kadrosunu getirir.
  Future<TeamModel?> getTeamById(String teamId);

  /// Kullanıcının kaptan veya oyuncu olarak dahil olduğu tüm aktif maç randevularını listeler.
  Future<List<TeamModel>> getUserAppointments(String userId);

  /// Kullanıcının kaptanı olduğu takımları listeler.
  Future<List<TeamModel>> getCaptainTeams(String captainId);

  /// Kullanıcının mesajlaşabildiği (üyesi olduğu) takımları sohbet listesi için döndürür.
  Future<List<TeamModel>> getUserChatTeams(String userId);

  /// Belirtilen maçı kullanıcının randevu listesinden siler (kullanıcı takımdan ayrılır veya kaydı gizler).
  Future<void> deleteAppointmentForUser({
    required String teamId,
    required String userId,
  });

  /// Kullanıcının ilgili takımın kadrosunda yer alıp almadığını doğrular.
  Future<bool> isUserMemberOfTeam({
    required String teamId,
    required String userId,
  });
}
