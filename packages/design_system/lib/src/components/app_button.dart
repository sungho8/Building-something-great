import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 버튼 크기 (높이 48/42/36/32).
enum AppButtonSize { lg, md, sm, xs }

/// 버튼 변형. primary=채움 / secondary=외곽선 / tertiary=텍스트.
enum AppButtonVariant { primary, secondary, tertiary }

/// 디자인 시스템 버튼.
///
/// 색은 Theme(브랜드)에서, 크기·간격·반경은 토큰에서 가져온다.
/// hover/pressed/disabled 상태는 Material이 자동 처리한다.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  /// 가로로 꽉 채울지.
  final bool expand;

  /// 모서리 반경. 기본 [AppRadius.md] (10).
  final double borderRadius;

  /// 강조 색 커스텀. null이면 테마 primary.
  /// primary 변형은 채움색, secondary/tertiary는 글자·테두리색으로 쓰인다.
  final Color? color;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.expand = false,
    this.borderRadius = AppRadius.md,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final spec = _specOf(size);
    final theme = Theme.of(context);
    final primary = color ?? theme.colorScheme.primary;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
    // ButtonStyle.textStyle은 Theme.textTheme merge 경로를 타지 않으므로,
    // 폰트 패밀리를 여기서 명시적으로 이어받아야 브랜드 폰트가 버튼에도 적용된다.
    final textStyle = spec.labelStyle.copyWith(
      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
    );
    final child = _child(spec);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(0, spec.height),
            padding: EdgeInsets.symmetric(horizontal: spec.hPad),
            textStyle: textStyle,
            shape: shape,
            backgroundColor: color,
            foregroundColor: color != null ? AppCommon.white : null,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(0, spec.height),
            padding: EdgeInsets.symmetric(horizontal: spec.hPad),
            textStyle: textStyle,
            shape: shape,
            side: BorderSide(color: primary),
            foregroundColor: primary,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        ),
      AppButtonVariant.tertiary => TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(0, spec.height),
            padding: EdgeInsets.symmetric(horizontal: spec.hPad),
            textStyle: textStyle,
            shape: shape,
            foregroundColor: primary,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  // 라벨 + 옵션 아이콘 구성
  Widget _child(_SizeSpec spec) {
    if (leadingIcon == null && trailingIcon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: spec.iconSize),
          const SizedBox(width: AppSpacing.s6),
        ],
        Text(label),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.s6),
          Icon(trailingIcon, size: spec.iconSize),
        ],
      ],
    );
  }

  _SizeSpec _specOf(AppButtonSize s) => switch (s) {
        AppButtonSize.lg => const _SizeSpec(48, 20, AppTypography.label1, 20),
        AppButtonSize.md => const _SizeSpec(42, 16, AppTypography.label2, 18),
        AppButtonSize.sm => const _SizeSpec(36, 14, AppTypography.label3, 16),
        AppButtonSize.xs => const _SizeSpec(32, 12, AppTypography.label4, 16),
      };
}

class _SizeSpec {
  final double height;
  final double hPad;
  final TextStyle labelStyle;
  final double iconSize;

  const _SizeSpec(this.height, this.hPad, this.labelStyle, this.iconSize);
}
