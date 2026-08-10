import 'package:core/core.dart';
import 'package:dday/data/repositories/dday_repository_impl.dart';
import 'package:dday/domain/entities/dday_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 목(mock) SharedPreferences 위에서 리포지토리를 만든다.
Future<DDayRepositoryImpl> _repo() async =>
    DDayRepositoryImpl(await LocalStore.create());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('빈 저장소는 빈 목록을 돌려준다', () async {
    final repo = await _repo();
    expect(repo.load(), isEmpty);
  });

  test('save → load 왕복 (엔티티 동등성 유지)', () async {
    final repo = await _repo();
    final items = [
      DDayItem(id: '1', title: 'A', date: DateTime(2026, 1, 1)),
      DDayItem(
        id: '2',
        title: 'B',
        date: DateTime(2026, 2, 2),
        emoji: '🎉',
        colorValue: 0xFF3182F6,
        reminders: const [DdayReminder.dayBefore],
      ),
    ];
    await repo.save(items);
    expect(repo.load(), items);
  });

  test('exportRaw/importRaw 로 원본 JSON을 그대로 옮긴다', () async {
    final repo = await _repo();
    await repo.save([DDayItem(id: '1', title: 'A', date: DateTime(2026, 1, 1))]);
    final raw = repo.exportRaw();
    expect(raw, isNotNull);

    // 새 기기(빈 저장소)로 옮기는 상황 재현
    SharedPreferences.setMockInitialValues({});
    final fresh = await _repo();
    expect(fresh.load(), isEmpty);

    await fresh.importRaw(raw!);
    expect(fresh.load().single.title, 'A');
  });

  test('빈 저장소에서 exportRaw는 null', () async {
    final repo = await _repo();
    expect(repo.exportRaw(), isNull);
  });
}
