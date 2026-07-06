import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_button.dart';

/// 확인/알림 다이얼로그.
///
/// [cancelLabel]을 주면 확인+취소 2버튼, 없으면 확인 1버튼.
/// [destructive]면 확인 버튼이 빨간색(삭제 등 파괴적 행동).
/// 확인=true, 취소/닫기=false 또는 null을 반환한다.
Future<bool?> showAppDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = '확인',
  String? cancelLabel,
  bool destructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppCommon.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppTypography.title3),

            if (message != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                message,
                style: AppTypography.description
                    .copyWith(color: AppSemantic.textSecondary),
              ),
            ],

            const SizedBox(height: AppSpacing.s24),

            Row(
              children: [
                if (cancelLabel != null) ...[
                  Expanded(
                    child: AppButton(
                      label: cancelLabel,
                      size: AppButtonSize.md,
                      variant: AppButtonVariant.secondary,
                      color: AppSemantic.textSecondary,
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                ],
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    size: AppButtonSize.md,
                    color: destructive ? AppRed.s500 : null,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
