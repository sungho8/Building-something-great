import 'package:home_widget/home_widget.dart';

import '../domain/entities/quit_item.dart';
import '../utils/format.dart';

/// 홈 위젯에 대표 목표의 D+ 일수 + 절약액을 노출한다.
/// 위젯 미지원/테스트 환경에서는 조용히 무시.
Future<void> syncHomeWidget(List<QuitItem> items) async {
  try {
    if (items.isEmpty) {
      await HomeWidget.saveWidgetData<String>('quit_title', '끊기 시작하기');
      await HomeWidget.saveWidgetData<String>('quit_days', '+0');
      await HomeWidget.saveWidgetData<String>('quit_saved', '하루더');
    } else {
      final sorted = [...items]..sort((a, b) => a.quitDate.compareTo(b.quitDate));
      final p = sorted.first;
      await HomeWidget.saveWidgetData<String>('quit_title', p.name);
      await HomeWidget.saveWidgetData<String>('quit_days', '+${p.daysSince}');
      await HomeWidget.saveWidgetData<String>(
          'quit_saved', '${formatWon(p.moneySaved)} 절약');
    }
    await HomeWidget.updateWidget(
      androidName: 'QuitWidgetProvider',
      iOSName: 'QuitWidget',
    );
  } catch (_) {
    // 위젯이 없거나 테스트 환경이면 무시.
  }
}
