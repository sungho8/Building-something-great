import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui_theme.dart';

/// 섹션 라벨.
class UiSectionLabel extends StatelessWidget {
  const UiSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: Text(text,
          style: AppTypography.label2.copyWith(color: c.textSecondary)),
    );
  }
}

/// 테마 대응 텍스트 입력.
class UiTextField extends StatelessWidget {
  const UiTextField({
    super.key,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.prefixText,
    this.suffixText,
    this.autofocus = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final String? prefixText;
  final String? suffixText;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        autofocus: autofocus,
        onSubmitted: onSubmitted,
        cursorColor: c.accent,
        style: AppTypography.body1.copyWith(color: c.textPrimary),
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTypography.body1.copyWith(color: c.textTertiary),
          prefixText: prefixText,
          prefixStyle: AppTypography.body1.copyWith(color: c.textSecondary),
          suffixText: suffixText,
          suffixStyle: AppTypography.body1.copyWith(color: c.textSecondary),
        ),
      ),
    );
  }
}

class UiSegment<T> {
  final T value;
  final String label;
  const UiSegment({required this.value, required this.label});
}

/// 세그먼트 컨트롤 — 선택 세그먼트는 accent로 채우고 흰 텍스트.
class UiSegmented<T> extends StatelessWidget {
  const UiSegmented({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
  });

  final T value;
  final List<UiSegment<T>> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.max),
      ),
      child: Row(
        children: [
          for (final seg in segments)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(seg.value),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: seg.value == value ? c.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.max),
                  ),
                  child: Text(
                    seg.label,
                    style: AppTypography.label3.copyWith(
                      color: seg.value == value ? Colors.white : c.textSecondary,
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

/// 선택형 칩.
class UiChip extends StatelessWidget {
  const UiChip({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.color,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final fill = selected ? (color ?? c.accent) : c.surface;
    final fg = selected ? Colors.white : c.textSecondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.max),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
          decoration: BoxDecoration(
            color: fill,
            border: Border.all(color: selected ? Colors.transparent : c.border),
            borderRadius: BorderRadius.circular(AppRadius.max),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: AppSpacing.s6),
              ],
              Text(label, style: AppTypography.label3.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 값 표시 + 탭 동작 행 (예: 날짜 선택).
class UiTile extends StatelessWidget {
  const UiTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16, vertical: AppSpacing.s14),
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: c.accent),
              const SizedBox(width: AppSpacing.s12),
              Text(title,
                  style: AppTypography.body2.copyWith(color: c.textPrimary)),
              const Spacer(),
              Flexible(
                child: Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style:
                        AppTypography.body2.copyWith(color: c.textSecondary)),
              ),
              const SizedBox(width: AppSpacing.s4),
              Icon(Icons.chevron_right, size: 18, color: c.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

/// accent로 꽉 채운 기본 버튼.
class UiButton extends StatelessWidget {
  const UiButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.expand = true,
    this.filled = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;

  /// false면 외곽선(secondary) 스타일.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final enabled = onPressed != null;
    final bg = filled
        ? (enabled ? c.accent : c.surfaceAlt)
        : Colors.transparent;
    final fg = filled
        ? Colors.white
        : c.textPrimary;

    final child = Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: filled
              ? null
              : BoxDecoration(
                  border: Border.all(color: c.border),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: AppSpacing.s8),
              ],
              Text(label, style: AppTypography.label1.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}
