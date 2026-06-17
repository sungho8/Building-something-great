import 'package:shared_preferences/shared_preferences.dart';

/// 공용 키-값 로컬 저장소. shared_preferences 래퍼.
///
/// 모든 앱이 공유하는 인프라. 도메인별 직렬화는 각 앱의 리포지토리가 담당하고,
/// 이 클래스는 순수하게 문자열 저장/조회만 책임진다.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  /// 인스턴스 생성. 앱 시작 시 한 번 호출한다.
  static Future<LocalStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStore(prefs);
  }

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
}
