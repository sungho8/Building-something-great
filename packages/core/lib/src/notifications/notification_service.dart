import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// 공용 로컬 알림 서비스. 모든 앱이 재사용한다.
///
/// 특정 날짜에 1회성 알림을 예약/취소한다. 타임존은 기기 로컬을 따른다.
class NotificationService {
  /// [plugin] 생략 시 기본 인스턴스를 쓴다. 단위 테스트에서 이 서비스를 상속한
  /// 페이크가 `flutter_local_notifications`를 직접 import하지 않고도 super()를
  /// 호출할 수 있게 선택 인자로 둔다.
  /// [plugin] 생략 시 기본 인스턴스를 쓴다(단위 테스트 페이크용).
  /// [channelId]/[channelName]은 앱마다 다르게 준다(공용 인프라이므로).
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    this.channelId = 'reminders',
    this.channelName = '알림',
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// Android 알림 채널 id/이름. 앱별로 지정한다.
  final String channelId;
  final String channelName;

  /// 앱 시작 시 한 번 호출. 타임존 초기화 + 플러그인 초기화.
  static Future<NotificationService> create({
    String channelId = 'reminders',
    String channelName = '알림',
  }) async {
    tzdata.initializeTimeZones();
    try {
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (_) {
      // 기기 타임존 조회 실패 시 기본(UTC) 유지.
    }

    final plugin = FlutterLocalNotificationsPlugin();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(settings);
    return NotificationService(
        plugin: plugin, channelId: channelId, channelName: channelName);
  }

  /// 알림 권한 요청 (Android 13+ / iOS).
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// [date] 당일 오전 9시에 알림을 예약한다. 과거 시각이면 예약하지 않는다.
  Future<void> scheduleOnDate({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    int hour = 9,
  }) =>
      scheduleAt(
        id: id,
        title: title,
        body: body,
        dateTime: DateTime(date.year, date.month, date.day, hour),
      );

  /// [dateTime] 정각(시각 포함)에 알림을 예약한다. 과거면 예약하지 않는다.
  /// 부정확 허용(정확 알람 권한 불필요) — 이정표 축하 등 분 단위 오차는 무방.
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
}
