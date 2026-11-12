class MatchModel { // MatchModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String teamId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String venueName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String province; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String district; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String matchDate; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String startTime; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String endTime; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const MatchModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.teamId, // teamId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.venueName, // venueName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.province, // province parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.district, // district parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.matchDate, // matchDate parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.startTime, // startTime parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.endTime, // endTime parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'teamId': teamId, // 'teamId' özelliğini yapılandırır
      'venueName': venueName, // 'venueName' özelliğini yapılandırır
      'province': province, // 'province' özelliğini yapılandırır
      'district': district, // 'district' özelliğini yapılandırır
      'matchDate': matchDate, // 'matchDate' özelliğini yapılandırır
      'startTime': startTime, // 'startTime' özelliğini yapılandırır
      'endTime': endTime, // 'endTime' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory MatchModel.fromMap(Map<String, dynamic> map) { // İlgili kod satırını ve işlemi yürütür
    return MatchModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      teamId: map['teamId'] as String, // teamId özelliğini yapılandırır
      venueName: map['venueName'] as String, // venueName özelliğini yapılandırır
      province: map['province'] as String, // province özelliğini yapılandırır
      district: map['district'] as String, // district özelliğini yapılandırır
      matchDate: map['matchDate'] as String, // matchDate özelliğini yapılandırır
      startTime: map['startTime'] as String, // startTime özelliğini yapılandırır
      endTime: map['endTime'] as String, // endTime özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

