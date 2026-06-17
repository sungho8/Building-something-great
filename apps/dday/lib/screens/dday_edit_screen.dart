import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dday_item.dart';
import '../providers/dday_providers.dart';
import '../utils/date_format.dart';

/// D-Day 추가/편집 화면. item이 null이면 신규.
class DDayEditScreen extends ConsumerStatefulWidget {
  const DDayEditScreen({super.key, this.item});

  final DDayItem? item;

  @override
  ConsumerState<DDayEditScreen> createState() => _DDayEditScreenState();
}

class _DDayEditScreenState extends ConsumerState<DDayEditScreen> {
  late final TextEditingController _titleController;
  late DateTime _date;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _date = widget.item?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    final notifier = ref.read(ddayListProvider.notifier);
    if (_isEditing) {
      await notifier.update(widget.item!.copyWith(title: title, date: _date));
    } else {
      await notifier.add(DDayItem.create(title: title, date: _date));
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref.read(ddayListProvider.notifier).remove(widget.item!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: '제목',
                hintText: '예: 수능, 결혼기념일',
                border: OutlineInputBorder(),
              ),
            ),
            AppSpacing.gapLg,
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('날짜'),
                subtitle: Text(formatDdayDate(_date)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),
            ),
            const Spacer(),
            AppButton(label: '저장', icon: Icons.check, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
