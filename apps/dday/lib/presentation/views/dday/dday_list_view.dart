import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';
import '../../../domain/entities/dday_item.dart';
import '../../widgets/dday_card.dart';
import 'dday_edit_view.dart';
import 'widgets/dday_empty_view.dart';

/// D-Day 목록 화면.
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
          ? const DDayEmptyView()
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

  // 추가/편집 화면 열기
  void _openEdit(BuildContext context, [DDayItem? item]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DDayEditView(item: item)),
    );
  }
}
