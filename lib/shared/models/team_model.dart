import 'formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'team_member_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class TeamModel { // TeamModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String captainId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String captainName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Formation formation; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String province; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String district; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String venueName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String matchDate; // YYYY-MM-DD
  final String startTime; // HH.mm
  final String endTime; // HH.mm
  final DateTime createdAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String status; // 'active' | 'cancelled'
  final List<TeamMemberModel> members; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const TeamModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.captainId, // captainId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.captainName = '', // captainName = '' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.formation, // formation parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.province, // province parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.district, // district parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.venueName, // venueName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.matchDate, // matchDate parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.startTime, // startTime parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.endTime, // endTime parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.createdAt, // createdAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.status = 'active', // status = 'active' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.members = const [], // members = const [] sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  String get timeSlot => '$startTime - $endTime'; // İlgili kod satırını ve işlemi yürütür

  String get formattedDate { // İlgili kod satırını ve işlemi yürütür
    final parts = matchDate.split('-'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (parts.length == 3) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return '${parts[2]}.${parts[1]}.${parts[0]}'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return matchDate; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Bu takımdaki boş mevkileri döndürür (davet gönderimi ve kontrolü için)
  List<PlayerPositionSlot> get emptyPositions { // İlgili kod satırını ve işlemi yürütür
    final occupiedKeys = members // Sabit/final değişken veya nesne tanımını başlatır
        .where((m) => m.displayName.trim().isNotEmpty) // İlgili kod satırını ve işlemi yürütür
        .map((m) => m.position) // İlgili kod satırını ve işlemi yürütür
        .toSet(); // İlgili kod satırını ve işlemi yürütür
    return formation.positions // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        .where((slot) => !occupiedKeys.contains(slot.key)) // İlgili kod satırını ve işlemi yürütür
        .toList(); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  TeamModel copyWith({ // İlgili kod satırını ve işlemi yürütür
    String? id, // İlgili kod satırını ve işlemi yürütür
    String? captainId, // İlgili kod satırını ve işlemi yürütür
    String? captainName, // İlgili kod satırını ve işlemi yürütür
    Formation? formation, // İlgili kod satırını ve işlemi yürütür
    String? province, // İlgili kod satırını ve işlemi yürütür
    String? district, // İlgili kod satırını ve işlemi yürütür
    String? venueName, // İlgili kod satırını ve işlemi yürütür
    String? matchDate, // İlgili kod satırını ve işlemi yürütür
    String? startTime, // İlgili kod satırını ve işlemi yürütür
    String? endTime, // İlgili kod satırını ve işlemi yürütür
    DateTime? createdAt, // İlgili kod satırını ve işlemi yürütür
    String? status, // İlgili kod satırını ve işlemi yürütür
    List<TeamMemberModel>? members, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return TeamModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: id ?? this.id, // id özelliğini yapılandırır
      captainId: captainId ?? this.captainId, // captainId özelliğini yapılandırır
      captainName: captainName ?? this.captainName, // captainName özelliğini yapılandırır
      formation: formation ?? this.formation, // formation özelliğini yapılandırır
      province: province ?? this.province, // province özelliğini yapılandırır
      district: district ?? this.district, // district özelliğini yapılandırır
      venueName: venueName ?? this.venueName, // venueName özelliğini yapılandırır
      matchDate: matchDate ?? this.matchDate, // matchDate özelliğini yapılandırır
      startTime: startTime ?? this.startTime, // startTime özelliğini yapılandırır
      endTime: endTime ?? this.endTime, // endTime özelliğini yapılandırır
      createdAt: createdAt ?? this.createdAt, // createdAt özelliğini yapılandırır
      status: status ?? this.status, // status özelliğini yapılandırır
      members: members ?? this.members, // members özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'captainId': captainId, // 'captainId' özelliğini yapılandırır
      'formation': formation.label, // 'formation' özelliğini yapılandırır
      'province': province, // 'province' özelliğini yapılandırır
      'district': district, // 'district' özelliğini yapılandırır
      'venueName': venueName, // 'venueName' özelliğini yapılandırır
      'matchDate': matchDate, // 'matchDate' özelliğini yapılandırır
      'startTime': startTime, // 'startTime' özelliğini yapılandırır
      'endTime': endTime, // 'endTime' özelliğini yapılandırır
      'createdAt': createdAt.toIso8601String(), // 'createdAt' özelliğini yapılandırır
      'status': status, // 'status' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory TeamModel.fromMap( // İlgili kod satırını ve işlemi yürütür
    Map<String, dynamic> map, { // İlgili kod satırını ve işlemi yürütür
    String captainName = '', // İlgili kod satırını ve işlemi yürütür
    List<TeamMemberModel> members = const [], // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return TeamModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      captainId: map['captainId'] as String, // captainId özelliğini yapılandırır
      captainName: captainName, // captainName özelliğini yapılandırır
      formation: Formation.fromLabel(map['formation'] as String), // formation özelliğini yapılandırır
      province: map['province'] as String, // province özelliğini yapılandırır
      district: map['district'] as String, // district özelliğini yapılandırır
      venueName: map['venueName'] as String, // venueName özelliğini yapılandırır
      matchDate: map['matchDate'] as String, // matchDate özelliğini yapılandırır
      startTime: map['startTime'] as String, // startTime özelliğini yapılandırır
      endTime: map['endTime'] as String, // endTime özelliğini yapılandırır
      createdAt: DateTime.parse(map['createdAt'] as String), // createdAt özelliğini yapılandırır
      status: (map['status'] as String?) ?? 'active', // status özelliğini yapılandırır
      members: members, // members özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

