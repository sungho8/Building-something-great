import 'package:intl/intl.dart';

final _won = NumberFormat('#,###');

/// 50000 → "₩50,000"
String formatWon(num v) => '₩${_won.format(v.round())}';

/// 소수 → "1,234" (천단위)
String formatNumber(num v) => _won.format(v.round());

/// 경과를 사람이 읽는 형태로. 1일 이상은 'N일', 미만은 시/분.
String formatElapsed(Duration d) {
  if (d.inDays >= 1) return '${d.inDays}일';
  if (d.inHours >= 1) return '${d.inHours}시간 ${d.inMinutes % 60}분';
  return '${d.inMinutes}분';
}
