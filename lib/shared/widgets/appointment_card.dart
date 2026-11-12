import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/team_member_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/team_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class AppointmentCard extends StatelessWidget { // Durumsuz (Stateless) AppointmentCard görsel bileşenini tanımlar
  final TeamModel team; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String currentUserId; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback onDeleteConfirmed; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const AppointmentCard({ // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.team, // team parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.currentUserId, // currentUserId parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.onDeleteConfirmed, // onDeleteConfirmed parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  bool get _isCaptain => team.captainId == currentUserId; // İlgili kod satırını ve işlemi yürütür

  String get _userRoleLabel { // İlgili kod satırını ve işlemi yürütür
    if (_isCaptain) return 'Takım Kaptanı'; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final myMember = // Sabit/final değişken veya nesne tanımını başlatır
        team.members.where((m) => m.userId == currentUserId).firstOrNull; // İlgili kod satırını ve işlemi yürütür
    if (myMember != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      final posLabel = team.formation.labelForKey(myMember.position); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      return 'Oyuncu ($posLabel)'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return 'Takım Üyesi'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _showDeleteDialog(BuildContext context) async { // İlgili kod satırını ve işlemi yürütür
    final confirmed = await showDialog<bool>( // Sabit/final değişken veya nesne tanımını başlatır
      context: context, // context özelliğini yapılandırır
      builder: (ctx) => AlertDialog( // İlgili kod satırını ve işlemi yürütür
        title: const Text('Randevuyu Sil'), // Ekrana metin bileşeni yazdırır
        content: const Text( // Ekrana metin bileşeni yazdırır
          'Bu maç randevusunu randevu listenizden silmek istediğinize emin misiniz?\n\nNot: Kendi listenizden silmeniz diğer takım oyuncularının randevusunu silmez.', // 'Bu maç randevusunu randevu listenizden silmek istediğinize emin misiniz?\n\nNot özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        actions: [ // İlgili kod satırını ve işlemi yürütür
          TextButton( // Tıklanabilir aksiyon butonunu oluşturur
            onPressed: () => Navigator.of(ctx).pop(false), // onPressed özelliğini yapılandırır
            child: const Text('Vazgeç'), // Ekrana metin bileşeni yazdırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          ElevatedButton( // Tıklanabilir aksiyon butonunu oluşturur
            key: const Key('confirm_delete_appointment_btn'), // key özelliğini yapılandırır
            style: ElevatedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
              backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
              foregroundColor: Colors.white, // foregroundColor özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            onPressed: () => Navigator.of(ctx).pop(true), // onPressed özelliğini yapılandırır
            child: const Text('Randevuyu Sil'), // Ekrana metin bileşeni yazdırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır

    if (confirmed == true) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      onDeleteConfirmed(); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final slots = team.formation.positions; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final memberByPosition = <String, TeamMemberModel>{ // Sabit/final değişken veya nesne tanımını başlatır
      for (final m in team.members) m.position: m, // Koleksiyon veya aralık üzerinde döngü başlatır
    }; // Açık olan kod/bileşen bloğunu kapatır

    return Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
        padding: const EdgeInsets.all(16), // padding özelliğini yapılandırır
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
          children: [ // İlgili kod satırını ve işlemi yürütür
            // Üst Başlık + Rol Rozeti + Üç Nokta Menüsü
            Row( // Alt bileşenleri yatay eksende yan yana dizer
              crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
              children: [ // İlgili kod satırını ve işlemi yürütür
                CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                  radius: 22, // radius özelliğini yapılandırır
                  backgroundColor: theme.colorScheme.primary, // backgroundColor özelliğini yapılandırır
                  child: const Icon( // Ekranda vektörel ikon gösterir
                    Icons.sports_soccer, // İlgili kod satırını ve işlemi yürütür
                    color: Colors.white, // color özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                const SizedBox(width: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                  child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                    crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      Text( // Ekrana metin bileşeni yazdırır
                        '${team.captainName} Takımı (7v7)', // İlgili kod satırını ve işlemi yürütür
                        style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                          fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Wrap( // İlgili kod satırını ve işlemi yürütür
                        spacing: 6, // spacing özelliğini yapılandırır
                        runSpacing: 4, // runSpacing özelliğini yapılandırır
                        children: [ // İlgili kod satırını ve işlemi yürütür
                          Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                            padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                              horizontal: 8, // horizontal özelliğini yapılandırır
                              vertical: 3, // vertical özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                              color: _isCaptain // İlgili kod satırını ve işlemi yürütür
                                  ? AppColors.goldAccent.withValues(alpha: 0.2) // İlgili kod satırını ve işlemi yürütür
                                  : theme.colorScheme.primaryContainer, //  özelliğini yapılandırır
                              borderRadius: BorderRadius.circular(8), // borderRadius özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            child: Text( // Ekrana metin bileşeni yazdırır
                              'Rolünüz: $_userRoleLabel', // 'Rolünüz özelliğini yapılandırır
                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                fontSize: 11.5, // fontSize özelliğini yapılandırır
                                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                                color: _isCaptain // İlgili kod satırını ve işlemi yürütür
                                    ? const Color(0xFFB45309) // İlgili kod satırını ve işlemi yürütür
                                    : theme.colorScheme.onPrimaryContainer, //  özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                            padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                              horizontal: 8, // horizontal özelliğini yapılandırır
                              vertical: 3, // vertical özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                              color: theme.colorScheme.secondaryContainer, // color özelliğini yapılandırır
                              borderRadius: BorderRadius.circular(8), // borderRadius özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            child: Text( // Ekrana metin bileşeni yazdırır
                              'Diziliş: ${team.formation.label}', // 'Diziliş özelliğini yapılandırır
                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                fontSize: 11.5, // fontSize özelliğini yapılandırır
                                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                                color: theme.colorScheme.onSecondaryContainer, // color özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ], // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                PopupMenuButton<String>( // İlgili kod satırını ve işlemi yürütür
                  key: Key('appointment_menu_${team.id}'), // key özelliğini yapılandırır
                  tooltip: 'Seçenekler', // tooltip özelliğini yapılandırır
                  icon: const Icon(Icons.more_vert_rounded), // Ekranda vektörel ikon gösterir
                  onSelected: (value) { // onSelected özelliğini yapılandırır
                    if (value == 'delete') { // Koşulun sağlanıp sağlanmadığını kontrol eder
                      _showDeleteDialog(context); // İlgili kod satırını ve işlemi yürütür
                    } // Açık olan kod/bileşen bloğunu kapatır
                  }, // Açık olan kod/bileşen bloğunu kapatır
                  itemBuilder: (_) => const [ // İlgili kod satırını ve işlemi yürütür
                    PopupMenuItem<String>( // İlgili kod satırını ve işlemi yürütür
                      value: 'delete', // value özelliğini yapılandırır
                      child: Row( // Alt bileşenleri yatay eksende yan yana dizer
                        children: [ // İlgili kod satırını ve işlemi yürütür
                          Icon( // Ekranda vektörel ikon gösterir
                            Icons.delete_outline_rounded, // İlgili kod satırını ve işlemi yürütür
                            color: AppColors.error, // color özelliğini yapılandırır
                            size: 20, // size özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          SizedBox(width: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                          Text( // Ekrana metin bileşeni yazdırır
                            'Randevuyu Sil', // İlgili kod satırını ve işlemi yürütür
                            style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                              color: AppColors.error, // color özelliğini yapılandırır
                              fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ], // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ], // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ], // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            const Divider(height: 1), // Sabit/final değişken veya nesne tanımını başlatır
            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

            // Konum, Tarih ve Saat Bilgileri
            _InfoRow( // Alt bileşenleri yatay eksende yan yana dizer
              icon: Icons.location_on_outlined, // icon özelliğini yapılandırır
              label: 'İl / İlçe:', // label özelliğini yapılandırır
              value: '${team.province} / ${team.district}', // value özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            _InfoRow( // Alt bileşenleri yatay eksende yan yana dizer
              icon: Icons.stadium_outlined, // icon özelliğini yapılandırır
              label: 'Halı Saha:', // label özelliğini yapılandırır
              value: team.venueName, // value özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Row( // Alt bileşenleri yatay eksende yan yana dizer
              children: [ // İlgili kod satırını ve işlemi yürütür
                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                  child: _InfoRow( // Alt bileşenleri yatay eksende yan yana dizer
                    icon: Icons.calendar_today_outlined, // icon özelliğini yapılandırır
                    label: 'Tarih:', // label özelliğini yapılandırır
                    value: team.formattedDate, // value özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                  child: _InfoRow( // Alt bileşenleri yatay eksende yan yana dizer
                    icon: Icons.access_time_rounded, // icon özelliğini yapılandırır
                    label: 'Saat:', // label özelliğini yapılandırır
                    value: team.timeSlot, // value özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ], // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

            // Takım Kadrosu (7 Mevki)
            Text( // Ekrana metin bileşeni yazdırır
              'Takım Kadrosu (${team.members.length}/7 Dolu)', // İlgili kod satırını ve işlemi yürütür
              style: theme.textTheme.labelLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Wrap( // İlgili kod satırını ve işlemi yürütür
              spacing: 6, // spacing özelliğini yapılandırır
              runSpacing: 6, // runSpacing özelliğini yapılandırır
              children: slots.map((slot) { // children özelliğini yapılandırır
                final member = memberByPosition[slot.key]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                final hasMember = // Sabit/final değişken veya nesne tanımını başlatır
                    member != null && member.displayName.trim().isNotEmpty; // İlgili kod satırını ve işlemi yürütür
                return Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                  padding: // İlgili kod satırını ve işlemi yürütür
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Sabit/final değişken veya nesne tanımını başlatır
                  decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                    color: hasMember // İlgili kod satırını ve işlemi yürütür
                        ? theme.colorScheme.primaryContainer // İlgili kod satırını ve işlemi yürütür
                            .withValues(alpha: 0.45) // İlgili kod satırını ve işlemi yürütür
                        : theme.colorScheme.surfaceContainerHighest // İlgili kod satırını ve işlemi yürütür
                            .withValues(alpha: 0.5), // .withValues(alpha özelliğini yapılandırır
                    borderRadius: BorderRadius.circular(10), // borderRadius özelliğini yapılandırır
                    border: Border.all( // İlgili kod satırını ve işlemi yürütür
                      color: hasMember // İlgili kod satırını ve işlemi yürütür
                          ? theme.colorScheme.primary.withValues(alpha: 0.35) // İlgili kod satırını ve işlemi yürütür
                          : theme.colorScheme.outline.withValues(alpha: 0.3), //  özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  child: Row( // Alt bileşenleri yatay eksende yan yana dizer
                    mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      Icon( // Ekranda vektörel ikon gösterir
                        hasMember // İlgili kod satırını ve işlemi yürütür
                            ? Icons.person_rounded // İlgili kod satırını ve işlemi yürütür
                            : Icons.person_outline_rounded, //  özelliğini yapılandırır
                        size: 14, // size özelliğini yapılandırır
                        color: hasMember // İlgili kod satırını ve işlemi yürütür
                            ? theme.colorScheme.primary // İlgili kod satırını ve işlemi yürütür
                            : theme.colorScheme.onSurfaceVariant, //  özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(width: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Text( // Ekrana metin bileşeni yazdırır
                        '${slot.label}: ', // '${slot.label} özelliğini yapılandırır
                        style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                          fontSize: 11.5, // fontSize özelliğini yapılandırır
                          fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                          color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      Text( // Ekrana metin bileşeni yazdırır
                        hasMember ? member.displayName : 'Boş', // hasMember ? member.displayName özelliğini yapılandırır
                        style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                          fontSize: 11.5, // fontSize özelliğini yapılandırır
                          fontWeight: // İlgili kod satırını ve işlemi yürütür
                              hasMember ? FontWeight.w800 : FontWeight.w500, // hasMember ? FontWeight.w800 özelliğini yapılandırır
                          color: hasMember // İlgili kod satırını ve işlemi yürütür
                              ? theme.colorScheme.onSurface // İlgili kod satırını ve işlemi yürütür
                              : theme.colorScheme.onSurfaceVariant, //  özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ); // Açık olan kod/bileşen bloğunu kapatır
              }).toList(), // İlgili kod satırını ve işlemi yürütür
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class _InfoRow extends StatelessWidget { // Durumsuz (Stateless) _InfoRow görsel bileşenini tanımlar
  final IconData icon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String label; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String value; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const _InfoRow({ // Alt bileşenleri yatay eksende yan yana dizer
    required this.icon, // icon parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.label, // label parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.value, // value parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Row( // Alt bileşenleri yatay eksende yan yana dizer
      children: [ // İlgili kod satırını ve işlemi yürütür
        Icon(icon, size: 17, color: theme.colorScheme.primary), // Ekranda vektörel ikon gösterir
        const SizedBox(width: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
        Text( // Ekrana metin bileşeni yazdırır
          label, // İlgili kod satırını ve işlemi yürütür
          style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
            fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
            color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
        const SizedBox(width: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
        Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
          child: Text( // Ekrana metin bileşeni yazdırır
            value, // İlgili kod satırını ve işlemi yürütür
            maxLines: 1, // maxLines özelliğini yapılandırır
            overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
            style: theme.textTheme.bodyMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
              fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ], // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

