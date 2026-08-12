# App Factory — Claude 프로젝트 지침

이 파일은 Claude Code가 자동으로 읽는 프로젝트 컨텍스트다.
다른 기기에서 이 repo를 열면 여기서부터 맥락을 복원한다.

## 프로젝트 목적

**"앱 하나"가 아니라 "앱을 빠르게 찍어내는 생산 라인"을 만든다.**
공용 디자인 시스템 + 공용 인프라 위에, 기능이 서로 다른 작은 유틸 앱들을 패시브 수익원으로 양산한다.

자세한 전략·결정 내역은 `docs/PLANNING.md` 참고.

## 핵심 결정 (요약)

- **수익 모델:** 패시브 B2C (앱스토어 검색 유입, 광고/인앱결제)
- **플랫폼:** Android + iOS 동시 (Flutter 단일 코드베이스)
- **첫 앱:** D-Day 카운터 → **2번:** 구독관리 트래커
- **서버:** 없음 (로컬 전용, 비용 $0)

## 아키텍처 구조

```
app_factory/
├── packages/
│   ├── design_system/   ← 브랜드 무지한 공용 위젯·토큰 (BrandConfig 주입)
│   ├── core/            ← 저장·알림 공용 인프라 (모든 앱)
│   ├── ads/             ← AdMob (옵트인, Firebase 불필요)
│   ├── backend/         ← Firebase 인증(게스트·Google)+Firestore 동기화 (옵트인)
│   └── app_theme/       ← 공용 다크/라이트 테마 + 폼 컴포넌트(Ui*). accent만 앱별 주입.
│                          design_system(흰배경 전용)과 달리 라이트/다크 지원. subscription·quit 사용.
├── apps/
│   ├── dday/            ← 경량 3계층 (domain/data/presentation) + Riverpod
│   └── subscription/
└── gallery/
    └── showcase/        ← 디자인 시스템 쇼케이스 앱 (토큰·컴포넌트 갤러리 + 브랜드 스위처)
```

## 디자인 방향 — TDS(토스) 스타일

- **무드:** 흰 배경 + 회색 위계([AppGrey] 뼈대) + 선명한 브랜드 포인트 + 또렷한 타이포
- **배경 규칙:** 화면 배경은 **흰색 고정**. 색은 배경이 아니라 **위젯이 짊어진다**(채움/아웃라인).
  `BrandConfig`엔 배경색이 없다. 특정 화면만 예외적으로 `AppScaffold(backgroundColor:)`. (자세히: `docs/CONVENTIONS.md`)
- **토큰(4종 확정):** `AppGrey/AppBlue/AppRed/AppGreen/AppOrange/AppSemantic`(색),
  `AppTypography`(display~caption + 버튼용 label1~4), `AppSpacing`(4그리드), `AppRadius`
- 새 공용 컴포넌트를 만들면 **showcase 컴포넌트 탭에 섹션 추가** (전시 의무)
- **Pretendard 번들 완료** (Regular/SemiBold/Bold, `packages/design_system/assets/fonts/`). `AppFont.family`는
  `packages/design_system/Pretendard` (패키지 네임스페이스 접두사 필수 — 없으면 조용히 시스템 폰트로 폴백됨, `docs/KNOWN_ISSUES.md` #3 참고)

## 코드 컨벤션 — `docs/CONVENTIONS.md` (필수)

코드 작성·수정 전 **`docs/CONVENTIONS.md`를 따른다.** 핵심:
- **경량 3계층 + Riverpod**: domain(entities·repositories) / data(repositories impl) / presentation(viewmodels·views·widgets) + di/
- 서버 없는 앱이라 **UseCase·Either·State클래스는 trivial하면 생략** (불필요한 추상화 금지)
- freezed 3.x 엔티티, 수정 후 `melos run gen` (build_runner)
- Provider 접근은 View에서만, 정의는 `di/`에
- 주석 필수(/// public, // private), 하드코딩 금지(토큰 사용), `withValues(alpha:)`, InkWell(¬GestureDetector)

## 핵심 원칙

- `design_system` 위젯은 색·폰트를 **모른다** → `Theme.of(context)`만 본다
- 각 앱은 시작 시 `BrandConfig(seed, font, radius, vibe)`만 주입
- `design_system` 시그니처가 깨지면 **모든 앱이 동시에** 깨진다 → 안정화 후 함부로 바꾸지 않는다
- 공용으로 쓰는 것(저장·알림 등)은 앱이 아니라 `packages/core`에

## 현재 상태

- [x] 모노레포 골격 세팅 (Dart workspace + Melos 7, design_system·core·dday 연결, analyze/test 통과)
- [~] design_system: 골격 + 코어(BrandConfig/AppFactory/AppButton/AppCard/AppSpacing) 구현. 토큰·컴포넌트 확장 필요
- [~] D-Day MVP 개발 중 (로드맵: `docs/DDAY_ROADMAP.md`):
  - [x] 목록(히어로+컴팩트 카드)/추가·편집 화면 (Riverpod)
  - [x] 로컬 저장 (core `LocalStore`) + 알림 (core `NotificationService`, 당일/1일전/7일전)
  - [x] 홈 위젯 — Android 완료. iOS는 Xcode 작업 필요 → `docs/HOME_WIDGET.md`
  - [x] Phase 1(세련화: 히어로 카드·D-DAY 강조·애니메이션·햅틱·스와이프삭제+실행취소·다크모드 수정)
  - [x] Phase 2(기능: 매년반복/N주년·이모지·다중알림·시작일포함·고정·부팅복원)
  - [~] Phase 3: 게스트모드·카카오로그인(커스텀토큰)·Firebase백업 ✅, AdMob(테스트ID) ✅, 앱아이콘 ✅
        → 남은 배포 작업은 `docs/DEPLOY_CHECKLIST.md` (릴리스 서명·실광고ID·키해시·스토어 등록)
- [~] 2번 앱 `apps/subscription` (구독 관리 트래커) — **로컬 MVP 개발 중**
  - 기획/UX: `docs/SUBSCRIPTION_PLAN.md` + Notion "구독 관리 트래커 — 기획/UX 검수"
  - 완료: 경량 3계층(Subscription 엔티티·repo·뷰모델) + 총액합산 + 알림 + Android 설정. analyze/test 통과(14개)
  - **디자인 방향 확정(레퍼런스 기반 전면 재설계)**: 상단 스탯 타일 3종(이번달/활성/연간) + 아이콘 중심
    **행(row) 리스트**(카테고리 색 사각 아이콘) + 카테고리 팝업 필터. 카드형·상태탭 폐기.
  - ⚠️ **다크/라이트 자체 테마** (`lib/theme/sub_theme.dart`의 `SubColors` + `buildSubTheme`, `ThemeMode.system`).
    공용 design_system은 흰배경 전용이라 이 앱만 자체 테마 사용. **홈·편집 모두 다크 대응 완료.**
    재사용 폼 컴포넌트는 `lib/theme/sub_widgets.dart` (SubTextField/SubSegmented/SubChip/SubTile/SubButton).
    design_system에선 토큰(AppSpacing/AppRadius/AppTypography)만 빌려 씀.
  - 카테고리 아이콘: 지금은 Material 아이콘(임시), 추후 브랜드 asset 아이콘으로 교체 예정.
  - **앱 런처 아이콘 완료**: 블루 배경 + 흰 카드(카드+스트라이프) 라인아트. `assets/icon/` +
    flutter_launcher_icons(전역 실행, adaptive #3182F6, remove_alpha_ios). 생성 스크립트: 스크래치패드 Swift.
  - 홈: 스탯 타일 3종 + 곧 결제 예정 가로 카러셀 + 카테고리 필터 + 행 리스트. 우상단 라이트/다크 토글.
  - **홈 위젯(Android) ✅** (`SubscriptionWidgetProvider` + layout/xml/drawable + 매니페스트 리시버).
  - **릴리스 서명 gradle 배선 ✅** (key.properties 있으면 릴리스, `key.properties.example` 제공, minify off).
  - **스토어 에셋 ✅** (`apps/subscription/store/`: 512 아이콘·피처그래픽) + Notion(개인정보처리방침·스토어문구 초안).
  - **배포 체크리스트: `docs/SUBSCRIPTION_DEPLOY.md`** (남은 건 키스토어 생성·실 AdMob ID·개인정보방침 공개·Play 등록 — 사용자 몫).
  - 남은 코드: iOS 위젯·iOS 표시명. 백엔드(카카오·백업)=Phase 2.
  - ⚠️ 로컬 온리 — 카카오/Firebase 미포함(backend 패키지 의존 안 함)
  - AdMob 실 ID·릴리스 키스토어·알림 채널명 반영 완료(App ID ~4333782621).
- [~] 3번 앱 `apps/quit` (하루더 — 금연·금주·커스텀 끊기) — **로컬 MVP 개발 중**
  - 기획/UX: `docs/QUIT_PLAN.md` + Notion "하루더 — 기획/UX"
  - 도메인 `QuitItem`: 경과·절약액·회피량·건강 이정표(type별)·최고기록. 테스트 12개 통과.
  - ⭐ **핵심: 토스식 단계별 생성 마법사** (`quit_create_wizard.dart`) — 종류→(이름)→시점→소비량→확인,
    **AnimatedSwitcher 슬라이드+페이드 부드러운 전환** + 진행바 + 선택 시 자동전환 + 햅틱. **수정은 별도 폼**(리셋·삭제).
  - 홈: 대표목표 히어로(D+·절약액·다음 이정표) + 스탯 타일 + 다른 목표 카드. 라이트/다크 토글.
  - 테마: 자체 그린 다크/라이트 (`lib/theme/ui_theme.dart` UiColors + ui_widgets.dart Ui*). subscription의 SubColors와
    별개 — 나중에 **둘을 공용 패키지로 추출 예정**(이번엔 subscription 안정 위해 보류).
  - 홈 위젯(Android)·앱아이콘(그린 원+체크)·릴리스 서명 배선·AdMob(테스트ID)·스토어 에셋(512·피처그래픽)·
    Notion(개인정보방침·스토어문구)·**이정표 달성 알림**(core `scheduleAt` 추가) 완료. analyze/test 통과(15개).
  - **출시 전 남은 건 전부 사용자 몫**: 실 AdMob ID·키스토어 생성·개인정보방침 공개·스크린샷·Play 등록 (`docs/QUIT_DEPLOY.md`).
  - 후속(선택): 매일 응원 리마인드(반복 알림), iOS.

### 추가된 의존성
- core: shared_preferences, flutter_local_notifications, timezone, flutter_timezone
- dday: flutter_riverpod, home_widget, intl
- Android: core library desugaring 활성화(build.gradle.kts), POST_NOTIFICATIONS 권한

### 워크스페이스 사용법
- **SDK: FVM 3.41.7 고정** (`.fvmrc`). 셸에서 `export PATH="$HOME/fvm/versions/3.41.7/bin:$HOME/.pub-cache/bin:$PATH"` 후 작업
  (homebrew flutter는 3.38이라 SDK 불일치 남 — melos 커널 에러 나면 `dart pub global activate melos` 재실행)
- 의존성 일괄: `melos bootstrap` (또는 루트 `flutter pub get`)
- 분석/테스트: `melos run analyze` / `melos run test --no-select`
- 코드 생성(freezed): `melos run gen`
- dday 실행: `cd apps/dday && flutter run --dart-define-from-file=dart_defines.json`
  (카카오 키·함수 URL은 `dart_defines.json`(gitignore)에서 주입. `dart_defines.example.json` 참고. Android 매니페스트도 이 파일에서 키를 읽음)
- **VSCode Debug 탭**: `.vscode/launch.json`의 `dday` 선택 (dart-define 자동 주입됨).
  ⚠️ dart-define 없이 실행하면 카카오 키·함수 URL이 빈 값이라 로그인이 실패한다.
- 쇼케이스 실행: `cd gallery/showcase && flutter run` (크롬: `-d chrome`)

## 도구

| 도구 | 역할 |
|---|---|
| Melos | 모노레포 패키지 일괄 관리 |
| design_system | 공용 위젯·토큰 |
| core | 광고·저장·분석·공용화면 |
| BrandConfig | 코드 1벌 → 앱마다 다른 피부 |
| Widgetbook | 컴포넌트 전시장 (두 번째 앱부터) |
| Mason brick | 새 앱 1줄 생성 (두 번째 앱부터) |

## 문서

- 전략 전체: `docs/PLANNING.md`
- 코드 컨벤션: `docs/CONVENTIONS.md`
- 배포 체크리스트: `docs/DEPLOY_CHECKLIST.md`
- 알려진 이슈·보류: `docs/KNOWN_ISSUES.md`
- 홈 위젯 설정: `docs/HOME_WIDGET.md`
- Notion 대시보드: https://github.com/sungho8/Building-something-great
