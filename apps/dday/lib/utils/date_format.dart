import 'package:intl/intl.dart';

const _weekdaysKo = ['월', '화', '수', '목', '금', '토', '일'];

/// 2026.06.17 (수) 형태로 포맷.
String formatDdayDate(DateTime date) {
  final base = DateFormat('yyyy.MM.dd').format(date);
  final weekday = _weekdaysKo[date.weekday - 1];
  return '$base ($weekday)';
}
