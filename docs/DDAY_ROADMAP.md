# D-Day 앱 로드맵

첫 제품 D-Day의 세련화·기능 확장·출시 준비 계획.

## Phase 1 — 세련화 (완료, 2026-07-06)

- [x] 히어로 카드: 최상단 항목을 크게 (큰 D-라벨 + 진행 게이지)
- [x] D-DAY 당일 강조: 브랜드색 채움 카드 + 라벨 반전
- [x] 등장 애니메이션(FadeSlideIn, design_system 공용), 탭·저장·삭제 햅틱
- [x] 스와이프 삭제 + 실행취소 스낵바
- [x] 다크모드 배경 버그 수정 (브랜드 무드 배경은 라이트 전용)

## Phase 2 — 기능 확장 (완료, 2026-07-06)

- [x] 매년 반복(기념일 모드): 지난 날짜는 자동 다음 도래일 + N주년 배지
- [x] 항목별 이모지 (카드·홈위젯 반영)
- [x] 미리 알림: 당일 / 1일 전 / 7일 전 다중 선택
- [x] 시작일 포함(+1) 토글 (만난 날 = 1일 카운팅)
- [x] 고정(pin): 목록 맨 위 + 홈 위젯 우선
- [x] 재부팅 알림 복원 (Android BOOT_COMPLETED 리시버 + 권한)

## Phase 3 — 출시 준비 & 계정 (진행 중)

핵심 목표: 로컬 전용 유지하되, **선택적 클라우드 백업/복원**.
공용 인프라는 옵트인 패키지로: `packages/ads`(AdMob), `packages/backend`(Firebase).

- [x] **AdMob**: `packages/ads`(초기화·UMP 동의·배너) + dday 하단 배너, 테스트 ID로 빌드 검증
- [x] **Firebase 연동 코드**: `packages/backend`(AuthService·CloudSyncService) + dday 배선
  - [x] 게스트(익명) 로그인 + 시작 시 복원 + 저장 시 자동 백업
  - [x] 카카오 로그인 코드 (점유율 고려해 Google→Kakao 확정, 2026-07-21) — 커스텀 토큰 서버(Cloud Function) 경유. 콘솔·함수배포·네이티브 설정 남음 → `docs/KAKAO_SETUP.md`
  - [x] 유저당 단일 문서 모델(비용 최소화), 계정 시트 UI
  - [ ] 콘솔 설정 마무리(익명·Google 켜기, Firestore 규칙, SHA-1, 예산알림) → `docs/FIREBASE_SETUP.md`
  - [ ] 실기기에서 로그인·Firestore 왕복 검증
- [ ] Apple 로그인 (iOS 출시 시)
- [ ] 앱 아이콘 / 스플래시
- [ ] AdMob 실계정 ID로 교체 (출시 시)
- [ ] 스토어 등록·심사 (Android 먼저 → iOS)

### 비용 검토 결론 (2026-07-21)
- 단일 문서/유저 + 보안규칙 + App Check + 예산알림 → **수천 DAU까지 사실상 $0**, 이상도 월 몇 달러.
- Auth(Google/익명) 무료, Firestore 무료 한도(읽기 5만·쓰기 2만/일·저장 1GB)가 프로젝트마다 별도.
- 진짜 리스크는 요금이 아니라 폭주 → Blaze + 예산알림 + App Check로 방어.
- 플랜: **Blaze + 예산알림** 채택.

### 설계 메모 (Phase 3)
- 게스트 우선 + 익명 Auth로 시작해, 사용자가 원할 때 소셜 계정으로 **업그레이드**(익명 계정 연결)하는 흐름이 이탈을 줄인다.
- 로컬 저장(`LocalStore`)은 그대로 SSOT로 두고, Firebase는 "백업 미러"로. 오프라인 우선.
- Auth/Firebase 래퍼는 여러 앱이 재사용할 수 있으니 `packages/core`에 두는 것을 검토 (단, 실제 2개 앱 이상에서 쓸 때 추출 — 조기 추상화 금지).
