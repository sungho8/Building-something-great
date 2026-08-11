# 하루더 배포 체크리스트 (Android 우선)

3번 앱 `apps/quit`. **로컬 온리 MVP** — 로그인·서버·백엔드 없음.

현재 상태 (2026-08-11):
- applicationId: `com.sungho.quit` / 표시명: **하루더**
- 앱 아이콘(그린 원+체크) ✅ · 홈 위젯(Android) ✅ · 다크/라이트 ✅ · 토스식 생성 마법사 ✅
- 서명: **debug** (릴리스 키스토어 미연결) — gradle 배선 완료(key.properties 있으면 릴리스)
- AdMob: **테스트 ID** (코드/매니페스트 모두) — 실 ID 미발급
- 개인정보처리방침·스토어문구: Notion 초안 완료 · 512 아이콘·피처그래픽: `apps/quit/store/`

## 제가 이미 해둔 것 ✅
- 경량 3계층 + 그린 다크/라이트 테마 + 토스식 생성 마법사 + 수정 폼(리셋·삭제)
- 홈(대표목표 히어로·스탯·다른 목표 카드) + 홈 위젯 네이티브 + 앱아이콘
- 릴리스 서명 gradle 배선 + `key.properties.example` (minify off)
- 512 스토어 아이콘 / 피처그래픽 (`apps/quit/store/`)
- Notion: 개인정보처리방침 초안, 스토어 등록 문구

## 사용자가 해야 할 것 🔲
1. **AdMob 실제 ID** — 콘솔에서 앱(하루더) 등록 → App ID + 배너 단위 발급 → 알려주시면 코드/매니페스트 반영
   - `lib/config/ad_config.dart` `_androidBanner` + `AndroidManifest.xml` `APPLICATION_ID`
2. **릴리스 키스토어** — 새로 만들거나 기존 키 재사용.
   - `keytool -genkey -v -keystore ~/keys/quit-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
   - `apps/quit/android/key.properties` 작성(`key.properties.example` 복사)
3. **개인정보처리방침 공개** — Notion 페이지 문의 이메일 채우고 Share → Publish → URL을 Play 콘솔에 등록
4. **스크린샷** (폰 최소 2장) — 홈·마법사·위젯 캡처
5. **AAB 빌드**: `cd apps/quit && flutter build appbundle --release`
6. **Play 콘솔**: 앱 생성 → Play App Signing → AAB 업로드 → 데이터보안(광고 식별자만)·콘텐츠 등급 → 등록물 → 출시

## 남은 코드 작업 (선택)
- 알림(응원 리마인드 · 이정표 달성 축하) — 후속
- iOS 홈 위젯(WidgetKit) · iOS 표시명 — iOS 출시 시
- 백엔드(카카오 로그인 + 백업) = Phase 2
