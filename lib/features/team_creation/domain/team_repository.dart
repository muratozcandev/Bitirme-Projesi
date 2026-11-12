import '../../../shared/models/formation.dart';
import '../../../shared/models/team_model.dart';

abstract class TeamRepository {
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

  Future<TeamModel?> getTeamById(String teamId);

  Future<List<TeamModel>> getUserAppointments(String userId);

  Future<List<TeamModel>> getCaptainTeams(String captainId);

  Future<List<TeamModel>> getUserChatTeams(String userId);

  Future<void> deleteAppointmentForUser({
    required String teamId,
    required String userId,
  });

  Future<bool> isUserMemberOfTeam({
    required String teamId,
    required String userId,
  });
}

