import 'package:flutter/material.dart';

/// 모든 화면의 기본 Scaffold.
///
/// body를 [SafeArea]로 감싸 하단 시스템 내비게이션/제스처 영역에 UI가 가려지는 것을
/// 막는다. 화면마다 SafeArea를 두지 않고 여기서 한 번에 처리한다.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        // appBar가 있으면 상단 inset은 appBar가 처리하므로 top은 제외.
        top: appBar == null,
        // 하단 내비게이션이 있으면 하단 inset은 그쪽이 처리.
        bottom: bottomNavigationBar == null,
        child: body,
      ),
    );
  }
}
