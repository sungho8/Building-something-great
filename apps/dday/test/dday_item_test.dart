import 'package:dday/models/dday_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('오늘 날짜는 D-DAY', () {
    final item = DDayItem.create(title: '시험', date: DateTime.now());
    expect(item.label, 'D-DAY');
  });

  test('미래 날짜는 D-N', () {
    final item = DDayItem.create(
      title: '여행',
      date: DateTime.now().add(const Duration(days: 10)),
    );
    expect(item.label, 'D-10');
  });

  test('과거 날짜는 D+N', () {
    final item = DDayItem.create(
      title: '기념일',
      date: DateTime.now().subtract(const Duration(days: 5)),
    );
    expect(item.label, 'D+5');
  });

  test('JSON 직렬화 왕복', () {
    final item = DDayItem.create(title: '시험', date: DateTime(2026, 11, 19));
    final restored = DDayItem.fromJson(item.toJson());
    expect(restored.id, item.id);
    expect(restored.title, '시험');
    expect(restored.date, DateTime(2026, 11, 19));
  });
}
