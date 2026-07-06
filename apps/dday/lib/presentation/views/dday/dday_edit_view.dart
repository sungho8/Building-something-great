import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';
import '../../../domain/entities/dday_item.dart';
import '../../../utils/date_format.dart';

/// 이모지 프리셋
const _emojiPresets = [
  '🎂', '💍', '✈️', '🎓', '🎉', '❤️', '📚', '🏃', '💼', '🐣', //
];

/// 색상 프리셋. 첫 스와치는 화면에서 '기본(브랜드색)'으로 별도 표시.
const _colorPresets = <int>[
  0xFF3182F6, // blue
  0xFF02BC70, // green
  0xFFF98C0E, // orange
  0xFF7E5BEF, // purple
  0xFFF04452, // red
  0xFF06B4C9, // teal
  0xFFEF5DA8, // pink
  0xFF8B95A1, // grey
];

/// 알림 시점 라벨
const _reminderLabels = {
  DdayReminder.onDay: '당일',
  DdayReminder.dayBefore: '1일 전',
  DdayReminder.weekBefore: '7일 전',
};

/// D-Day 추가/편집 화면. item이 null이면 신규.
class DDayEditView extends ConsumerStatefulWidget {
  const DDayEditView({super.key, this.item});

  final DDayItem? item;

  @override
  ConsumerState<DDayEditView> createState() => _DDayEditViewState();
}

class _DDayEditViewState extends ConsumerState<DDayEditView> {
  // 제목 입력 컨트롤러
  late final TextEditingController _titleController;

  late DateTime _date;
  late String _emoji;
  late int? _colorValue;
  late bool _repeatYearly;
  late bool _includeStartDay;
  late bool _pinned;
  late Set<DdayReminder> _reminders;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _date = item?.date ?? DateTime.now();
    _emoji = item?.emoji ?? '';
    _colorValue = item?.colorValue;
    _repeatYearly = item?.repeatYearly ?? false;
    _includeStartDay = item?.includeStartDay ?? false;
    _pinned = item?.pinned ?? false;
    _reminders = {...?item?.reminders};
    if (item == null) _reminders = {DdayReminder.onDay};
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // 날짜 선택
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  // 이모지 선택 바텀시트
  Future<void> _pickEmoji() async {
    final picked = await showAppEmojiPickerSheet(
      context,
      presets: _emojiPresets,
      selected: _emoji,
    );
    if (picked != null) setState(() => _emoji = picked);
  }

  // 색상 선택 바텀시트
  Future<void> _pickColor() async {
    final brand = Theme.of(context).colorScheme.primary;
    final current = _colorValue == null ? brand : Color(_colorValue!);
    final picked = await showAppColorPickerSheet(
      context,
      presets: [brand, for (final v in _colorPresets) Color(v)],
      selected: current,
    );
    if (picked == null) return;
    setState(() {
      _colorValue = picked.toARGB32() == brand.toARGB32() ? null : picked.toARGB32();
    });
  }

  // 저장
  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showAppSnackBar(context, '제목을 입력해주세요',
          variant: AppSnackBarVariant.error);
      return;
    }

    final base = widget.item;
    final item = (base ??
            DDayItem(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: title,
              date: _date,
              createdAt: DateTime.now(),
            ))
        .copyWith(
      title: title,
      date: _date,
      emoji: _emoji,
      colorValue: _colorValue,
      repeatYearly: _repeatYearly,
      includeStartDay: _includeStartDay,
      pinned: _pinned,
      reminders: _reminders.toList()..sort((a, b) => a.index - b.index),
    );

    await ref.read(ddayListProvider.notifier).save(item);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // 삭제 (확인 후)
  Future<void> _delete() async {
    final ok = await showAppDialog(
      context,
      title: '삭제할까요?',
      message: '«${widget.item!.title}»을(를) 삭제합니다.',
      confirmLabel: '삭제',
      cancelLabel: '취소',
      destructive: true,
    );
    if (ok != true || !mounted) return;
    await ref.read(ddayListProvider.notifier).remove(widget.item!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).colorScheme.primary;
    final swatchColor = _colorValue == null ? brand : Color(_colorValue!);

    return AppScaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '편집' : '새 D-Day'),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s20,
          AppSpacing.s20,
          AppSpacing.s32,
        ),
        children: [
          AppTextField(
            controller: _titleController,
            label: '제목',
            hint: '예: 수능, 결혼기념일',
            textInputAction: TextInputAction.done,
          ),

          const SizedBox(height: AppSpacing.s16),

          // 이모지·색상 선택 버튼 (탭하면 바텀시트)
          Row(
            children: [
              Expanded(
                child: _PickerButton(
                  label: '이모지',
                  onTap: _pickEmoji,
                  child: _emoji.isEmpty
                      ? const Icon(Icons.mood_outlined,
                          color: AppSemantic.textTertiary)
                      : Text(_emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _PickerButton(
                  label: '색상',
                  onTap: _pickColor,
                  child: AppColorSwatch(color: swatchColor, size: 22),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s20),

          AppListTile(
            leadingIcon: Icons.calendar_today_outlined,
            title: '날짜',
            subtitle: formatDdayDate(_date),
            onTap: _pickDate,
          ),

          const Divider(height: AppSpacing.s20),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _repeatYearly,
            onChanged: (v) => setState(() => _repeatYearly = v),
            title: const Text('매년 반복'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _includeStartDay,
            onChanged: (v) => setState(() => _includeStartDay = v),
            title: const Text('시작일 포함'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _pinned,
            onChanged: (v) => setState(() => _pinned = v),
            title: const Text('고정'),
          ),

          const SizedBox(height: AppSpacing.s12),

          const AppSectionTitle(text: '알림'),

          Wrap(
            spacing: AppSpacing.s8,
            children: [
              for (final r in DdayReminder.values)
                AppChip(
                  label: _reminderLabels[r]!,
                  selected: _reminders.contains(r),
                  onTap: () => setState(() {
                    if (_reminders.contains(r)) {
                      _reminders.remove(r);
                    } else {
                      _reminders.add(r);
                    }
                  }),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.s32),

          AppButton(
            label: '저장',
            leadingIcon: Icons.check,
            expand: true,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

/// 이모지/색상 선택 버튼. 라벨 + 현재 값 미리보기 + chevron.
class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.label,
    required this.child,
    required this.onTap,
  });

  final String label;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        decoration: BoxDecoration(
          border: Border.all(color: AppSemantic.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            child,
            const SizedBox(width: AppSpacing.s8),
            Text(label, style: AppTypography.body2),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 18, color: AppGrey.s400),
          ],
        ),
      ),
    );
  }
}
