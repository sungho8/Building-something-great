import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';

/// 이모지 선택 바텀시트. 프리셋 그리드 + "직접 입력"(시스템 이모지 키보드)으로
/// 임의 이모지 지정. 빈 문자열을 선택하면 "없음"을 의미한다.
///
/// 반환값 null이면 취소, 빈 문자열이면 선택 해제.
Future<String?> showAppEmojiPickerSheet(
  BuildContext context, {
  required List<String> presets,
  String? selected,
}) {
  return showAppBottomSheet<String>(
    context,
    title: '이모지 선택',
    child: _EmojiPickerSheetBody(presets: presets, initial: selected ?? ''),
  );
}

class _EmojiPickerSheetBody extends StatefulWidget {
  const _EmojiPickerSheetBody({required this.presets, required this.initial});

  final List<String> presets;
  final String initial;

  @override
  State<_EmojiPickerSheetBody> createState() => _EmojiPickerSheetBodyState();
}

class _EmojiPickerSheetBodyState extends State<_EmojiPickerSheetBody> {
  late String _selected = widget.initial;
  late final _customController = TextEditingController(
    text: widget.presets.contains(widget.initial) ? '' : widget.initial,
  );

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            _EmojiTile(
              selected: _selected.isEmpty,
              onTap: () => setState(() {
                _selected = '';
                _customController.clear();
              }),
              child: const Icon(Icons.block,
                  size: 18, color: AppSemantic.textTertiary),
            ),
            for (final emoji in widget.presets)
              _EmojiTile(
                selected: _selected == emoji,
                onTap: () => setState(() {
                  _selected = emoji;
                  _customController.clear();
                }),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.s20),

        Text(
          '직접 입력',
          style: AppTypography.descriptionSub
              .copyWith(color: AppSemantic.textSecondary),
        ),

        const SizedBox(height: AppSpacing.s8),

        TextField(
          controller: _customController,
          maxLength: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22),
          keyboardType: TextInputType.text,
          inputFormatters: [LengthLimitingTextInputFormatter(2)],
          decoration: const InputDecoration(
            counterText: '',
            hintText: '키보드의 이모지 버튼으로 원하는 이모지를 입력하세요',
            hintStyle: TextStyle(fontSize: 13),
          ),
          onChanged: (v) => setState(() => _selected = v.trim()),
        ),

        const SizedBox(height: AppSpacing.s24),

        AppButton(
          label: '선택 완료',
          expand: true,
          onPressed: () => Navigator.of(context).pop(_selected),
        ),
      ],
    );
  }
}

class _EmojiTile extends StatelessWidget {
  const _EmojiTile({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.12) : AppCommon.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? accent : AppSemantic.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
