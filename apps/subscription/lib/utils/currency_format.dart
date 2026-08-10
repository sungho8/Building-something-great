import 'package:intl/intl.dart';

final _won = NumberFormat('#,###');

/// 47900 → "₩47,900"
String formatWon(num amount) => '₩${_won.format(amount.round())}';

/// 결제일 표시: 매월 N일 / 매년 M월 D일 / 매주 (요일).
final _md = DateFormat('M월 d일');
const _weekdaysKo = ['월', '화', '수', '목', '금', '토', '일'];

String cycleDateLabel(DateTime date, int cycleIndex) {
  // cycleIndex: 0=월, 1=연, 2=주 (BillingCycle.index)
  switch (cycleIndex) {
    case 1:
      return '매년 ${_md.format(date)}';
    case 2:
      return '매주 ${_weekdaysKo[date.weekday - 1]}요일';
    default:
      return '매월 ${date.day}일';
  }
}
