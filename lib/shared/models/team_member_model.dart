// Bir takımdaki oyuncunun mevki ve üyelik bilgilerini temsil eden veri modelidir.

class TeamMemberModel {
  final String id;
  final String teamId;
  final String? userId;
  final String position;
  final String displayName;
  final String role;
  final DateTime joinedAt;

  const TeamMemberModel({
    required this.id,
    required this.teamId,
    this.userId,
    required this.position,
    required this.displayName,
    required this.role,
    required this.joinedAt,
  });

  String get roleLabel {
    switch (role) {
      case 'captain':
        return 'Takım Kaptanı';
      case 'member':
        return 'Oyuncu (Üye)';
      default:
        return 'Oyuncu';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'userId': userId,
      'position': position,
      'displayName': displayName,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory TeamMemberModel.fromMap(Map<String, dynamic> map) {
    return TeamMemberModel(
      id: map['id'] as String,
      teamId: map['teamId'] as String,
      userId: map['userId'] as String?,
      position: map['position'] as String,
      displayName: map['displayName'] as String,
      role: map['role'] as String,
      joinedAt: DateTime.parse(map['joinedAt'] as String),
    );
  }
}
