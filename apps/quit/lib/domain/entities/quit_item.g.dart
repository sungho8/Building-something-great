// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuitItem _$QuitItemFromJson(Map<String, dynamic> json) => _QuitItem(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecodeNullable(_$QuitTypeEnumMap, json['type']) ?? QuitType.custom,
  quitDate: DateTime.parse(json['quitDate'] as String),
  dailyCost: (json['dailyCost'] as num?)?.toInt() ?? 0,
  dailyUnits: (json['dailyUnits'] as num?)?.toDouble() ?? 0,
  unitLabel: json['unitLabel'] as String? ?? '회',
  bestStreakDays: (json['bestStreakDays'] as num?)?.toInt() ?? 0,
  colorValue: (json['colorValue'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuitItemToJson(_QuitItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$QuitTypeEnumMap[instance.type]!,
  'quitDate': instance.quitDate.toIso8601String(),
  'dailyCost': instance.dailyCost,
  'dailyUnits': instance.dailyUnits,
  'unitLabel': instance.unitLabel,
  'bestStreakDays': instance.bestStreakDays,
  'colorValue': instance.colorValue,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$QuitTypeEnumMap = {
  QuitType.smoking: 'smoking',
  QuitType.drinking: 'drinking',
  QuitType.custom: 'custom',
};
