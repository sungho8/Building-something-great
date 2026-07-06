import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 모달 바텀시트. 상단 그래버 + 선택 제목 + 내용.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  String? title,
  required Widget child,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppCommon.white,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s12,
          AppSpacing.s20,
          AppSpacing.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 그래버
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppGrey.s300,
                  borderRadius: BorderRadius.circular(AppRadius.max),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s16),

            if (title != null) ...[
              Text(title, style: AppTypography.title3),
              const SizedBox(height: AppSpacing.s12),
            ],

            child,
          ],
        ),
      ),
    ),
  );
}
