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

        const Text('FadeSlideIn — 등장 모션', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const _FadeSlideDemo(),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppTextField', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const AppTextField(
          label: '제목',
          hint: '예: 수능, 결혼기념일',
          prefixIcon: Icons.edit_outlined,
        ),

        const SizedBox(height: AppSpacing.s12),

        const AppTextField(
          label: '이메일',
          hint: 'you@example.com',
          errorText: '이메일 형식이 아니에요',
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppChip', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const _ChipDemo(),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppListTile', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            children: [
              AppListTile(
                leadingIcon: Icons.notifications_outlined,
                leadingColor: Theme.of(context).colorScheme.primary,
                title: '알림 설정',
                subtitle: '당일 오전 9시',
                onTap: () {},
              ),

              const Divider(height: 1),

              AppListTile(
                leadingIcon: Icons.palette_outlined,
                title: '테마',
                trailing: const AppBadge(text: 'NEW'),
                onTap: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppBadge', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            AppBadge(text: 'tint'),
            AppBadge(text: 'fill', variant: AppBadgeVariant.fill),
            AppBadge(text: 'outline', variant: AppBadgeVariant.outline),
            AppBadge(text: '성공', color: AppGreen.s500),
            AppBadge(text: '경고', color: AppOrange.s600),
            AppBadge(text: '오류', color: AppRed.s500),
          ],
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppSectionTitle', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        AppSectionTitle(
          text: '최근 항목',
          trailing: AppButton(
            label: '전체보기',
            size: AppButtonSize.xs,
            variant: AppButtonVariant.tertiary,
            onPressed: () {},
          ),
        ),

        const SizedBox(height: AppSpacing.s24),

        const Text('AppEmptyState', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Container(
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: AppSemantic.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: AppEmptyState(
            icon: Icons.inbox_outlined,
            title: '아직 비어 있어요',
            description: '첫 항목을 추가해보세요',
            action: AppButton(
              label: '추가하기',
              size: AppButtonSize.sm,
              onPressed: () {},
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('Dialog · BottomSheet · SnackBar',
            style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            AppButton(
              label: 'Dialog',
              size: AppButtonSize.sm,
              variant: AppButtonVariant.secondary,
              onPressed: () => showAppDialog(
                context,
                title: '삭제할까요?',
                message: '이 동작은 되돌릴 수 없어요.',
                confirmLabel: '삭제',
                cancelLabel: '취소',
                destructive: true,
              ),
            ),
            AppButton(
              label: 'BottomSheet',
              size: AppButtonSize.sm,
              variant: AppButtonVariant.secondary,
              onPressed: () => showAppBottomSheet(
                context,
                title: '옵션 선택',
                child: Column(
                  children: [
                    AppListTile(
                      leadingIcon: Icons.share_outlined,
                      title: '공유',
                      onTap: () => Navigator.pop(context),
                    ),
                    AppListTile(
                      leadingIcon: Icons.delete_outline,
                      leadingColor: AppRed.s500,
                      title: '삭제',
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
            AppButton(
              label: 'SnackBar',
              size: AppButtonSize.sm,
              variant: AppButtonVariant.secondary,
              onPressed: () => showAppSnackBar(
                context,
                '저장했어요',
                variant: AppSnackBarVariant.success,
                actionLabel: '실행취소',
                onAction: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('ColorPicker · EmojiPicker (BottomSheet)',
            style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const _PickerSheetDemo(),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppSegmentedControl', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const _SegmentedDemo(),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppCheckbox · AppRadioGroup', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const _SelectionDemo(),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppDropdown', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const _DropdownDemo(),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppAvatar', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        Row(
          children: [
            const AppAvatar(icon: Icons.person, size: 48),
            const SizedBox(width: AppSpacing.s12),
            AppAvatar(
              initials: 'SH',
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.s12),
            const AppAvatar(initials: '박', size: 48, color: AppGreen.s500),
            const SizedBox(width: AppSpacing.s12),
            const AppAvatar(initials: 'A', size: 40, color: AppOrange.s600),
            const SizedBox(width: AppSpacing.s12),
            const AppAvatar(initials: 'B', size: 32, color: AppBlue.s500),
          ],
        ),

        const SizedBox(height: AppSpacing.s32),

        const Text('AppLoading', style: AppTypography.heading1),

        const SizedBox(height: AppSpacing.s12),

        const SizedBox(height: 80, child: AppLoading(message: '불러오는 중…')),

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

/// AppSegmentedControl 데모.
class _SegmentedDemo extends StatefulWidget {
  const _SegmentedDemo();

  @override
  State<_SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<_SegmentedDemo> {
  // 선택된 세그먼트
  String _value = 'day';

  @override
  Widget build(BuildContext context) {
    return AppSegmentedControl<String>(
      value: _value,
      onChanged: (v) => setState(() => _value = v),
      segments: const [
        AppSegment(value: 'day', label: '일'),
        AppSegment(value: 'week', label: '주'),
        AppSegment(value: 'month', label: '월'),
      ],
    );
  }
}

/// AppCheckbox + AppRadioGroup 데모.
class _SelectionDemo extends StatefulWidget {
  const _SelectionDemo();

  @override
  State<_SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<_SelectionDemo> {
  // 체크 여부
  bool _checked = true;

  // 라디오 선택값
  String _radio = 'onday';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCheckbox(
          value: _checked,
          label: '약관에 동의합니다',
          onChanged: (v) => setState(() => _checked = v),
        ),

        const SizedBox(height: AppSpacing.s8),

        AppRadioGroup<String>(
          groupValue: _radio,
          onChanged: (v) => setState(() => _radio = v),
          options: const [
            AppRadioOption(
                value: 'onday', label: '당일', description: '이벤트 당일 오전 9시'),
            AppRadioOption(
                value: 'before', label: '1일 전', description: '하루 전 미리 알림'),
            AppRadioOption(value: 'none', label: '안 함'),
          ],
        ),
      ],
    );
  }
}

/// AppDropdown 데모.
class _DropdownDemo extends StatefulWidget {
  const _DropdownDemo();

  @override
  State<_DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<_DropdownDemo> {
  // 선택된 값
  String? _value = 'kr';

  @override
  Widget build(BuildContext context) {
    return AppDropdown<String>(
      label: '지역',
      value: _value,
      onChanged: (v) => setState(() => _value = v),
      items: const [
        AppDropdownItem(value: 'kr', label: '대한민국', icon: Icons.flag_outlined),
        AppDropdownItem(value: 'us', label: '미국', icon: Icons.flag_outlined),
        AppDropdownItem(value: 'jp', label: '일본', icon: Icons.flag_outlined),
      ],
    );
  }
}

/// AppChip 다중 선택 데모.
class _ChipDemo extends StatefulWidget {
  const _ChipDemo();

  @override
  State<_ChipDemo> createState() => _ChipDemoState();
}

class _ChipDemoState extends State<_ChipDemo> {
  // 선택된 라벨 집합
  final _selected = <String>{'당일'};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        for (final label in ['당일', '1일 전', '7일 전'])
          AppChip(
            label: label,
            selected: _selected.contains(label),
            onTap: () => setState(() {
              _selected.contains(label)
                  ? _selected.remove(label)
                  : _selected.add(label);
            }),
          ),
        AppChip(
          label: '아이콘',
          leadingIcon: Icons.star_outline,
          size: AppChipSize.sm,
          onTap: () {},
        ),
      ],
    );
  }
}

/// FadeSlideIn 순차 등장을 재생 버튼으로 반복 확인.
class _FadeSlideDemo extends StatefulWidget {
  const _FadeSlideDemo();

  @override
  State<_FadeSlideDemo> createState() => _FadeSlideDemoState();
}

class _FadeSlideDemoState extends State<_FadeSlideDemo> {
  // 재생마다 key를 바꿔 모션을 다시 트리거
  int _round = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: FadeSlideIn(
              key: ValueKey('$_round-$i'),
              index: i,
              child: AppCard(
                child: Text('순차 등장 ${i + 1}', style: AppTypography.body2),
              ),
            ),
          ),

        const SizedBox(height: AppSpacing.s4),

        AppButton(
          label: '다시 재생',
          size: AppButtonSize.sm,
          variant: AppButtonVariant.secondary,
          leadingIcon: Icons.replay,
          onPressed: () => setState(() => _round++),
        ),
      ],
    );
  }
}

/// ColorPicker · EmojiPicker 바텀시트 데모.
class _PickerSheetDemo extends StatefulWidget {
  const _PickerSheetDemo();

  @override
  State<_PickerSheetDemo> createState() => _PickerSheetDemoState();
}

class _PickerSheetDemoState extends State<_PickerSheetDemo> {
  // 선택된 색 (null이면 기본)
  Color? _color;

  // 선택된 이모지 (빈 문자열이면 없음)
  String _emoji = '';

  static const _colorPresets = <Color>[
    AppBlue.s500,
    AppGreen.s500,
    AppOrange.s600,
    AppRed.s500,
  ];

  static const _emojiPresets = ['🎉', '💰', '📌', '⭐', '🔥'];

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final picked = await showAppColorPickerSheet(
                context,
                presets: _colorPresets,
                selected: _color ?? brand,
              );
              if (picked != null) setState(() => _color = picked);
            },
            icon: AppColorSwatch(color: _color ?? brand, size: 20),
            label: const Text('색상 선택'),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final picked = await showAppEmojiPickerSheet(
                context,
                presets: _emojiPresets,
                selected: _emoji,
              );
              if (picked != null) setState(() => _emoji = picked);
            },
            icon: Text(_emoji.isEmpty ? '🙂' : _emoji),
            label: const Text('이모지 선택'),
          ),
        ),
      ],
    );
  }
}
