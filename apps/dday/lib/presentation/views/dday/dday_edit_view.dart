import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';
import '../../../domain/entities/dday_item.dart';
import '../../../utils/date_format.dart';

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

  // 선택된 날짜
  late DateTime _date;

  // 편집 모드 여부
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

  // 날짜 선택 다이얼로그
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  // 저장 (신규 추가 또는 수정)
  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    final viewModel = ref.read(ddayListProvider.notifier);
    if (_isEditing) {
      await viewModel.update(widget.item!.copyWith(title: title, date: _date));
    } else {
      await viewModel.add(title: title, date: _date);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // 삭제
  Future<void> _delete() async {
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

            AppButton(
              label: '저장',
              leadingIcon: Icons.check,
              expand: true,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
