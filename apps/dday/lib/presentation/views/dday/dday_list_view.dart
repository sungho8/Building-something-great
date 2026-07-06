import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';
import '../../../domain/entities/dday_item.dart';
import '../../widgets/dday_card.dart';
import '../../widgets/dday_hero_card.dart';
import 'dday_edit_view.dart';

/// D-Day 목록 화면. 최상단은 히어로 카드, 나머지는 컴팩트 카드.
class DDayListView extends ConsumerWidget {
  const DDayListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(ddayListProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('D-Day')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEdit(context),
        icon: const Icon(Icons.add),
        label: const Text('추가'),
      ),
      body: items.isEmpty
          ? const AppEmptyState(
              icon: Icons.event_outlined,
              title: '등록된 D-Day가 없어요',
              description: '오른쪽 아래 버튼으로 추가해보세요',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s16,
                AppSpacing.s16,
                AppSpacing.s96, // FAB에 가리지 않도록
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
