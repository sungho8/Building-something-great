/// 공용 백엔드 인프라 — Firebase 인증 + Firestore 동기화.
///
/// Firebase가 필요한 앱만 의존한다(옵트인). 각 앱은 자기 Firebase 프로젝트
/// (firebase_options.dart)로 초기화한 뒤 이 서비스들을 재사용한다.
library;

export 'src/app_user.dart';
export 'src/auth_service.dart';
export 'src/cloud_sync_service.dart';
