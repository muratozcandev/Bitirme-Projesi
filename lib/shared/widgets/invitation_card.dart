import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/invitation_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/team_member_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class InvitationCard extends StatelessWidget { // Durumsuz (Stateless) InvitationCard görsel bileşenini tanımlar
  final InvitationModel invitation; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback? onAccept; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback? onReject; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const InvitationCard({ // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.invitation, // invitation parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.onAccept, // onAccept sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.onReject, // onReject sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final team = invitation.team; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (team == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return const SizedBox.shrink(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır

    final invitedPositionLabel = team.formation.labelForKey(invitation.position); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final slots = team.formation.positions; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final memberByPosition = <String, TeamMemberModel>{ // Sabit/final değişken veya nesne tanımını başlatır
      for (final m in team.members) m.position: m, // Koleksiyon veya aralık üzerinde döngü başlatır
    }; // Açık olan kod/bileşen bloğunu kapatır

    final Color statusColor; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    switch (invitation.status) { // Değere göre çoklu durum kontrolü (switch) başlatır
      case InvitationStatus.pending: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        statusColor = AppColors.warning; // İlgili kod satırını ve işlemi yürütür
      case InvitationStatus.accepted: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        statusColor = AppColors.success; // İlgili kod satırını ve işlemi yürütür
      case InvitationStatus.rejected: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
      case InvitationStatus.cancelled: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        statusColor = AppColors.error; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    return Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
        padding: const EdgeInsets.all(16), // padding özelliğini yapılandırır
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
          children: [ // İlgili kod satırını ve işlemi yürütür
            Row( // Alt bileşenleri yatay eksende yan yana dizer
              children: [ // İlgili kod satırını ve işlemi yürütür
                CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                  backgroundColor: theme.colorScheme.primary, // backgroundColor özelliğini yapılandırır
                  child: const Icon( // Ekranda vektörel ikon gösterir
                    Icons.mail_outline_rounded, // İlgili kod satırını ve işlemi yürütür
                    color: Colors.white, // color özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                const SizedBox(width: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                  child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                    crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      Text( // Ekrana metin bileşeni yazdırır
                        'Davet Gönderen: ${invitation.senderName}', // 'Davet Gönderen özelliğini yapılandırır
                        style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                          fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(height: 2), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Text( // Ekrana metin bileşeni yazdırır
                        'Davet Edilen Mevki: $invitedPositionLabel', // 'Davet Edilen Mevki özelliğini yapılandırır
                        style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                          fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                          color: theme.colorScheme.primary, // color özelliğini yapılandırır
                          fontSize: 13, // fontSize özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                  padding: // İlgili kod satırını ve işlemi yürütür
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Sabit/final değişken veya nesne tanımını başlatır
                  decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                    color: statusColor.withValues(alpha: 0.16), // color özelliğini yapılandırır
                    borderRadius: BorderRadius.circular(10), // borderRadius özelliğini yapılandırır
                    border: Border.all( // İlgili kod satırını ve işlemi yürütür
                      color: statusColor.withValues(alpha: 0.5), // color özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  child: Text( // Ekrana metin bileşeni yazdırır
                    invitation.status.labelTr, // İlgili kod satırını ve işlemi yürütür
                    style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                      fontSize: 11.5, // fontSize özelliğini yapılandırır
                      fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                      color: statusColor, // color özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ], // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            const Divider(height: 1), // Sabit/final değişken veya nesne tanımını başlatır
            const SizedBox(height: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            _DetailLine( // İlgili kod satırını ve işlemi yürütür
              label: 'İl / İlçe:', // label özelliğini yapılandırır
              value: '${team.province} / ${team.district}', // value özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            _DetailLine( // İlgili kod satırını ve işlemi yürütür
              label: 'Halı Saha:', // label özelliğini yapılandırır
              value: team.venueName, // value özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            _DetailLine( // İlgili kod satırını ve işlemi yürütür
              label: 'Tarih / Saat:', // label özelliğini yapılandırır
              value: '${team.formattedDate} • ${team.timeSlot}', // value özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            _DetailLine( // İlgili kod satırını ve işlemi yürütür
              label: 'Diziliş:', // label özelliğini yapılandırır
              value: team.formation.label, // value özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text( // Ekrana metin bileşeni yazdırır
              'Takım Kadrosu:', // İlgili kod satırını ve işlemi yürütür
              style: theme.textTheme.labelMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Wrap( // İlgili kod satırını ve işlemi yürütür
              spacing: 6, // spacing özelliğini yapılandırır
              runSpacing: 6, // runSpacing özelliğini yapılandırır
              children: slots.map((slot) { // children özelliğini yapılandırır
                final member = memberByPosition[slot.key]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                final isTargetSlot = slot.key == invitation.position; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                final text = member != null && member.displayName.isNotEmpty // Sabit/final değişken veya nesne tanımını başlatır
                    ? member.displayName // İlgili kod satırını ve işlemi yürütür
                    : (isTargetSlot && invitation.isPending // İlgili kod satırını ve işlemi yürütür
                        ? 'Sizin İçin Ayrıldı' // İlgili kod satırını ve işlemi yürütür
                        : 'Boş'); // İlgili kod satırını ve işlemi yürütür

                return Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                  padding: // İlgili kod satırını ve işlemi yürütür
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Sabit/final değişken veya nesne tanımını başlatır
                  decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                    color: isTargetSlot // İlgili kod satırını ve işlemi yürütür
                        ? AppColors.pitchGreen.withValues(alpha: 0.18) // İlgili kod satırını ve işlemi yürütür
                        : theme.colorScheme.surfaceContainerHighest // İlgili kod satırını ve işlemi yürütür
                            .withValues(alpha: 0.55), // .withValues(alpha özelliğini yapılandırır
                    borderRadius: BorderRadius.circular(8), // borderRadius özelliğini yapılandırır
                    border: Border.all( // İlgili kod satırını ve işlemi yürütür
                      color: isTargetSlot // İlgili kod satırını ve işlemi yürütür
                          ? AppColors.pitchGreen // İlgili kod satırını ve işlemi yürütür
                          : Colors.transparent, //  özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  child: Text( // Ekrana metin bileşeni yazdırır
                    '${slot.label}: $text', // '${slot.label} özelliğini yapılandırır
                    style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                      fontSize: 11, // fontSize özelliğini yapılandırır
                      fontWeight: // İlgili kod satırını ve işlemi yürütür
                          isTargetSlot ? FontWeight.w800 : FontWeight.w600, // isTargetSlot ? FontWeight.w800 özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ); // Açık olan kod/bileşen bloğunu kapatır
              }).toList(), // İlgili kod satırını ve işlemi yürütür
            ), // Açık olan kod/bileşen bloğunu kapatır
            if (invitation.isPending && // Koşulun sağlanıp sağlanmadığını kontrol eder
                onAccept != null && // İlgili kod satırını ve işlemi yürütür
                onReject != null) ...[ // İlgili kod satırını ve işlemi yürütür
              const SizedBox(height: 14), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
              Row( // Alt bileşenleri yatay eksende yan yana dizer
                children: [ // İlgili kod satırını ve işlemi yürütür
                  Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                    child: OutlinedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                      key: Key('reject_invite_btn_${invitation.id}'), // key özelliğini yapılandırır
                      style: OutlinedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
                        foregroundColor: AppColors.error, // foregroundColor özelliğini yapılandırır
                        side: const BorderSide(color: AppColors.error), // side özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      onPressed: onReject, // onPressed özelliğini yapılandırır
                      icon: const Icon(Icons.close_rounded, size: 18), // Ekranda vektörel ikon gösterir
                      label: const Text('Reddet'), // Ekrana metin bileşeni yazdırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(width: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                    child: ElevatedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                      key: Key('accept_invite_btn_${invitation.id}'), // key özelliğini yapılandırır
                      style: ElevatedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
                        backgroundColor: AppColors.success, // backgroundColor özelliğini yapılandırır
                        foregroundColor: Colors.white, // foregroundColor özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      onPressed: onAccept, // onPressed özelliğini yapılandırır
                      icon: const Icon(Icons.check_rounded, size: 18), // Ekranda vektörel ikon gösterir
                      label: const Text('Kabul Et'), // Ekrana metin bileşeni yazdırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class _DetailLine extends StatelessWidget { // Durumsuz (Stateless) _DetailLine görsel bileşenini tanımlar
  final String label; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String value; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const _DetailLine({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.label, // label parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.value, // value parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
      padding: const EdgeInsets.symmetric(vertical: 2.5), // padding özelliğini yapılandırır
      child: Row( // Alt bileşenleri yatay eksende yan yana dizer
        children: [ // İlgili kod satırını ve işlemi yürütür
          SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            width: 96, // width özelliğini yapılandırır
            child: Text( // Ekrana metin bileşeni yazdırır
              label, // İlgili kod satırını ve işlemi yürütür
              style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
            child: Text( // Ekrana metin bileşeni yazdırır
              value, // İlgili kod satırını ve işlemi yürütür
              style: theme.textTheme.bodyMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

