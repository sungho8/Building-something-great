import 'package:ads/ads.dart';
import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/ad_config.dart';
import '../../di/quit_providers.dart';
import '../../domain/entities/quit_item.dart';
import '../../theme/ui_theme.dart';
import '../../theme/ui_widgets.dart';
import '../../utils/format.dart';
import '../widgets/quit_card.dart';
import '../widgets/quit_hero.dart';
import 'quit_create_wizard.dart';
import 'quit_edit_view.dart';

/// 하루더 홈 — 대표 목표 히어로 + 스탯 + 다른 목표 카드.
class QuitHomeView extends ConsumerWidget {
  const QuitHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = UiColors.of(context);
    final items = ref.watch(quitListProvider);
    final primary = items.isEmpty ? null : items.first;
    final others = items.length > 1 ? items.sublist(1) : const <QuitItem>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('하루더'),
        actions: const [_ThemeToggleButton()],
      ),
      bottomNavigationBar: SafeArea(child: AppBannerAd(adUnitId: QuitAds.banner)),
      floatingActionButton: items.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openWizard(context),
              icon: const Icon(Icons.add),
              label: const Text('목표 추가'),
            ),
      body: primary == null
          ? _empty(context, c)
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16, AppSpacing.s8, AppSpacing.s16, AppSpacing.s24),
              children: [
                QuitHero(
                  item: primary,
                  onTap: () => _openEdit(context, primary),
                ),
                const SizedBox(height: AppSpacing.s12),
                _StatTiles(item: primary),
                if (others.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s24),
                  Text('다른 목표',
                      style: AppTypography.sectionTitle
                          .copyWith(color: c.textPrimary)),
                  const SizedBox(height: AppSpacing.s12),
                  for (final o in others) ...[
                    QuitCard(item: o, onTap: () => _openEdit(context, o)),
                    const SizedBox(height: AppSpacing.s10),
                  ],
                ],
              ],
            ),
    );
  }

  Widget _empty(BuildContext context, UiColors c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined, size: 56, color: c.textTertiary),
            const SizedBox(height: AppSpacing.s16),
            Text('첫 끊기를 시작해볼까요?',
                style: AppTypography.title3.copyWith(color: c.textPrimary)),
            const SizedBox(height: AppSpacing.s6),
            Text('끊은 순간부터 며칠, 얼마를 아꼈는지 세어드려요',
                textAlign: TextAlign.center,
                style: AppTypography.body3.copyWith(color: c.textTertiary)),
            const SizedBox(height: AppSpacing.s24),
            UiButton(
              label: '끊기 시작하기',
              icon: Icons.add,
              expand: false,
              onPressed: () => _openWizard(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWizard(BuildContext context) {
    HapticFeedback.selectionClick();
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const QuitCreateWizard(),
      fullscreenDialog: true,
    ));
  }

  Future<void> _openEdit(BuildContext context, QuitItem item) {
    HapticFeedback.selectionClick();
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => QuitEditView(item: item)),
    );
  }
}

/// 대표 목표 스탯 3종 — 절약액 / 회피량 / 최고기록.
class _StatTiles extends StatelessWidget {
  const _StatTiles({required this.item});
  final QuitItem item;

  @override
  Widget build(BuildContext context) {
    final avoided = item.unitsAvoided;
    return Row(
      children: [
        _tile(context, '절약액', formatWon(item.moneySaved)),
        const SizedBox(width: AppSpacing.s10),
        _tile(context, '안 한 ${item.unitLabel}', formatNumber(avoided)),
        const SizedBox(width: AppSpacing.s10),
        _tile(context, '최고기록', '${item.updatedBestStreak}일'),
      ],
    );
  }

  Widget _tile(BuildContext context, String label, String value) {
    final c = UiColors.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14, vertical: AppSpacing.s16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTypography.caption1.copyWith(color: c.textTertiary)),
            const SizedBox(height: AppSpacing.s6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  style: AppTypography.heading1.copyWith(color: c.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 라이트/다크 토글.
class _ThemeToggleButton extends ConsumerWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? '라이트 모드' : '다크 모드',
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => ref
          .read(themeModeProvider.notifier)
          .set(isDark ? ThemeMode.light : ThemeMode.dark),
    );
  }
}
