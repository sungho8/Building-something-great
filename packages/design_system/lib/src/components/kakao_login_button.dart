import 'package:flutter/material.dart';

import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 카카오 로그인 버튼 (카카오 브랜드 노랑 배경 + 어두운 글자).
///
/// ⚠️ 공식 카카오 심볼 아이콘은 브랜드 애셋이라 여기선 자리표시(말풍선) 아이콘을 쓴다.
/// 스토어 제출 전 카카오 디자인 가이드의 공식 심볼로 교체할 것.
class KakaoLoginButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  /// 진행 중이면 스피너 표시 + 비활성.
  final bool loading;

  const KakaoLoginButton({
    super.key,
    this.label = '카카오 로그인',
    this.onPressed,
    this.loading = false,
  });

  // 카카오 브랜드 색
  static const _kakaoYellow = Color(0xFFFEE500);
  static const _kakaoLabel = Color(0xFF191919);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _kakaoYellow,
          foregroundColor: _kakaoLabel,
          disabledBackgroundColor: _kakaoYellow,
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
                    strokeWidth: 2.4, color: _kakaoLabel),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 자리표시 — 공식 카카오 심볼로 교체 예정
                  const Icon(Icons.chat_bubble, size: 18, color: _kakaoLabel),
                  const SizedBox(width: AppSpacing.s8),
                  Text(label, style: AppTypography.label1),
                ],
              ),
      ),
    );
  }
}
