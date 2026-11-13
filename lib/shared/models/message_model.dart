// Takım sohbetlerinde gönderilen mesajları temsil eden veri modelidir.

/// Takım üyelerinin sohbet odasında paylaştığı metin mesajlarını ve gönderen bilgilerini tutan model.
class MessageModel {
  final String id;
  final String teamId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.teamId,
    required this.senderId,
    this.senderName = '',
    required this.content,
    required this.createdAt,
  });

  /// Modeli SQLite veritabanına eklemek için Map yapısına dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'senderId': senderId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// SQLite sorgu sonucundan (Map) model örneği oluşturur
  factory MessageModel.fromMap(
    Map<String, dynamic> map, {
    String senderName = '',
  }) {
    return MessageModel(
      id: map['id'] as String,
      teamId: map['teamId'] as String,
      senderId: map['senderId'] as String,
      senderName: senderName,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
