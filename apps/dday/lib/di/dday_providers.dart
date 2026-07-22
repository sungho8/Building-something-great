import 'package:backend/backend.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/dday_repository_impl.dart';
import '../domain/entities/dday_item.dart';
import '../domain/repositories/dday_repository.dart';
import '../presentation/viewmodels/dday_list_viewmodel.dart';

/// 카카오 네이티브 앱 키. `dart_defines.json`(gitignore)에서 주입.
/// 실행: `flutter run --dart-define-from-file=dart_defines.json`
/// ⚠️ 비어 있으면 카카오 SDK 초기화를 건너뛴다(게스트·백업은 정상).
const dDayKakaoNativeAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');

/// 카카오 토큰 → Firebase 커스텀 토큰 교환 Cloud Function URL. dart_defines.json에서 주입.
/// ⚠️ 함수 배포 후 채운다. 비어 있으면 카카오 로그인만 비활성.
const dDayAuthFunctionUrl = String.fromEnvironment('AUTH_FUNCTION_URL');

/// main에서 초기화 인스턴스로 override.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// main에서 초기화 인스턴스로 override.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// D-Day 리포지토리.
final ddayRepositoryProvider = Provider<DDayRepository>(
  (ref) => DDayRepositoryImpl(ref.watch(localStoreProvider)),
);

/// 인증 서비스 (게스트 + Kakao).
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    authFunctionUrl:
        dDayAuthFunctionUrl.isEmpty ? null : dDayAuthFunctionUrl,
  ),
);

/// 클라우드 동기화 서비스.
final cloudSyncProvider = Provider<CloudSyncService>(
  (ref) => CloudSyncService(),
);

/// 로그인 상태 스트림.
final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authServiceProvider).authState,
);

/// 온보딩(로그인 화면) 완료 여부. 첫 실행 때만 로그인 화면을 보여주기 위함.
final onboardingProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);

/// 온보딩 완료 여부를 로컬에 영속화.
class OnboardingController extends Notifier<bool> {
  static const _key = 'onboarded';

  @override
  bool build() => ref.read(localStoreProvider).getString(_key) == 'true';

  /// 로그인 화면을 통과 처리(게스트 시작 또는 로그인 성공 후).
  Future<void> complete() async {
    await ref.read(localStoreProvider).setString(_key, 'true');
    state = true;
  }
}

/// D-Day 목록 상태.
final ddayListProvider =
    NotifierProvider<DDayListViewModel, List<DDayItem>>(DDayListViewModel.new);
