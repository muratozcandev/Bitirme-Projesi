// Kullanıcının onayladığı yasal sözleşme kayıtlarını temsil eden veri modelidir.

/// Kullanıcı Sözleşmesi ve KVKK metinlerinin kullanıcı tarafından ne zaman,
/// hangi sürümle onaylandığını SQLite üzerinde saklayan veri modeli.
class ConsentModel {
  final String id;
  final String userId;
  final String documentType;
  final String documentVersion;
  final bool accepted;
  final DateTime acceptedAt;

  const ConsentModel({
    required this.id,
    required this.userId,
    required this.documentType,
    this.documentVersion = '1.0',
    required this.accepted,
    required this.acceptedAt,
  });

  /// Modeli SQLite veritabanına eklemek için Map yapısına dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'documentType': documentType,
      'documentVersion': documentVersion,
      'accepted': accepted ? 1 : 0,
      'acceptedAt': acceptedAt.toIso8601String(),
    };
  }

  /// SQLite sorgu sonucundan (Map) model örneği oluşturur
  factory ConsentModel.fromMap(Map<String, dynamic> map) {
    return ConsentModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      documentType: map['documentType'] as String,
      documentVersion: (map['documentVersion'] as String?) ?? '1.0',
      accepted: (map['accepted'] as int? ?? 0) == 1,
      acceptedAt: DateTime.parse(map['acceptedAt'] as String),
    );
  }
}
