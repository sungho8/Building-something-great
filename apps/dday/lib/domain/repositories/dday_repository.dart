import '../entities/dday_item.dart';

/// D-Day 목록 영속화 계약.
abstract interface class DDayRepository {
  /// 저장된 목록을 읽는다.
  List<DDayItem> load();

  /// 목록 전체를 저장한다.
  Future<void> save(List<DDayItem> items);

  /// 저장된 원본 JSON 문자열 (클라우드 백업용). 없으면 null.
  String? exportRaw();

  /// 원본 JSON 문자열을 그대로 저장 (클라우드 복원용).
  Future<void> importRaw(String json);
}
