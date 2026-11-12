enum NotificationType { // NotificationType sabit seçenekler (enum) kümesini tanımlar
  teamInvitation('teamInvitation', 'Takım Daveti'), // İlgili kod satırını ve işlemi yürütür
  invitationAccepted('invitationAccepted', 'Davet Kabul Edildi'), // İlgili kod satırını ve işlemi yürütür
  invitationRejected('invitationRejected', 'Davet Reddedildi'), // İlgili kod satırını ve işlemi yürütür
  teamInfo('teamInfo', 'Takım Bilgilendirmesi'); // İlgili kod satırını ve işlemi yürütür

  final String value; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String labelTr; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const NotificationType(this.value, this.labelTr); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  static NotificationType fromValue(String value) { // İlgili kod satırını ve işlemi yürütür
    return NotificationType.values.firstWhere( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      (t) => t.value == value, // İlgili kod satırını ve işlemi yürütür
      orElse: () => NotificationType.teamInfo, // orElse özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class NotificationModel { // NotificationModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String receiverId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String senderId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String senderName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final NotificationType type; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? relatedTeamId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? relatedInvitationId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String title; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String body; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isRead; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime createdAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const NotificationModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.receiverId, // receiverId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.senderId, // senderId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.senderName = '', // senderName = '' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.type, // type parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.relatedTeamId, // relatedTeamId sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.relatedInvitationId, // relatedInvitationId sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.title, // title parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.body, // body parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.isRead = false, // isRead = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.createdAt, // createdAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'receiverId': receiverId, // 'receiverId' özelliğini yapılandırır
      'senderId': senderId, // 'senderId' özelliğini yapılandırır
      'type': type.value, // 'type' özelliğini yapılandırır
      'relatedTeamId': relatedTeamId, // 'relatedTeamId' özelliğini yapılandırır
      'relatedInvitationId': relatedInvitationId, // 'relatedInvitationId' özelliğini yapılandırır
      'title': title, // 'title' özelliğini yapılandırır
      'body': body, // 'body' özelliğini yapılandırır
      'isRead': isRead ? 1 : 0, // 'isRead' özelliğini yapılandırır
      'createdAt': createdAt.toIso8601String(), // 'createdAt' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory NotificationModel.fromMap( // İlgili kod satırını ve işlemi yürütür
    Map<String, dynamic> map, { // İlgili kod satırını ve işlemi yürütür
    String senderName = '', // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return NotificationModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      receiverId: map['receiverId'] as String, // receiverId özelliğini yapılandırır
      senderId: map['senderId'] as String, // senderId özelliğini yapılandırır
      senderName: senderName, // senderName özelliğini yapılandırır
      type: NotificationType.fromValue(map['type'] as String), // type özelliğini yapılandırır
      relatedTeamId: map['relatedTeamId'] as String?, // relatedTeamId özelliğini yapılandırır
      relatedInvitationId: map['relatedInvitationId'] as String?, // relatedInvitationId özelliğini yapılandırır
      title: map['title'] as String, // title özelliğini yapılandırır
      body: map['body'] as String, // body özelliğini yapılandırır
      isRead: (map['isRead'] as int? ?? 0) == 1, // isRead özelliğini yapılandırır
      createdAt: DateTime.parse(map['createdAt'] as String), // createdAt özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

