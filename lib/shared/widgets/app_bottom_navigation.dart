import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır

class AppBottomNavigationShell extends StatelessWidget { // Durumsuz (Stateless) AppBottomNavigationShell görsel bileşenini tanımlar
  final StatefulNavigationShell navigationShell; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const AppBottomNavigationShell({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.navigationShell, // navigationShell parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  void _onDestinationSelected(int index) { // İlgili kod satırını ve işlemi yürütür
    navigationShell.goBranch( // İlgili kod satırını ve işlemi yürütür
      index, // İlgili kod satırını ve işlemi yürütür
      initialLocation: index == navigationShell.currentIndex, // initialLocation özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      body: navigationShell, // body özelliğini yapılandırır
      bottomNavigationBar: NavigationBar( // Uygulamanın alt gezinme çubuğunu (4 ana sekme) oluşturur
        selectedIndex: navigationShell.currentIndex, // selectedIndex özelliğini yapılandırır
        onDestinationSelected: _onDestinationSelected, // onDestinationSelected özelliğini yapılandırır
        destinations: const [ // İlgili kod satırını ve işlemi yürütür
          NavigationDestination( // Alt gezinme çubuğundaki sekme öğesini tanımlar
            icon: Icon(Icons.sports_soccer_outlined), // Ekranda vektörel ikon gösterir
            selectedIcon: Icon(Icons.sports_soccer), // Ekranda vektörel ikon gösterir
            label: 'Takım Kur', // label özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          NavigationDestination( // Alt gezinme çubuğundaki sekme öğesini tanımlar
            icon: Icon(Icons.calendar_month_outlined), // Ekranda vektörel ikon gösterir
            selectedIcon: Icon(Icons.calendar_month), // Ekranda vektörel ikon gösterir
            label: 'Randevularım', // label özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          NavigationDestination( // Alt gezinme çubuğundaki sekme öğesini tanımlar
            icon: Icon(Icons.person_outline_rounded), // Ekranda vektörel ikon gösterir
            selectedIcon: Icon(Icons.person_rounded), // Ekranda vektörel ikon gösterir
            label: 'Profil', // label özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          NavigationDestination( // Alt gezinme çubuğundaki sekme öğesini tanımlar
            icon: Icon(Icons.forum_outlined), // Ekranda vektörel ikon gösterir
            selectedIcon: Icon(Icons.forum_rounded), // Ekranda vektörel ikon gösterir
            label: 'Sohbet', // label özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

