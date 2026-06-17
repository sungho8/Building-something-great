import '../entities/dday_item.dart';

/// D-Day 목록 영속화 계약.
abstract interface class DDayRepository {
  /// 저장된 목록을 읽는다.
  List<DDayItem> load();

  /// 목록 전체를 저장한다.
  Future<void> save(List<DDayItem> items);
}
