// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dday_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DDayItem {

 String get id; String get title; DateTime get date;/// 매년 반복(생일·기념일). 지난 날짜는 자동으로 다음 도래일로 계산된다.
 bool get repeatYearly;/// 카드·위젯에 붙는 이모지. 빈 문자열이면 없음.
 String get emoji;/// 목록 맨 위·홈 위젯 고정.
 bool get pinned;/// 지난 날짜를 셀 때 당일을 1일로 포함 (만난 날 = 1일).
 bool get includeStartDay;/// 알림 시점 목록. 비어 있으면 알림 없음.
 List<DdayReminder> get reminders;/// KeyColor(ARGB). null이면 앱 브랜드색을 따른다. 히어로 카드 채움·라벨 강조에 쓰임.
 int? get colorValue;/// 생성 시각. 진행 게이지 계산용 (구버전 데이터는 null).
 DateTime? get createdAt;
/// Create a copy of DDayItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DDayItemCopyWith<DDayItem> get copyWith => _$DDayItemCopyWithImpl<DDayItem>(this as DDayItem, _$identity);

  /// Serializes this DDayItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DDayItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.repeatYearly, repeatYearly) || other.repeatYearly == repeatYearly)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.includeStartDay, includeStartDay) || other.includeStartDay == includeStartDay)&&const DeepCollectionEquality().equals(other.reminders, reminders)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,repeatYearly,emoji,pinned,includeStartDay,const DeepCollectionEquality().hash(reminders),colorValue,createdAt);

@override
String toString() {
  return 'DDayItem(id: $id, title: $title, date: $date, repeatYearly: $repeatYearly, emoji: $emoji, pinned: $pinned, includeStartDay: $includeStartDay, reminders: $reminders, colorValue: $colorValue, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DDayItemCopyWith<$Res>  {
  factory $DDayItemCopyWith(DDayItem value, $Res Function(DDayItem) _then) = _$DDayItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime date, bool repeatYearly, String emoji, bool pinned, bool includeStartDay, List<DdayReminder> reminders, int? colorValue, DateTime? createdAt
});




}
/// @nodoc
class _$DDayItemCopyWithImpl<$Res>
    implements $DDayItemCopyWith<$Res> {
  _$DDayItemCopyWithImpl(this._self, this._then);

  final DDayItem _self;
  final $Res Function(DDayItem) _then;

/// Create a copy of DDayItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,Object? repeatYearly = null,Object? emoji = null,Object? pinned = null,Object? includeStartDay = null,Object? reminders = null,Object? colorValue = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,repeatYearly: null == repeatYearly ? _self.repeatYearly : repeatYearly // ignore: cast_nullable_to_non_nullable
as bool,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,includeStartDay: null == includeStartDay ? _self.includeStartDay : includeStartDay // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<DdayReminder>,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DDayItem].
extension DDayItemPatterns on DDayItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DDayItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DDayItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DDayItem value)  $default,){
final _that = this;
switch (_that) {
case _DDayItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DDayItem value)?  $default,){
final _that = this;
switch (_that) {
case _DDayItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime date,  bool repeatYearly,  String emoji,  bool pinned,  bool includeStartDay,  List<DdayReminder> reminders,  int? colorValue,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DDayItem() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.repeatYearly,_that.emoji,_that.pinned,_that.includeStartDay,_that.reminders,_that.colorValue,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime date,  bool repeatYearly,  String emoji,  bool pinned,  bool includeStartDay,  List<DdayReminder> reminders,  int? colorValue,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DDayItem():
return $default(_that.id,_that.title,_that.date,_that.repeatYearly,_that.emoji,_that.pinned,_that.includeStartDay,_that.reminders,_that.colorValue,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime date,  bool repeatYearly,  String emoji,  bool pinned,  bool includeStartDay,  List<DdayReminder> reminders,  int? colorValue,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DDayItem() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.repeatYearly,_that.emoji,_that.pinned,_that.includeStartDay,_that.reminders,_that.colorValue,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DDayItem extends DDayItem {
  const _DDayItem({required this.id, required this.title, required this.date, this.repeatYearly = false, this.emoji = '', this.pinned = false, this.includeStartDay = false, final  List<DdayReminder> reminders = const [DdayReminder.onDay], this.colorValue, this.createdAt}): _reminders = reminders,super._();
  factory _DDayItem.fromJson(Map<String, dynamic> json) => _$DDayItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime date;
/// 매년 반복(생일·기념일). 지난 날짜는 자동으로 다음 도래일로 계산된다.
@override@JsonKey() final  bool repeatYearly;
/// 카드·위젯에 붙는 이모지. 빈 문자열이면 없음.
@override@JsonKey() final  String emoji;
/// 목록 맨 위·홈 위젯 고정.
@override@JsonKey() final  bool pinned;
/// 지난 날짜를 셀 때 당일을 1일로 포함 (만난 날 = 1일).
@override@JsonKey() final  bool includeStartDay;
/// 알림 시점 목록. 비어 있으면 알림 없음.
 final  List<DdayReminder> _reminders;
/// 알림 시점 목록. 비어 있으면 알림 없음.
@override@JsonKey() List<DdayReminder> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

/// KeyColor(ARGB). null이면 앱 브랜드색을 따른다. 히어로 카드 채움·라벨 강조에 쓰임.
@override final  int? colorValue;
/// 생성 시각. 진행 게이지 계산용 (구버전 데이터는 null).
@override final  DateTime? createdAt;

/// Create a copy of DDayItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DDayItemCopyWith<_DDayItem> get copyWith => __$DDayItemCopyWithImpl<_DDayItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DDayItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DDayItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.repeatYearly, repeatYearly) || other.repeatYearly == repeatYearly)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.includeStartDay, includeStartDay) || other.includeStartDay == includeStartDay)&&const DeepCollectionEquality().equals(other._reminders, _reminders)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,repeatYearly,emoji,pinned,includeStartDay,const DeepCollectionEquality().hash(_reminders),colorValue,createdAt);

@override
String toString() {
  return 'DDayItem(id: $id, title: $title, date: $date, repeatYearly: $repeatYearly, emoji: $emoji, pinned: $pinned, includeStartDay: $includeStartDay, reminders: $reminders, colorValue: $colorValue, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DDayItemCopyWith<$Res> implements $DDayItemCopyWith<$Res> {
  factory _$DDayItemCopyWith(_DDayItem value, $Res Function(_DDayItem) _then) = __$DDayItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime date, bool repeatYearly, String emoji, bool pinned, bool includeStartDay, List<DdayReminder> reminders, int? colorValue, DateTime? createdAt
});




}
/// @nodoc
class __$DDayItemCopyWithImpl<$Res>
    implements _$DDayItemCopyWith<$Res> {
  __$DDayItemCopyWithImpl(this._self, this._then);

  final _DDayItem _self;
  final $Res Function(_DDayItem) _then;

/// Create a copy of DDayItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,Object? repeatYearly = null,Object? emoji = null,Object? pinned = null,Object? includeStartDay = null,Object? reminders = null,Object? colorValue = freezed,Object? createdAt = freezed,}) {
  return _then(_DDayItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,repeatYearly: null == repeatYearly ? _self.repeatYearly : repeatYearly // ignore: cast_nullable_to_non_nullable
as bool,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,includeStartDay: null == includeStartDay ? _self.includeStartDay : includeStartDay // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<DdayReminder>,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
