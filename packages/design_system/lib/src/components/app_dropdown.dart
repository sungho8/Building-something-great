import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 드롭다운 선택지 하나.
class AppDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppDropdownItem({required this.value, required this.label, this.icon});
}

/// 드롭다운 선택 필드 (선택 라벨 + 테두리 박스).
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final field = Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppCommon.white,
        border: Border.all(color: AppSemantic.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(
                  hint!,
                  style: AppTypography.body1
                      .copyWith(color: AppSemantic.textTertiary),
                )
              : null,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppSemantic.textSecondary),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          style: AppTypography.body1.copyWith(color: AppSemantic.textPrimary),
          onChanged: onChanged,
          items: [
            for (final item in items)
              DropdownMenuItem<T>(
                value: item.value,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: 18, color: AppSemantic.textSecondary),
                      const SizedBox(width: AppSpacing.s8),
                    ],
                    Text(item.label),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: AppTypography.descriptionSub
              .copyWith(color: AppSemantic.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s6),
        field,
      ],
    );
  }
}
