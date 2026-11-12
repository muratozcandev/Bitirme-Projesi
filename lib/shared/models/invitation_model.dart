import 'team_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

enum InvitationStatus { // InvitationStatus sabit seçenekler (enum) kümesini tanımlar
  pending('Pending', 'Beklemede'), // İlgili kod satırını ve işlemi yürütür
  accepted('Accepted', 'Kabul Edildi'), // İlgili kod satırını ve işlemi yürütür
  rejected('Rejected', 'Reddedildi'), // İlgili kod satırını ve işlemi yürütür
  cancelled('Cancelled', 'İptal Edildi'); // İlgili kod satırını ve işlemi yürütür

  final String value; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String labelTr; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const InvitationStatus(this.value, this.labelTr); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  static InvitationStatus fromValue(String value) { // İlgili kod satırını ve işlemi yürütür
    return InvitationStatus.values.firstWhere( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      (s) => s.value.toLowerCase() == value.toLowerCase(), // İlgili kod satırını ve işlemi yürütür
      orElse: () => InvitationStatus.pending, // orElse özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class InvitationModel { // InvitationModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String teamId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String senderId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String senderName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String receiverId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String receiverName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String position; // Örn: DEF_1
  final InvitationStatus status; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime createdAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime? respondedAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final TeamModel? team; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const InvitationModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.teamId, // teamId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.senderId, // senderId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.senderName = '', // senderName = '' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.receiverId, // receiverId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.receiverName = '', // receiverName = '' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.position, // position parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.status, // status parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.createdAt, // createdAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.respondedAt, // respondedAt sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.team, // team sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  bool get isPending => status == InvitationStatus.pending; // İlgili kod satırını ve işlemi yürütür

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'teamId': teamId, // 'teamId' özelliğini yapılandırır
      'senderId': senderId, // 'senderId' özelliğini yapılandırır
      'receiverId': receiverId, // 'receiverId' özelliğini yapılandırır
      'position': position, // 'position' özelliğini yapılandırır
      'status': status.value, // 'status' özelliğini yapılandırır
      'createdAt': createdAt.toIso8601String(), // 'createdAt' özelliğini yapılandırır
      'respondedAt': respondedAt?.toIso8601String(), // 'respondedAt' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory InvitationModel.fromMap( // İlgili kod satırını ve işlemi yürütür
    Map<String, dynamic> map, { // İlgili kod satırını ve işlemi yürütür
    String senderName = '', // İlgili kod satırını ve işlemi yürütür
    String receiverName = '', // İlgili kod satırını ve işlemi yürütür
    TeamModel? team, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return InvitationModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      teamId: map['teamId'] as String, // teamId özelliğini yapılandırır
      senderId: map['senderId'] as String, // senderId özelliğini yapılandırır
      senderName: senderName, // senderName özelliğini yapılandırır
      receiverId: map['receiverId'] as String, // receiverId özelliğini yapılandırır
      receiverName: receiverName, // receiverName özelliğini yapılandırır
      position: map['position'] as String, // position özelliğini yapılandırır
      status: InvitationStatus.fromValue(map['status'] as String), // status özelliğini yapılandırır
      createdAt: DateTime.parse(map['createdAt'] as String), // createdAt özelliğini yapılandırır
      respondedAt: map['respondedAt'] != null // İlgili kod satırını ve işlemi yürütür
          ? DateTime.parse(map['respondedAt'] as String) // İlgili kod satırını ve işlemi yürütür
          : null, //  özelliğini yapılandırır
      team: team, // team özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

