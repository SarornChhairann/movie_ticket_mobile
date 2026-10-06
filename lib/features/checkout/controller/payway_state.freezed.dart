// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payway_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaywayState {

 PaywayLaunch get launch;/// Polls that failed in a row; the message shows from the third.
 int get failures;/// Server or network message after three failures in a row; the page stays open.
 String? get message;/// The close call is running.
 bool get closing;/// Set once; the view pops with it.
 PaywayOutcome? get outcome;
/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywayStateCopyWith<PaywayState> get copyWith => _$PaywayStateCopyWithImpl<PaywayState>(this as PaywayState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaywayState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayState&&(identical(other.launch, _this.launch) || other.launch == _this.launch)&&(identical(other.failures, _this.failures) || other.failures == _this.failures)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.closing, _this.closing) || other.closing == _this.closing)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome));
}


@override
int get hashCode {
  final _this = this as PaywayState;
  return Object.hash(runtimeType,_this.launch,_this.failures,_this.message,_this.closing,_this.outcome);
}

@override
String toString() {
  final _this = this as PaywayState;
  return 'PaywayState(launch: ${_this.launch}, failures: ${_this.failures}, message: ${_this.message}, closing: ${_this.closing}, outcome: ${_this.outcome})';
}


}

/// @nodoc
abstract mixin class $PaywayStateCopyWith<$Res>  {
  factory $PaywayStateCopyWith(PaywayState value, $Res Function(PaywayState) _then) = _$PaywayStateCopyWithImpl;
@useResult
$Res call({
 PaywayLaunch launch, int failures, String? message, bool closing, PaywayOutcome? outcome
});


$PaywayLaunchCopyWith<$Res> get launch;$PaywayOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class _$PaywayStateCopyWithImpl<$Res>
    implements $PaywayStateCopyWith<$Res> {
  _$PaywayStateCopyWithImpl(this._self, this._then);

  final PaywayState _self;
  final $Res Function(PaywayState) _then;

/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? launch = null,Object? failures = null,Object? message = freezed,Object? closing = null,Object? outcome = freezed,}) {
  return _then(PaywayState(
launch: null == launch ? _self.launch : launch // ignore: cast_nullable_to_non_nullable
as PaywayLaunch,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,closing: null == closing ? _self.closing : closing // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as PaywayOutcome?,
  ));
}
/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywayLaunchCopyWith<$Res> get launch {
  
  return $PaywayLaunchCopyWith<$Res>(_self.launch, (value) {
    return _then(_self.copyWith(launch: value));
  });
}/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywayOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $PaywayOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaywayState].
extension PaywayStatePatterns on PaywayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywayState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywayState value)  $default,){
final _that = this;
switch (_that) {
case _PaywayState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywayState value)?  $default,){
final _that = this;
switch (_that) {
case _PaywayState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaywayLaunch launch,  int failures,  String? message,  bool closing,  PaywayOutcome? outcome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywayState() when $default != null:
return $default(_that.launch,_that.failures,_that.message,_that.closing,_that.outcome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaywayLaunch launch,  int failures,  String? message,  bool closing,  PaywayOutcome? outcome)  $default,) {final _that = this;
switch (_that) {
case _PaywayState():
return $default(_that.launch,_that.failures,_that.message,_that.closing,_that.outcome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaywayLaunch launch,  int failures,  String? message,  bool closing,  PaywayOutcome? outcome)?  $default,) {final _that = this;
switch (_that) {
case _PaywayState() when $default != null:
return $default(_that.launch,_that.failures,_that.message,_that.closing,_that.outcome);case _:
  return null;

}
}

}

/// @nodoc


class _PaywayState implements PaywayState {
  const _PaywayState({required this.launch, this.failures = 0, this.message, this.closing = false, this.outcome});
  

@override final  PaywayLaunch launch;
/// Polls that failed in a row; the message shows from the third.
@override@JsonKey() final  int failures;
/// Server or network message after three failures in a row; the page stays open.
@override final  String? message;
/// The close call is running.
@override@JsonKey() final  bool closing;
/// Set once; the view pops with it.
@override final  PaywayOutcome? outcome;

/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywayStateCopyWith<_PaywayState> get copyWith => __$PaywayStateCopyWithImpl<_PaywayState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywayState&&(identical(other.launch, launch) || other.launch == launch)&&(identical(other.failures, failures) || other.failures == failures)&&(identical(other.message, message) || other.message == message)&&(identical(other.closing, closing) || other.closing == closing)&&(identical(other.outcome, outcome) || other.outcome == outcome));
}


@override
int get hashCode {
    return Object.hash(runtimeType,launch,failures,message,closing,outcome);
}

@override
String toString() {
    return 'PaywayState(launch: $launch, failures: $failures, message: $message, closing: $closing, outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class _$PaywayStateCopyWith<$Res> implements $PaywayStateCopyWith<$Res> {
  factory _$PaywayStateCopyWith(_PaywayState value, $Res Function(_PaywayState) _then) = __$PaywayStateCopyWithImpl;
@override @useResult
$Res call({
 PaywayLaunch launch, int failures, String? message, bool closing, PaywayOutcome? outcome
});


@override $PaywayLaunchCopyWith<$Res> get launch;@override $PaywayOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class __$PaywayStateCopyWithImpl<$Res>
    implements _$PaywayStateCopyWith<$Res> {
  __$PaywayStateCopyWithImpl(this._self, this._then);

  final _PaywayState _self;
  final $Res Function(_PaywayState) _then;

/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? launch = null,Object? failures = null,Object? message = freezed,Object? closing = null,Object? outcome = freezed,}) {
  return _then(_PaywayState(
launch: null == launch ? _self.launch : launch // ignore: cast_nullable_to_non_nullable
as PaywayLaunch,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,closing: null == closing ? _self.closing : closing // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as PaywayOutcome?,
  ));
}

/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywayLaunchCopyWith<$Res> get launch {
  
  return $PaywayLaunchCopyWith<$Res>(_self.launch, (value) {
    return _then(_self.copyWith(launch: value));
  });
}/// Create a copy of PaywayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywayOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $PaywayOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}

// dart format on
