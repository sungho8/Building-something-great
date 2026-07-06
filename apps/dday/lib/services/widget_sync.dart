import 'package:home_widget/home_widget.dart';

import '../domain/entities/dday_item.dart';

/// 홈 위젯에 최상단(고정 우선·가장 임박) D-Day를 노출한다.
///
/// 목록이 바뀔 때마다 호출. 위젯 미지원/테스트 환경에서는 조용히 무시한다.
Future<void> syncHomeWidget(List<DDayItem> items) async {
  try {
    if (items.isEmpty) {
      await HomeWidget.saveWidgetData<String>('dday_title', '등록된 D-Day 없음');
      await HomeWidget.saveWidgetData<String>('dday_label', '+');
    } else {
      final top = items.first;
      final title =
          top.emoji.isEmpty ? top.title : '${top.emoji} ${top.title}';
      await HomeWidget.saveWidgetData<String>('dday_title', title);
      await HomeWidget.saveWidgetData<String>('dday_label', top.label);
    }
    await HomeWidget.updateWidget(
      androidName: 'DDayWidgetProvider',
      iOSName: 'DDayWidget',
    );
  } catch (_) {
    // 위젯이 없거나 테스트 환경이면 무시.
  }
}
