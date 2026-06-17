# 홈 위젯 설정 메모

D-Day 앱의 홈 화면 위젯 구현 현황과 설정 방법.

## 동작 원리

1. Flutter 측 `lib/services/widget_sync.dart`가 목록 변경 시 `home_widget`으로
   `dday_title` / `dday_label`을 저장하고 위젯 갱신을 트리거한다.
2. 네이티브 위젯이 그 값을 읽어 화면에 표시한다.

## ✅ Android (구현 완료)

- `android/app/src/main/kotlin/com/sungho/dday/DDayWidgetProvider.kt`
  — `HomeWidgetProvider` 상속, SharedPreferences에서 값 읽어 RemoteViews 갱신, 탭 시 앱 실행
- `res/layout/dday_widget.xml` — 위젯 레이아웃
- `res/xml/dday_widget_info.xml` — appwidget-provider 메타
- `res/drawable/dday_widget_bg.xml` — 둥근 핑크 배경
- `AndroidManifest.xml` — `<receiver>` 등록 + `POST_NOTIFICATIONS` 권한
- `build.gradle.kts` — `flutter_local_notifications`용 core library desugaring 활성화

`flutter build apk --debug` 통과 확인됨.

## ⏳ iOS (Xcode 작업 필요 — 미완)

iOS 홈 위젯은 **WidgetKit 확장 타깃**이 필요해서 CLI로 자동 생성이 어렵다.
앱 자체는 빌드·실행되지만 위젯은 아래 단계를 Xcode에서 직접 해야 추가된다.

1. `ios/Runner.xcworkspace`를 Xcode로 연다.
2. File → New → Target → **Widget Extension** 추가 (이름 예: `DDayWidget`).
3. Runner와 위젯 타깃 모두에 **App Groups** capability 추가
   (예: `group.com.sungho.dday`).
4. Flutter `main()`의 iOS 분기에서 `HomeWidget.setAppGroupId('group.com.sungho.dday')` 호출.
5. SwiftUI 위젯에서 `UserDefaults(suiteName: "group.com.sungho.dday")`로
   `dday_title` / `dday_label`을 읽어 표시. 위젯 `kind`는 `DDayWidget`
   (Flutter `updateWidget(iOSName: 'DDayWidget')`와 일치해야 함).

> 참고: 이 단계는 첫 출시(파이프라인 검증)에는 필수가 아니다.
> Android 위젯 + 양 플랫폼 알림으로 먼저 출시하고, iOS 위젯은 후속 업데이트로 붙여도 된다.
