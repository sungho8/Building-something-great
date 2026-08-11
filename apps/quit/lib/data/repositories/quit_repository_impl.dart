import 'dart:convert';

import 'package:core/core.dart';

import '../../domain/entities/quit_item.dart';
import '../../domain/repositories/quit_repository.dart';

/// [QuitRepository] 구현 — core [LocalStore] 위에서 JSON 직렬화.
class QuitRepositoryImpl implements QuitRepository {
  QuitRepositoryImpl(this._store);

  final LocalStore _store;
  static const _key = 'quit_items_v1';

  @override
  List<QuitItem> load() {
    final raw = _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => QuitItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(List<QuitItem> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _store.setString(_key, encoded);
  }

  @override
  String? exportRaw() => _store.getString(_key);

  @override
  Future<void> importRaw(String json) => _store.setString(_key, json);
}
