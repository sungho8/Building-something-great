import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 타이포 토큰 갤러리 — 스케일별 스펙과 실제 렌더를 나열한다.
class TypographyView extends StatelessWidget {
  const TypographyView({super.key});

  // (이름, 스타일, 용도) 목록
  static const _styles = <(String, TextStyle, String)>[
    ('display', AppTypography.display, '큰 숫자·화면의 주인공'),
    ('title1', AppTypography.title1, '화면 대제목'),
    ('title2', AppTypography.title2, '섹션 제목'),
    ('title3', AppTypography.title3, '카드 제목·강조 숫자'),
    ('heading1', AppTypography.heading1, '리스트 타이틀'),
    ('heading2', AppTypography.heading2, '작은 타이틀'),
    ('body1', AppTypography.body1, '큰 본문'),
    ('body2', AppTypography.body2, '기본 본문'),
    ('body3', AppTypography.body3, '보조 본문'),
    ('caption1', AppTypography.caption1, '캡션'),
    ('caption2', AppTypography.caption2, '최소 캡션'),
    ('label1', AppTypography.label1, '버튼 lg(48)'),
    ('label2', AppTypography.label2, '버튼 md(42)'),
    ('label3', AppTypography.label3, '버튼 sm(36)'),
    ('label4', AppTypography.label4, '버튼 xs(32)'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.s20),
      itemCount: _styles.length,
      separatorBuilder: (_, _) => const Divider(height: AppSpacing.s32),
      itemBuilder: (context, index) {
        final (name, style, usage) = _styles[index];
        return _TypeRow(name: name, style: style, usage: usage);
      },
    );
  }
}

/// 타입 스타일 한 줄(스펙 + 샘플).
class _TypeRow extends StatelessWidget {
  const _TypeRow({required this.name, required this.style, required this.usage});

  /// 토큰 이름
  final String name;

  /// 스타일
  final TextStyle style;

  /// 용도 설명
  final String usage;

  @override
  Widget build(BuildContext context) {
    final size = style.fontSize!.toInt();
    final lineHeight = (style.fontSize! * (style.height ?? 1)).round();
    final weight = switch (style.fontWeight) {
      AppFontWeight.bold => 'Bold',
      AppFontWeight.semiBold => 'SemiBold',
      AppFontWeight.medium => 'Medium',
      _ => 'Regular',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$name · $size/$lineHeight $weight · $usage',
          style: AppTypography.caption1
              .copyWith(color: AppSemantic.textTertiary),
        ),

        const SizedBox(height: AppSpacing.s6),

        Text('토스처럼 만드는 디자인 시스템 123', style: style),
      ],
    );
  }
}
