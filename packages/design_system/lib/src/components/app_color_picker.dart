import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';

/// 원형 색상 스와치. 프리셋 그리드·선택 버튼 공용.
class AppColorSwatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final double size;

  const AppColorSwatch({
    super.key,
    required this.color,
    this.selected = false,
    this.onTap,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppSemantic.border),
        ),
        child: selected
            ? Icon(Icons.check, color: _onColor(color), size: size * 0.55)
            : null,
      ),
    );
  }

  // 배경색 명도에 따라 체크 아이콘을 흰/검정으로.
  static Color _onColor(Color bg) =>
      bg.computeLuminance() > 0.6 ? AppGrey.s900 : AppCommon.white;
}

/// 색상 선택 바텀시트. 프리셋 그리드 + "직접 선택"(HSV 휠)으로 임의 색상 지정.
///
/// [presets]가 비어 있지 않아야 한다. 반환값 null이면 취소.
Future<Color?> showAppColorPickerSheet(
  BuildContext context, {
  required List<Color> presets,
  Color? selected,
}) {
  return showAppBottomSheet<Color>(
    context,
    title: '색상 선택',
    child: _ColorPickerSheetBody(presets: presets, initial: selected),
  );
}

class _ColorPickerSheetBody extends StatefulWidget {
  const _ColorPickerSheetBody({required this.presets, this.initial});

  final List<Color> presets;
  final Color? initial;

  @override
  State<_ColorPickerSheetBody> createState() => _ColorPickerSheetBodyState();
}

class _ColorPickerSheetBodyState extends State<_ColorPickerSheetBody> {
  // 현재 미리보기 색 (직접 선택 모드에서 실시간 반영)
  late Color _preview = widget.initial ?? widget.presets.first;

  // 직접 선택(HSV 휠) 펼침 여부
  bool _customOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            for (final color in widget.presets)
              AppColorSwatch(
                color: color,
                selected: !_customOpen && _preview.toARGB32() == color.toARGB32(),
                onTap: () => setState(() {
                  _customOpen = false;
                  _preview = color;
                }),
              ),
            _CustomSwatchButton(
              active: _customOpen,
              onTap: () => setState(() => _customOpen = true),
            ),
          ],
        ),

        if (_customOpen) ...[
          const SizedBox(height: AppSpacing.s20),
          ColorPicker(
            pickerColor: _preview,
            onColorChanged: (c) => setState(() => _preview = c),
            enableAlpha: false,
            labelTypes: const [],
            pickerAreaHeightPercent: 0.7,
            displayThumbColor: true,
          ),
        ],

        const SizedBox(height: AppSpacing.s24),

        AppButton(
          label: '선택 완료',
          expand: true,
          color: _preview,
          onPressed: () => Navigator.of(context).pop(_preview),
        ),
      ],
    );
  }
}

/// "직접 선택" 진입 버튼 (무지개 그라디언트 원).
class _CustomSwatchButton extends StatelessWidget {
  const _CustomSwatchButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [
              Color(0xFFFF0000),
              Color(0xFFFFFF00),
              Color(0xFF00FF00),
              Color(0xFF00FFFF),
              Color(0xFF0000FF),
              Color(0xFFFF00FF),
              Color(0xFFFF0000),
            ],
          ),
          border: Border.all(
            color: active ? AppGrey.s900 : AppSemantic.border,
            width: active ? 2 : 1,
          ),
        ),
        child: const Icon(Icons.colorize, color: AppCommon.white, size: 16),
      ),
    );
  }
}
