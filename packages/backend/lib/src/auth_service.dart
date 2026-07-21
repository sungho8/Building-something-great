import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app_user.dart';

/// 인증 서비스 — 게스트(익명) + Google, 그리고 익명→Google 업그레이드(연결).
///
/// 사용 흐름: 앱 시작 시 [ensureGuest]로 익명 로그인 → 원하면 [signInWithGoogle]로
/// 같은 uid를 유지한 채 Google 계정으로 승격.
class AuthService {
  AuthService({FirebaseAuth? auth, this.googleServerClientId})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Google idToken 발급에 필요한 web(서버) OAuth 클라이언트 ID.
  /// Android에서 idToken을 받으려면 반드시 필요하다. Firebase 콘솔에서 Google
  /// 로그인을 켜면 생성되는 "웹 클라이언트 ID"를 넣는다.
  final String? googleServerClientId;

  bool _googleInitialized = false;

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

  /// Google 로그인. 현재 게스트(익명)면 같은 uid로 연결(업그레이드)한다.
  Future<AppUser> signInWithGoogle() async {
    if (!_googleInitialized) {
      await GoogleSignIn.instance.initialize(
        serverClientId: googleServerClientId,
      );
      _googleInitialized = true;
    }

    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError(
        'Google idToken이 null입니다. Firebase 콘솔에서 Google 로그인을 켜고 '
        'web 클라이언트 ID(googleServerClientId)를 전달했는지 확인하세요.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final current = _auth.currentUser;

    UserCredential result;
    if (current != null && current.isAnonymous) {
      // 익명 계정을 Google로 승격(연결).
      try {
        result = await current.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        // 이미 그 Google로 만든 계정이 있으면 그 계정으로 로그인.
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          result = await _auth.signInWithCredential(credential);
        } else {
          rethrow;
        }
      }
    } else {
      result = await _auth.signInWithCredential(credential);
    }

    return AppUser.fromFirebase(result.user!);
  }

  /// 로그아웃 (Google 세션도 함께 정리).
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Google 미초기화 등은 무시.
    }
    await _auth.signOut();
  }
}
