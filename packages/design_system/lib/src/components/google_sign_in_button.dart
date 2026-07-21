import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Google 로그인 버튼 (구글 브랜딩 가이드라인 준수: 흰 배경 + 공식 G 로고).
///
/// 공식 "G" 로고 애셋은 design_system에 번들된다. 스토어 제출 전
/// 현재 브랜딩 가이드라인과 로고를 한 번 확인할 것.
class GoogleSignInButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  /// 진행 중이면 스피너 표시 + 비활성.
  final bool loading;

  const GoogleSignInButton({
    super.key,
    this.label = 'Google로 계속하기',
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppCommon.white,
          foregroundColor: AppSemantic.textPrimary,
          disabledBackgroundColor: AppCommon.white,
          side: const BorderSide(color: AppSemantic.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: AppSemantic.textTertiary),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/brand/google_g.svg',
                    package: 'design_system',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Text(label, style: AppTypography.label1),
                ],
              ),
      ),
    );
  }
}
