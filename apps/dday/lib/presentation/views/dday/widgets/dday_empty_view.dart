import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 목록이 비었을 때 보여주는 안내 화면.
class DDayEmptyView extends StatelessWidget {
  const DDayEmptyView({super.key});

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
