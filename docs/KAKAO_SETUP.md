# 카카오 로그인 설정 (dday)

카카오는 Firebase 기본 provider가 아니라 **커스텀 토큰 서버(Cloud Function)** 경유로 로그인한다.
코드(`packages/backend` + dday + `apps/dday/functions/`)는 완료·빌드 검증됨. 아래는 **콘솔·배포·네이티브 설정**.

## 흐름 요약

```
앱: 카카오 로그인 → access token
  → Cloud Function(kakaoLogin): 카카오 API 검증 + Firebase 커스텀 토큰 발급
  → 앱: signInWithCustomToken → Firebase 로그인 완료
```

## 1. 카카오 개발자 앱

1. [developers.kakao.com](https://developers.kakao.com) → 애플리케이션 추가
2. **네이티브 앱 키** 복사 → `apps/dday/lib/di/dday_providers.dart`의 `dDayKakaoNativeAppKey`에 넣기
3. 플랫폼 등록:
   - Android: 패키지명 `com.sungho.dday` + 키 해시(디버그/릴리스)
   - iOS: 번들 ID
4. 카카오 로그인 **활성화 ON**, 동의항목에서 닉네임(+선택: 이메일) 설정

## 2. Cloud Function 배포 (커스텀 토큰 교환)

함수 코드는 `apps/dday/functions/`에 있음.

```bash
cd apps/dday
firebase deploy --only functions      # (firebase.json에 functions 설정 필요 시 firebase init functions로 연결)
```

- 배포되면 나오는 함수 URL(예: `https://asia-northeast3-d-day-273b7.cloudfunctions.net/kakaoLogin`)을
  `dDayAuthFunctionUrl`에 넣기
- Blaze 필요(이미 Blaze). 로그인 호출은 드물어 사실상 무료(월 200만 호출 무료).

## 3. Firebase 콘솔

- Authentication에서 **익명(Anonymous)** 켜기 (게스트/백업용)
- 커스텀 토큰 로그인은 provider를 따로 켤 필요 없음(Admin SDK가 발급)

## 4. 네이티브 설정 (카카오톡 앱 로그인 리다이렉트)

### Android — `android/app/src/main/AndroidManifest.xml`
`<application>` 안에 리다이렉트 액티비티 추가:
```xml
<activity android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
    android:exported="true">
    <intent-filter android:label="flutter_web_auth">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- kakao{NATIVE_APP_KEY} -->
        <data android:scheme="kakao{네이티브앱키}" android:host="oauth" />
    </intent-filter>
</activity>
```

### iOS — `ios/Runner/Info.plist`
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>kakao{네이티브앱키}</string></array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>kakaokompassauth</string>
  <string>kakaolink</string>
</array>
```

## 동작·검증

- `dDayKakaoNativeAppKey` + `dDayAuthFunctionUrl` 둘 다 채우고 위 네이티브 설정을 하면 카카오 로그인 동작.
- 두 값이 비어 있어도 **게스트 로그인·백업/복원은 정상**, 앱은 문제없이 실행됨(코드가 가드).
- ⚠️ 로그인 실제 왕복은 위 설정 완료 후 실기기 검증 필요.

## iOS 참고

Apple 앱스토어는 서드파티 소셜 로그인(카카오)이 있으면 **Sign in with Apple**도 요구한다.
Android 출시엔 무관, iOS 출시 시 Apple 로그인 추가 필요.
