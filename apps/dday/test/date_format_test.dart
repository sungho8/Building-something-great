import 'package:dday/utils/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('yyyy.MM.dd (요일) 형태로 포맷한다', () {
    // 2024-01-01은 월요일
    expect(formatDdayDate(DateTime(2024, 1, 1)), '2024.01.01 (월)');
  });

  test('한 자리 월/일도 0으로 패딩한다', () {
    expect(formatDdayDate(DateTime(2026, 3, 9)), startsWith('2026.03.09'));
  });

  test('일요일도 올바르게 매핑한다', () {
    // 2024-01-07은 일요일
    expect(formatDdayDate(DateTime(2024, 1, 7)), endsWith('(일)'));
  });
}
