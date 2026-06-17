import 'dart:convert';

import 'package:core/core.dart';

import '../../domain/entities/dday_item.dart';
import '../../domain/repositories/dday_repository.dart';

/// [DDayRepository] 구현 — core [LocalStore] 위에서 JSON 직렬화.
class DDayRepositoryImpl implements DDayRepository {
  DDayRepositoryImpl(this._store);

  final LocalStore _store;
  static const _key = 'dday_items_v1';

  @override
  List<DDayItem> load() {
    final raw = _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => DDayItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(List<DDayItem> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _store.setString(_key, encoded);
  }
}
