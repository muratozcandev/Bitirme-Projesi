import '../../../shared/models/formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/team_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

abstract class TeamRepository { // TeamRepository soyut arayüz (interface) sınıfını tanımlar
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
  }); // İlgili kod satırını ve işlemi yürütür

  Future<TeamModel?> getTeamById(String teamId); // İlgili kod satırını ve işlemi yürütür

  Future<List<TeamModel>> getUserAppointments(String userId); // İlgili kod satırını ve işlemi yürütür

  Future<List<TeamModel>> getCaptainTeams(String captainId); // İlgili kod satırını ve işlemi yürütür

  Future<List<TeamModel>> getUserChatTeams(String userId); // İlgili kod satırını ve işlemi yürütür

  Future<void> deleteAppointmentForUser({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<bool> isUserMemberOfTeam({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

