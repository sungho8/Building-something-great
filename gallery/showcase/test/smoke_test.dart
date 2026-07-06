import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/main.dart';

void main() {
  testWidgets('쇼케이스가 뜨고 4개 탭이 보인다', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    expect(find.text('타이포'), findsOneWidget);
    expect(find.text('레이아웃'), findsOneWidget);
    expect(find.text('컴포넌트'), findsOneWidget);
  });
}
