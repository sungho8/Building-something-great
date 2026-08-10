import 'package:home_widget/home_widget.dart';

import '../domain/entities/subscription.dart';
import '../utils/currency_format.dart';

/// 홈 위젯에 이번 달 총액 + 가장 임박한 결제를 노출한다.
/// 위젯 미지원/테스트 환경에서는 조용히 무시한다. (네이티브 위젯은 후속 작업)
Future<void> syncHomeWidget(List<Subscription> items) async {
  try {
    final active = items.where((s) => s.active).toList();
    final total =
        active.fold<double>(0, (sum, s) => sum + s.monthlyEquivalent);
    await HomeWidget.saveWidgetData<String>('sub_total', formatWon(total));

    if (active.isEmpty) {
      await HomeWidget.saveWidgetData<String>('sub_next', '등록된 구독 없음');
    } else {
      active.sort((a, b) => a.daysUntilPayment.compareTo(b.daysUntilPayment));
      final n = active.first;
      await HomeWidget.saveWidgetData<String>(
          'sub_next', '${n.name} ${n.paymentLabel}');
    }
    await HomeWidget.updateWidget(
      androidName: 'SubscriptionWidgetProvider',
      iOSName: 'SubscriptionWidget',
    );
  } catch (_) {
    // 위젯이 없거나 테스트 환경이면 무시.
  }
}
