// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dday_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DDayItem _$DDayItemFromJson(Map<String, dynamic> json) => _DDayItem(
  id: json['id'] as String,
  title: json['title'] as String,
  date: DateTime.parse(json['date'] as String),
  repeatYearly: json['repeatYearly'] as bool? ?? false,
  emoji: json['emoji'] as String? ?? '',
  pinned: json['pinned'] as bool? ?? false,
  includeStartDay: json['includeStartDay'] as bool? ?? false,
  reminders:
      (json['reminders'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DdayReminderEnumMap, e))
          .toList() ??
      const [DdayReminder.onDay],
  colorValue: (json['colorValue'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$DDayItemToJson(_DDayItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'date': instance.date.toIso8601String(),
  'repeatYearly': instance.repeatYearly,
  'emoji': instance.emoji,
  'pinned': instance.pinned,
  'includeStartDay': instance.includeStartDay,
  'reminders': instance.reminders
      .map((e) => _$DdayReminderEnumMap[e]!)
      .toList(),
  'colorValue': instance.colorValue,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$DdayReminderEnumMap = {
  DdayReminder.onDay: 'onDay',
  DdayReminder.dayBefore: 'dayBefore',
  DdayReminder.weekBefore: 'weekBefore',
};
