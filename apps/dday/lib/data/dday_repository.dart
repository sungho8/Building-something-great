import 'dart:convert';

import 'package:core/core.dart';

import '../models/dday_item.dart';

/// D-Day 목록을 로컬에 영속화한다. core의 [LocalStore] 위에서 JSON 직렬화.
class DDayRepository {
  DDayRepository(this._store);

  final LocalStore _store;
  static const _key = 'dday_items_v1';

  List<DDayItem> load() {
    final raw = _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => DDayItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<DDayItem> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _store.setString(_key, encoded);
  }
}
