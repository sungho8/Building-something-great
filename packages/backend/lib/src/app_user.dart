import 'package:firebase_auth/firebase_auth.dart';

/// 앱 유저 표현. 게스트(익명)면 [isAnonymous]가 true.
class AppUser {
  final String uid;
  final bool isAnonymous;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    required this.isAnonymous,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  factory AppUser.fromFirebase(User user) => AppUser(
        uid: user.uid,
        isAnonymous: user.isAnonymous,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
}
