class TeamMemberModel { // TeamMemberModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String teamId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? userId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String position; // Örn: GK_1, DEF_1, MID_1, FWD_1
  final String displayName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String role; // 'captain' | 'member' | 'guest'
  final DateTime joinedAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const TeamMemberModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.teamId, // teamId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.userId, // userId sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.position, // position parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.displayName, // displayName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.role, // role parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.joinedAt, // joinedAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  String get roleLabel { // İlgili kod satırını ve işlemi yürütür
    switch (role) { // Değere göre çoklu durum kontrolü (switch) başlatır
      case 'captain': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return 'Takım Kaptanı'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      case 'member': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return 'Oyuncu (Üye)'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      default: // Hiçbir durum eşleşmediğinde çalışacak varsayılan dalı tanımlar
        return 'Oyuncu'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'teamId': teamId, // 'teamId' özelliğini yapılandırır
      'userId': userId, // 'userId' özelliğini yapılandırır
      'position': position, // 'position' özelliğini yapılandırır
      'displayName': displayName, // 'displayName' özelliğini yapılandırır
      'role': role, // 'role' özelliğini yapılandırır
      'joinedAt': joinedAt.toIso8601String(), // 'joinedAt' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory TeamMemberModel.fromMap(Map<String, dynamic> map) { // İlgili kod satırını ve işlemi yürütür
    return TeamMemberModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      teamId: map['teamId'] as String, // teamId özelliğini yapılandırır
      userId: map['userId'] as String?, // userId özelliğini yapılandırır
      position: map['position'] as String, // position özelliğini yapılandırır
      displayName: map['displayName'] as String, // displayName özelliğini yapılandırır
      role: map['role'] as String, // role özelliğini yapılandırır
      joinedAt: DateTime.parse(map['joinedAt'] as String), // joinedAt özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

