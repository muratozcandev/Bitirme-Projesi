import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/state_widgets.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class TeamChatRoomScreen extends ConsumerStatefulWidget { // Riverpod destekli durum bilgili (Stateful) TeamChatRoomScreen ekran bileşenini tanımlar
  final String teamId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const TeamChatRoomScreen({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.teamId, // teamId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  ConsumerState<TeamChatRoomScreen> createState() => _TeamChatRoomScreenState(); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

class _TeamChatRoomScreenState extends ConsumerState<TeamChatRoomScreen> { // _TeamChatRoomScreenState ekranının Riverpod destekli durum (State) sınıfını tanımlar
  final _messageController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _scrollController = ScrollController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  bool _isSending = false; // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  void dispose() { // İlgili kod satırını ve işlemi yürütür
    _messageController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    _scrollController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    super.dispose(); // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleSend() async { // İlgili kod satırını ve işlemi yürütür
    final text = _messageController.text.trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (text.isEmpty || _isSending) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (user == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    setState(() { // Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler
      _isSending = true; // İlgili kod satırını ve işlemi yürütür
    }); // İlgili kod satırını ve işlemi yürütür

    try { // Hata yakalama (try) bloğunu başlatır
      await ref.read(chatRepositoryProvider).sendMessage( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
            teamId: widget.teamId, // teamId özelliğini yapılandırır
            senderId: user.id, // senderId özelliğini yapılandırır
            content: text, // content özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
      _messageController.clear(); // İlgili kod satırını ve işlemi yürütür
      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür

      WidgetsBinding.instance.addPostFrameCallback((_) { // İlgili kod satırını ve işlemi yürütür
        if (_scrollController.hasClients) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          _scrollController.animateTo( // İlgili kod satırını ve işlemi yürütür
            _scrollController.position.maxScrollExtent, // İlgili kod satırını ve işlemi yürütür
            duration: const Duration(milliseconds: 250), // duration özelliğini yapılandırır
            curve: Curves.easeOut, // curve özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır
      }); // İlgili kod satırını ve işlemi yürütür
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
            content: Text(e.toString()), // Ekrana metin bileşeni yazdırır
            backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } finally { // İlgili kod satırını ve işlemi yürütür
      if (mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        setState(() { // Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler
          _isSending = false; // İlgili kod satırını ve işlemi yürütür
        }); // İlgili kod satırını ve işlemi yürütür
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final messagesAsync = ref.watch(teamMessagesProvider(widget.teamId)); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final currentUser = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: const Text('Takım Sohbeti'), // Ekrana metin bileşeni yazdırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          children: [ // İlgili kod satırını ve işlemi yürütür
            Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
              child: messagesAsync.when( // İlgili kod satırını ve işlemi yürütür
                loading: () => // İlgili kod satırını ve işlemi yürütür
                    const LoadingWidget(message: 'Mesajlar yükleniyor...'), // Sabit/final değişken veya nesne tanımını başlatır
                error: (err, _) => AppErrorWidget( // İlgili kod satırını ve işlemi yürütür
                  message: err.toString(), // message özelliğini yapılandırır
                  onRetry: () => triggerGlobalRefresh(ref), // onRetry özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                data: (messages) { // data özelliğini yapılandırır
                  if (messages.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                    return const EmptyStateWidget( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                      icon: Icons.chat_outlined, // icon özelliğini yapılandırır
                      title: 'Henüz Mesaj Yok', // title özelliğini yapılandırır
                      subtitle: // İlgili kod satırını ve işlemi yürütür
                          'Takım arkadaşlarınızla maç öncesi ilk mesajı siz gönderin!', // İlgili kod satırını ve işlemi yürütür
                    ); // Açık olan kod/bileşen bloğunu kapatır
                  } // Açık olan kod/bileşen bloğunu kapatır

                  return ListView.builder( // Kaydırılabilir liste görünümü oluşturur
                    controller: _scrollController, // controller özelliğini yapılandırır
                    padding: const EdgeInsets.all(14), // padding özelliğini yapılandırır
                    itemCount: messages.length, // itemCount özelliğini yapılandırır
                    itemBuilder: (context, index) { // itemBuilder özelliğini yapılandırır
                      final msg = messages[index]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                      final isMe = msg.senderId == currentUser?.id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

                      return Align( // İçindeki bileşeni belirtilen hizaya konumlandırır
                        alignment: // İlgili kod satırını ve işlemi yürütür
                            isMe ? Alignment.centerRight : Alignment.centerLeft, // isMe ? Alignment.centerRight özelliğini yapılandırır
                        child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                          constraints: BoxConstraints( // İlgili kod satırını ve işlemi yürütür
                            maxWidth: // İlgili kod satırını ve işlemi yürütür
                                MediaQuery.of(context).size.width * 0.78, // İlgili kod satırını ve işlemi yürütür
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          margin: const EdgeInsets.symmetric(vertical: 5), // margin özelliğini yapılandırır
                          padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                            horizontal: 14, // horizontal özelliğini yapılandırır
                            vertical: 10, // vertical özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                            color: isMe // İlgili kod satırını ve işlemi yürütür
                                ? theme.colorScheme.primary // İlgili kod satırını ve işlemi yürütür
                                : theme.colorScheme.surfaceContainerHighest, //  özelliğini yapılandırır
                            borderRadius: BorderRadius.only( // İlgili kod satırını ve işlemi yürütür
                              topLeft: const Radius.circular(16), // topLeft özelliğini yapılandırır
                              topRight: const Radius.circular(16), // topRight özelliğini yapılandırır
                              bottomLeft: Radius.circular(isMe ? 16 : 4), // bottomLeft özelliğini yapılandırır
                              bottomRight: Radius.circular(isMe ? 4 : 16), // bottomRight özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                            crossAxisAlignment: isMe // İlgili kod satırını ve işlemi yürütür
                                ? CrossAxisAlignment.end // İlgili kod satırını ve işlemi yürütür
                                : CrossAxisAlignment.start, //  özelliğini yapılandırır
                            children: [ // İlgili kod satırını ve işlemi yürütür
                              Text( // Ekrana metin bileşeni yazdırır
                                msg.senderName, // İlgili kod satırını ve işlemi yürütür
                                style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                  fontSize: 11.5, // fontSize özelliğini yapılandırır
                                  fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                                  color: isMe // İlgili kod satırını ve işlemi yürütür
                                      ? AppColors.pitchLightGreen // İlgili kod satırını ve işlemi yürütür
                                      : theme.colorScheme.primary, //  özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                              const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                              Text( // Ekrana metin bileşeni yazdırır
                                msg.content, // İlgili kod satırını ve işlemi yürütür
                                style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                  fontSize: 14, // fontSize özelliğini yapılandırır
                                  color: isMe // İlgili kod satırını ve işlemi yürütür
                                      ? Colors.white // İlgili kod satırını ve işlemi yürütür
                                      : theme.colorScheme.onSurface, //  özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                              const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                              Text( // Ekrana metin bileşeni yazdırır
                                _formatTime(msg.createdAt), // İlgili kod satırını ve işlemi yürütür
                                style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                  fontSize: 10.5, // fontSize özelliğini yapılandırır
                                  color: isMe // İlgili kod satırını ve işlemi yürütür
                                      ? Colors.white70 // İlgili kod satırını ve işlemi yürütür
                                      : theme.colorScheme.onSurfaceVariant, //  özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ], // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ); // Açık olan kod/bileşen bloğunu kapatır
                    }, // Açık olan kod/bileşen bloğunu kapatır
                  ); // Açık olan kod/bileşen bloğunu kapatır
                }, // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12), // padding özelliğini yapılandırır
              decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                color: theme.colorScheme.surface, // color özelliğini yapılandırır
                border: Border( // İlgili kod satırını ve işlemi yürütür
                  top: BorderSide( // İlgili kod satırını ve işlemi yürütür
                    color: theme.colorScheme.outline.withValues(alpha: 0.25), // color özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
              child: Row( // Alt bileşenleri yatay eksende yan yana dizer
                children: [ // İlgili kod satırını ve işlemi yürütür
                  Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                    child: TextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                      key: const Key('chat_message_input'), // key özelliğini yapılandırır
                      controller: _messageController, // controller özelliğini yapılandırır
                      textInputAction: TextInputAction.send, // textInputAction özelliğini yapılandırır
                      onSubmitted: (_) => _handleSend(), // onSubmitted özelliğini yapılandırır
                      decoration: const InputDecoration( // İlgili kod satırını ve işlemi yürütür
                        hintText: 'Takımına mesaj yaz...', // hintText özelliğini yapılandırır
                        contentPadding: EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                          horizontal: 16, // horizontal özelliğini yapılandırır
                          vertical: 12, // vertical özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(width: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  IconButton.filled( // İlgili kod satırını ve işlemi yürütür
                    key: const Key('chat_send_button'), // key özelliğini yapılandırır
                    style: IconButton.styleFrom( // İlgili kod satırını ve işlemi yürütür
                      backgroundColor: AppColors.pitchGreen, // backgroundColor özelliğini yapılandırır
                      foregroundColor: Colors.white, // foregroundColor özelliğini yapılandırır
                      minimumSize: const Size(48, 48), // minimumSize özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    onPressed: _isSending ? null : _handleSend, // onPressed özelliğini yapılandırır
                    icon: _isSending // İlgili kod satırını ve işlemi yürütür
                        ? const SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            width: 20, // width özelliğini yapılandırır
                            height: 20, // height özelliğini yapılandırır
                            child: CircularProgressIndicator( // İşlem devam ederken dönen yükleme göstergesi çizer
                              strokeWidth: 2, // strokeWidth özelliğini yapılandırır
                              color: Colors.white, // color özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ) // İlgili kod satırını ve işlemi yürütür
                        : const Icon(Icons.send_rounded), // Ekranda vektörel ikon gösterir
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  String _formatTime(DateTime dt) { // İlgili kod satırını ve işlemi yürütür
    final d = dt.day.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final m = dt.month.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final h = dt.hour.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final min = dt.minute.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return '$d.$m $h:$min'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

