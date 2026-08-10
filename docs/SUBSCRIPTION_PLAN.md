# 2번 앱 — 구독 관리 트래커 기획안

D-Day에 이어 공용 인프라를 재활용하는 두 번째 양산 앱. (결정: `docs/PLANNING.md` 2026-06-17)

## 한 줄 가치

**"내가 매달 구독에 얼마 쓰는지 + 다음 결제일이 언제인지"를 홈 화면에서 한눈에.**

D-Day가 "날짜 카운트다운"이라면, 이 앱은 거기에 **금액 합산**이라는 축을 더한다. 그게 유일한 새 로직이고 나머지는 D-Day 패턴 그대로다.

## 차별점 (핵심)

- **월 환산 총액 자동 합산**: 연 구독은 ÷12, 주 구독은 ×52÷12로 환산해 "이번 달 총 구독료"를 계산.
- **다음 결제일 D-day**: 각 구독의 다음 결제일까지 며칠 남았는지 (D-Day 로직 재사용).
- **위젯 한 방**: "이번 달 ₩47,900 · 다음: 넷플릭스 D-3"

## 데이터 모델 — `Subscription` (freezed)

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String | |
| name | String | 서비스명 (넷플릭스 등) |
| amount | int | 금액(원) |
| cycle | enum | monthly / yearly / weekly |
| firstPaymentDate | DateTime | 최초(기준) 결제일 → 다음 결제일 계산의 기준 |
| category | enum | 엔터/음악/생산성/통신/게임/기타 (색·그룹핑용) |
| emoji | String | 카드 이모지 (기본 빈값) |
| colorValue | int? | KeyColor. null이면 브랜드색 |
| reminders | List | 결제 며칠 전 알림 (당일/1일전/3일전) |
| active | bool | 일시정지 시 합산·알림 제외 |
| createdAt | DateTime? | |

**계산 getter (엔티티 순수 로직 — 단위테스트 대상):**
- `nextPaymentDate` — firstPaymentDate + cycle을 오늘 이후로 굴린 값 (D-Day의 `effectiveDate`와 동일 패턴)
- `daysUntilPayment` — D-N
- `monthlyEquivalent` — cycle별 월 환산액
- (리스트 레벨) `totalMonthly` = 활성 구독의 monthlyEquivalent 합, `totalYearly`

## 화면

1. **목록/홈**
   - 히어로: **이번 달 총 구독료 ₩XX,XXX** + 활성 구독 수 (+ 연 환산 보조 표기)
   - 구독 카드 리스트: 이름·금액·다음 결제 D-N·카테고리 색. 정렬은 다음 결제일 임박 순.
   - 필터: 전체 / 이번 달 결제예정 / 일시정지
2. **추가·편집**: 이름·금액·주기·기준 결제일·카테고리·이모지/색·알림·활성 토글
3. **홈 위젯**: 이번 달 총액 + 가장 임박한 결제
4. **계정 시트**: (백엔드 포함 시) D-Day와 동일 재사용

## 재사용 맵 (D-Day 대비)

**그대로 재사용 (코드 손 안 댐)**
- `core` LocalStore / NotificationService
- `ads` AdsService / AppBannerAd
- `backend` AuthService(카카오) / CloudSyncService  *(백엔드 포함 단계에서)*
- `design_system` 전 컴포넌트 + 테마 (BrandConfig만 교체)
- 홈 위젯 배선, Play 릴리스 파이프라인(키스토어·서명·개인정보방침 템플릿·minify off)

**새로 만드는 것 (앱 고유)**
- `Subscription` 엔티티 + repository (JSON 직렬화는 D-Day와 동일 구조)
- `SubscriptionListViewModel` — D-Day 뷰모델에 **총액 합산**만 추가
- 목록/추가/편집 뷰, 위젯 레이아웃(원화 포맷)
- BrandConfig(블루 계열), AdMob 앱/단위, 앱 아이콘

## 브랜드

- seed: 단정한 블루 (예: `0xFF3182F6`) — D-Day 코랄과 확실히 구분. 흰 배경 규칙 동일.
- 아이콘 컨셉: 블루 배경 + 카드/원화(₩) 또는 반복 화살표 라인아트.

## 수익화

- 배너 광고(재사용). 향후 옵션: 프리미엄(구독 무제한·광고 제거·카테고리별 통계 차트).

## MVP 범위 & 단계 (제안)

- **Phase 1 (로컬 MVP, 빠른 출시)**: 구독 등록/편집/삭제 · 총액 합산 · 다음 결제일 D-day · 알림 · 홈 위젯 · 배너 광고. **로그인/백업 없음** (D-Day 초기 전략과 동일).
- **Phase 2**: 카카오 로그인 + Firestore 백업/복원 (backend 재사용).
- **Phase 3**: 카테고리별 통계, 프리미엄.

→ 로컬 MVP부터 가면 신규 인프라 셋업(Firebase/Kakao/함수)을 미뤄서 **가장 빠르게 스토어에 올릴 수 있다.**

## 신규 앱마다 반복되는 인프라 (공장 체크리스트)

- **AdMob**: 앱마다 **새 앱 + 광고 단위 필수** (App ID/단위 ID)
- **Firebase**: 백엔드 포함 시 결정 필요 — (A) 새 프로젝트+새 커스텀토큰 함수, (B) 기존 D-Day 프로젝트 재사용. *데이터 분리·앱 독립성 위해 A 권장, 단 셋업 반복 비용 있음.*
- **Kakao**: 백엔드 포함 시 새 카카오 앱(네이티브 키) + 릴리스/디버그 키 해시 등록
- **서명**: 앱마다 새 업로드 키스토어 (또는 factory 공용 키 — 정책상 앱별 분리 권장)

## 열린 결정사항

1. MVP를 **로컬 온리로 빠르게** vs 처음부터 백엔드 포함?
2. 통계(카테고리별 차트)를 언제? (MVP 제외 권장)
3. 통화: 원(₩) 고정 vs 다통화? (KR 타깃이면 원 고정 권장)
