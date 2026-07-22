import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app_user.dart';

/// 인증 서비스 — 게스트(익명) + Kakao.
///
/// Kakao는 Firebase 기본 provider가 아니라, 카카오 토큰을 **커스텀 토큰 서버**
/// (Cloud Function)로 보내 Firebase 커스텀 토큰을 받아 로그인한다.
/// [authFunctionUrl]에 그 함수 URL을 넣어야 Kakao 로그인이 동작한다.
class AuthService {
  AuthService({FirebaseAuth? auth, this.authFunctionUrl})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// 카카오 access token → Firebase 커스텀 토큰 교환 Cloud Function URL.
  final String? authFunctionUrl;

  /// 로그인 상태 스트림.
  Stream<AppUser?> get authState => _auth.authStateChanges().map(
        (user) => user == null ? null : AppUser.fromFirebase(user),
      );

  /// 현재 유저 (없으면 null).
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : AppUser.fromFirebase(user);
  }

  /// 게스트 보장 — 로그인 이력이 없으면 익명으로 로그인한다.
  Future<AppUser> ensureGuest() async {
    final existing = _auth.currentUser;
    if (existing != null) return AppUser.fromFirebase(existing);
    final result = await _auth.signInAnonymously();
    return AppUser.fromFirebase(result.user!);
  }

  /// Kakao 로그인.
  ///
  /// 카카오톡 앱이 있으면 앱으로, 없으면 카카오계정 웹으로 로그인한 뒤,
  /// 발급받은 access token을 커스텀 토큰 서버에 보내 Firebase에 로그인한다.
  Future<AppUser> signInWithKakao() async {
    final url = authFunctionUrl;
    if (url == null || url.isEmpty) {
      throw StateError(
        'authFunctionUrl 미설정 — 카카오 토큰을 교환할 Cloud Function URL이 필요합니다.',
      );
    }

    // 1. 카카오 로그인 → access token
    final OAuthToken token = await isKakaoTalkInstalled()
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();

    // 2. 커스텀 토큰 서버에서 Firebase 토큰 교환
    final response = await http.post(
      Uri.parse(url),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'accessToken': token.accessToken}),
    );
    if (response.statusCode != 200) {
      throw StateError('커스텀 토큰 교환 실패: ${response.statusCode} ${response.body}');
    }
    final firebaseToken =
        (jsonDecode(response.body) as Map<String, dynamic>)['firebaseToken']
            as String;

    // 3. Firebase 커스텀 토큰으로 로그인
    final result = await _auth.signInWithCustomToken(firebaseToken);
    return AppUser.fromFirebase(result.user!);
  }

  /// 로그아웃 (카카오 세션도 함께 정리).
  Future<void> signOut() async {
    try {
      await UserApi.instance.logout();
    } catch (_) {
      // 카카오 미로그인 등은 무시.
    }
    await _auth.signOut();
  }
}
