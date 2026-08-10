# 구독노트 배포 체크리스트 (Android 우선)

2번 앱 `apps/subscription`. **로컬 온리 MVP** — 로그인·서버·백엔드 없음(그만큼 심사·데이터보안이 단순).

현재 상태 (2026-08-10):
- applicationId: `com.sungho.subscription` / 표시명: **구독노트**
- 앱 아이콘 ✅ (블루+카드) · 홈 위젯(Android) ✅ · 다크/라이트 ✅
- 서명: **debug** (릴리스 키스토어 미연결) — gradle 배선은 완료(key.properties 있으면 릴리스)
- AdMob: **테스트 ID** (App ID `~3347511713`, 코드 배너 placeholder)
- 개인정보처리방침·스토어문구: Notion 초안 완료

## 제가 이미 해둔 것 ✅
- 경량 3계층 + 다크/라이트 테마 + 홈(스탯·카러셀·리스트)·편집 화면
- 홈 위젯 네이티브(`SubscriptionWidgetProvider` + layout/xml/drawable + 매니페스트 리시버)
- 릴리스 서명 gradle 배선 + `key.properties.example` (minify off)
- 앱 아이콘 / 512 스토어 아이콘 / 피처그래픽(`apps/subscription/store/`)
- Notion: 개인정보처리방침 초안, 스토어 등록 문구

## 사용자가 해야 할 것 🔲
1. **릴리스 키스토어** — 새로 만들거나 dday 키 재사용.
   - 새로: `keytool -genkey -v -keystore ~/keys/subscription-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
   - `apps/subscription/android/key.properties` 작성(`key.properties.example` 복사) — storeFile 경로만 맞추면 됨
2. **AdMob 실제 ID** — 콘솔에서 앱(구독노트) 등록 → App ID + 배너 단위 발급 → 알려주시면 코드/매니페스트 반영
   - `lib/config/ad_config.dart` `_androidBanner` + `AndroidManifest.xml` `APPLICATION_ID`
3. **개인정보처리방침 공개** — Notion 페이지 문의 이메일 채우고 Share → Publish → 그 URL을 Play 콘솔에 등록
4. **AAB 빌드**: `cd apps/subscription && flutter build appbundle --release`
   - (dart-define 불필요 — 로컬 온리라 주입할 키 없음)
5. **Play 콘솔**: 앱 생성 → Play App Signing → AAB 업로드 → 데이터보안(광고 식별자만)·콘텐츠 등급 → 등록물(512 아이콘·피처그래픽·스크린샷) → 출시
   - ⚠️ 카카오/Firebase 없음 → 키 해시·SHA 등록 불필요, 데이터보안도 매우 단순(로컬 저장 + AdMob 광고 식별자)

## 남은 코드 작업 (선택)
- iOS 홈 위젯(WidgetKit) — iOS 출시 시
- iOS 표시명(Info.plist CFBundleDisplayName = 구독노트)
- 백엔드(카카오 로그인 + 백업) = Phase 2
