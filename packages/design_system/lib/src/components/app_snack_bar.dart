import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 스낵바 변형.
enum AppSnackBarVariant { info, success, error }

/// 토스트형 스낵바 (어두운 배경 + 변형별 아이콘 + 선택 액션).
void showAppSnackBar(
  BuildContext context,
  String message, {
  AppSnackBarVariant variant = AppSnackBarVariant.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final (icon, iconColor) = switch (variant) {
    AppSnackBarVariant.info => (Icons.info_outline, AppGrey.s300),
    AppSnackBarVariant.success =>
      (Icons.check_circle_outline, AppGreen.s400),
    AppSnackBarVariant.error => (Icons.error_outline, AppRed.s400),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppGrey.s800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        content: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),

            const SizedBox(width: AppSpacing.s8),

            Expanded(
              child: Text(
                message,
                style: AppTypography.description
                    .copyWith(color: AppCommon.white),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppBlue.s300,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
}
