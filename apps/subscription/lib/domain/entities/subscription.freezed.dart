// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Subscription {

 String get id; String get name;/// 1회 결제 금액(원).
 int get amount;/// 결제 주기.
 BillingCycle get cycle;/// 기준(최초) 결제일. 다음 결제일은 여기서 주기만큼 굴려 계산한다.
 DateTime get firstPaymentDate;/// 카테고리 (색·그룹핑).
 SubscriptionCategory get category;/// 카드 이모지. 빈 문자열이면 없음.
 String get emoji;/// KeyColor(ARGB). null이면 카테고리 기본색을 따른다.
 int? get colorValue;/// 결제 알림 시점. 비어 있으면 알림 없음.
 List<SubReminder> get reminders;/// 일시정지 여부. true면 총액 합산·알림에서 제외.
 bool get active; DateTime? get createdAt;
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<Subscription> get copyWith => _$SubscriptionCopyWithImpl<Subscription>(this as Subscription, _$identity);

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.firstPaymentDate, firstPaymentDate) || other.firstPaymentDate == firstPaymentDate)&&(identical(other.category, category) || other.category == category)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&const DeepCollectionEquality().equals(other.reminders, reminders)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,cycle,firstPaymentDate,category,emoji,colorValue,const DeepCollectionEquality().hash(reminders),active,createdAt);

@override
String toString() {
  return 'Subscription(id: $id, name: $name, amount: $amount, cycle: $cycle, firstPaymentDate: $firstPaymentDate, category: $category, emoji: $emoji, colorValue: $colorValue, reminders: $reminders, active: $active, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res>  {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) _then) = _$SubscriptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int amount, BillingCycle cycle, DateTime firstPaymentDate, SubscriptionCategory category, String emoji, int? colorValue, List<SubReminder> reminders, bool active, DateTime? createdAt
});




}
/// @nodoc
class _$SubscriptionCopyWithImpl<$Res>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? cycle = null,Object? firstPaymentDate = null,Object? category = null,Object? emoji = null,Object? colorValue = freezed,Object? reminders = null,Object? active = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as BillingCycle,firstPaymentDate: null == firstPaymentDate ? _self.firstPaymentDate : firstPaymentDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SubscriptionCategory,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int?,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<SubReminder>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subscription value)  $default,){
final _that = this;
switch (_that) {
case _Subscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subscription value)?  $default,){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int amount,  BillingCycle cycle,  DateTime firstPaymentDate,  SubscriptionCategory category,  String emoji,  int? colorValue,  List<SubReminder> reminders,  bool active,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.cycle,_that.firstPaymentDate,_that.category,_that.emoji,_that.colorValue,_that.reminders,_that.active,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int amount,  BillingCycle cycle,  DateTime firstPaymentDate,  SubscriptionCategory category,  String emoji,  int? colorValue,  List<SubReminder> reminders,  bool active,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Subscription():
return $default(_that.id,_that.name,_that.amount,_that.cycle,_that.firstPaymentDate,_that.category,_that.emoji,_that.colorValue,_that.reminders,_that.active,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int amount,  BillingCycle cycle,  DateTime firstPaymentDate,  SubscriptionCategory category,  String emoji,  int? colorValue,  List<SubReminder> reminders,  bool active,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.cycle,_that.firstPaymentDate,_that.category,_that.emoji,_that.colorValue,_that.reminders,_that.active,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Subscription extends Subscription {
  const _Subscription({required this.id, required this.name, required this.amount, this.cycle = BillingCycle.monthly, required this.firstPaymentDate, this.category = SubscriptionCategory.etc, this.emoji = '', this.colorValue, final  List<SubReminder> reminders = const [SubReminder.dayBefore], this.active = true, this.createdAt}): _reminders = reminders,super._();
  factory _Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

@override final  String id;
@override final  String name;
/// 1회 결제 금액(원).
@override final  int amount;
/// 결제 주기.
@override@JsonKey() final  BillingCycle cycle;
/// 기준(최초) 결제일. 다음 결제일은 여기서 주기만큼 굴려 계산한다.
@override final  DateTime firstPaymentDate;
/// 카테고리 (색·그룹핑).
@override@JsonKey() final  SubscriptionCategory category;
/// 카드 이모지. 빈 문자열이면 없음.
@override@JsonKey() final  String emoji;
/// KeyColor(ARGB). null이면 카테고리 기본색을 따른다.
@override final  int? colorValue;
/// 결제 알림 시점. 비어 있으면 알림 없음.
 final  List<SubReminder> _reminders;
/// 결제 알림 시점. 비어 있으면 알림 없음.
@override@JsonKey() List<SubReminder> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

/// 일시정지 여부. true면 총액 합산·알림에서 제외.
@override@JsonKey() final  bool active;
@override final  DateTime? createdAt;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionCopyWith<_Subscription> get copyWith => __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.firstPaymentDate, firstPaymentDate) || other.firstPaymentDate == firstPaymentDate)&&(identical(other.category, category) || other.category == category)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&const DeepCollectionEquality().equals(other._reminders, _reminders)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,cycle,firstPaymentDate,category,emoji,colorValue,const DeepCollectionEquality().hash(_reminders),active,createdAt);

@override
String toString() {
  return 'Subscription(id: $id, name: $name, amount: $amount, cycle: $cycle, firstPaymentDate: $firstPaymentDate, category: $category, emoji: $emoji, colorValue: $colorValue, reminders: $reminders, active: $active, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(_Subscription value, $Res Function(_Subscription) _then) = __$SubscriptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int amount, BillingCycle cycle, DateTime firstPaymentDate, SubscriptionCategory category, String emoji, int? colorValue, List<SubReminder> reminders, bool active, DateTime? createdAt
});




}
/// @nodoc
class __$SubscriptionCopyWithImpl<$Res>
    implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? cycle = null,Object? firstPaymentDate = null,Object? category = null,Object? emoji = null,Object? colorValue = freezed,Object? reminders = null,Object? active = null,Object? createdAt = freezed,}) {
  return _then(_Subscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as BillingCycle,firstPaymentDate: null == firstPaymentDate ? _self.firstPaymentDate : firstPaymentDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SubscriptionCategory,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,colorValue: freezed == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int?,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<SubReminder>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
