import 'package:flutter/material.dart';

/// 브랜드 무지한 기본 버튼.
///
/// 색·모서리·패딩은 모두 `Theme.of(context)`에서 자동으로 가져온다.
/// 즉 어느 앱에 놓이느냐에 따라 외모가 달라진다.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}
