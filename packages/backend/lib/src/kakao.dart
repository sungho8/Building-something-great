import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// 카카오 SDK 초기화. 앱 시작 시 한 번, 네이티브 앱 키로 호출한다.
///
/// 키가 비어 있으면 초기화하지 않는다(카카오 로그인 비활성 상태로 앱은 정상 동작).
void initKakao(String nativeAppKey) {
  if (nativeAppKey.isEmpty) return;
  KakaoSdk.init(nativeAppKey: nativeAppKey);
}
