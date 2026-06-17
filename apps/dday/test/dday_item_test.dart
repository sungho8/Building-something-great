import 'package:dday/domain/entities/dday_item.dart';
import 'package:flutter_test/flutter_test.dart';

DDayItem _item(DateTime date) =>
    DDayItem(id: 't', title: '테스트', date: date);

void main() {
  test('오늘 날짜는 D-DAY', () {
    expect(_item(DateTime.now()).label, 'D-DAY');
  });

  test('미래 날짜는 D-N', () {
    expect(_item(DateTime.now().add(const Duration(days: 10))).label, 'D-10');
  });

  test('과거 날짜는 D+N', () {
    expect(
      _item(DateTime.now().subtract(const Duration(days: 5))).label,
      'D+5',
    );
  });

  test('JSON 직렬화 왕복', () {
    final item = DDayItem(id: 'abc', title: '시험', date: DateTime(2026, 11, 19));
    final restored = DDayItem.fromJson(item.toJson());
    expect(restored, item);
  });
}
