import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';

/// 첫 실행 로그인/온보딩 화면.
///
/// 게스트 우선 — "Google로 계속" 또는 "게스트로 시작" 중 선택하면 온보딩이 완료되고
/// 목록으로 넘어간다. 나중 로그인/로그아웃은 계정 시트에서.
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // Google 로그인 진행 중 여부
  bool _loading = false;

  // 카카오 로그인 → 성공 시 로컬 백업 + 온보딩 완료
  Future<void> _kakao() async {
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).signInWithKakao();
      await ref.read(ddayListProvider.notifier).backupNow();
      await ref.read(onboardingProvider.notifier).complete();
    } catch (_) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        '카카오 로그인에 실패했어요. 게스트로 시작할 수 있어요.',
        variant: AppSnackBarVariant.error,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // 게스트로 시작 → 온보딩만 완료 (익명 세션은 이미 활성)
  Future<void> _guest() async {
    HapticFeedback.selectionClick();
    await ref.read(onboardingProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),

            // 브랜드 히어로 — KeyColor를 짊어진 큰 원
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.event_available,
                    color: AppCommon.white, size: 48),
              ),
            ),

            const SizedBox(height: AppSpacing.s24),

            Text('D-Day', textAlign: TextAlign.center, style: AppTypography.title1),

            const SizedBox(height: AppSpacing.s8),

            Text(
              '소중한 날, 며칠 남았는지 세어보세요',
              textAlign: TextAlign.center,
              style: AppTypography.body2
                  .copyWith(color: AppSemantic.textSecondary),
            ),

            const Spacer(flex: 3),

            KakaoLoginButton(
              loading: _loading,
              onPressed: _kakao,
            ),

            const SizedBox(height: AppSpacing.s8),

            AppButton(
              label: '게스트로 시작하기',
              variant: AppButtonVariant.tertiary,
              expand: true,
              onPressed: _loading ? null : _guest,
            ),

            const SizedBox(height: AppSpacing.s16),

            Text(
              '게스트로 시작해도 나중에 로그인하면 기기 간 백업이 돼요',
              textAlign: TextAlign.center,
              style: AppTypography.caption1
                  .copyWith(color: AppSemantic.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
