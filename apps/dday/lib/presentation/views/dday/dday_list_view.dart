import 'package:ads/ads.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';
import '../../../domain/entities/dday_item.dart';
import '../../widgets/dday_card.dart';
import '../../widgets/dday_hero_card.dart';
import 'account_sheet.dart';
import 'dday_edit_view.dart';

/// 목록 필터.
enum _Filter { all, upcoming, past }

/// D-Day 목록 화면. 상단 필터 + 히어로/컴팩트 카드.
class DDayListView extends ConsumerStatefulWidget {
  const DDayListView({super.key});

  @override
  ConsumerState<DDayListView> createState() => _DDayListViewState();
}

class _DDayListViewState extends ConsumerState<DDayListView> {
  // 현재 필터
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(ddayListProvider);
    final items = switch (_filter) {
      _Filter.all => all,
      _Filter.upcoming => all.where((e) => e.daysFromToday >= 0).toList(),
      _Filter.past => all.where((e) => e.daysFromToday < 0).toList(),
    };

    return AppScaffold(
      appBar: AppBar(
        title: const Text('D-Day'),
        actions: [
          IconButton(
            onPressed: () => showAccountSheet(context),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(child: AppBannerAd()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEdit(context),
        icon: const Icon(Icons.add),
        label: const Text('추가'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s8,
              AppSpacing.s16,
              AppSpacing.s4,
            ),
            child: AppSegmentedControl<_Filter>(
              value: _filter,
              onChanged: (f) => setState(() => _filter = f),
              segments: const [
                AppSegment(value: _Filter.all, label: '전체'),
                AppSegment(value: _Filter.upcoming, label: '예정'),
                AppSegment(value: _Filter.past, label: '지남'),
              ],
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? _emptyState(all.isEmpty)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      AppSpacing.s12,
                      AppSpacing.s16,
                      AppSpacing.s96,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                        child: Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: const _DeleteBackground(),
                          onDismissed: (_) => _delete(context, ref, item),
                          child: FadeSlideIn(
                            index: index,
                            child: index == 0
                                ? DDayHeroCard(
                                    item: item,
                                    onTap: () => _openEdit(context, item),
                                    onPinToggle: () => _togglePin(ref, item),
                                  )
                                : DDayCard(
                                    item: item,
                                    onTap: () => _openEdit(context, item),
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
  }

  // 비었을 때 안내 (전체가 비었는지 vs 필터 결과만 비었는지)
  Widget _emptyState(bool allEmpty) {
    if (allEmpty) {
      return const AppEmptyState(
        icon: Icons.event_outlined,
        title: '등록된 D-Day가 없어요',
        description: '오른쪽 아래 버튼으로 추가해보세요',
      );
    }
    return AppEmptyState(
      icon: Icons.filter_list_off,
      title: _filter == _Filter.upcoming ? '예정된 D-Day가 없어요' : '지난 D-Day가 없어요',
    );
  }

  // 추가/편집 화면 열기
  void _openEdit(BuildContext context, [DDayItem? item]) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DDayEditView(item: item)),
    );
  }

  // 고정 토글 + 햅틱
  void _togglePin(WidgetRef ref, DDayItem item) {
    HapticFeedback.selectionClick();
    ref.read(ddayListProvider.notifier).togglePin(item.id);
  }

  // 스와이프 삭제 + 실행취소 스낵바
  void _delete(BuildContext context, WidgetRef ref, DDayItem item) {
    HapticFeedback.mediumImpact();
    ref.read(ddayListProvider.notifier).remove(item.id);
    showAppSnackBar(
      context,
      '«${item.title}» 삭제됨',
      actionLabel: '실행취소',
      onAction: () => ref.read(ddayListProvider.notifier).restore(item),
    );
  }
}

/// 스와이프 시 뒤로 드러나는 삭제 배경.
class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      decoration: BoxDecoration(
        color: AppRed.s500,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: const Icon(Icons.delete_outline, color: AppCommon.white),
    );
  }
}
