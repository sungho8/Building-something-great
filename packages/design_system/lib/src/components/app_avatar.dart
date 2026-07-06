import 'package:flutter/material.dart';

import '../tokens/typography.dart';

/// 원형 아바타. 이미지 > 이니셜 > 아이콘 순으로 표시.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final double size;

  /// 이니셜·아이콘 색. null이면 테마 primary.
  final Color? color;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    final Widget content;
    if (imageUrl != null) {
      content = Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(accent),
      );
    } else {
      content = _fallback(accent);
    }

    return ClipOval(
      child: SizedBox(width: size, height: size, child: content),
    );
  }

  // 이니셜 또는 아이콘 (틴트 배경)
  Widget _fallback(Color accent) {
    return Container(
      color: accent.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: initials != null
          ? Text(
              initials!,
              style: AppTypography.itemTitle.copyWith(
                color: accent,
                fontSize: size * 0.38,
              ),
            )
          : Icon(icon ?? Icons.person, color: accent, size: size * 0.5),
    );
  }
}
