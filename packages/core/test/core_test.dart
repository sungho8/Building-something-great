import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppInfo가 이름·버전을 보관한다', () {
    const info = AppInfo(name: 'dday', version: '1.0.0');

    expect(info.name, 'dday');
    expect(info.version, '1.0.0');
  });
}
