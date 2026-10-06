// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_lookup_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingLookupState {

 bool get submitting;/// Set once; the view pops with it.
 BookingSummary? get found; TicketsFailure? get failure;
/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingLookupStateCopyWith<BookingLookupState> get copyWith => _$BookingLookupStateCopyWithImpl<BookingLookupState>(this as BookingLookupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingLookupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingLookupState&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.found, _this.found) || other.found == _this.found)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as BookingLookupState;
  return Object.hash(runtimeType,_this.submitting,_this.found,_this.failure);
}

@override
String toString() {
  final _this = this as BookingLookupState;
  return 'BookingLookupState(submitting: ${_this.submitting}, found: ${_this.found}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $BookingLookupStateCopyWith<$Res>  {
  factory $BookingLookupStateCopyWith(BookingLookupState value, $Res Function(BookingLookupState) _then) = _$BookingLookupStateCopyWithImpl;
@useResult
$Res call({
 bool submitting, BookingSummary? found, TicketsFailure? failure
});


$BookingSummaryCopyWith<$Res>? get found;$TicketsFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$BookingLookupStateCopyWithImpl<$Res>
    implements $BookingLookupStateCopyWith<$Res> {
  _$BookingLookupStateCopyWithImpl(this._self, this._then);

  final BookingLookupState _self;
  final $Res Function(BookingLookupState) _then;

/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submitting = null,Object? found = freezed,Object? failure = freezed,}) {
  return _then(BookingLookupState(
submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,found: freezed == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as BookingSummary?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TicketsFailure?,
  ));
}
/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSummaryCopyWith<$Res>? get found {
    if (_self.found == null) {
    return null;
  }

  return $BookingSummaryCopyWith<$Res>(_self.found!, (value) {
    return _then(_self.copyWith(found: value));
  });
}/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketsFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $TicketsFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingLookupState].
extension BookingLookupStatePatterns on BookingLookupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingLookupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingLookupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingLookupState value)  $default,){
final _that = this;
switch (_that) {
case _BookingLookupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingLookupState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingLookupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool submitting,  BookingSummary? found,  TicketsFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingLookupState() when $default != null:
return $default(_that.submitting,_that.found,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool submitting,  BookingSummary? found,  TicketsFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _BookingLookupState():
return $default(_that.submitting,_that.found,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool submitting,  BookingSummary? found,  TicketsFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BookingLookupState() when $default != null:
return $default(_that.submitting,_that.found,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BookingLookupState implements BookingLookupState {
  const _BookingLookupState({this.submitting = false, this.found, this.failure});
  

@override@JsonKey() final  bool submitting;
/// Set once; the view pops with it.
@override final  BookingSummary? found;
@override final  TicketsFailure? failure;

/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingLookupStateCopyWith<_BookingLookupState> get copyWith => __$BookingLookupStateCopyWithImpl<_BookingLookupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingLookupState&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.found, found) || other.found == found)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,submitting,found,failure);
}

@override
String toString() {
    return 'BookingLookupState(submitting: $submitting, found: $found, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BookingLookupStateCopyWith<$Res> implements $BookingLookupStateCopyWith<$Res> {
  factory _$BookingLookupStateCopyWith(_BookingLookupState value, $Res Function(_BookingLookupState) _then) = __$BookingLookupStateCopyWithImpl;
@override @useResult
$Res call({
 bool submitting, BookingSummary? found, TicketsFailure? failure
});


@override $BookingSummaryCopyWith<$Res>? get found;@override $TicketsFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$BookingLookupStateCopyWithImpl<$Res>
    implements _$BookingLookupStateCopyWith<$Res> {
  __$BookingLookupStateCopyWithImpl(this._self, this._then);

  final _BookingLookupState _self;
  final $Res Function(_BookingLookupState) _then;

/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submitting = null,Object? found = freezed,Object? failure = freezed,}) {
  return _then(_BookingLookupState(
submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,found: freezed == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as BookingSummary?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TicketsFailure?,
  ));
}

/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSummaryCopyWith<$Res>? get found {
    if (_self.found == null) {
    return null;
  }

  return $BookingSummaryCopyWith<$Res>(_self.found!, (value) {
    return _then(_self.copyWith(found: value));
  });
}/// Create a copy of BookingLookupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketsFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $TicketsFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
