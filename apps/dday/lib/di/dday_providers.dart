import 'package:backend/backend.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/dday_repository_impl.dart';
import '../domain/entities/dday_item.dart';
import '../domain/repositories/dday_repository.dart';
import '../presentation/viewmodels/dday_list_viewmodel.dart';

/// Firebase 콘솔에서 Google 로그인을 켜면 생성되는 web(서버) OAuth 클라이언트 ID.
///
/// ⚠️ 아직 비어 있음. Google 로그인을 켜고 google-services.json을 재발급한 뒤,
/// 그 web 클라이언트 ID를 여기에 넣으면 Google 로그인이 동작한다.
/// (게스트 로그인·백업/복원은 이 값 없이도 정상)
const dDayGoogleServerClientId = '';

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

/// 인증 서비스 (게스트 + Google).
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    googleServerClientId:
        dDayGoogleServerClientId.isEmpty ? null : dDayGoogleServerClientId,
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
