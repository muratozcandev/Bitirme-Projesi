// Maç konum, tarih ve saat bilgilerini temsil eden veri modelidir.

/// Bir halı saha maçının oynanacağı tesis, il/ilçe, gün ve saat aralığını tutan model.
class MatchModel {
  final String id;
  final String teamId;
  final String venueName;
  final String province;
  final String district;
  final String matchDate;
  final String startTime;
  final String endTime;

  const MatchModel({
    required this.id,
    required this.teamId,
    required this.venueName,
    required this.province,
    required this.district,
    required this.matchDate,
    required this.startTime,
    required this.endTime,
  });

  /// Modeli SQLite veritabanına eklemek için Map yapısına dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'venueName': venueName,
      'province': province,
      'district': district,
      'matchDate': matchDate,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  /// SQLite sorgu sonucundan (Map) model örneği oluşturur
  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'] as String,
      teamId: map['teamId'] as String,
      venueName: map['venueName'] as String,
      province: map['province'] as String,
      district: map['district'] as String,
      matchDate: map['matchDate'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
    );
  }
}
