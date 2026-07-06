# 알려진 이슈 & 보류 항목

실제 실행에서 발견했지만 "지금이 아니라 디자인 시스템 단계에서 한 번에 해결"하기로 한 항목들.

## 1. SafeArea 미적용 — 하단 시스템 UI에 가려짐

- **증상:** Android 하단 내비게이션 바/제스처 영역에 본문 UI가 가려진다. (2026-06-17, 실기기 확인)
- **원인:** 화면이 `SafeArea`로 감싸지지 않음.
- **해결 위치(중요):** 각 앱에서 화면마다 `SafeArea`를 두지 말고, **`design_system`에서 공용으로 해결**한다.
  - 후보 A: `AppFactory`(또는 새 `AppScaffold`)가 body를 `SafeArea`로 감싸도록.
  - 후보 B: 공용 `AppScaffold` 위젯을 만들어 모든 화면이 그것을 쓰게.
  - → 한 번 고치면 모든 앱이 자동 적용되는 게 양산 원칙에 맞음.
- **상태:** ✅ 해결 (2026-06-17) — `AppScaffold`(design_system)가 body를 SafeArea로 감쌈. D-Day 화면 적용 완료.

## 2. 기본적인 디자인 — 조잡한 느낌

- **증상:** Material 기본값 그대로라 완성도가 낮아 보인다. (2026-06-17)
- **해결 위치:** `design_system` 본격 구축 시 토큰(색·타이포·간격·반경·그림자)·컴포넌트 다듬기로 해결.
- **상태:** 🔧 진행 중 — 방향을 **TDS(토스) 스타일**로 확정 (2026-06-18). 색(AppGrey 뼈대+시맨틱)·타이포(AppTypography 15/17축 스케일)·간격·반경 4종 토큰 확정, Theme·AppButton 연결, `gallery/showcase` 갤러리 앱으로 확인 가능. Pretendard 폰트 번들 완료(2026-07-06, 아래 참고). 남은 것: 컴포넌트 확충(input·chip·dialog 등).

## 3. (해결됨) Pretendard 폰트 미적용 — 패키지 네임스페이스 누락

- **증상:** `AppFont.family = 'Pretendard'`로 접두사 없이 지정 → 폰트가 로드는 되지만 **에러 없이 조용히 시스템 폰트로 폴백**됨 (겉보기엔 멀쩡해 보여서 눈치채기 쉬움).
- **원인:** `design_system`은 각 앱(dday 등) 입장에서 의존 패키지라, Flutter가 폰트 매니페스트에 family를 `packages/design_system/Pretendard`로 네임스페이싱해서 등록한다. Dart 코드가 접두사 없는 `'Pretendard'`를 요청하면 매니페스트 키와 안 맞아 매칭 실패.
- **해결:** `AppFont.family`를 `'packages/design_system/Pretendard'`로 수정. `AppButton`은 `ButtonStyle.textStyle`이 `Theme.textTheme` merge 경로를 안 타므로 별도로 `theme.textTheme.bodyMedium?.fontFamily`를 명시적으로 이어받도록 수정.
- **회귀 테스트:** `packages/design_system/test/design_system_test.dart` — 폰트 패밀리 접두사 검증 + 3개 굵기(Regular/SemiBold/Bold) 에셋 실제 로드 검증.
- **상태:** ✅ 해결 (2026-07-06)

---

> 두 항목 모두 "앱별 땜질"이 아니라 **공용 design_system 레이어에서 해결**하는 게 핵심.
> 디자인 시스템 정비 작업 시 이 문서를 먼저 확인할 것.
