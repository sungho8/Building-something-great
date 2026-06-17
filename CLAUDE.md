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
│   └── core/            ← 광고·저장·분석·설정화면 공용 인프라
├── apps/
│   ├── dday/
│   └── subscription/
└── gallery/             ← Widgetbook (컴포넌트 전시장)
```

## 핵심 원칙

- `design_system` 위젯은 색·폰트를 **모른다** → `Theme.of(context)`만 본다
- 각 앱은 시작 시 `BrandConfig(seed, font, radius, vibe)`만 주입
- `design_system` 시그니처가 깨지면 **모든 앱이 동시에** 깨진다 → 안정화 후 함부로 바꾸지 않는다

## 현재 상태

- [ ] 모노레포 골격 세팅 (melos + design_system + core + dday 연결)
- [ ] design_system 구체 설계
- [ ] D-Day MVP 범위 확정 및 개발 시작

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
- Notion 대시보드: https://github.com/sungho8/Building-something-great
