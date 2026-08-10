import 'dart:convert';

import 'package:core/core.dart';

import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

/// [SubscriptionRepository] 구현 — core [LocalStore] 위에서 JSON 직렬화.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._store);

  final LocalStore _store;
  static const _key = 'subscriptions_v1';

  @override
  List<Subscription> load() {
    final raw = _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(List<Subscription> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _store.setString(_key, encoded);
  }

  @override
  String? exportRaw() => _store.getString(_key);

  @override
  Future<void> importRaw(String json) => _store.setString(_key, json);
}
