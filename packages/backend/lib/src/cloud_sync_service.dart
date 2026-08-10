import 'package:cloud_firestore/cloud_firestore.dart';

/// 클라우드 백업 스냅샷.
class CloudSnapshot {
  final String data;
  final DateTime? updatedAt;

  const CloudSnapshot({required this.data, this.updatedAt});
}

/// 유저별 단일 문서 백업/복원.
///
/// 비용 방어의 핵심: 유저의 모든 데이터를 **문서 1개**(`backups/{uid}`)에
/// 문자열(JSON)로 저장한다. 항목마다 문서를 만들지 않아 읽기/쓰기가 최소화된다.
/// 로컬을 SSOT로 두고 이걸 백업 미러로 쓴다.
class CloudSyncService {
  CloudSyncService({FirebaseFirestore? db}) : _injectedDb = db;

  /// 주입된 인스턴스(테스트용). null이면 [FirebaseFirestore.instance]를 **지연** 사용한다.
  /// 생성자에서 즉시 참조하지 않아 단위 테스트에서 페이크 상속이 가능하다.
  final FirebaseFirestore? _injectedDb;
  FirebaseFirestore get _db => _injectedDb ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('backups').doc(uid);

  /// 백업 — 유저 데이터 전체를 한 번의 쓰기로 올린다.
  Future<void> push(String uid, String data) async {
    await _doc(uid).set({
      'data': data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 복원 — 클라우드 스냅샷을 한 번의 읽기로 가져온다. 없으면 null.
  Future<CloudSnapshot?> pull(String uid) async {
    final snap = await _doc(uid).get();
    if (!snap.exists) return null;
    final map = snap.data() ?? const {};
    final ts = map['updatedAt'];
    return CloudSnapshot(
      data: (map['data'] as String?) ?? '',
      updatedAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
