import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/team_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/notification_icon.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/state_widgets.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/user_card.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class ChatHubScreen extends ConsumerWidget { // Riverpod sağlayıcılarını dinleyebilen ChatHubScreen görsel bileşenini tanımlar
  const ChatHubScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  Future<void> _showInviteDialog( // İlgili kod satırını ve işlemi yürütür
    BuildContext context, // İlgili kod satırını ve işlemi yürütür
    WidgetRef ref, // İlgili kod satırını ve işlemi yürütür
    UserModel targetPlayer, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (user == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    final captainTeams = await ref.read(captainTeamsProvider.future); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (!context.mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    if (captainTeams.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            'Oyuncu davet edebilmek için önce "Takım Kur" sekmesinden bir takım oluşturmalısınız.', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.warning, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    // Boş mevkisi olan takımları filtrele
    final teamsWithEmptySlots = // Sabit/final değişken veya nesne tanımını başlatır
        captainTeams.where((t) => t.emptyPositions.isNotEmpty).toList(); // İlgili kod satırını ve işlemi yürütür
    if (teamsWithEmptySlots.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            'Oluşturduğunuz tüm takımların kadrosu (7/7) dolu durumda.', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.warning, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    TeamModel selectedTeam = teamsWithEmptySlots.first; // İlgili kod satırını ve işlemi yürütür
    String selectedPositionKey = selectedTeam.emptyPositions.first.key; // İlgili kod satırını ve işlemi yürütür

    await showDialog<void>( // Asenkron işlemin tamamlanmasını bekler
      context: context, // context özelliğini yapılandırır
      builder: (ctx) { // builder özelliğini yapılandırır
        return StatefulBuilder( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          builder: (ctx, setDialogState) { // builder özelliğini yapılandırır
            final emptySlots = selectedTeam.emptyPositions; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
            if (!emptySlots.any((s) => s.key == selectedPositionKey) && // Koşulun sağlanıp sağlanmadığını kontrol eder
                emptySlots.isNotEmpty) { // İlgili kod satırını ve işlemi yürütür
              selectedPositionKey = emptySlots.first.key; // İlgili kod satırını ve işlemi yürütür
            } // Açık olan kod/bileşen bloğunu kapatır

            return AlertDialog( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
              title: Text('${targetPlayer.fullName} — Davet Gönder'), // Ekrana metin bileşeni yazdırır
              content: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
                child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                  mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
                  crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                  children: [ // İlgili kod satırını ve işlemi yürütür
                    const Text( // Ekrana metin bileşeni yazdırır
                      'Davet göndermek istediğiniz takımı ve boş mevkiyi seçiniz:', // İlgili kod satırını ve işlemi yürütür
                      style: TextStyle(fontSize: 13), // style özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    const SizedBox(height: 14), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                    DropdownButtonFormField<String>( // İlgili kod satırını ve işlemi yürütür
                      initialValue: selectedTeam.id, // initialValue özelliğini yapılandırır
                      isExpanded: true, // isExpanded özelliğini yapılandırır
                      decoration: const InputDecoration( // İlgili kod satırını ve işlemi yürütür
                        labelText: 'Takım / Maç Seçin', // labelText özelliğini yapılandırır
                        prefixIcon: Icon(Icons.stadium_outlined), // Ekranda vektörel ikon gösterir
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      items: teamsWithEmptySlots.map((team) { // items özelliğini yapılandırır
                        return DropdownMenuItem<String>( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                          value: team.id, // value özelliğini yapılandırır
                          child: Text( // Ekrana metin bileşeni yazdırır
                            '${team.venueName} (${team.formattedDate} ${team.timeSlot})', // İlgili kod satırını ve işlemi yürütür
                            overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
                            style: const TextStyle(fontSize: 13), // style özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      }).toList(), // İlgili kod satırını ve işlemi yürütür
                      onChanged: (teamId) { // onChanged özelliğini yapılandırır
                        if (teamId == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
                        final found = teamsWithEmptySlots // Sabit/final değişken veya nesne tanımını başlatır
                            .firstWhere((t) => t.id == teamId); // İlgili kod satırını ve işlemi yürütür
                        setDialogState(() { // İlgili kod satırını ve işlemi yürütür
                          selectedTeam = found; // İlgili kod satırını ve işlemi yürütür
                          selectedPositionKey = // İlgili kod satırını ve işlemi yürütür
                              found.emptyPositions.first.key; // İlgili kod satırını ve işlemi yürütür
                        }); // İlgili kod satırını ve işlemi yürütür
                      }, // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    const SizedBox(height: 14), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                    DropdownButtonFormField<String>( // İlgili kod satırını ve işlemi yürütür
                      initialValue: selectedPositionKey, // initialValue özelliğini yapılandırır
                      isExpanded: true, // isExpanded özelliğini yapılandırır
                      decoration: const InputDecoration( // İlgili kod satırını ve işlemi yürütür
                        labelText: 'Boş Mevki Seçin', // labelText özelliğini yapılandırır
                        prefixIcon: Icon(Icons.sports_soccer_outlined), // Ekranda vektörel ikon gösterir
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      items: emptySlots.map((slot) { // items özelliğini yapılandırır
                        return DropdownMenuItem<String>( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                          value: slot.key, // value özelliğini yapılandırır
                          child: Text( // Ekrana metin bileşeni yazdırır
                            '${slot.label} (${selectedTeam.formation.label})', // İlgili kod satırını ve işlemi yürütür
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      }).toList(), // İlgili kod satırını ve işlemi yürütür
                      onChanged: (posKey) { // onChanged özelliğini yapılandırır
                        if (posKey == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
                        setDialogState(() { // İlgili kod satırını ve işlemi yürütür
                          selectedPositionKey = posKey; // İlgili kod satırını ve işlemi yürütür
                        }); // İlgili kod satırını ve işlemi yürütür
                      }, // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ], // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
              actions: [ // İlgili kod satırını ve işlemi yürütür
                TextButton( // Tıklanabilir aksiyon butonunu oluşturur
                  onPressed: () => Navigator.of(ctx).pop(), // onPressed özelliğini yapılandırır
                  child: const Text('İptal'), // Ekrana metin bileşeni yazdırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                ElevatedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                  key: const Key('confirm_send_invite_btn'), // key özelliğini yapılandırır
                  onPressed: () async { // onPressed özelliğini yapılandırır
                    try { // Hata yakalama (try) bloğunu başlatır
                      await ref // Asenkron işlemin tamamlanmasını bekler
                          .read(invitationRepositoryProvider) // İlgili kod satırını ve işlemi yürütür
                          .sendInvitation( // İlgili kod satırını ve işlemi yürütür
                            teamId: selectedTeam.id, // teamId özelliğini yapılandırır
                            senderId: user.id, // senderId özelliğini yapılandırır
                            receiverId: targetPlayer.id, // receiverId özelliğini yapılandırır
                            positionKey: selectedPositionKey, // positionKey özelliğini yapılandırır
                          ); // Açık olan kod/bileşen bloğunu kapatır
                      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
                      if (ctx.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                        Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                      } // Açık olan kod/bileşen bloğunu kapatır
                      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
                          SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
                            content: Text( // Ekrana metin bileşeni yazdırır
                              '${targetPlayer.fullName} oyuncusuna davet gönderildi (Durum: Beklemede).', // '${targetPlayer.fullName} oyuncusuna davet gönderildi (Durum özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            backgroundColor: AppColors.success, // backgroundColor özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      } // Açık olan kod/bileşen bloğunu kapatır
                    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
                      if (ctx.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                        Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                      } // Açık olan kod/bileşen bloğunu kapatır
                      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
                          SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
                            content: Text(e.toString()), // Ekrana metin bileşeni yazdırır
                            backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      } // Açık olan kod/bileşen bloğunu kapatır
                    } // Açık olan kod/bileşen bloğunu kapatır
                  }, // Açık olan kod/bileşen bloğunu kapatır
                  icon: const Icon(Icons.send_rounded, size: 18), // Ekranda vektörel ikon gösterir
                  label: const Text('Daveti Gönder'), // Ekrana metin bileşeni yazdırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ], // Açık olan kod/bileşen bloğunu kapatır
            ); // Açık olan kod/bileşen bloğunu kapatır
          }, // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context, WidgetRef ref) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final suggestedPlayersAsync = ref.watch(suggestedPlayersProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final chatTeamsAsync = ref.watch(userChatTeamsProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer

    return DefaultTabController( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      length: 2, // length özelliğini yapılandırır
      child: Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
        appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
          title: const Text('Oyuncu Önerileri & Sohbet'), // Ekrana metin bileşeni yazdırır
          actions: const [ // İlgili kod satırını ve işlemi yürütür
            NotificationIcon(), // Ekranda vektörel ikon gösterir
            SizedBox(width: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
          ], // Açık olan kod/bileşen bloğunu kapatır
          bottom: const TabBar( // İlgili kod satırını ve işlemi yürütür
            indicatorColor: AppColors.pitchLightGreen, // indicatorColor özelliğini yapılandırır
            indicatorWeight: 3, // indicatorWeight özelliğini yapılandırır
            labelColor: Colors.white, // labelColor özelliğini yapılandırır
            unselectedLabelColor: Colors.white70, // unselectedLabelColor özelliğini yapılandırır
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 14), // labelStyle özelliğini yapılandırır
            tabs: [ // İlgili kod satırını ve işlemi yürütür
              Tab( // İlgili kod satırını ve işlemi yürütür
                key: Key('tab_player_suggestions'), // key özelliğini yapılandırır
                icon: Icon(Icons.group_add_outlined), // Ekranda vektörel ikon gösterir
                text: 'Oyuncu Önerileri', // text özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
              Tab( // İlgili kod satırını ve işlemi yürütür
                key: Key('tab_team_chat'), // key özelliğini yapılandırır
                icon: Icon(Icons.chat_bubble_outline_rounded), // Ekranda vektörel ikon gösterir
                text: 'Sohbet', // text özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
        body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
          child: TabBarView( // İlgili kod satırını ve işlemi yürütür
            children: [ // İlgili kod satırını ve işlemi yürütür
              // SEKME 1: Oyuncu Önerileri
              suggestedPlayersAsync.when( // İlgili kod satırını ve işlemi yürütür
                loading: () => // İlgili kod satırını ve işlemi yürütür
                    const LoadingWidget(message: 'Oyuncular yükleniyor...'), // Sabit/final değişken veya nesne tanımını başlatır
                error: (err, _) => AppErrorWidget( // İlgili kod satırını ve işlemi yürütür
                  message: err.toString(), // message özelliğini yapılandırır
                  onRetry: () => triggerGlobalRefresh(ref), // onRetry özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                data: (players) { // data özelliğini yapılandırır
                  if (players.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                    return const EmptyStateWidget( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                      icon: Icons.people_outline_rounded, // icon özelliğini yapılandırır
                      title: 'Önerilecek Oyuncu Bulunamadı', // title özelliğini yapılandırır
                      subtitle: 'Sistemde başka kayıtlı oyuncu bulunmuyor.', // subtitle özelliğini yapılandırır
                    ); // Açık olan kod/bileşen bloğunu kapatır
                  } // Açık olan kod/bileşen bloğunu kapatır
                  return RefreshIndicator( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                    onRefresh: () async => triggerGlobalRefresh(ref), // onRefresh özelliğini yapılandırır
                    child: ListView.builder( // Kaydırılabilir liste görünümü oluşturur
                      padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                        horizontal: 16, // horizontal özelliğini yapılandırır
                        vertical: 12, // vertical özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      itemCount: players.length, // itemCount özelliğini yapılandırır
                      itemBuilder: (ctx, index) { // itemBuilder özelliğini yapılandırır
                        final player = players[index]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                        return UserCard( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                          key: Key('suggested_user_card_${player.id}'), // key özelliğini yapılandırır
                          player: player, // player özelliğini yapılandırır
                          onInvitePressed: () => // İlgili kod satırını ve işlemi yürütür
                              _showInviteDialog(context, ref, player), // İlgili kod satırını ve işlemi yürütür
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      }, // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ); // Açık olan kod/bileşen bloğunu kapatır
                }, // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır

              // SEKME 2: Takım Sohbeti
              chatTeamsAsync.when( // İlgili kod satırını ve işlemi yürütür
                loading: () => const LoadingWidget( // İlgili kod satırını ve işlemi yürütür
                    message: 'Takım sohbetleri yükleniyor...'), // message özelliğini yapılandırır
                error: (err, _) => AppErrorWidget( // İlgili kod satırını ve işlemi yürütür
                  message: err.toString(), // message özelliğini yapılandırır
                  onRetry: () => triggerGlobalRefresh(ref), // onRetry özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                data: (teams) { // data özelliğini yapılandırır
                  if (teams.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                    return EmptyStateWidget( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                      icon: Icons.forum_outlined, // icon özelliğini yapılandırır
                      title: 'Henüz Üyesi Olduğunuz Takım Yok', // title özelliğini yapılandırır
                      subtitle: // İlgili kod satırını ve işlemi yürütür
                          'Takım sohbetine katılmak için yeni bir takım kurabilir veya size gelen bir takım davetini kabul edebilirsiniz.', // İlgili kod satırını ve işlemi yürütür
                      action: ElevatedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                        onPressed: () => context.go('/team-creation'), // Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)
                        icon: const Icon(Icons.sports_soccer), // Ekranda vektörel ikon gösterir
                        label: const Text('Takım Kur'), // Ekrana metin bileşeni yazdırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ); // Açık olan kod/bileşen bloğunu kapatır
                  } // Açık olan kod/bileşen bloğunu kapatır

                  return RefreshIndicator( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                    onRefresh: () async => triggerGlobalRefresh(ref), // onRefresh özelliğini yapılandırır
                    child: ListView.builder( // Kaydırılabilir liste görünümü oluşturur
                      padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                        horizontal: 16, // horizontal özelliğini yapılandırır
                        vertical: 12, // vertical özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      itemCount: teams.length, // itemCount özelliğini yapılandırır
                      itemBuilder: (ctx, index) { // itemBuilder özelliğini yapılandırır
                        final team = teams[index]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                        return Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                          key: Key('chat_team_tile_${team.id}'), // key özelliğini yapılandırır
                          child: ListTile( // İlgili kod satırını ve işlemi yürütür
                            contentPadding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                              horizontal: 16, // horizontal özelliğini yapılandırır
                              vertical: 8, // vertical özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            leading: CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                              radius: 24, // radius özelliğini yapılandırır
                              backgroundColor: // İlgili kod satırını ve işlemi yürütür
                                  Theme.of(context).colorScheme.primary, // İlgili kod satırını ve işlemi yürütür
                              child: const Icon( // Ekranda vektörel ikon gösterir
                                Icons.groups_rounded, // İlgili kod satırını ve işlemi yürütür
                                color: Colors.white, // color özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            title: Text( // Ekrana metin bileşeni yazdırır
                              '${team.captainName} Takımı (${team.formation.label})', // İlgili kod satırını ve işlemi yürütür
                              style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                                fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            subtitle: Column( // Alt bileşenleri dikey eksende alt alta dizer
                              crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                              children: [ // İlgili kod satırını ve işlemi yürütür
                                const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                                Text( // Ekrana metin bileşeni yazdırır
                                  '${team.province} / ${team.district} — ${team.venueName}', // İlgili kod satırını ve işlemi yürütür
                                  maxLines: 1, // maxLines özelliğini yapılandırır
                                  overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                const SizedBox(height: 2), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                                Text( // Ekrana metin bileşeni yazdırır
                                  'Maç: ${team.formattedDate} • ${team.timeSlot} • ${team.members.length}/7 Oyuncu', // 'Maç özelliğini yapılandırır
                                  style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                    fontSize: 12, // fontSize özelliğini yapılandırır
                                    color: Theme.of(context) // İlgili kod satırını ve işlemi yürütür
                                        .colorScheme // İlgili kod satırını ve işlemi yürütür
                                        .primary, // İlgili kod satırını ve işlemi yürütür
                                    fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ], // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            trailing: // İlgili kod satırını ve işlemi yürütür
                                const Icon(Icons.chevron_right_rounded), // Ekranda vektörel ikon gösterir
                            onTap: () { // onTap özelliğini yapılandırır
                              context.push('/chat-room/${team.id}'); // Yeni ekranı mevcut ekranın üzerine açar (geri dönülebilir)
                            }, // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      }, // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ); // Açık olan kod/bileşen bloğunu kapatır
                }, // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

