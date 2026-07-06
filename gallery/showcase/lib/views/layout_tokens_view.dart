import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 레이아웃 토큰 갤러리 — spacing 스케일과 radius 스케일.
class LayoutTokensView extends StatelessWidget {
  const LayoutTokensView({super.key});

  // 대표 spacing 값
  static const _spacings = <double>[
    AppSpacing.s2,
    AppSpacing.s4,
    AppSpacing.s6,
    AppSpacing.s8,
    AppSpacing.s12,
    AppSpacing.s16,
    AppSpacing.s20,
    AppSpacing.s24,
    AppSpacing.s32,
    AppSpacing.s40,
    AppSpacing.s48,
    AppSpacing.s64,
  ];

  // 대표 radius 값
  static const _radii = <(String, double)>[
    ('xxs', AppRadius.xxs),
    ('xs', AppRadius.xs),
    ('sm', AppRadius.sm),
    ('md', AppRadius.md),
    ('lg', AppRadius.lg),
    ('xl', AppRadius.xl),
    ('max', AppRadius.max),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      children: [
        const Text('Spacing', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        for (final value in _spacings) ...[
          Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  value.toInt().toString(),
                  style: AppTypography.caption1
                      .copyWith(color: AppSemantic.textTertiary),
                ),
              ),
              Container(
                width: value * 3,
                height: 14,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s8),
        ],

        const SizedBox(height: AppSpacing.s32),

        const Text('Radius', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Wrap(
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            for (final (name, value) in _radii)
              Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppSemantic.bgSecondary,
                      borderRadius: BorderRadius.circular(value),
                      border: Border.all(color: AppSemantic.border),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s4),

                  Text('$name · ${value.toInt()}',
                      style: AppTypography.caption1),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
