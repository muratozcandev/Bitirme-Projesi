import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/formation.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/notification_icon.dart';
import 'widgets/football_pitch_widget.dart';

class TeamCreationScreen extends ConsumerStatefulWidget {
  const TeamCreationScreen({super.key});

  @override
  ConsumerState<TeamCreationScreen> createState() => _TeamCreationScreenState();
}

class _TeamCreationScreenState extends ConsumerState<TeamCreationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      final formState = ref.read(teamCreationProvider);
      if (user != null && formState.lineup.isEmpty) {
        ref.read(teamCreationProvider.notifier).resetForUser(user.fullName);
      }
    });
  }

  Future<void> _showSearchablePicker({
    required String title,
    required List<String> items,
    required String? selectedValue,
    required void Function(String) onSelected,
    String? subtitleBanner,
  }) async {
    final searchController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final query = searchController.text.trim().toLowerCase();
            final filtered = query.isEmpty
                ? items
                : items
                    .where((item) => item.toLowerCase().contains(query))
                    .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.72,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      if (subtitleBanner != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitleBanner,
                          style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                                color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: '$title içinde ara...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setModalState(() {});
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => setModalState(() {}),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(
                                child: Text('Sonuç bulunamadı.'),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                itemCount: filtered.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (_, index) {
                                  final item = filtered[index];
                                  final isSelected = item == selectedValue;
                                  return ListTile(
                                    title: Text(
                                      item,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.w800
                                            : FontWeight.w500,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppColors.pitchGreen,
                                          )
                                        : null,
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.of(ctx).pop();
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _handleProvinceSelect() async {
    final provinces = await ref.read(provincesProvider.future);
    if (!mounted) return;
    final current = ref.read(teamCreationProvider).selectedProvince;
    await _showSearchablePicker(
      title: 'İl Seçimi (81 İl)',
      items: provinces,
      selectedValue: current,
      onSelected: (val) {
        ref.read(teamCreationProvider.notifier).selectProvince(val);
      },
    );
  }

  Future<void> _handleDistrictSelect() async {
    final province = ref.read(teamCreationProvider).selectedProvince;
    if (province == null || province.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İlçe seçebilmek için lütfen önce bir il seçiniz.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final districts = await ref.read(districtsProvider(province).future);
    if (!mounted) return;
    final current = ref.read(teamCreationProvider).selectedDistrict;
    await _showSearchablePicker(
      title: '$province — İlçe Seçimi',
      items: districts,
      selectedValue: current,
      onSelected: (val) {
        ref.read(teamCreationProvider.notifier).selectDistrict(val);
      },
    );
  }

  Future<void> _handleVenueSelect() async {
    final form = ref.read(teamCreationProvider);
    if (form.selectedProvince == null || form.selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Halı saha seçebilmek için önce il ve ilçe seçmelisiniz.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final venues = await ref.read(
      venuesProvider((
        province: form.selectedProvince!,
        district: form.selectedDistrict!,
      )).future,
    );
    if (!mounted) return;
    await _showSearchablePicker(
      title: '${form.selectedDistrict} Halı Sahaları',
      subtitleBanner:
          'Not: Listelenen halı saha isimleri test verisidir; gerçek işletme rezervasyonu değildir.',
      items: venues,
      selectedValue: form.selectedVenue,
      onSelected: (val) {
        ref.read(teamCreationProvider.notifier).selectVenue(val);
      },
    );
  }

  Future<void> _handleDateSelect() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = ref.read(teamCreationProvider).selectedDate ?? today;

    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(today) ? today : current,
      firstDate: today,
      lastDate: DateTime(today.year + 5, 12, 31),
      helpText: 'Maç Tarihini Seçiniz (Geçmiş tarihler seçilemez)',
      cancelText: 'İptal',
      confirmText: 'Seç',
    );

    if (picked != null && mounted) {
      ref.read(teamCreationProvider.notifier).selectDate(picked);
    }
  }

  Future<void> _handleTimeSelect() async {
    final slots = AppConstants.timeSlots;
    final current = ref.read(teamCreationProvider).selectedTimeSlot;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.68,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Maç Saati Seçimi (24 Saat / 1 Saatlik Aralıklar)',
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3.1,
                      ),
                      itemCount: slots.length,
                      itemBuilder: (_, index) {
                        final slot = slots[index];
                        final isSelected = slot == current;
                        return InkWell(
                          onTap: () {
                            ref
                                .read(teamCreationProvider.notifier)
                                .selectTimeSlot(slot);
                            Navigator.of(ctx).pop();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryDarkGreen
                                  : Theme.of(ctx)
                                      .colorScheme
                                      .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.pitchGreen
                                    : Colors.transparent,
                                width: 1.8,
                              ),
                            ),
                            child: Text(
                              slot,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(ctx).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleFormationSelect() async {
    final current = ref.read(teamCreationProvider).selectedFormation;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  '7v7 Saha Dizilişi Seçiniz',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Her dizilişte Kaleci (1) sabittir ve toplam 7 oyuncu bulunur.',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ...Formation.values.map((f) {
                  final isSelected = f == current;
                  return ListTile(
                    key: Key('formation_option_${f.label}'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? AppColors.pitchGreen
                          : AppColors.primaryDarkGreen,
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      '${f.label} Dizilişi',
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '1 Kaleci • ${f.defenderCount} Defans • ${f.midfielderCount} Orta Saha • ${f.forwardCount} Forvet',
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.pitchGreen,
                          )
                        : null,
                    onTap: () {
                      ref
                          .read(teamCreationProvider.notifier)
                          .selectFormation(f);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handlePositionTap(PlayerPositionSlot slot) async {
    final form = ref.read(teamCreationProvider);
    final user = ref.read(authProvider).user;
    final currentName = form.lineup[slot.key] ?? '';
    final controller = TextEditingController(text: currentName);
    final isCaptainSlot = form.captainPositionKey == slot.key;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('${slot.label} Oyuncu Bilgisi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sadece ad veya ad-soyad yazabilirsiniz. Boş bırakırsanız daha sonra oyuncu davet edebilirsiniz.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('player_name_dialog_input'),
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: '${slot.label} Oyuncu Adı',
                    hintText: 'Örn: Cristiano Ronaldo',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                if (user != null && !isCaptainSlot) ...[
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref
                          .read(teamCreationProvider.notifier)
                          .setCaptainPosition(slot.key, user.fullName);
                      Navigator.of(ctx).pop();
                    },
                    icon: const Icon(Icons.star_outline_rounded),
                    label: Text('Kendimi (${user.fullName}) Bu Mevkiye Ata'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (currentName.isNotEmpty && !isCaptainSlot)
              TextButton(
                onPressed: () {
                  ref
                      .read(teamCreationProvider.notifier)
                      .setPlayerName(slot.key, '');
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Boşalt',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              key: const Key('player_name_dialog_save'),
              onPressed: () {
                ref
                    .read(teamCreationProvider.notifier)
                    .setPlayerName(slot.key, controller.text);
                Navigator.of(ctx).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSaveTeam() async {
    final form = ref.read(teamCreationProvider);
    final user = ref.read(authProvider).user;
    if (user == null) return;

    if (!form.isReadyToSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lütfen takım oluşturmadan önce İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçimlerini tamamlayınız.',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    ref.read(teamCreationProvider.notifier).setSubmitting(true);
    try {
      final startTime = AppConstants.startTimeFromSlot(form.selectedTimeSlot!);
      final endTime = AppConstants.endTimeFromSlot(form.selectedTimeSlot!);

      await ref.read(teamRepositoryProvider).createTeam(
            captainId: user.id,
            captainName: user.fullName,
            formation: form.selectedFormation,
            province: form.selectedProvince!,
            district: form.selectedDistrict!,
            venueName: form.selectedVenue!,
            matchDate: form.formattedDateKey,
            startTime: startTime,
            endTime: endTime,
            lineup: form.lineup,
            captainPositionKey: form.captainPositionKey,
          );

      ref.read(teamCreationProvider.notifier).resetForUser(user.fullName);
      triggerGlobalRefresh(ref);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '7v7 Takımınız ve maç randevunuz başarıyla oluşturuldu!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/appointments');
    } catch (e) {
      ref.read(teamCreationProvider.notifier).setSubmitting(false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(teamCreationProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.sports_soccer, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            const Text('7v7 — Takım Kur'),
          ],
        ),
        actions: const [
          NotificationIcon(),
          SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Üst Bölüm: 5 Eşit Boyutlu Seçim Butonu (İl, İlçe, Halı Saha, Tarih, Saat)
                  Row(
                    children: [
                      Expanded(
                        child: _SelectionTopButton(
                          key: const Key('btn_select_province'),
                          icon: Icons.location_city_rounded,
                          title: 'İl',
                          value: form.selectedProvince ?? 'Seçiniz',
                          isSelected: form.selectedProvince != null,
                          onTap: _handleProvinceSelect,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _SelectionTopButton(
                          key: const Key('btn_select_district'),
                          icon: Icons.map_outlined,
                          title: 'İlçe',
                          value: form.selectedDistrict ?? 'Seçiniz',
                          isSelected: form.selectedDistrict != null,
                          onTap: _handleDistrictSelect,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _SelectionTopButton(
                          key: const Key('btn_select_venue'),
                          icon: Icons.stadium_outlined,
                          title: 'Halı Saha',
                          value: form.selectedVenue ?? 'Seçiniz',
                          isSelected: form.selectedVenue != null,
                          onTap: _handleVenueSelect,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _SelectionTopButton(
                          key: const Key('btn_select_date'),
                          icon: Icons.calendar_today_rounded,
                          title: 'Tarih',
                          value: form.selectedDate != null
                              ? form.formattedDateDisplay
                              : 'Seçiniz',
                          isSelected: form.selectedDate != null,
                          onTap: _handleDateSelect,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _SelectionTopButton(
                          key: const Key('btn_select_time'),
                          icon: Icons.schedule_rounded,
                          title: 'Saat',
                          value: form.selectedTimeSlot ?? 'Seçiniz',
                          isSelected: form.selectedTimeSlot != null,
                          onTap: _handleTimeSelect,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Diziliş Seçim Butonu (Yatay ve Geniş) + Yeşil Tik İkonu
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          key: const Key('btn_select_formation'),
                          onTap: _handleFormationSelect,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 54,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.45),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.grid_view_rounded,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Diziliş: ${form.selectedFormation.label}',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        '1 Kaleci • ${form.selectedFormation.defenderCount} Defans • ${form.selectedFormation.midfielderCount} Orta Saha • ${form.selectedFormation.forwardCount} Forvet',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          fontSize: 11,
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Yeşil Tik İkonu (Kaydetme Butonu)
                      Tooltip(
                        message: form.isReadyToSubmit
                            ? 'Takımı ve Randevuyu Kaydet'
                            : 'Önce İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçiniz',
                        child: Material(
                          color: form.isReadyToSubmit
                              ? AppColors.success
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            key: const Key('btn_confirm_team_creation'),
                            borderRadius: BorderRadius.circular(14),
                            onTap: _handleSaveTeam,
                            child: SizedBox(
                              width: 54,
                              height: 54,
                              child: form.isSubmitting
                                  ? const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.check_circle_rounded,
                                      size: 30,
                                      color: form.isReadyToSubmit
                                          ? Colors.white
                                          : theme.colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.45),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Futbol Sahası Görünümü
                  FootballPitchWidget(
                    formation: form.selectedFormation,
                    lineup: form.lineup,
                    captainPositionKey: form.captainPositionKey,
                    onPositionTap: _handlePositionTap,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'İpucu: Sahadaki mevki butonlarına dokunarak oyuncu adı girebilir veya boş bırakıp daha sonra Sohbet > Oyuncu Önerileri sekmesinden davet gönderebilirsiniz.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionTopButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionTopButton({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

