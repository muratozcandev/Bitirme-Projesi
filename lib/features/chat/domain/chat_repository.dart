import '../../../shared/models/message_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

abstract class ChatRepository { // ChatRepository soyut arayüz (interface) sınıfını tanımlar
  Future<List<MessageModel>> getTeamMessages({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String requesterId, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<MessageModel> sendMessage({ // İlgili kod satırını ve işlemi yürütür
    required String teamId, // İlgili kod satırını ve işlemi yürütür
    required String senderId, // İlgili kod satırını ve işlemi yürütür
    required String content, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

