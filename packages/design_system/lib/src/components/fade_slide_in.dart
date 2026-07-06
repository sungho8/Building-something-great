import 'package:flutter/widgets.dart';

/// 마운트 시 아래→위 슬라이드 + 페이드 인 등장 모션.
///
/// [index]를 주면 리스트에서 순차(stagger) 등장한다. 스크롤 성능을 위해
/// 지연은 8번째 항목까지만 벌어진다.
class FadeSlideIn extends StatelessWidget {
  final Widget child;

  /// 리스트 내 순번. 0부터.
  final int index;

  const FadeSlideIn({super.key, required this.child, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + index.clamp(0, 8) * 40),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - t)),
          child: child,
        ),
      ),
    );
  }
}
