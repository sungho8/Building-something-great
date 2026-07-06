import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 세그먼트 하나.
class AppSegment<T> {
  final T value;
  final String label;

  const AppSegment({required this.value, required this.label});
}

/// 세그먼트 컨트롤 (토스식). 회색 트랙 위에서 선택 항목이 흰 pill로 뜬다.
///
/// 2~4개 상호배타 선택지에 쓴다 (탭 성격). 색은 [color] 또는 테마 primary.
class AppSegmentedControl<T> extends StatelessWidget {
  final T value;
  final List<AppSegment<T>> segments;
  final ValueChanged<T>? onChanged;
  final Color? color;

  const AppSegmentedControl({
    super.key,
    required this.value,
    required this.segments,
    this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppGrey.s100,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onChanged == null ? null : () => onChanged!(segment.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                  decoration: BoxDecoration(
                    color: segment.value == value
                        ? AppCommon.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: segment.value == value
                        ? [
                            BoxShadow(
                              color: AppGrey.s900.withValues(alpha: 0.10),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      segment.label,
                      style: AppTypography.label3.copyWith(
                        color: segment.value == value
                            ? accent
                            : AppSemantic.textSecondary,
                        fontWeight: segment.value == value
                            ? AppFontWeight.semiBold
                            : AppFontWeight.medium,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
