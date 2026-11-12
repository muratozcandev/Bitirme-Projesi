class MessageModel { // MessageModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String teamId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String senderId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String senderName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String content; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime createdAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const MessageModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.teamId, // teamId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.senderId, // senderId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.senderName = '', // senderName = '' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.content, // content parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.createdAt, // createdAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'teamId': teamId, // 'teamId' özelliğini yapılandırır
      'senderId': senderId, // 'senderId' özelliğini yapılandırır
      'content': content, // 'content' özelliğini yapılandırır
      'createdAt': createdAt.toIso8601String(), // 'createdAt' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory MessageModel.fromMap( // İlgili kod satırını ve işlemi yürütür
    Map<String, dynamic> map, { // İlgili kod satırını ve işlemi yürütür
    String senderName = '', // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return MessageModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: map['id'] as String, // id özelliğini yapılandırır
      teamId: map['teamId'] as String, // teamId özelliğini yapılandırır
      senderId: map['senderId'] as String, // senderId özelliğini yapılandırır
      senderName: senderName, // senderName özelliğini yapılandırır
      content: map['content'] as String, // content özelliğini yapılandırır
      createdAt: DateTime.parse(map['createdAt'] as String), // createdAt özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

