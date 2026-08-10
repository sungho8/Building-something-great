import '../entities/subscription.dart';

/// 구독 목록 영속화 계약.
abstract interface class SubscriptionRepository {
  /// 저장된 목록을 읽는다.
  List<Subscription> load();

  /// 목록 전체를 저장한다.
  Future<void> save(List<Subscription> items);

  /// 저장된 원본 JSON (클라우드 백업용, Phase 2). 없으면 null.
  String? exportRaw();

  /// 원본 JSON을 그대로 저장 (클라우드 복원용, Phase 2).
  Future<void> importRaw(String json);
}
