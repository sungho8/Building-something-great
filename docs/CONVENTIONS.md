# App Factory — 코드 컨벤션

회사(EggSchool) CLAUDE.md를 **서버 없는 작은 유틸 앱 양산**에 맞게 적응시킨 규칙.
보편 규칙은 그대로 가져오고, API·인증 등 백엔드 전용 계층은 "해당 시에만" 적용한다.

> 핵심 정신: **단순함 우선 · 불필요한 추상화 금지**. 아래 구조도 이 원칙에 종속된다.

---

## 아키텍처: 경량 3계층 + Riverpod

```
apps/<app>/lib/
├── domain/
│   ├── entities/        # freezed 엔티티 (순수 데이터 + 계산 getter)
│   └── repositories/    # 리포지토리 인터페이스 (abstract interface class)
├── data/
│   └── repositories/    # 인터페이스 구현 (core LocalStore 등 위에)
├── presentation/
│   ├── viewmodels/      # Riverpod Notifier (+ 필요 시 freezed State)
│   ├── views/<feature>/ # 화면. 화면 전용 위젯은 views/<feature>/widgets/
│   └── widgets/         # 여러 화면 공용 위젯
├── di/                  # Provider 정의 (localStore·repository·viewmodel 등)
├── services/            # 앱 한정 서비스 (예: 홈위젯 동기화)
├── utils/               # 순수 유틸 함수
├── app.dart             # 루트 위젯 (BrandConfig 주입)
└── main.dart            # 진입점 (서비스 초기화 + ProviderScope override)
```

### 데이터 흐름
```
View → ViewModel(Notifier) → Repository → DataSource/LocalStore
```

### 경량화 원칙 (서버 없는 앱 기준)
- **UseCase 생략 가능:** ViewModel→Repository가 단순 통과면 UseCase를 두지 않는다.
- **Either/fpdart 생략 가능:** 로컬 저장은 실패 케이스가 거의 없다. 비동기 실패가
  의미 있는 기능(네트워크 등)에서만 `Either`/State-enum 도입.
- **State 클래스 생략 가능:** 동기 목록은 `Notifier<List<T>>`로 충분.
  비동기 로딩/에러가 있으면 freezed `State` + `status` enum 사용.
- 회사 doc의 "지금 필요 없는 인터페이스·추상 클래스 생성 금지"를 그대로 따른다.

### 공용 인프라는 packages로
- 저장·알림·광고·분석처럼 **모든 앱이 쓰는 것**은 앱이 아니라 `packages/core`에.
- 위젯·테마·토큰은 `packages/design_system`에 (브랜드 무지 원칙).

---

## 주석 (필수)
- 공개(public) 함수·클래스: `///` 한 줄 (무엇 + 왜)
- private 함수·변수: `//` 한 줄
- 모든 함수·클래스·위젯에 작성

## 간결한 코드
- 1곳에서만 쓰는 wrapper 함수 금지 → 인라인
- 실제 3곳 이상 재사용될 때만 추출
- 내부 코드 방어 코드 금지 (외부 입력에만 방어)
- `final items = <String>[];` (타입 중복 명시 금지)
- `return isValid;` (불필요한 if/else 금지)
- 미사용 import/변수/메서드 즉시 제거, "나중에 쓸" 코드 금지

## Riverpod
- `ref.watch`: select로 필요한 값만 구독 (3개 이상 동시면 전체 watch 허용)
- `ref.read`: 이벤트 핸들러 내 일회성 읽기
- `ref.listen`: 콜백 10줄 초과 또는 2개 이상이면 `_listenXxx(ref, context)`로 분리
- **Provider 접근은 View에서만.** 하위 위젯은 파라미터/콜백으로 수신
- Provider 정의는 `di/`에 모음

## Freezed 3.x
```dart
@freezed
abstract class DDayItem with _$DDayItem {   // abstract 필수
  const DDayItem._();                         // getter/메서드 추가 시 private 생성자 필수
  const factory DDayItem({required String id}) = _DDayItem;
  factory DDayItem.fromJson(Map<String, dynamic> json) => _$DDayItemFromJson(json);
}
```
- `@freezed`/`@JsonSerializable` 파일 생성·수정 후 `melos run gen` (build_runner) 필수

## 코드 스타일
- Enum Shorthand: `copyWith(status: .loading)`, `textAlign: .center`
- `withValues(alpha:)` 사용 (`withOpacity` 금지 — deprecated)
- `const` 위젯 적극 사용
- `GestureDetector` 금지 → `InkWell`/`Material` (ripple). 예외: 정밀 제스처 제어
- children 배열 위젯 간 빈 줄
- View 파일 내 private 위젯 클래스(`_Xxx`) 금지 → `views/<feature>/widgets/`에 별도 파일

## 디자인 토큰 (하드코딩 금지)
- 색/크기/간격/반경은 `design_system` 토큰 사용 (`AppSpacing` 등)
- 하드코딩된 색상·크기·경로·시간 금지 → 상수/토큰

## 네이밍
- 파일: snake_case | 클래스: PascalCase | 변수·함수: camelCase
- 1 엔티티 = 1 파일

## 로깅
- 메시지는 **한글**, 클래스·함수·변수명은 영어
- (로거 패키지는 추후 core에 도입 예정)

## Barrel (export)
- 폴더에 파일이 여러 개로 늘면 barrel 도입 (단일 파일이면 생략 — 과한 추상화 방지)
- `.freezed.dart`/`.g.dart` export 금지, 알파벳순 정렬

## 완료 전 검증 (필수)
- `melos run analyze` 에러 0개
- `melos run test --no-select` 통과
- freezed 수정 시 `melos run gen` 선행

---

## 보안
- `.env`, 서비스 계정 JSON, keystore(.jks), `key.properties` 등 시크릿은
  어떤 도구로도 읽지 않고 Git에 커밋하지 않는다.

## 보류/이슈
- 발견한 이슈는 `docs/KNOWN_ISSUES.md`에 기록.
