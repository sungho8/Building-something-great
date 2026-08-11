import '../entities/quit_item.dart';

/// 끊기 목표 영속화 계약.
abstract interface class QuitRepository {
  List<QuitItem> load();
  Future<void> save(List<QuitItem> items);
  String? exportRaw();
  Future<void> importRaw(String json);
}
