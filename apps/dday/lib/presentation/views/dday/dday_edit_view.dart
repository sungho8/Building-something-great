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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제할까요?'),
        content: Text('«${widget.item!.title}»을(를) 삭제합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
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
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.done,
            style: AppTypography.body1,
            decoration: const InputDecoration(
              labelText: '제목',
              hintText: '예: 수능, 결혼기념일',
            ),
          ),

          const SizedBox(height: AppSpacing.s20),

          _EmojiPicker(
            selected: _emoji,
            onSelected: (e) => setState(() => _emoji = e),
          ),

          const SizedBox(height: AppSpacing.s20),

          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('날짜'),
              subtitle: Text(formatDdayDate(_date)),
              trailing: const Icon(Icons.chevron_right),
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

          Text(
            '알림',
            style: AppTypography.sectionTitle
                .copyWith(color: AppSemantic.textSecondary),
          ),

          const SizedBox(height: AppSpacing.s8),

          Wrap(
            spacing: AppSpacing.s8,
            children: [
              for (final r in DdayReminder.values)
                FilterChip(
                  label: Text(_reminderLabels[r]!),
                  selected: _reminders.contains(r),
                  onSelected: (on) => setState(() {
                    if (on) {
                      _reminders.add(r);
                    } else {
                      _reminders.remove(r);
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
