import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 공용 컴포넌트 갤러리.
///
/// design_system에 컴포넌트가 추가될 때마다 여기에 섹션을 추가한다.
class ComponentsView extends StatelessWidget {
  const ComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      children: [
        const Text('AppButton — Variant', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            AppButton(label: 'Primary', onPressed: () {}),
            AppButton(
              label: 'Secondary',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            AppButton(
              label: 'Tertiary',
              variant: AppButtonVariant.tertiary,
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppButton — Size', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(label: 'lg 48', onPressed: () {}),
            AppButton(
                label: 'md 42', size: AppButtonSize.md, onPressed: () {}),
            AppButton(
                label: 'sm 36', size: AppButtonSize.sm, onPressed: () {}),
            AppButton(
                label: 'xs 32', size: AppButtonSize.xs, onPressed: () {}),
          ],
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppButton — State · Icon', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            const AppButton(label: 'Disabled'),
            const AppButton(
                label: 'Disabled', variant: AppButtonVariant.secondary),
            AppButton(
                label: '추가', leadingIcon: Icons.add, onPressed: () {}),
            AppButton(
              label: '다음',
              trailingIcon: Icons.arrow_forward,
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s16),

        AppButton(label: 'Expand 버튼', expand: true, onPressed: () {}),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppCard', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('카드 제목', style: AppTypography.heading2),

              SizedBox(height: AppSpacing.s6),

              Text(
                '흰 카드 + 얇은 구분선 테두리. 배경 위에서 위계를 만든다.',
                style: AppTypography.body3,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.s32),

        Text(
          '새 공용 컴포넌트를 만들면 이 화면에 섹션을 추가한다.',
          style: AppTypography.caption1
              .copyWith(color: AppSemantic.textTertiary),
        ),
      ],
    );
  }
}
