import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 라디오 선택지 하나.
class AppRadioOption<T> {
  final T value;
  final String label;
  final String? description;

  const AppRadioOption({
    required this.value,
    required this.label,
    this.description,
  });
}

/// 단일 선택 라디오 그룹 (세로 나열).
class AppRadioGroup<T> extends StatelessWidget {
  final T? groupValue;
  final List<AppRadioOption<T>> options;
  final ValueChanged<T>? onChanged;
  final Color? color;

  const AppRadioGroup({
    super.key,
    required this.groupValue,
    required this.options,
    this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        for (final option in options)
          InkWell(
            onTap:
                onChanged == null ? null : () => onChanged!(option.value),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
              child: Row(
                children: [
                  _RadioDot(
                    selected: option.value == groupValue,
                    color: accent,
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(option.label, style: AppTypography.description),
                        if (option.description != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            option.description!,
                            style: AppTypography.descriptionSub
                                .copyWith(color: AppSemantic.textTertiary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// 라디오 표시점 (외곽 링 + 선택 시 내부 점).
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? color : AppSemantic.border,
          width: selected ? 2 : 1.5,
        ),
      ),
      child: Center(
        child: selected
            ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              )
            : null,
      ),
    );
  }
}
