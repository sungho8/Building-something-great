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
│   └── backend/         ← Firebase 인증(게스트·Google)+Firestore 동기화 (옵트인)
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
  - [ ] Phase 3: 게스트모드/소셜로그인/Firebase, AdMob, 앱아이콘, 스토어 심사 — 미착수

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
- dday 실행: `cd apps/dday && flutter run`
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
- 알려진 이슈·보류: `docs/KNOWN_ISSUES.md`
- 홈 위젯 설정: `docs/HOME_WIDGET.md`
- Notion 대시보드: https://github.com/sungho8/Building-something-great
