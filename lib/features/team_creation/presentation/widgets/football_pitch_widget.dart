import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../../shared/models/formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../../shared/widgets/player_position_button.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class FootballPitchWidget extends StatelessWidget { // Durumsuz (Stateless) FootballPitchWidget görsel bileşenini tanımlar
  final Formation formation; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Map<String, String> lineup; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String captainPositionKey; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final void Function(PlayerPositionSlot slot) onPositionTap; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const FootballPitchWidget({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.formation, // formation parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.lineup, // lineup parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.captainPositionKey, // captainPositionKey parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.onPositionTap, // onPositionTap parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final slots = formation.positions; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final forwards = // Sabit/final değişken veya nesne tanımını başlatır
        slots.where((s) => s.line == PositionLine.forward).toList(); // İlgili kod satırını ve işlemi yürütür
    final midfielders = // Sabit/final değişken veya nesne tanımını başlatır
        slots.where((s) => s.line == PositionLine.midfielder).toList(); // İlgili kod satırını ve işlemi yürütür
    final defenders = // Sabit/final değişken veya nesne tanımını başlatır
        slots.where((s) => s.line == PositionLine.defender).toList(); // İlgili kod satırını ve işlemi yürütür
    final goalkeepers = // Sabit/final değişken veya nesne tanımını başlatır
        slots.where((s) => s.line == PositionLine.goalkeeper).toList(); // İlgili kod satırını ve işlemi yürütür

    return AspectRatio( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      aspectRatio: 0.76, // aspectRatio özelliğini yapılandırır
      child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
        decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
          borderRadius: BorderRadius.circular(20), // borderRadius özelliğini yapılandırır
          border: Border.all( // İlgili kod satırını ve işlemi yürütür
            color: Colors.white.withValues(alpha: 0.85), // color özelliğini yapılandırır
            width: 2.5, // width özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          boxShadow: [ // İlgili kod satırını ve işlemi yürütür
            BoxShadow( // İlgili kod satırını ve işlemi yürütür
              color: AppColors.primaryDarkGreen.withValues(alpha: 0.35), // color özelliğini yapılandırır
              blurRadius: 16, // blurRadius özelliğini yapılandırır
              offset: const Offset(0, 6), // offset özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
        clipBehavior: Clip.antiAlias, // clipBehavior özelliğini yapılandırır
        child: Stack( // Alt bileşenleri üst üste katmanlar halinde yerleştirir
          fit: StackFit.expand, // fit özelliğini yapılandırır
          children: [ // İlgili kod satırını ve işlemi yürütür
            // Saha çim çizgileri ve saha çizgileri
            CustomPaint( // İlgili kod satırını ve işlemi yürütür
              painter: _PitchMarkingsPainter(), // painter özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            // Mevki Satırları: Üstte Forvet -> Orta Saha -> Defans -> Altta Kaleci
            Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14), // padding özelliğini yapılandırır
              child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // mainAxisAlignment özelliğini yapılandırır
                children: [ // İlgili kod satırını ve işlemi yürütür
                  _buildLineRow(forwards), // Alt bileşenleri yatay eksende yan yana dizer
                  if (midfielders.isNotEmpty) // Koşulun sağlanıp sağlanmadığını kontrol eder
                    _buildLineRow(midfielders) // Alt bileşenleri yatay eksende yan yana dizer
                  else // İlgili kod satırını ve işlemi yürütür
                    const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  _buildLineRow(defenders), // Alt bileşenleri yatay eksende yan yana dizer
                  _buildLineRow(goalkeepers), // Alt bileşenleri yatay eksende yan yana dizer
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Widget _buildLineRow(List<PlayerPositionSlot> rowSlots) { // Alt bileşenleri yatay eksende yan yana dizer
    return Row( // Alt bileşenleri yatay eksende yan yana dizer
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // mainAxisAlignment özelliğini yapılandırır
      children: rowSlots.map((slot) { // children özelliğini yapılandırır
        return Flexible( // İçeriğin taşmasını önlemek için esnek boyutlandırma sağlar
          child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
            padding: const EdgeInsets.symmetric(horizontal: 3), // padding özelliğini yapılandırır
            child: PlayerPositionButton( // İlgili kod satırını ve işlemi yürütür
              key: Key('pitch_pos_${slot.key}'), // key özelliğini yapılandırır
              slot: slot, // slot özelliğini yapılandırır
              playerName: lineup[slot.key], // playerName özelliğini yapılandırır
              isCaptain: slot.key == captainPositionKey, // isCaptain özelliğini yapılandırır
              onTap: () => onPositionTap(slot), // onTap özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }).toList(), // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class _PitchMarkingsPainter extends CustomPainter { // Tuval (Canvas) üzerine özel çizim yapan _PitchMarkingsPainter sınıfını tanımlar
  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  void paint(Canvas canvas, Size size) { // İlgili kod satırını ve işlemi yürütür
    // Çim şeritleri
    const stripeCount = 8; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final stripeHeight = size.height / stripeCount; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (var i = 0; i < stripeCount; i++) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final paint = Paint() // Sabit/final değişken veya nesne tanımını başlatır
        ..color = i.isEven ? AppColors.pitchGrassDark : AppColors.pitchGrassLight; // İlgili kod satırını ve işlemi yürütür
      canvas.drawRect( // İlgili kod satırını ve işlemi yürütür
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight), // İlgili kod satırını ve işlemi yürütür
        paint, // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final linePaint = Paint() // Sabit/final değişken veya nesne tanımını başlatır
      ..color = Colors.white.withValues(alpha: 0.65) // İlgili kod satırını ve işlemi yürütür
      ..style = PaintingStyle.stroke // İlgili kod satırını ve işlemi yürütür
      ..strokeWidth = 2.0; // İlgili kod satırını ve işlemi yürütür

    // Dış saha çerçevesi
    final outerRect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    canvas.drawRect(outerRect, linePaint); // İlgili kod satırını ve işlemi yürütür

    // Orta çizgi ve orta yuvarlak
    final midY = size.height / 2; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    canvas.drawLine( // İlgili kod satırını ve işlemi yürütür
      Offset(10, midY), // İlgili kod satırını ve işlemi yürütür
      Offset(size.width - 10, midY), // İlgili kod satırını ve işlemi yürütür
      linePaint, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır
    canvas.drawCircle(Offset(size.width / 2, midY), size.width * 0.14, linePaint); // İlgili kod satırını ve işlemi yürütür

    final spotPaint = Paint() // Sabit/final değişken veya nesne tanımını başlatır
      ..color = Colors.white.withValues(alpha: 0.8) // İlgili kod satırını ve işlemi yürütür
      ..style = PaintingStyle.fill; // İlgili kod satırını ve işlemi yürütür
    canvas.drawCircle(Offset(size.width / 2, midY), 3.5, spotPaint); // İlgili kod satırını ve işlemi yürütür

    // Üst ceza sahası (Hücum bölgesi)
    final penaltyWidth = size.width * 0.54; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final penaltyHeight = size.height * 0.14; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final penaltyLeft = (size.width - penaltyWidth) / 2; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    canvas.drawRect( // İlgili kod satırını ve işlemi yürütür
      Rect.fromLTWH(penaltyLeft, 10, penaltyWidth, penaltyHeight), // İlgili kod satırını ve işlemi yürütür
      linePaint, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır

    // Alt ceza sahası (Kaleci bölgesi)
    canvas.drawRect( // İlgili kod satırını ve işlemi yürütür
      Rect.fromLTWH( // İlgili kod satırını ve işlemi yürütür
        penaltyLeft, // İlgili kod satırını ve işlemi yürütür
        size.height - 10 - penaltyHeight, // İlgili kod satırını ve işlemi yürütür
        penaltyWidth, // İlgili kod satırını ve işlemi yürütür
        penaltyHeight, // İlgili kod satırını ve işlemi yürütür
      ), // Açık olan kod/bileşen bloğunu kapatır
      linePaint, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır

    // Alt ve üst kale çizgileri
    final goalWidth = size.width * 0.28; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final goalHeight = size.height * 0.055; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final goalLeft = (size.width - goalWidth) / 2; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    canvas.drawRect( // İlgili kod satırını ve işlemi yürütür
      Rect.fromLTWH(goalLeft, 10, goalWidth, goalHeight), // İlgili kod satırını ve işlemi yürütür
      linePaint, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır
    canvas.drawRect( // İlgili kod satırını ve işlemi yürütür
      Rect.fromLTWH( // İlgili kod satırını ve işlemi yürütür
        goalLeft, // İlgili kod satırını ve işlemi yürütür
        size.height - 10 - goalHeight, // İlgili kod satırını ve işlemi yürütür
        goalWidth, // İlgili kod satırını ve işlemi yürütür
        goalHeight, // İlgili kod satırını ve işlemi yürütür
      ), // Açık olan kod/bileşen bloğunu kapatır
      linePaint, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

