import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 섹션 헤더 라벨. 그룹 위에 붙는 회색 강조 텍스트 + 선택 트레일링.
class AppSectionTitle extends StatelessWidget {
  final String text;

  /// 오른쪽 끝 위젯 (예: '전체보기' 텍스트 버튼).
  final Widget? trailing;

  const AppSectionTitle({super.key, required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTypography.sectionTitle
                  .copyWith(color: AppSemantic.textSecondary),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
