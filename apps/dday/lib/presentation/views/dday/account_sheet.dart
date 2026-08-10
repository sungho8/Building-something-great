import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';

/// 계정 시트를 연다.
Future<void> showAccountSheet(BuildContext context) {
  return showAppBottomSheet(context, title: '계정', child: const _AccountSheet());
}

/// 현재 로그인 상태 표시 + 로그아웃(→ 로그인 화면).
///
/// 로그인/복원 같은 동작은 로그인 화면에서만 한다. 여기선 상태 확인과
/// 로그아웃(로그인 화면으로 복귀)만 담당해 단순하게 유지한다.
class _AccountSheet extends ConsumerWidget {
  const _AccountSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.valueOrNull;
    final signedIn = user != null && !user.isAnonymous;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppAvatar(imageUrl: user?.photoUrl, icon: Icons.person, size: 44),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signedIn ? (user.displayName ?? '카카오 계정') : '게스트로 사용 중',
                    style: AppTypography.itemTitle,
                  ),
                  Text(
                    signedIn
                        ? (user.email ?? '카카오 계정으로 로그인됨')
                        : '로그인하면 기기 간 백업·복원이 돼요',
                    style: AppTypography.descriptionSub
                        .copyWith(color: AppSemantic.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s24),

        if (signedIn)
          AppButton(
            label: '로그아웃',
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: () => _logout(context, ref),
          )
        else
          AppButton(
            label: '로그인하기',
            variant: AppButtonVariant.primary,
            expand: true,
            onPressed: () => _toLogin(context, ref),
          ),
      ],
    );
  }

  // 로그아웃 → 카카오·Firebase 세션 정리 후 로그인 화면으로.
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authServiceProvider).signOut();
    await ref.read(onboardingProvider.notifier).reset();
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  // 게스트 → 로그인하러 로그인 화면으로.
  Future<void> _toLogin(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingProvider.notifier).reset();
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}
