// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quit_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuitItem {

 String get id; String get name; QuitType get type;/// 끊은 일시(시 단위까지). 경과 카운트의 기준.
 DateTime get quitDate;/// 이전 하루 지출(원). 절약액 계산.
 int get dailyCost;/// 이전 하루 소비량(개비/잔/회). 회피량 계산.
 double get dailyUnits;/// 소비 단위 라벨(개비/잔/회).
 String get unitLabel;/// 최고 연속 기록(일). 리셋해도 보존.
 int get bestStreakDays;/// KeyColor(ARGB). null이면 브랜드색.
 int? get colorValue; DateTime? get createdAt;
/// Create a copy of QuitItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuitItemCopyWith<QuitItem> get copyWith => _$QuitItemCopyWithImpl<QuitItem>(this as QuitItem, _$identity);

  /// Serializes this QuitItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.quitDate, quitDate) || other.quitDate == quitDate)&&(identical(other.dailyCost, dailyCost) || other.dailyCost == dailyCost)&&(identical(other.dailyUnits, dailyUnits) || other.dailyUnits == dailyUnits)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&(identical(other.bestStreakDays, bestStreakDays) || other.bestStreakDays == bestStreakDays)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,quitDate,dailyCost,dailyUnits,unitLabel,bestStreakDays,colorValue,createdAt);

@override
String toString() {
  return 'QuitItem(id: $id, name: $name, type: $type, quitDate: $quitDate, dailyCost: $dailyCost, dailyUnits: $dailyUnits, unitLabel: $unitLabel, bestStreakDays: $bestStreakDays, colorValue: $colorValue, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $QuitItemCopyWith<$Res>  {
  factory $QuitItemCopyWith(QuitItem value, $Res Function(QuitItem) _then) = _$QuitItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, QuitType type, DateTime quitDate, int dailyCost, double dailyUnits, String unitLabel, int bestStreakDays, int? colorValue, DateTime? createdAt
});




}
/// @nodoc
class _$QuitItemCopyWithImpl<$Res>
    implements $QuitItemCopyWith<$Res> {
  _$QuitItemCopyWithImpl(this._self, this._then);

  final QuitItem _self;
  final $Res Function(QuitItem) _then;

/// Create a copy of QuitItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? quitDate = null,Object? dailyCost = null,Object? dailyUnits = null,Object? unitLabel = null,Object? bestStreakDays = null,Object? colorValue = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuitType,quitDate: null == quitDate ? _self.quitDate : quitDate // ignore: cast_nullable_to_non_nullable
as DateTime,dailyCost: null == dailyCost ? _self.dailyCost : dailyCost // ignore: cast_nullable_to_non_nullable
as int,dailyUnits: null == dailyUnits ? _self.dailyUnits : dailyUnits // ignore: cast_nullable_to_non_nullable
as double,unitLabel: null == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String,bestStreakDays: null == bestStreakDays ? _self.bestStreakDays : bestStreakDays // ignore: cast_nullable_to_non_nullable
as int,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuitItem].
extension QuitItemPatterns on QuitItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuitItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuitItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuitItem value)  $default,){
final _that = this;
switch (_that) {
case _QuitItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuitItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuitItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  QuitType type,  DateTime quitDate,  int dailyCost,  double dailyUnits,  String unitLabel,  int bestStreakDays,  int? colorValue,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuitItem() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.quitDate,_that.dailyCost,_that.dailyUnits,_that.unitLabel,_that.bestStreakDays,_that.colorValue,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  QuitType type,  DateTime quitDate,  int dailyCost,  double dailyUnits,  String unitLabel,  int bestStreakDays,  int? colorValue,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _QuitItem():
return $default(_that.id,_that.name,_that.type,_that.quitDate,_that.dailyCost,_that.dailyUnits,_that.unitLabel,_that.bestStreakDays,_that.colorValue,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  QuitType type,  DateTime quitDate,  int dailyCost,  double dailyUnits,  String unitLabel,  int bestStreakDays,  int? colorValue,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _QuitItem() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.quitDate,_that.dailyCost,_that.dailyUnits,_that.unitLabel,_that.bestStreakDays,_that.colorValue,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuitItem extends QuitItem {
  const _QuitItem({required this.id, required this.name, this.type = QuitType.custom, required this.quitDate, this.dailyCost = 0, this.dailyUnits = 0, this.unitLabel = '회', this.bestStreakDays = 0, this.colorValue, this.createdAt}): super._();
  factory _QuitItem.fromJson(Map<String, dynamic> json) => _$QuitItemFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  QuitType type;
/// 끊은 일시(시 단위까지). 경과 카운트의 기준.
@override final  DateTime quitDate;
/// 이전 하루 지출(원). 절약액 계산.
@override@JsonKey() final  int dailyCost;
/// 이전 하루 소비량(개비/잔/회). 회피량 계산.
@override@JsonKey() final  double dailyUnits;
/// 소비 단위 라벨(개비/잔/회).
@override@JsonKey() final  String unitLabel;
/// 최고 연속 기록(일). 리셋해도 보존.
@override@JsonKey() final  int bestStreakDays;
/// KeyColor(ARGB). null이면 브랜드색.
@override final  int? colorValue;
@override final  DateTime? createdAt;

/// Create a copy of QuitItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuitItemCopyWith<_QuitItem> get copyWith => __$QuitItemCopyWithImpl<_QuitItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuitItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.quitDate, quitDate) || other.quitDate == quitDate)&&(identical(other.dailyCost, dailyCost) || other.dailyCost == dailyCost)&&(identical(other.dailyUnits, dailyUnits) || other.dailyUnits == dailyUnits)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&(identical(other.bestStreakDays, bestStreakDays) || other.bestStreakDays == bestStreakDays)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,quitDate,dailyCost,dailyUnits,unitLabel,bestStreakDays,colorValue,createdAt);

@override
String toString() {
  return 'QuitItem(id: $id, name: $name, type: $type, quitDate: $quitDate, dailyCost: $dailyCost, dailyUnits: $dailyUnits, unitLabel: $unitLabel, bestStreakDays: $bestStreakDays, colorValue: $colorValue, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuitItemCopyWith<$Res> implements $QuitItemCopyWith<$Res> {
  factory _$QuitItemCopyWith(_QuitItem value, $Res Function(_QuitItem) _then) = __$QuitItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, QuitType type, DateTime quitDate, int dailyCost, double dailyUnits, String unitLabel, int bestStreakDays, int? colorValue, DateTime? createdAt
});




}
/// @nodoc
class __$QuitItemCopyWithImpl<$Res>
    implements _$QuitItemCopyWith<$Res> {
  __$QuitItemCopyWithImpl(this._self, this._then);

  final _QuitItem _self;
  final $Res Function(_QuitItem) _then;

/// Create a copy of QuitItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? quitDate = null,Object? dailyCost = null,Object? dailyUnits = null,Object? unitLabel = null,Object? bestStreakDays = null,Object? colorValue = freezed,Object? createdAt = freezed,}) {
  return _then(_QuitItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuitType,quitDate: null == quitDate ? _self.quitDate : quitDate // ignore: cast_nullable_to_non_nullable
as DateTime,dailyCost: null == dailyCost ? _self.dailyCost : dailyCost // ignore: cast_nullable_to_non_nullable
as int,dailyUnits: null == dailyUnits ? _self.dailyUnits : dailyUnits // ignore: cast_nullable_to_non_nullable
as double,unitLabel: null == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String,bestStreakDays: null == bestStreakDays ? _self.bestStreakDays : bestStreakDays // ignore: cast_nullable_to_non_nullable
as int,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
