// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dday_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DDayItem _$DDayItemFromJson(Map<String, dynamic> json) => _DDayItem(
  id: json['id'] as String,
  title: json['title'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$DDayItemToJson(_DDayItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'date': instance.date.toIso8601String(),
};
