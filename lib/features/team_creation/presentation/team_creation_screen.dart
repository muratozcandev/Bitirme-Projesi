import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/constants/app_constants.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/notification_icon.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'widgets/football_pitch_widget.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class TeamCreationScreen extends ConsumerStatefulWidget { // Riverpod destekli durum bilgili (Stateful) TeamCreationScreen ekran bileşenini tanımlar
  const TeamCreationScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  ConsumerState<TeamCreationScreen> createState() => _TeamCreationScreenState(); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

class _TeamCreationScreenState extends ConsumerState<TeamCreationScreen> { // _TeamCreationScreenState ekranının Riverpod destekli durum (State) sınıfını tanımlar
  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  void initState() { // İlgili kod satırını ve işlemi yürütür
    super.initState(); // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    WidgetsBinding.instance.addPostFrameCallback((_) { // İlgili kod satırını ve işlemi yürütür
      final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      final formState = ref.read(teamCreationProvider); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      if (user != null && formState.lineup.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        ref.read(teamCreationProvider.notifier).resetForUser(user.fullName); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      } // Açık olan kod/bileşen bloğunu kapatır
    }); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _showSearchablePicker({ // İlgili kod satırını ve işlemi yürütür
    required String title, // İlgili kod satırını ve işlemi yürütür
    required List<String> items, // İlgili kod satırını ve işlemi yürütür
    required String? selectedValue, // İlgili kod satırını ve işlemi yürütür
    required void Function(String) onSelected, // İlgili kod satırını ve işlemi yürütür
    String? subtitleBanner, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final searchController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    await showModalBottomSheet<void>( // Ekranın altından açılan seçim penceresini (BottomSheet) gösterir
      context: context, // context özelliğini yapılandırır
      isScrollControlled: true, // isScrollControlled özelliğini yapılandırır
      useSafeArea: true, // useSafeArea özelliğini yapılandırır
      shape: const RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)), // borderRadius özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      builder: (ctx) { // builder özelliğini yapılandırır
        return StatefulBuilder( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          builder: (ctx, setModalState) { // builder özelliğini yapılandırır
            final query = searchController.text.trim().toLowerCase(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
            final filtered = query.isEmpty // Sabit/final değişken veya nesne tanımını başlatır
                ? items // İlgili kod satırını ve işlemi yürütür
                : items // İlgili kod satırını ve işlemi yürütür
                    .where((item) => item.toLowerCase().contains(query)) // İlgili kod satırını ve işlemi yürütür
                    .toList(); // İlgili kod satırını ve işlemi yürütür

            return DraggableScrollableSheet( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
              expand: false, // expand özelliğini yapılandırır
              initialChildSize: 0.72, // initialChildSize özelliğini yapılandırır
              minChildSize: 0.45, // minChildSize özelliğini yapılandırır
              maxChildSize: 0.92, // maxChildSize özelliğini yapılandırır
              builder: (_, scrollController) { // builder özelliğini yapılandırır
                return Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), // padding özelliğini yapılandırır
                  child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                    crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
                        child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                          width: 42, // width özelliğini yapılandırır
                          height: 4, // height özelliğini yapılandırır
                          decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                            color: Colors.grey.withValues(alpha: 0.4), // color özelliğini yapılandırır
                            borderRadius: BorderRadius.circular(4), // borderRadius özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Text( // Ekrana metin bileşeni yazdırır
                        title, // İlgili kod satırını ve işlemi yürütür
                        style: Theme.of(ctx).textTheme.titleLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                              fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      if (subtitleBanner != null) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
                        const SizedBox(height: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                        Text( // Ekrana metin bileşeni yazdırır
                          subtitleBanner, // İlgili kod satırını ve işlemi yürütür
                          style: Theme.of(ctx).textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                color: Theme.of(ctx).colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ], // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      TextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                        controller: searchController, // controller özelliğini yapılandırır
                        decoration: InputDecoration( // İlgili kod satırını ve işlemi yürütür
                          hintText: '$title içinde ara...', // hintText özelliğini yapılandırır
                          prefixIcon: const Icon(Icons.search), // Ekranda vektörel ikon gösterir
                          suffixIcon: searchController.text.isNotEmpty // İlgili kod satırını ve işlemi yürütür
                              ? IconButton( // Tıklanabilir aksiyon butonunu oluşturur
                                  icon: const Icon(Icons.clear), // Ekranda vektörel ikon gösterir
                                  onPressed: () { // onPressed özelliğini yapılandırır
                                    searchController.clear(); // İlgili kod satırını ve işlemi yürütür
                                    setModalState(() {}); // İlgili kod satırını ve işlemi yürütür
                                  }, // Açık olan kod/bileşen bloğunu kapatır
                                ) // İlgili kod satırını ve işlemi yürütür
                              : null, //  özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                        onChanged: (_) => setModalState(() {}), // onChanged özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(height: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: filtered.isEmpty // İlgili kod satırını ve işlemi yürütür
                            ? const Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
                                child: Text('Sonuç bulunamadı.'), // Ekrana metin bileşeni yazdırır
                              ) // İlgili kod satırını ve işlemi yürütür
                            : ListView.separated( // Kaydırılabilir liste görünümü oluşturur
                                controller: scrollController, // controller özelliğini yapılandırır
                                itemCount: filtered.length, // itemCount özelliğini yapılandırır
                                separatorBuilder: (_, _) => // İlgili kod satırını ve işlemi yürütür
                                    const Divider(height: 1), // Sabit/final değişken veya nesne tanımını başlatır
                                itemBuilder: (_, index) { // itemBuilder özelliğini yapılandırır
                                  final item = filtered[index]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                                  final isSelected = item == selectedValue; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                                  return ListTile( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                                    title: Text( // Ekrana metin bileşeni yazdırır
                                      item, // İlgili kod satırını ve işlemi yürütür
                                      style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                        fontWeight: isSelected // İlgili kod satırını ve işlemi yürütür
                                            ? FontWeight.w800 // İlgili kod satırını ve işlemi yürütür
                                            : FontWeight.w500, //  özelliğini yapılandırır
                                      ), // Açık olan kod/bileşen bloğunu kapatır
                                    ), // Açık olan kod/bileşen bloğunu kapatır
                                    trailing: isSelected // İlgili kod satırını ve işlemi yürütür
                                        ? const Icon( // Ekranda vektörel ikon gösterir
                                            Icons.check_circle, // İlgili kod satırını ve işlemi yürütür
                                            color: AppColors.pitchGreen, // color özelliğini yapılandırır
                                          ) // İlgili kod satırını ve işlemi yürütür
                                        : null, //  özelliğini yapılandırır
                                    onTap: () { // onTap özelliğini yapılandırır
                                      onSelected(item); // İlgili kod satırını ve işlemi yürütür
                                      Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                                    }, // Açık olan kod/bileşen bloğunu kapatır
                                  ); // Açık olan kod/bileşen bloğunu kapatır
                                }, // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ); // Açık olan kod/bileşen bloğunu kapatır
              }, // Açık olan kod/bileşen bloğunu kapatır
            ); // Açık olan kod/bileşen bloğunu kapatır
          }, // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleProvinceSelect() async { // İlgili kod satırını ve işlemi yürütür
    final provinces = await ref.read(provincesProvider.future); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final current = ref.read(teamCreationProvider).selectedProvince; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    await _showSearchablePicker( // Asenkron işlemin tamamlanmasını bekler
      title: 'İl Seçimi (81 İl)', // title özelliğini yapılandırır
      items: provinces, // items özelliğini yapılandırır
      selectedValue: current, // selectedValue özelliğini yapılandırır
      onSelected: (val) { // onSelected özelliğini yapılandırır
        ref.read(teamCreationProvider.notifier).selectProvince(val); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleDistrictSelect() async { // İlgili kod satırını ve işlemi yürütür
    final province = ref.read(teamCreationProvider).selectedProvince; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (province == null || province.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text('İlçe seçebilmek için lütfen önce bir il seçiniz.'), // Ekrana metin bileşeni yazdırır
          backgroundColor: AppColors.warning, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    final districts = await ref.read(districtsProvider(province).future); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final current = ref.read(teamCreationProvider).selectedDistrict; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    await _showSearchablePicker( // Asenkron işlemin tamamlanmasını bekler
      title: '$province — İlçe Seçimi', // title özelliğini yapılandırır
      items: districts, // items özelliğini yapılandırır
      selectedValue: current, // selectedValue özelliğini yapılandırır
      onSelected: (val) { // onSelected özelliğini yapılandırır
        ref.read(teamCreationProvider.notifier).selectDistrict(val); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleVenueSelect() async { // İlgili kod satırını ve işlemi yürütür
    final form = ref.read(teamCreationProvider); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (form.selectedProvince == null || form.selectedDistrict == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: // İlgili kod satırını ve işlemi yürütür
              Text('Halı saha seçebilmek için önce il ve ilçe seçmelisiniz.'), // Ekrana metin bileşeni yazdırır
          backgroundColor: AppColors.warning, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    final venues = await ref.read( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      venuesProvider(( // İlgili kod satırını ve işlemi yürütür
        province: form.selectedProvince!, // province özelliğini yapılandırır
        district: form.selectedDistrict!, // district özelliğini yapılandırır
      )).future, // İlgili kod satırını ve işlemi yürütür
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    await _showSearchablePicker( // Asenkron işlemin tamamlanmasını bekler
      title: '${form.selectedDistrict} Halı Sahaları', // title özelliğini yapılandırır
      subtitleBanner: // İlgili kod satırını ve işlemi yürütür
          'Not: Listelenen halı saha isimleri test verisidir; gerçek işletme rezervasyonu değildir.', // 'Not özelliğini yapılandırır
      items: venues, // items özelliğini yapılandırır
      selectedValue: form.selectedVenue, // selectedValue özelliğini yapılandırır
      onSelected: (val) { // onSelected özelliğini yapılandırır
        ref.read(teamCreationProvider.notifier).selectVenue(val); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleDateSelect() async { // İlgili kod satırını ve işlemi yürütür
    final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final today = DateTime(now.year, now.month, now.day); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final current = ref.read(teamCreationProvider).selectedDate ?? today; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur

    final picked = await showDatePicker( // Kullanıcının maç tarihi seçmesi için takvim penceresini açar
      context: context, // context özelliğini yapılandırır
      initialDate: current.isBefore(today) ? today : current, // initialDate özelliğini yapılandırır
      firstDate: today, // firstDate özelliğini yapılandırır
      lastDate: DateTime(today.year + 5, 12, 31), // lastDate özelliğini yapılandırır
      helpText: 'Maç Tarihini Seçiniz (Geçmiş tarihler seçilemez)', // helpText özelliğini yapılandırır
      cancelText: 'İptal', // cancelText özelliğini yapılandırır
      confirmText: 'Seç', // confirmText özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    if (picked != null && mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ref.read(teamCreationProvider.notifier).selectDate(picked); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleTimeSelect() async { // İlgili kod satırını ve işlemi yürütür
    final slots = AppConstants.timeSlots; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final current = ref.read(teamCreationProvider).selectedTimeSlot; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur

    await showModalBottomSheet<void>( // Ekranın altından açılan seçim penceresini (BottomSheet) gösterir
      context: context, // context özelliğini yapılandırır
      isScrollControlled: true, // isScrollControlled özelliğini yapılandırır
      useSafeArea: true, // useSafeArea özelliğini yapılandırır
      shape: const RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)), // borderRadius özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      builder: (ctx) { // builder özelliğini yapılandırır
        return DraggableScrollableSheet( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          expand: false, // expand özelliğini yapılandırır
          initialChildSize: 0.68, // initialChildSize özelliğini yapılandırır
          minChildSize: 0.45, // minChildSize özelliğini yapılandırır
          maxChildSize: 0.9, // maxChildSize özelliğini yapılandırır
          builder: (_, scrollController) { // builder özelliğini yapılandırır
            return Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), // padding özelliğini yapılandırır
              child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                children: [ // İlgili kod satırını ve işlemi yürütür
                  Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
                    child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                      width: 42, // width özelliğini yapılandırır
                      height: 4, // height özelliğini yapılandırır
                      decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                        color: Colors.grey.withValues(alpha: 0.4), // color özelliğini yapılandırır
                        borderRadius: BorderRadius.circular(4), // borderRadius özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  Text( // Ekrana metin bileşeni yazdırır
                    'Maç Saati Seçimi (24 Saat / 1 Saatlik Aralıklar)', // İlgili kod satırını ve işlemi yürütür
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                          fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                    child: GridView.builder( // İlgili kod satırını ve işlemi yürütür
                      controller: scrollController, // controller özelliğini yapılandırır
                      gridDelegate: // İlgili kod satırını ve işlemi yürütür
                          const SliverGridDelegateWithFixedCrossAxisCount( // Sabit/final değişken veya nesne tanımını başlatır
                        crossAxisCount: 2, // crossAxisCount özelliğini yapılandırır
                        mainAxisSpacing: 8, // mainAxisSpacing özelliğini yapılandırır
                        crossAxisSpacing: 8, // crossAxisSpacing özelliğini yapılandırır
                        childAspectRatio: 3.1, // childAspectRatio özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      itemCount: slots.length, // itemCount özelliğini yapılandırır
                      itemBuilder: (_, index) { // itemBuilder özelliğini yapılandırır
                        final slot = slots[index]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                        final isSelected = slot == current; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                        return InkWell( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                          onTap: () { // onTap özelliğini yapılandırır
                            ref // İlgili kod satırını ve işlemi yürütür
                                .read(teamCreationProvider.notifier) // İlgili kod satırını ve işlemi yürütür
                                .selectTimeSlot(slot); // İlgili kod satırını ve işlemi yürütür
                            Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                          }, // Açık olan kod/bileşen bloğunu kapatır
                          borderRadius: BorderRadius.circular(12), // borderRadius özelliğini yapılandırır
                          child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                            alignment: Alignment.center, // alignment özelliğini yapılandırır
                            decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                              color: isSelected // İlgili kod satırını ve işlemi yürütür
                                  ? AppColors.primaryDarkGreen // İlgili kod satırını ve işlemi yürütür
                                  : Theme.of(ctx) // İlgili kod satırını ve işlemi yürütür
                                      .colorScheme // İlgili kod satırını ve işlemi yürütür
                                      .surfaceContainerHighest, // İlgili kod satırını ve işlemi yürütür
                              borderRadius: BorderRadius.circular(12), // borderRadius özelliğini yapılandırır
                              border: Border.all( // İlgili kod satırını ve işlemi yürütür
                                color: isSelected // İlgili kod satırını ve işlemi yürütür
                                    ? AppColors.pitchGreen // İlgili kod satırını ve işlemi yürütür
                                    : Colors.transparent, //  özelliğini yapılandırır
                                width: 1.8, // width özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            child: Text( // Ekrana metin bileşeni yazdırır
                              slot, // İlgili kod satırını ve işlemi yürütür
                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                                color: isSelected // İlgili kod satırını ve işlemi yürütür
                                    ? Colors.white // İlgili kod satırını ve işlemi yürütür
                                    : Theme.of(ctx).colorScheme.onSurface, //  özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      }, // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ); // Açık olan kod/bileşen bloğunu kapatır
          }, // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleFormationSelect() async { // İlgili kod satırını ve işlemi yürütür
    final current = ref.read(teamCreationProvider).selectedFormation; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    await showModalBottomSheet<void>( // Ekranın altından açılan seçim penceresini (BottomSheet) gösterir
      context: context, // context özelliğini yapılandırır
      isScrollControlled: true, // isScrollControlled özelliğini yapılandırır
      useSafeArea: true, // useSafeArea özelliğini yapılandırır
      shape: const RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)), // borderRadius özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      builder: (ctx) { // builder özelliğini yapılandırır
        return SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
          child: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18), // padding özelliğini yapılandırır
            child: Column( // Alt bileşenleri dikey eksende alt alta dizer
              mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
              crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
              children: [ // İlgili kod satırını ve işlemi yürütür
                Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
                  child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                    width: 42, // width özelliğini yapılandırır
                    height: 4, // height özelliğini yapılandırır
                    margin: const EdgeInsets.only(bottom: 12), // margin özelliğini yapılandırır
                    decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                      color: Colors.grey.withValues(alpha: 0.4), // color özelliğini yapılandırır
                      borderRadius: BorderRadius.circular(4), // borderRadius özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                Text( // Ekrana metin bileşeni yazdırır
                  '7v7 Saha Dizilişi Seçiniz', // İlgili kod satırını ve işlemi yürütür
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                        fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                Text( // Ekrana metin bileşeni yazdırır
                  'Her dizilişte Kaleci (1) sabittir ve toplam 7 oyuncu bulunur.', // İlgili kod satırını ve işlemi yürütür
                  style: Theme.of(ctx).textTheme.bodySmall, // style özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                ...Formation.values.map((f) { // İlgili kod satırını ve işlemi yürütür
                  final isSelected = f == current; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                  return ListTile( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                    key: Key('formation_option_${f.label}'), // key özelliğini yapılandırır
                    shape: RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
                      borderRadius: BorderRadius.circular(12), // borderRadius özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    leading: CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                      backgroundColor: isSelected // İlgili kod satırını ve işlemi yürütür
                          ? AppColors.pitchGreen // İlgili kod satırını ve işlemi yürütür
                          : AppColors.primaryDarkGreen, //  özelliğini yapılandırır
                      child: const Icon( // Ekranda vektörel ikon gösterir
                        Icons.grid_view_rounded, // İlgili kod satırını ve işlemi yürütür
                        color: Colors.white, // color özelliğini yapılandırır
                        size: 18, // size özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    title: Text( // Ekrana metin bileşeni yazdırır
                      '${f.label} Dizilişi', // İlgili kod satırını ve işlemi yürütür
                      style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                        fontWeight: // İlgili kod satırını ve işlemi yürütür
                            isSelected ? FontWeight.w800 : FontWeight.w600, // isSelected ? FontWeight.w800 özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    subtitle: Text( // Ekrana metin bileşeni yazdırır
                      '1 Kaleci • ${f.defenderCount} Defans • ${f.midfielderCount} Orta Saha • ${f.forwardCount} Forvet', // İlgili kod satırını ve işlemi yürütür
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    trailing: isSelected // İlgili kod satırını ve işlemi yürütür
                        ? const Icon( // Ekranda vektörel ikon gösterir
                            Icons.check_circle, // İlgili kod satırını ve işlemi yürütür
                            color: AppColors.pitchGreen, // color özelliğini yapılandırır
                          ) // İlgili kod satırını ve işlemi yürütür
                        : null, //  özelliğini yapılandırır
                    onTap: () { // onTap özelliğini yapılandırır
                      ref // İlgili kod satırını ve işlemi yürütür
                          .read(teamCreationProvider.notifier) // İlgili kod satırını ve işlemi yürütür
                          .selectFormation(f); // İlgili kod satırını ve işlemi yürütür
                      Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                    }, // Açık olan kod/bileşen bloğunu kapatır
                  ); // Açık olan kod/bileşen bloğunu kapatır
                }), // İlgili kod satırını ve işlemi yürütür
              ], // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handlePositionTap(PlayerPositionSlot slot) async { // İlgili kod satırını ve işlemi yürütür
    final form = ref.read(teamCreationProvider); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    final currentName = form.lineup[slot.key] ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final controller = TextEditingController(text: currentName); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final isCaptainSlot = form.captainPositionKey == slot.key; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    await showDialog<void>( // Asenkron işlemin tamamlanmasını bekler
      context: context, // context özelliğini yapılandırır
      builder: (ctx) { // builder özelliğini yapılandırır
        return AlertDialog( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          title: Text('${slot.label} Oyuncu Bilgisi'), // Ekrana metin bileşeni yazdırır
          content: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
            child: Column( // Alt bileşenleri dikey eksende alt alta dizer
              mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
              crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
              children: [ // İlgili kod satırını ve işlemi yürütür
                const Text( // Ekrana metin bileşeni yazdırır
                  'Sadece ad veya ad-soyad yazabilirsiniz. Boş bırakırsanız daha sonra oyuncu davet edebilirsiniz.', // İlgili kod satırını ve işlemi yürütür
                  style: TextStyle(fontSize: 13), // style özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                TextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                  key: const Key('player_name_dialog_input'), // key özelliğini yapılandırır
                  controller: controller, // controller özelliğini yapılandırır
                  autofocus: true, // autofocus özelliğini yapılandırır
                  decoration: InputDecoration( // İlgili kod satırını ve işlemi yürütür
                    labelText: '${slot.label} Oyuncu Adı', // labelText özelliğini yapılandırır
                    hintText: 'Örn: Cristiano Ronaldo', // hintText özelliğini yapılandırır
                    prefixIcon: const Icon(Icons.person_outline), // Ekranda vektörel ikon gösterir
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                if (user != null && !isCaptainSlot) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
                  const SizedBox(height: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  OutlinedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                    onPressed: () { // onPressed özelliğini yapılandırır
                      ref // İlgili kod satırını ve işlemi yürütür
                          .read(teamCreationProvider.notifier) // İlgili kod satırını ve işlemi yürütür
                          .setCaptainPosition(slot.key, user.fullName); // İlgili kod satırını ve işlemi yürütür
                      Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                    }, // Açık olan kod/bileşen bloğunu kapatır
                    icon: const Icon(Icons.star_outline_rounded), // Ekranda vektörel ikon gösterir
                    label: Text('Kendimi (${user.fullName}) Bu Mevkiye Ata'), // Ekrana metin bileşeni yazdırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ], // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          actions: [ // İlgili kod satırını ve işlemi yürütür
            if (currentName.isNotEmpty && !isCaptainSlot) // Koşulun sağlanıp sağlanmadığını kontrol eder
              TextButton( // Tıklanabilir aksiyon butonunu oluşturur
                onPressed: () { // onPressed özelliğini yapılandırır
                  ref // İlgili kod satırını ve işlemi yürütür
                      .read(teamCreationProvider.notifier) // İlgili kod satırını ve işlemi yürütür
                      .setPlayerName(slot.key, ''); // İlgili kod satırını ve işlemi yürütür
                  Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
                }, // Açık olan kod/bileşen bloğunu kapatır
                child: const Text( // Ekrana metin bileşeni yazdırır
                  'Boşalt', // İlgili kod satırını ve işlemi yürütür
                  style: TextStyle(color: AppColors.error), // style özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            TextButton( // Tıklanabilir aksiyon butonunu oluşturur
              onPressed: () => Navigator.of(ctx).pop(), // onPressed özelliğini yapılandırır
              child: const Text('İptal'), // Ekrana metin bileşeni yazdırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            ElevatedButton( // Tıklanabilir aksiyon butonunu oluşturur
              key: const Key('player_name_dialog_save'), // key özelliğini yapılandırır
              onPressed: () { // onPressed özelliğini yapılandırır
                ref // İlgili kod satırını ve işlemi yürütür
                    .read(teamCreationProvider.notifier) // İlgili kod satırını ve işlemi yürütür
                    .setPlayerName(slot.key, controller.text); // İlgili kod satırını ve işlemi yürütür
                Navigator.of(ctx).pop(); // İlgili kod satırını ve işlemi yürütür
              }, // Açık olan kod/bileşen bloğunu kapatır
              child: const Text('Kaydet'), // Ekrana metin bileşeni yazdırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleSaveTeam() async { // İlgili kod satırını ve işlemi yürütür
    final form = ref.read(teamCreationProvider); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (user == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    if (!form.isReadyToSubmit) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            'Lütfen takım oluşturmadan önce İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçimlerini tamamlayınız.', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.warning, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    ref.read(teamCreationProvider.notifier).setSubmitting(true); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    try { // Hata yakalama (try) bloğunu başlatır
      final startTime = AppConstants.startTimeFromSlot(form.selectedTimeSlot!); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final endTime = AppConstants.endTimeFromSlot(form.selectedTimeSlot!); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      await ref.read(teamRepositoryProvider).createTeam( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
            captainId: user.id, // captainId özelliğini yapılandırır
            captainName: user.fullName, // captainName özelliğini yapılandırır
            formation: form.selectedFormation, // formation özelliğini yapılandırır
            province: form.selectedProvince!, // province özelliğini yapılandırır
            district: form.selectedDistrict!, // district özelliğini yapılandırır
            venueName: form.selectedVenue!, // venueName özelliğini yapılandırır
            matchDate: form.formattedDateKey, // matchDate özelliğini yapılandırır
            startTime: startTime, // startTime özelliğini yapılandırır
            endTime: endTime, // endTime özelliğini yapılandırır
            lineup: form.lineup, // lineup özelliğini yapılandırır
            captainPositionKey: form.captainPositionKey, // captainPositionKey özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır

      ref.read(teamCreationProvider.notifier).resetForUser(user.fullName); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür

      if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            '7v7 Takımınız ve maç randevunuz başarıyla oluşturuldu!', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.success, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      context.go('/appointments'); // Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      ref.read(teamCreationProvider.notifier).setSubmitting(false); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text(e.toString()), // Ekrana metin bileşeni yazdırır
          backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final form = ref.watch(teamCreationProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: Row( // Alt bileşenleri yatay eksende yan yana dizer
          children: [ // İlgili kod satırını ve işlemi yürütür
            ClipRRect( // İlgili kod satırını ve işlemi yürütür
              borderRadius: BorderRadius.circular(8), // borderRadius özelliğini yapılandırır
              child: Image.asset( // İlgili kod satırını ve işlemi yürütür
                'assets/images/logo.png', // İlgili kod satırını ve işlemi yürütür
                width: 30, // width özelliğini yapılandırır
                height: 30, // height özelliğini yapılandırır
                fit: BoxFit.cover, // fit özelliğini yapılandırır
                errorBuilder: (_, _, _) => // İlgili kod satırını ve işlemi yürütür
                    const Icon(Icons.sports_soccer, color: Colors.white), // Ekranda vektörel ikon gösterir
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(width: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            const Text('7v7 — Takım Kur'), // Ekrana metin bileşeni yazdırır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
        actions: const [ // İlgili kod satırını ve işlemi yürütür
          NotificationIcon(), // Ekranda vektörel ikon gösterir
          SizedBox(width: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 20), // padding özelliğini yapılandırır
          child: Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
            child: ConstrainedBox( // İlgili kod satırını ve işlemi yürütür
              constraints: const BoxConstraints(maxWidth: 600), // constraints özelliğini yapılandırır
              child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                children: [ // İlgili kod satırını ve işlemi yürütür
                  // Üst Bölüm: 5 Eşit Boyutlu Seçim Butonu (İl, İlçe, Halı Saha, Tarih, Saat)
                  Row( // Alt bileşenleri yatay eksende yan yana dizer
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: _SelectionTopButton( // İlgili kod satırını ve işlemi yürütür
                          key: const Key('btn_select_province'), // key özelliğini yapılandırır
                          icon: Icons.location_city_rounded, // icon özelliğini yapılandırır
                          title: 'İl', // title özelliğini yapılandırır
                          value: form.selectedProvince ?? 'Seçiniz', // value özelliğini yapılandırır
                          isSelected: form.selectedProvince != null, // isSelected özelliğini yapılandırır
                          onTap: _handleProvinceSelect, // onTap özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(width: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: _SelectionTopButton( // İlgili kod satırını ve işlemi yürütür
                          key: const Key('btn_select_district'), // key özelliğini yapılandırır
                          icon: Icons.map_outlined, // icon özelliğini yapılandırır
                          title: 'İlçe', // title özelliğini yapılandırır
                          value: form.selectedDistrict ?? 'Seçiniz', // value özelliğini yapılandırır
                          isSelected: form.selectedDistrict != null, // isSelected özelliğini yapılandırır
                          onTap: _handleDistrictSelect, // onTap özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(width: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: _SelectionTopButton( // İlgili kod satırını ve işlemi yürütür
                          key: const Key('btn_select_venue'), // key özelliğini yapılandırır
                          icon: Icons.stadium_outlined, // icon özelliğini yapılandırır
                          title: 'Halı Saha', // title özelliğini yapılandırır
                          value: form.selectedVenue ?? 'Seçiniz', // value özelliğini yapılandırır
                          isSelected: form.selectedVenue != null, // isSelected özelliğini yapılandırır
                          onTap: _handleVenueSelect, // onTap özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(width: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: _SelectionTopButton( // İlgili kod satırını ve işlemi yürütür
                          key: const Key('btn_select_date'), // key özelliğini yapılandırır
                          icon: Icons.calendar_today_rounded, // icon özelliğini yapılandırır
                          title: 'Tarih', // title özelliğini yapılandırır
                          value: form.selectedDate != null // İlgili kod satırını ve işlemi yürütür
                              ? form.formattedDateDisplay // İlgili kod satırını ve işlemi yürütür
                              : 'Seçiniz', //  özelliğini yapılandırır
                          isSelected: form.selectedDate != null, // isSelected özelliğini yapılandırır
                          onTap: _handleDateSelect, // onTap özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(width: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: _SelectionTopButton( // İlgili kod satırını ve işlemi yürütür
                          key: const Key('btn_select_time'), // key özelliğini yapılandırır
                          icon: Icons.schedule_rounded, // icon özelliğini yapılandırır
                          title: 'Saat', // title özelliğini yapılandırır
                          value: form.selectedTimeSlot ?? 'Seçiniz', // value özelliğini yapılandırır
                          isSelected: form.selectedTimeSlot != null, // isSelected özelliğini yapılandırır
                          onTap: _handleTimeSelect, // onTap özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

                  // Diziliş Seçim Butonu (Yatay ve Geniş) + Yeşil Tik İkonu
                  Row( // Alt bileşenleri yatay eksende yan yana dizer
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                        child: InkWell( // İlgili kod satırını ve işlemi yürütür
                          key: const Key('btn_select_formation'), // key özelliğini yapılandırır
                          onTap: _handleFormationSelect, // onTap özelliğini yapılandırır
                          borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
                          child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                            height: 54, // height özelliğini yapılandırır
                            padding: const EdgeInsets.symmetric(horizontal: 16), // padding özelliğini yapılandırır
                            decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                              color: theme.colorScheme.surface, // color özelliğini yapılandırır
                              borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
                              border: Border.all( // İlgili kod satırını ve işlemi yürütür
                                color: theme.colorScheme.primary // İlgili kod satırını ve işlemi yürütür
                                    .withValues(alpha: 0.45), // .withValues(alpha özelliğini yapılandırır
                                width: 1.5, // width özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            child: Row( // Alt bileşenleri yatay eksende yan yana dizer
                              children: [ // İlgili kod satırını ve işlemi yürütür
                                Icon( // Ekranda vektörel ikon gösterir
                                  Icons.grid_view_rounded, // İlgili kod satırını ve işlemi yürütür
                                  color: theme.colorScheme.primary, // color özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                const SizedBox(width: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                                  child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                                    mainAxisAlignment: MainAxisAlignment.center, // mainAxisAlignment özelliğini yapılandırır
                                    crossAxisAlignment: // İlgili kod satırını ve işlemi yürütür
                                        CrossAxisAlignment.start, // İlgili kod satırını ve işlemi yürütür
                                    children: [ // İlgili kod satırını ve işlemi yürütür
                                      Text( // Ekrana metin bileşeni yazdırır
                                        'Diziliş: ${form.selectedFormation.label}', // 'Diziliş özelliğini yapılandırır
                                        style: theme.textTheme.titleSmall // İlgili kod satırını ve işlemi yürütür
                                            ?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                          fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                                        ), // Açık olan kod/bileşen bloğunu kapatır
                                      ), // Açık olan kod/bileşen bloğunu kapatır
                                      Text( // Ekrana metin bileşeni yazdırır
                                        '1 Kaleci • ${form.selectedFormation.defenderCount} Defans • ${form.selectedFormation.midfielderCount} Orta Saha • ${form.selectedFormation.forwardCount} Forvet', // İlgili kod satırını ve işlemi yürütür
                                        maxLines: 1, // maxLines özelliğini yapılandırır
                                        overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
                                        style: // İlgili kod satırını ve işlemi yürütür
                                            theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                          fontSize: 11, // fontSize özelliğini yapılandırır
                                          color: theme // İlgili kod satırını ve işlemi yürütür
                                              .colorScheme.onSurfaceVariant, // İlgili kod satırını ve işlemi yürütür
                                        ), // Açık olan kod/bileşen bloğunu kapatır
                                      ), // Açık olan kod/bileşen bloğunu kapatır
                                    ], // Açık olan kod/bileşen bloğunu kapatır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                const Icon(Icons.keyboard_arrow_down_rounded), // Ekranda vektörel ikon gösterir
                              ], // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                      const SizedBox(width: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      // Yeşil Tik İkonu (Kaydetme Butonu)
                      Tooltip( // İlgili kod satırını ve işlemi yürütür
                        message: form.isReadyToSubmit // İlgili kod satırını ve işlemi yürütür
                            ? 'Takımı ve Randevuyu Kaydet' // İlgili kod satırını ve işlemi yürütür
                            : 'Önce İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçiniz', //  özelliğini yapılandırır
                        child: Material( // İlgili kod satırını ve işlemi yürütür
                          color: form.isReadyToSubmit // İlgili kod satırını ve işlemi yürütür
                              ? AppColors.success // İlgili kod satırını ve işlemi yürütür
                              : theme.colorScheme.surfaceContainerHighest, //  özelliğini yapılandırır
                          borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
                          child: InkWell( // İlgili kod satırını ve işlemi yürütür
                            key: const Key('btn_confirm_team_creation'), // key özelliğini yapılandırır
                            borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
                            onTap: _handleSaveTeam, // onTap özelliğini yapılandırır
                            child: SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                              width: 54, // width özelliğini yapılandırır
                              height: 54, // height özelliğini yapılandırır
                              child: form.isSubmitting // İlgili kod satırını ve işlemi yürütür
                                  ? const Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                                      padding: EdgeInsets.all(15), // padding özelliğini yapılandırır
                                      child: CircularProgressIndicator( // İşlem devam ederken dönen yükleme göstergesi çizer
                                        strokeWidth: 2.5, // strokeWidth özelliğini yapılandırır
                                        color: Colors.white, // color özelliğini yapılandırır
                                      ), // Açık olan kod/bileşen bloğunu kapatır
                                    ) // İlgili kod satırını ve işlemi yürütür
                                  : Icon( // Ekranda vektörel ikon gösterir
                                      Icons.check_circle_rounded, // İlgili kod satırını ve işlemi yürütür
                                      size: 30, // size özelliğini yapılandırır
                                      color: form.isReadyToSubmit // İlgili kod satırını ve işlemi yürütür
                                          ? Colors.white // İlgili kod satırını ve işlemi yürütür
                                          : theme.colorScheme.onSurfaceVariant // İlgili kod satırını ve işlemi yürütür
                                              .withValues(alpha: 0.45), // .withValues(alpha özelliğini yapılandırır
                                    ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

                  // Futbol Sahası Görünümü
                  FootballPitchWidget( // İlgili kod satırını ve işlemi yürütür
                    formation: form.selectedFormation, // formation özelliğini yapılandırır
                    lineup: form.lineup, // lineup özelliğini yapılandırır
                    captainPositionKey: form.captainPositionKey, // captainPositionKey özelliğini yapılandırır
                    onPositionTap: _handlePositionTap, // onPositionTap özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  Text( // Ekrana metin bileşeni yazdırır
                    'İpucu: Sahadaki mevki butonlarına dokunarak oyuncu adı girebilir veya boş bırakıp daha sonra Sohbet > Oyuncu Önerileri sekmesinden davet gönderebilirsiniz.', // 'İpucu özelliğini yapılandırır
                    textAlign: TextAlign.center, // textAlign özelliğini yapılandırır
                    style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                      color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class _SelectionTopButton extends StatelessWidget { // Durumsuz (Stateless) _SelectionTopButton görsel bileşenini tanımlar
  final IconData icon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String title; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String value; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isSelected; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback onTap; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const _SelectionTopButton({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.icon, // icon parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.title, // title parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.value, // value parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.isSelected, // isSelected parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.onTap, // onTap parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return InkWell( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      onTap: onTap, // onTap özelliğini yapılandırır
      borderRadius: BorderRadius.circular(12), // borderRadius özelliğini yapılandırır
      child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
        height: 76, // height özelliğini yapılandırır
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7), // padding özelliğini yapılandırır
        decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
          color: isSelected // İlgili kod satırını ve işlemi yürütür
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55) // İlgili kod satırını ve işlemi yürütür
              : theme.colorScheme.surface, //  özelliğini yapılandırır
          borderRadius: BorderRadius.circular(12), // borderRadius özelliğini yapılandırır
          border: Border.all( // İlgili kod satırını ve işlemi yürütür
            color: isSelected // İlgili kod satırını ve işlemi yürütür
                ? theme.colorScheme.primary // İlgili kod satırını ve işlemi yürütür
                : theme.colorScheme.outline.withValues(alpha: 0.5), //  özelliğini yapılandırır
            width: isSelected ? 1.6 : 1.0, // width özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          mainAxisAlignment: MainAxisAlignment.center, // mainAxisAlignment özelliğini yapılandırır
          children: [ // İlgili kod satırını ve işlemi yürütür
            Icon( // Ekranda vektörel ikon gösterir
              icon, // İlgili kod satırını ve işlemi yürütür
              size: 19, // size özelliğini yapılandırır
              color: isSelected // İlgili kod satırını ve işlemi yürütür
                  ? theme.colorScheme.primary // İlgili kod satırını ve işlemi yürütür
                  : theme.colorScheme.onSurfaceVariant, //  özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text( // Ekrana metin bileşeni yazdırır
              title, // İlgili kod satırını ve işlemi yürütür
              maxLines: 1, // maxLines özelliğini yapılandırır
              overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                fontSize: 10.5, // fontSize özelliğini yapılandırır
                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 2), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text( // Ekrana metin bileşeni yazdırır
              value, // İlgili kod satırını ve işlemi yürütür
              maxLines: 1, // maxLines özelliğini yapılandırır
              overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
              textAlign: TextAlign.center, // textAlign özelliğini yapılandırır
              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                fontSize: 11, // fontSize özelliğini yapılandırır
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, // fontWeight özelliğini yapılandırır
                color: isSelected // İlgili kod satırını ve işlemi yürütür
                    ? theme.colorScheme.onSurface // İlgili kod satırını ve işlemi yürütür
                    : theme.colorScheme.onSurfaceVariant, //  özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

