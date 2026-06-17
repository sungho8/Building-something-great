import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// 공용 로컬 알림 서비스. 모든 앱이 재사용한다.
///
/// 특정 날짜에 1회성 알림을 예약/취소한다. 타임존은 기기 로컬을 따른다.
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'dday_channel';
  static const _channelName = '날짜 알림';

  /// 앱 시작 시 한 번 호출. 타임존 초기화 + 플러그인 초기화.
  static Future<NotificationService> create() async {
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
    return NotificationService(plugin);
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
  }) async {
    final when = DateTime(date.year, date.month, date.day, hour);
    if (when.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
}
