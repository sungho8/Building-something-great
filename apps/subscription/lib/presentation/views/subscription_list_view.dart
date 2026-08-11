import 'package:ads/ads.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/ad_config.dart';
import '../../di/subscription_providers.dart';
import '../../domain/entities/subscription.dart';
import 'package:app_theme/app_theme.dart';
import '../category_style.dart';
import '../widgets/stat_tiles.dart';
import '../widgets/subscription_row.dart';
import '../widgets/upcoming_carousel.dart';
import 'subscription_edit_view.dart';

/// 구독 홈 — 상단 스탯 요약 + 카테고리 필터 + 아이콘 중심 행 리스트.
class SubscriptionListView extends ConsumerStatefulWidget {
  const SubscriptionListView({super.key});

  @override
  ConsumerState<SubscriptionListView> createState() =>
      _SubscriptionListViewState();
}

class _SubscriptionListViewState extends ConsumerState<SubscriptionListView> {
  SubscriptionCategory? _category; // null = 전체

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final all = ref.watch(subscriptionListProvider);
    final total = ref.watch(monthlyTotalProvider);
    final activeCount = ref.watch(activeCountProvider);

    final items = _category == null
        ? all
        : all.where((e) => e.category == _category).toList();

    // 곧 결제 예정 (활성 · 14일 내), 임박 순. 전체 보기일 때만 노출.
    final upcoming = all
        .where((e) => e.active && e.daysUntilPayment <= 14)
        .toList()
      ..sort((a, b) => a.daysUntilPayment.compareTo(b.daysUntilPayment));
    final showUpcoming = _category == null && upcoming.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('구독'),
        actions: const [_ThemeToggleButton()],
      ),
      bottomNavigationBar: SafeArea(child: AppBannerAd(adUnitId: SubAds.banner)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEdit(context),
        icon: const Icon(Icons.add),
        label: const Text('구독 추가'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16, AppSpacing.s8, AppSpacing.s16, AppSpacing.s16),
            child: StatTiles(monthlyTotal: total, activeCount: activeCount),
          ),
          if (showUpcoming) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16, 0, AppSpacing.s16, AppSpacing.s10),
              child: Text('곧 결제 예정',
                  style: AppTypography.sectionTitle.copyWith(color: c.textPrimary)),
            ),
            UpcomingCarousel(
              items: upcoming,
              onTap: (item) => _openEdit(context, item),
            ),
            const SizedBox(height: AppSpacing.s20),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Row(
              children: [
                Text('구독 목록',
                    style: AppTypography.sectionTitle
                        .copyWith(color: c.textPrimary)),
                const Spacer(),
                _CategoryFilter(
                  selected: _category,
                  onChanged: (v) => setState(() => _category = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Expanded(
            child: items.isEmpty
                ? _emptyState(context, all.isEmpty)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.s16, 0, AppSpacing.s16, AppSpacing.s24),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.s10),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        background: _deleteBackground(),
                        onDismissed: (_) => _delete(context, item),
                        child: SubscriptionRow(
                          item: item,
                          onTap: () => _openEdit(context, item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, bool allEmpty) {
    final c = UiColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              allEmpty ? Icons.credit_card_outlined : Icons.filter_list_off,
              size: 48,
              color: c.textTertiary,
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              allEmpty ? '등록된 구독이 없어요' : '이 카테고리의 구독이 없어요',
              style: AppTypography.itemTitle.copyWith(color: c.textSecondary),
            ),
            if (allEmpty) ...[
              const SizedBox(height: AppSpacing.s6),
              Text(
                '구독을 추가하고 매달 나가는 돈을 한눈에 확인하세요',
                textAlign: TextAlign.center,
                style: AppTypography.body3.copyWith(color: c.textTertiary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _deleteBackground() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        decoration: BoxDecoration(
          color: AppRed.s500,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      );

  Future<void> _openEdit(BuildContext context, [Subscription? item]) {
    HapticFeedback.selectionClick();
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SubscriptionEditView(item: item)),
    );
  }

  void _delete(BuildContext context, Subscription item) {
    ref.read(subscriptionListProvider.notifier).remove(item.id);
    HapticFeedback.mediumImpact();
    showAppSnackBar(
      context,
      '«${item.name}»을(를) 삭제했어요',
      actionLabel: '실행취소',
      onAction: () =>
          ref.read(subscriptionListProvider.notifier).restore(item),
    );
  }
}

/// 라이트/다크 토글 버튼. 현재 밝기의 반대로 전환한다.
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

/// 카테고리 필터 — 팝업 메뉴(다크/라이트 자동 대응).
class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onChanged});

  final SubscriptionCategory? selected;
  final ValueChanged<SubscriptionCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final label = selected == null ? '전체' : CategoryStyle.label(selected!);

    return PopupMenuButton<SubscriptionCategory?>(
      onSelected: onChanged,
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('전체 카테고리')),
        for (final cat in SubscriptionCategory.values)
          PopupMenuItem(
            value: cat,
            child: Row(
              children: [
                Icon(CategoryStyle.icon(cat),
                    size: 18, color: CategoryStyle.color(cat)),
                const SizedBox(width: AppSpacing.s8),
                Text(CategoryStyle.label(cat)),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12, vertical: AppSpacing.s6),
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.max),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 16, color: c.textSecondary),
            const SizedBox(width: AppSpacing.s6),
            Text(label,
                style:
                    AppTypography.label3.copyWith(color: c.textPrimary)),
            Icon(Icons.arrow_drop_down_rounded, size: 18, color: c.textSecondary),
          ],
        ),
      ),
    );
  }
}
