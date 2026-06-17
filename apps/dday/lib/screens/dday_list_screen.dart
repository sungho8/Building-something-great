import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dday_item.dart';
import '../providers/dday_providers.dart';
import '../widgets/dday_card.dart';
import 'dday_edit_screen.dart';

/// D-Day 목록 화면.
class DDayListScreen extends ConsumerWidget {
  const DDayListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(ddayListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('D-Day')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEdit(context),
        icon: const Icon(Icons.add),
        label: const Text('추가'),
      ),
      body: items.isEmpty
          ? const _EmptyView()
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: items.length,
              separatorBuilder: (_, _) => AppSpacing.gapSm,
              itemBuilder: (context, index) {
                final item = items[index];
                return DDayCard(
                  item: item,
                  onTap: () => _openEdit(context, item),
                );
              },
            ),
    );
  }

  void _openEdit(BuildContext context, [DDayItem? item]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DDayEditScreen(item: item)),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_outlined,
              size: 64, color: theme.colorScheme.outline),
          AppSpacing.gapMd,
          Text('등록된 D-Day가 없어요', style: theme.textTheme.titleMedium),
          AppSpacing.gapSm,
          Text(
            '오른쪽 아래 버튼으로 추가해보세요',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
