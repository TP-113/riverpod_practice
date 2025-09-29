// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lap_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LapTime {

 int get lapNumber;// ラップ番号
 int get totalSeconds;
/// Create a copy of LapTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LapTimeCopyWith<LapTime> get copyWith => _$LapTimeCopyWithImpl<LapTime>(this as LapTime, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LapTime&&(identical(other.lapNumber, lapNumber) || other.lapNumber == lapNumber)&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,lapNumber,totalSeconds);

@override
String toString() {
  return 'LapTime(lapNumber: $lapNumber, totalSeconds: $totalSeconds)';
}


}

/// @nodoc
abstract mixin class $LapTimeCopyWith<$Res>  {
  factory $LapTimeCopyWith(LapTime value, $Res Function(LapTime) _then) = _$LapTimeCopyWithImpl;
@useResult
$Res call({
 int lapNumber, int totalSeconds
});




}
/// @nodoc
class _$LapTimeCopyWithImpl<$Res>
    implements $LapTimeCopyWith<$Res> {
  _$LapTimeCopyWithImpl(this._self, this._then);

  final LapTime _self;
  final $Res Function(LapTime) _then;

/// Create a copy of LapTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lapNumber = null,Object? totalSeconds = null,}) {
  return _then(_self.copyWith(
lapNumber: null == lapNumber ? _self.lapNumber : lapNumber // ignore: cast_nullable_to_non_nullable
as int,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LapTime].
extension LapTimePatterns on LapTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LapTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LapTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LapTime value)  $default,){
final _that = this;
switch (_that) {
case _LapTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LapTime value)?  $default,){
final _that = this;
switch (_that) {
case _LapTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int lapNumber,  int totalSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LapTime() when $default != null:
return $default(_that.lapNumber,_that.totalSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int lapNumber,  int totalSeconds)  $default,) {final _that = this;
switch (_that) {
case _LapTime():
return $default(_that.lapNumber,_that.totalSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int lapNumber,  int totalSeconds)?  $default,) {final _that = this;
switch (_that) {
case _LapTime() when $default != null:
return $default(_that.lapNumber,_that.totalSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _LapTime implements LapTime {
  const _LapTime({required this.lapNumber, required this.totalSeconds});
  

@override final  int lapNumber;
// ラップ番号
@override final  int totalSeconds;

/// Create a copy of LapTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LapTimeCopyWith<_LapTime> get copyWith => __$LapTimeCopyWithImpl<_LapTime>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LapTime&&(identical(other.lapNumber, lapNumber) || other.lapNumber == lapNumber)&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,lapNumber,totalSeconds);

@override
String toString() {
  return 'LapTime(lapNumber: $lapNumber, totalSeconds: $totalSeconds)';
}


}

/// @nodoc
abstract mixin class _$LapTimeCopyWith<$Res> implements $LapTimeCopyWith<$Res> {
  factory _$LapTimeCopyWith(_LapTime value, $Res Function(_LapTime) _then) = __$LapTimeCopyWithImpl;
@override @useResult
$Res call({
 int lapNumber, int totalSeconds
});




}
/// @nodoc
class __$LapTimeCopyWithImpl<$Res>
    implements _$LapTimeCopyWith<$Res> {
  __$LapTimeCopyWithImpl(this._self, this._then);

  final _LapTime _self;
  final $Res Function(_LapTime) _then;

/// Create a copy of LapTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lapNumber = null,Object? totalSeconds = null,}) {
  return _then(_LapTime(
lapNumber: null == lapNumber ? _self.lapNumber : lapNumber // ignore: cast_nullable_to_non_nullable
as int,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
