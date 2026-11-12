// Kullanıcıya gösterilen bildirim öğelerini temsil eden veri modelidir.

enum NotificationType {
  teamInvitation('teamInvitation', 'Takım Daveti'),
  invitationAccepted('invitationAccepted', 'Davet Kabul Edildi'),
  invitationRejected('invitationRejected', 'Davet Reddedildi'),
  teamInfo('teamInfo', 'Takım Bilgilendirmesi');

  final String value;
  final String labelTr;

  const NotificationType(this.value, this.labelTr);

  static NotificationType fromValue(String value) {
    return NotificationType.values.firstWhere(
      (t) => t.value == value,
      orElse: () => NotificationType.teamInfo,
    );
  }
}

class NotificationModel {
  final String id;
  final String receiverId;
  final String senderId;
  final String senderName;
  final NotificationType type;
  final String? relatedTeamId;
  final String? relatedInvitationId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.receiverId,
    required this.senderId,
    this.senderName = '',
    required this.type,
    this.relatedTeamId,
    this.relatedInvitationId,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiverId': receiverId,
      'senderId': senderId,
      'type': type.value,
      'relatedTeamId': relatedTeamId,
      'relatedInvitationId': relatedInvitationId,
      'title': title,
      'body': body,
      'isRead': isRead ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(
    Map<String, dynamic> map, {
    String senderName = '',
  }) {
    return NotificationModel(
      id: map['id'] as String,
      receiverId: map['receiverId'] as String,
      senderId: map['senderId'] as String,
      senderName: senderName,
      type: NotificationType.fromValue(map['type'] as String),
      relatedTeamId: map['relatedTeamId'] as String?,
      relatedInvitationId: map['relatedInvitationId'] as String?,
      title: map['title'] as String,
      body: map['body'] as String,
      isRead: (map['isRead'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
