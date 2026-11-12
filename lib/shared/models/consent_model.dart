class ConsentModel { // ConsentModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String userId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String documentType; // 'user_agreement' | 'kvkk'
  final String documentVersion; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool accepted; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime acceptedAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const ConsentModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.userId, // userId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.documentType, // documentType parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.documentVersion = '1.0', // documentVersion = '1.0' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.accepted, // accepted parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.acceptedAt, // acceptedAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'userId': userId, // 'userId' özelliğini yapılandırır
      'documentType': documentType, // 'documentType' özelliğini yapılandırır
      'documentVersion': documentVersion, // 'documentVersion' özelliğini yapılandırır
      'accepted': accepted ? 1 : 0, // 'accepted' özelliğini yapılandırır
      'acceptedAt': acceptedAt.toIso8601String(), // 'acceptedAt' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory ConsentModel.fromMap(Map<String, dynamic> map) { // İlgili kod satırını ve işlemi yürütür
    return ConsentModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      userId: map['userId'] as String, // userId özelliğini yapılandırır
      documentType: map['documentType'] as String, // documentType özelliğini yapılandırır
      documentVersion: (map['documentVersion'] as String?) ?? '1.0', // documentVersion özelliğini yapılandırır
      accepted: (map['accepted'] as int? ?? 0) == 1, // accepted özelliğini yapılandırır
      acceptedAt: DateTime.parse(map['acceptedAt'] as String), // acceptedAt özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

