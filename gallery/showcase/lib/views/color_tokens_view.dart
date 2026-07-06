import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 색 토큰 갤러리 — 스케일별 스와치와 hex를 나열한다.
class ColorTokensView extends StatelessWidget {
  const ColorTokensView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      children: const [
        _ScaleSection(title: 'Grey — 시스템의 뼈대', swatches: [
          ('50', AppGrey.s50),
          ('100', AppGrey.s100),
          ('200', AppGrey.s200),
          ('300', AppGrey.s300),
          ('400', AppGrey.s400),
          ('500', AppGrey.s500),
          ('600', AppGrey.s600),
          ('700', AppGrey.s700),
          ('800', AppGrey.s800),
          ('900', AppGrey.s900),
        ]),
        _ScaleSection(title: 'Blue — 팩토리 기본 브랜드', swatches: [
          ('50', AppBlue.s50),
          ('100', AppBlue.s100),
          ('200', AppBlue.s200),
          ('300', AppBlue.s300),
          ('400', AppBlue.s400),
          ('500', AppBlue.s500),
          ('600', AppBlue.s600),
          ('700', AppBlue.s700),
          ('800', AppBlue.s800),
          ('900', AppBlue.s900),
        ]),
        _ScaleSection(title: 'Red — 오류·삭제', swatches: [
          ('50', AppRed.s50),
          ('100', AppRed.s100),
          ('200', AppRed.s200),
          ('300', AppRed.s300),
          ('400', AppRed.s400),
          ('500', AppRed.s500),
          ('600', AppRed.s600),
          ('700', AppRed.s700),
        ]),
        _ScaleSection(title: 'Green — 성공·완료', swatches: [
          ('50', AppGreen.s50),
          ('100', AppGreen.s100),
          ('200', AppGreen.s200),
          ('300', AppGreen.s300),
          ('400', AppGreen.s400),
          ('500', AppGreen.s500),
          ('600', AppGreen.s600),
          ('700', AppGreen.s700),
        ]),
        _ScaleSection(title: 'Orange — 경고·주의', swatches: [
          ('50', AppOrange.s50),
          ('100', AppOrange.s100),
          ('200', AppOrange.s200),
          ('300', AppOrange.s300),
          ('400', AppOrange.s400),
          ('500', AppOrange.s500),
          ('600', AppOrange.s600),
          ('700', AppOrange.s700),
        ]),
        _ScaleSection(title: 'Semantic — 역할 별칭', swatches: [
          ('textPrimary', AppSemantic.textPrimary),
          ('textSecondary', AppSemantic.textSecondary),
          ('textTertiary', AppSemantic.textTertiary),
          ('textDisabled', AppSemantic.textDisabled),
          ('border', AppSemantic.border),
          ('divider', AppSemantic.divider),
          ('bgSecondary', AppSemantic.bgSecondary),
        ]),
      ],
    );
  }
}

/// 스케일 한 세트(제목 + 스와치들).
class _ScaleSection extends StatelessWidget {
  const _ScaleSection({required this.title, required this.swatches});

  /// 섹션 제목
  final String title;

  /// (라벨, 색) 목록
  final List<(String, Color)> swatches;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s12,
          children: [
            for (final (label, color) in swatches)
              _Swatch(label: label, color: color),
          ],
        ),

        const SizedBox(height: AppSpacing.s32),
      ],
    );
  }
}

/// 스와치 하나(색상 박스 + 라벨 + hex).
class _Swatch extends StatelessWidget {
  const _Swatch({required this.label, required this.color});

  /// 스케일 라벨 (50~900 또는 역할명)
  final String label;

  /// 표시할 색
  final Color color;

  @override
  Widget build(BuildContext context) {
    // #RRGGBB 표기
    final hex =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppSemantic.divider),
          ),
        ),

        const SizedBox(height: AppSpacing.s4),

        Text(label, style: AppTypography.caption1),

        Text(
          hex,
          style: AppTypography.caption2
              .copyWith(color: AppSemantic.textTertiary),
        ),
      ],
    );
  }
}
