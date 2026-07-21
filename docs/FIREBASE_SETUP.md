# Firebase 설정 메모 (dday)

Phase 3 백엔드(게스트/Google 로그인 + Firestore 백업/복원)의 콘솔 설정.
코드는 `packages/backend`(공용) + dday 배선까지 완료·빌드 검증됨. 아래는 **콘솔에서 할 일**.

프로젝트: `d-day-273b7`

## ✅ 이미 완료

- `flutterfire configure` (firebase_options.dart / google-services.json / GoogleService-Info.plist)
- Blaze 플랜
- google-services Gradle 플러그인 적용
- dday 코드 배선: 게스트 로그인, 자동 백업(저장 시), 시작 시 로컬 비어있으면 복원, 계정 시트

## ⏳ 남은 콘솔 단계

### 1. 인증 provider 켜기
Firebase 콘솔 → Authentication → Sign-in method
- **익명(Anonymous)** 사용 설정 → 이걸 켜야 게스트 로그인·백업/복원이 동작
- **Google** 사용 설정 → 켜면 web OAuth 클라이언트가 자동 생성됨

### 2. Google 로그인 마무리 (익명만 쓸 거면 생략 가능)
1. 위에서 Google을 켠 뒤 **google-services.json 재발급**
   (콘솔 → 프로젝트 설정 → 안드로이드 앱 → google-services.json 다운로드,
   또는 `flutterfire configure` 재실행)
2. 새 json의 **web 클라이언트 ID**(client_type 3)를 복사해
   `apps/dday/lib/di/dday_providers.dart`의 `dDayGoogleServerClientId`에 넣기
3. **SHA-1 등록** (안드로이드 Google 로그인 필수):
   ```bash
   cd apps/dday/android && ./gradlew signingReport
   ```
   → debug SHA-1을 콘솔 → 안드로이드 앱 설정에 추가

### 3. Firestore 데이터베이스 + 보안 규칙
콘솔 → Firestore Database → 만들기(프로덕션 모드, 리전 `asia-northeast3` 서울) → 규칙에 아래 붙여넣기:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 백업은 본인(uid) 문서만 읽고 쓸 수 있다.
    match /backups/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

### 4. 비용 방어
- 결제 계정 → **예산 알림 $5, $10** 설정
- (권장) App Check 설정 — 봇의 백엔드 남용 차단

## 데이터 모델

- 컬렉션 `backups`, 문서 = `{uid}`, 필드 `data`(JSON 문자열) + `updatedAt`(서버 타임스탬프)
- **유저당 문서 1개** → 읽기/쓰기 최소화 (비용 핵심)
- 로컬(`LocalStore`)이 SSOT, Firestore는 백업 미러

## 동작 방식 (현재 구현)

- **자동 백업:** 항목 저장할 때마다 클라우드에 push (로그인돼 있고 온라인일 때, 비차단)
- **자동 복원:** 앱 시작 시 로컬이 비어 있고 클라우드에 백업이 있으면 복원 (새 기기 대비)
- **수동 복원:** 계정 시트 → "클라우드에서 복원" (로컬 덮어쓰기, 확인 후)
- ⚠️ 실시간 양방향 동기화(같은 항목 동시 편집 병합)는 아니고 **백업/복원(문서 단위 last-write-wins)** 수준. MVP엔 충분.

## 검증 상태

- 코드 컴파일 + APK 빌드 통과 ✅
- ⚠️ **로그인·Firestore 실제 왕복은 위 콘솔 단계(1·3) 완료 후 실기기에서 확인 필요** — 이 부분은 프로젝트/네트워크가 있어야 검증됨.
