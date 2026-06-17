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

 String get id; String get title; DateTime get date;
/// Create a copy of DDayItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DDayItemCopyWith<DDayItem> get copyWith => _$DDayItemCopyWithImpl<DDayItem>(this as DDayItem, _$identity);

  /// Serializes this DDayItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DDayItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date);

@override
String toString() {
  return 'DDayItem(id: $id, title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class $DDayItemCopyWith<$Res>  {
  factory $DDayItemCopyWith(DDayItem value, $Res Function(DDayItem) _then) = _$DDayItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime date
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DDayItem() when $default != null:
return $default(_that.id,_that.title,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _DDayItem():
return $default(_that.id,_that.title,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _DDayItem() when $default != null:
return $default(_that.id,_that.title,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DDayItem extends DDayItem {
  const _DDayItem({required this.id, required this.title, required this.date}): super._();
  factory _DDayItem.fromJson(Map<String, dynamic> json) => _$DDayItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime date;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DDayItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date);

@override
String toString() {
  return 'DDayItem(id: $id, title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class _$DDayItemCopyWith<$Res> implements $DDayItemCopyWith<$Res> {
  factory _$DDayItemCopyWith(_DDayItem value, $Res Function(_DDayItem) _then) = __$DDayItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime date
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,}) {
  return _then(_DDayItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
