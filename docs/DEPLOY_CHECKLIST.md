# D-Day 배포 체크리스트 (Android 우선 → iOS 나중)

첫 앱 `apps/dday`를 Google Play에 올리기까지 남은 작업. iOS(App Store)는 사용자 결정에 따라 **나중**.

현재 상태 스냅샷 (2026-07-27 기준):
- applicationId: `com.sungho.dday`
- 서명: **debug 키로만 서명 중** (릴리스 키스토어 없음)
- version: `1.0.0+1` (pubspec `version`)
- AdMob: **테스트 ID** (App ID `~3347511713`, 배너 `.../6300978111`) — 실제 아님
- `android:label`: `dday` (한글 브랜드명으로 교체 권장)
- 앱 아이콘: ✅ 완료 (coral + 캘린더/체크, adaptive 포함)
- 카카오 로그인: ✅ debug 키 해시로 동작 확인. 릴리스 키 해시는 미등록
- Firebase(익명/카카오 커스텀토큰 + Firestore 백업): ✅ 동작

---

## A. 출시 전 코드·설정 마무리

- [ ] **applicationId 최종 확정** — `com.sungho.dday`로 갈지 결정. Play에 한 번 올리면 **영구 고정**(변경 불가). 개인 도메인/브랜드로 바꿀 거면 지금.
- [ ] **앱 표시 이름** — `AndroidManifest.xml`의 `android:label`을 한글 브랜드명(예: "디데이", "며칠남았지")으로. 스토어명과 맞추기.
- [x] **AdMob 실제 광고 단위로 교체 (Android)** — App ID `...7882733072028788~4444673278`, 배너 `.../9313736435`
  - `lib/config/ad_config.dart` `_androidBanner` + `AndroidManifest.xml` `APPLICATION_ID` 반영 완료 (릴리스=실단위/그외=테스트 자동 분기)
  - [ ] iOS 배너 단위 (iOS 출시 시 `_iosBanner` 교체)
  - [ ] AdMob 계정 결제 정보(수익 수령) 등록
- [ ] **카카오 릴리스 키 해시 등록** — 릴리스 키스토어(아래 B)의 SHA-1 → 키 해시 변환 후 Kakao 개발자 콘솔 "플랫폼 > Android"에 추가. 안 하면 **릴리스 빌드에서 카카오 로그인 실패**.
- [ ] **Firebase 릴리스 지문 등록** — 릴리스 키스토어의 SHA-1/SHA-256을 Firebase 콘솔 프로젝트 설정에 추가. (Play App Signing 쓰면 Play가 재서명하므로 **Play 콘솔의 앱 서명 인증서 SHA도** 추가해야 함)
- [~] **Firestore 보안 규칙 확정·배포** — 규칙 작성 완료(`firestore.rules`: 본인만 R/W + 문자열·크기 가드 + 그외 전면차단), `firebase.json`에 firestore 블록 연결 완료.
  - [ ] **배포**: `cd apps/dday && firebase deploy --only firestore:rules` (사용자 firebase 로그인 필요)
- [ ] **버전 정책** — 최초 출시 `1.0.0+1` OK. 이후 업데이트마다 `+N`(versionCode) 증가 필수.

## B. 릴리스 서명 (키스토어) — ✅ 완료

- [x] **업로드 키스토어 생성** — `~/keys/dday-upload.jks` (alias `upload`)
  - ⚠️ **분실 시 앱 업데이트 영구 불가.** 클라우드 드라이브 백업 + 비밀번호는 별도(비밀번호 관리자)로 분리 보관.
  - 다른 PC에서 빌드하려면: `.jks`를 그 PC로 복사 + `android/key.properties`를 새로 작성 (둘 다 git엔 없음)
- [x] `apps/dday/android/key.properties` 작성 (gitignore됨). 템플릿: `key.properties.example`
- [x] `android/app/build.gradle.kts` — key.properties 있으면 release 서명, 없으면 debug 폴백
- [x] AAB 빌드 검증 완료 — 서명자 SHA-1이 업로드 키와 일치 확인
- [ ] **Play App Signing** — Play 콘솔 업로드 시 활성화(권장). 그러면 Google이 배포용으로 재서명 → 업로드 키 분실해도 재설정 가능

### 업로드 키 지문 (비밀 아님 — 콘솔 등록용 참고)
- SHA-1: `85:65:3C:5F:D9:7B:A3:03:2B:BF:41:10:7B:28:3B:B2:4A:7D:34:34`
- SHA-256: `B7:4F:EE:AB:1E:E7:70:F7:16:67:DE:51:45:89:DC:16:70:1E:C6:46:93:9F:98:99:52:CD:0B:9E:82:5C:91:2F`
- 카카오 키 해시(업로드 키): `hWU8X9l7owMrv0EQeyg7skp9NDQ=`
- ⚠️ Play App Signing 활성화 후엔 **Play 콘솔의 "앱 서명 키" SHA-1**로도 카카오 키 해시를 하나 더 만들어 등록해야 실제 배포판에서 카카오 로그인이 됨

## C. 릴리스 빌드·검증

- [ ] AAB 빌드:
  ```bash
  cd apps/dday && flutter build appbundle --release --dart-define-from-file=dart_defines.json
  ```
- [ ] R8/ProGuard로 카카오·Firebase 클래스가 제거되지 않는지 확인 (로그인/네트워크 깨지면 keep 규칙 추가)
- [~] **실기기 릴리스 설치 테스트** — 릴리스 APK 빌드 완료(`build/app/outputs/flutter-apk/app-release.apk`, 릴리스 서명). 남은 건 삼성 기기 설치 후 기능 확인:
  - [ ] 카카오 로그인(릴리스 키 해시로), 게스트, 알림(당일/1일/7일전), 홈 위젯, 백업/복원, 배너(릴리스라 실단위 — 실 ID 넣기 전엔 안 뜰 수 있음)
- [ ] 다크모드·작은 화면·권한 거부 시나리오 점검

## D. Play Console 등록물

- [ ] **Google Play 개발자 계정** 등록 ($25 1회)
- [ ] 앱 생성 (패키지명 = applicationId, 이후 고정)
- [ ] 스토어 등록정보
  - 앱 이름 / 짧은 설명(80자) / 자세한 설명(4000자)
  - 고해상도 아이콘 **512×512 PNG** (지금 `assets/icon/icon.png`에서 리사이즈)
  - 피처 그래픽 **1024×500**
  - 폰 스크린샷 최소 2장 (권장 4~8장)
- [ ] **개인정보처리방침 URL** — 로그인+광고+Firebase 수집이 있어 **필수**. 웹에 호스팅 필요 (GitHub Pages/Notion 공개페이지 등)
- [ ] 콘텐츠 등급 설문
- [ ] **데이터 보안(Data safety)** 양식 — 수집 항목 신고: 카카오 프로필(이름/이메일), 광고 식별자(AdMob), Firestore 백업 데이터
- [ ] 대상 연령·광고 포함 여부 신고
- [ ] 내부 테스트 → 비공개 테스트 → 프로덕션 단계적 출시 권장

## E. iOS (나중)

- [ ] Apple Developer Program ($99/년)
- [ ] Xcode 서명(팀/프로비저닝), 번들 ID
- [ ] 카카오 iOS 설정(URL Scheme, Info.plist `LSApplicationQueriesSchemes`, 네이티브 키)
- [ ] AdMob iOS App ID, ATT(App Tracking Transparency) 대응
- [ ] 홈 위젯 iOS(WidgetKit) — `docs/HOME_WIDGET.md`
- [ ] App Store Connect 등록물 + 심사(리뷰 가이드라인 엄격)

---

### 우선순위 요약 (출시까지 최소 경로)
1. 릴리스 키스토어 생성·서명 연결 (B)
2. 카카오/Firebase에 릴리스 지문·키해시 등록 (A)
3. AdMob 실제 ID 교체 (A)
4. Firestore 보안 규칙 배포 (A)
5. AAB 빌드 + 실기기 검증 (C)
6. 개발자 계정 + 등록물 + 개인정보처리방침 (D)
