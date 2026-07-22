const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * 카카오 access token → Firebase 커스텀 토큰 교환.
 *
 * 앱이 카카오 로그인으로 받은 access token을 보내면, 카카오 API로 검증한 뒤
 * `kakao:{id}` uid로 Firebase 커스텀 토큰을 발급해 돌려준다.
 * 커스텀 토큰 발급은 Admin SDK(서버 전용)로만 가능하므로 이 함수가 필요하다.
 */
exports.kakaoLogin = onRequest(
  { region: "asia-northeast3", cors: true },
  async (req, res) => {
    try {
      const accessToken = req.body && req.body.accessToken;
      if (!accessToken) {
        res.status(400).json({ error: "accessToken이 필요합니다." });
        return;
      }

      // 1. 카카오 토큰 검증 + 유저 정보 조회
      const kakaoRes = await fetch("https://kapi.kakao.com/v2/user/me", {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (!kakaoRes.ok) {
        res.status(401).json({ error: "카카오 토큰 검증 실패" });
        return;
      }
      const kakaoUser = await kakaoRes.json();

      // 2. Firebase 커스텀 토큰 발급
      const uid = `kakao:${kakaoUser.id}`;
      const profile =
        kakaoUser.kakao_account && kakaoUser.kakao_account.profile;
      const firebaseToken = await admin.auth().createCustomToken(uid, {
        provider: "kakao",
        displayName: (profile && profile.nickname) || null,
      });

      res.json({ firebaseToken });
    } catch (e) {
      res.status(500).json({ error: String(e) });
    }
  }
);
