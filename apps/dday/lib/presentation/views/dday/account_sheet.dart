import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dday_providers.dart';

/// 계정·백업 시트를 연다.
Future<void> showAccountSheet(BuildContext context) {
  return showAppBottomSheet(context, title: '계정', child: const _AccountSheet());
}

/// 계정 상태 + Google 로그인/로그아웃 + 클라우드 복원.
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
            AppAvatar(
              imageUrl: user?.photoUrl,
              icon: Icons.person,
              size: 44,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signedIn
                        ? (user.displayName ?? 'Google 계정')
                        : '게스트로 사용 중',
                    style: AppTypography.itemTitle,
                  ),
                  Text(
                    signedIn
                        ? (user.email ?? '')
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

        if (!signedIn)
          AppButton(
            label: 'Google로 로그인',
            leadingIcon: Icons.login,
            expand: true,
            onPressed: () => _google(context, ref),
          )
        else
          AppButton(
            label: '로그아웃',
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: () => _logout(context, ref),
          ),

        const SizedBox(height: AppSpacing.s8),

        AppButton(
          label: '클라우드에서 복원',
          variant: AppButtonVariant.tertiary,
          expand: true,
          onPressed: () => _restore(context, ref),
        ),
      ],
    );
  }

  // Google 로그인 (게스트면 계정 승격)
  Future<void> _google(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      await ref.read(ddayListProvider.notifier).backupNow();
      if (!context.mounted) return;
      Navigator.pop(context);
      showAppSnackBar(context, 'Google 계정으로 로그인했어요',
          variant: AppSnackBarVariant.success);
    } catch (_) {
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        'Google 로그인에 실패했어요 (콘솔 설정을 확인해주세요)',
        variant: AppSnackBarVariant.error,
      );
    }
  }

  // 로그아웃 → 게스트(익명)로 복귀 (로컬 백업 계속 가능하도록)
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authServiceProvider);
    await auth.signOut();
    try {
      await auth.ensureGuest();
    } catch (_) {
      // 익명 미설정·오프라인이면 무시.
    }
    if (!context.mounted) return;
    Navigator.pop(context);
    showAppSnackBar(context, '로그아웃했어요');
  }

  // 클라우드 복원 (로컬 덮어쓰기 확인)
  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final ok = await showAppDialog(
      context,
      title: '클라우드에서 복원할까요?',
      message: '현재 기기의 목록을 클라우드 백업으로 덮어씁니다.',
      confirmLabel: '복원',
      cancelLabel: '취소',
    );
    if (ok != true) return;

    final restored =
        await ref.read(ddayListProvider.notifier).restoreFromCloud();
    if (!context.mounted) return;
    Navigator.pop(context);
    showAppSnackBar(
      context,
      restored ? '클라우드에서 복원했어요' : '복원할 백업이 없어요',
      variant:
          restored ? AppSnackBarVariant.success : AppSnackBarVariant.info,
    );
  }
}
