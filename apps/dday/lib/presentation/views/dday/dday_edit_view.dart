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

/// 색상 프리셋 (ARGB). 첫 스와치는 '기본(브랜드색)' = null이라 여기엔 없음.
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
    _reminders = {...?item?.reminders} ;
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

          const SizedBox(height: AppSpacing.s20),

          _EmojiPicker(
            selected: _emoji,
            onSelected: (e) => setState(() => _emoji = e),
          ),

          const SizedBox(height: AppSpacing.s16),

          _ColorPicker(
            selected: _colorValue,
            onSelected: (c) => setState(() => _colorValue = c),
          ),

          const SizedBox(height: AppSpacing.s20),

          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: AppListTile(
              leadingIcon: Icons.calendar_today_outlined,
              title: '날짜',
              subtitle: formatDdayDate(_date),
              onTap: _pickDate,
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _repeatYearly,
                  onChanged: (v) => setState(() => _repeatYearly = v),
                  title: const Text('매년 반복'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _includeStartDay,
                  onChanged: (v) => setState(() => _includeStartDay = v),
                  title: const Text('시작일 포함'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _pinned,
                  onChanged: (v) => setState(() => _pinned = v),
                  title: const Text('고정'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s20),

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

/// 이모지 선택 가로 목록 (없음 포함).
class _EmojiPicker extends StatelessWidget {
  const _EmojiPicker({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _EmojiChip(
            label: const Icon(Icons.block, size: 18),
            active: selected.isEmpty,
            onTap: () => onSelected(''),
            scheme: scheme,
          ),
          for (final e in _emojiPresets)
            _EmojiChip(
              label: Text(e, style: const TextStyle(fontSize: 20)),
              active: selected == e,
              onTap: () => onSelected(e),
              scheme: scheme,
            ),
        ],
      ),
    );
  }
}

class _EmojiChip extends StatelessWidget {
  const _EmojiChip({
    required this.label,
    required this.active,
    required this.onTap,
    required this.scheme,
  });

  final Widget label;
  final bool active;
  final VoidCallback onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s8),
      child: Material(
        color: active ? scheme.primary.withValues(alpha: 0.12) : AppCommon.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: active ? scheme.primary : AppSemantic.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(width: 44, child: Center(child: label)),
        ),
      ),
    );
  }
}

/// 색상 선택 가로 목록. 첫 스와치는 '기본(브랜드색)' = null.
class _ColorPicker extends StatelessWidget {
  const _ColorPicker({required this.selected, required this.onSelected});

  final int? selected;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Swatch(
            color: brand,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final value in _colorPresets)
            _Swatch(
              color: Color(value),
              selected: selected == value,
              onTap: () => onSelected(value),
            ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: selected
              ? const Icon(Icons.check, color: AppCommon.white, size: 20)
              : null,
        ),
      ),
    );
  }
}
