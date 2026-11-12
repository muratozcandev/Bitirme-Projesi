import 'team_model.dart';

enum InvitationStatus {
  pending('Pending', 'Beklemede'),
  accepted('Accepted', 'Kabul Edildi'),
  rejected('Rejected', 'Reddedildi'),
  cancelled('Cancelled', 'İptal Edildi');

  final String value;
  final String labelTr;

  const InvitationStatus(this.value, this.labelTr);

  static InvitationStatus fromValue(String value) {
    return InvitationStatus.values.firstWhere(
      (s) => s.value.toLowerCase() == value.toLowerCase(),
      orElse: () => InvitationStatus.pending,
    );
  }
}

class InvitationModel {
  final String id;
  final String teamId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String position; // Örn: DEF_1
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final TeamModel? team;

  const InvitationModel({
    required this.id,
    required this.teamId,
    required this.senderId,
    this.senderName = '',
    required this.receiverId,
    this.receiverName = '',
    required this.position,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.team,
  });

  bool get isPending => status == InvitationStatus.pending;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'senderId': senderId,
      'receiverId': receiverId,
      'position': position,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  factory InvitationModel.fromMap(
    Map<String, dynamic> map, {
    String senderName = '',
    String receiverName = '',
    TeamModel? team,
  }) {
    return InvitationModel(
      id: map['id'] as String,
      teamId: map['teamId'] as String,
      senderId: map['senderId'] as String,
      senderName: senderName,
      receiverId: map['receiverId'] as String,
      receiverName: receiverName,
      position: map['position'] as String,
      status: InvitationStatus.fromValue(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      respondedAt: map['respondedAt'] != null
          ? DateTime.parse(map['respondedAt'] as String)
          : null,
      team: team,
    );
  }
}

