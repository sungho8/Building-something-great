import 'package:design_system/design_system.dart'
    show AppSpacing, AppTypography;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/quit_providers.dart';
import '../../domain/entities/quit_item.dart';
import '../../theme/ui_theme.dart';
import '../../theme/ui_widgets.dart';
import '../quit_type_style.dart';

const _typeLabels = {
  QuitType.smoking: '담배',
  QuitType.drinking: '술',
  QuitType.custom: '직접',
};

/// 끊기 목표 수정 폼 (별도 페이지). 다시 시작·삭제 포함.
class QuitEditView extends ConsumerStatefulWidget {
  const QuitEditView({super.key, required this.item});

  final QuitItem item;

  @override
  ConsumerState<QuitEditView> createState() => _QuitEditViewState();
}

class _QuitEditViewState extends ConsumerState<QuitEditView> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _unitsCtrl;
  late QuitType _type;
  late DateTime _quitDate;

  @override
  void initState() {
    super.initState();
    final it = widget.item;
    _nameCtrl = TextEditingController(text: it.name);
    _costCtrl = TextEditingController(text: it.dailyCost.toString());
    _unitsCtrl = TextEditingController(
        text: it.dailyUnits == 0 ? '' : _trim(it.dailyUnits));
    _type = it.type;
    _quitDate = it.quitDate;
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _costCtrl.dispose();
    _unitsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _quitDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_quitDate));
    if (!mounted) return;
    final t = time ?? TimeOfDay.fromDateTime(_quitDate);
    setState(() => _quitDate =
        DateTime(date.year, date.month, date.day, t.hour, t.minute));
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _toast('이름을 입력해주세요');
      return;
    }
    final item = widget.item.copyWith(
      name: name,
      type: _type,
      quitDate: _quitDate,
      dailyCost: int.tryParse(_costCtrl.text.trim()) ?? 0,
      dailyUnits: double.tryParse(_unitsCtrl.text.trim()) ?? 0,
      unitLabel: QuitTypeStyle.unitLabel(_type),
    );
    await ref.read(quitListProvider.notifier).save(item);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _reset() async {
    final ok = await _confirm(
      title: '다시 시작할까요?',
      message: '카운터가 0으로 초기화돼요. 최고 기록은 그대로 남아요.',
      confirmLabel: '다시 시작',
    );
    if (ok != true) return;
    await ref.read(quitListProvider.notifier).reset(widget.item.id);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final ok = await _confirm(
      title: '삭제할까요?',
      message: '«${widget.item.name}»을(를) 삭제합니다.',
      confirmLabel: '삭제',
      destructive: true,
    );
    if (ok != true) return;
    await ref.read(quitListProvider.notifier).remove(widget.item.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<bool?> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) {
    final c = UiColors.of(context);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(title,
            style: AppTypography.title3.copyWith(color: c.textPrimary)),
        content: Text(message,
            style: AppTypography.body2.copyWith(color: c.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('취소',
                style: AppTypography.label2.copyWith(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel,
                style: AppTypography.label2.copyWith(
                    color: destructive ? const Color(0xFFEB5757) : c.accent)),
          ),
        ],
      ),
    );
  }

  void _toast(String message) {
    final c = UiColors.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceAlt,
        content: Text(message,
            style: AppTypography.body2.copyWith(color: c.textPrimary)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('수정'),
        actions: [
          IconButton(
            onPressed: _delete,
            icon: Icon(Icons.delete_outline, color: c.textSecondary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.s20, AppSpacing.s16, AppSpacing.s20, AppSpacing.s32),
        children: [
          const UiSectionLabel('이름'),
          UiTextField(controller: _nameCtrl, hint: '예: 담배'),
          const SizedBox(height: AppSpacing.s20),

          const UiSectionLabel('종류'),
          UiSegmented<QuitType>(
            value: _type,
            onChanged: (v) => setState(() => _type = v),
            segments: [
              for (final t in QuitType.values)
                UiSegment(value: t, label: _typeLabels[t]!),
            ],
          ),
          const SizedBox(height: AppSpacing.s20),

          const UiSectionLabel('끊은 시점'),
          UiTile(
            icon: Icons.event_rounded,
            title: '시작',
            value: _fmt(_quitDate),
            onTap: _pickDateTime,
          ),
          const SizedBox(height: AppSpacing.s20),

          const UiSectionLabel('하루 비용'),
          UiTextField(
            controller: _costCtrl,
            prefixText: '₩ ',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: AppSpacing.s20),

          UiSectionLabel('하루 소비량 (${QuitTypeStyle.unitLabel(_type)})'),
          UiTextField(
            controller: _unitsCtrl,
            suffixText: QuitTypeStyle.unitLabel(_type),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: AppSpacing.s32),

          UiButton(label: '저장', icon: Icons.check, onPressed: _save),
          const SizedBox(height: AppSpacing.s12),
          UiButton(
            label: '다시 시작 (리셋)',
            icon: Icons.refresh_rounded,
            filled: false,
            onPressed: _reset,
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
