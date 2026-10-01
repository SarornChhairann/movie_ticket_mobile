// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_bookings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyBookingsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MyBookingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MyBookingsState()';
}


}

/// @nodoc
class $MyBookingsStateCopyWith<$Res>  {
$MyBookingsStateCopyWith(MyBookingsState _, $Res Function(MyBookingsState) __);
}


/// Adds pattern-matching-related methods to [MyBookingsState].
extension MyBookingsStatePatterns on MyBookingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MyBookingsInitial value)?  initial,TResult Function( MyBookingsLoading value)?  loading,TResult Function( MyBookingsReady value)?  ready,TResult Function( MyBookingsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MyBookingsInitial() when initial != null:
return initial(_that);case MyBookingsLoading() when loading != null:
return loading(_that);case MyBookingsReady() when ready != null:
return ready(_that);case MyBookingsFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MyBookingsInitial value)  initial,required TResult Function( MyBookingsLoading value)  loading,required TResult Function( MyBookingsReady value)  ready,required TResult Function( MyBookingsFailure value)  failure,}){
final _that = this;
switch (_that) {
case MyBookingsInitial():
return initial(_that);case MyBookingsLoading():
return loading(_that);case MyBookingsReady():
return ready(_that);case MyBookingsFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MyBookingsInitial value)?  initial,TResult? Function( MyBookingsLoading value)?  loading,TResult? Function( MyBookingsReady value)?  ready,TResult? Function( MyBookingsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MyBookingsInitial() when initial != null:
return initial(_that);case MyBookingsLoading() when loading != null:
return loading(_that);case MyBookingsReady() when ready != null:
return ready(_that);case MyBookingsFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BookingSummary> bookings,  bool refreshing,  int? cancellingId,  MyBookingsEffect? effect,  String? message)?  ready,TResult Function( TicketsFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MyBookingsInitial() when initial != null:
return initial();case MyBookingsLoading() when loading != null:
return loading();case MyBookingsReady() when ready != null:
return ready(_that.bookings,_that.refreshing,_that.cancellingId,_that.effect,_that.message);case MyBookingsFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BookingSummary> bookings,  bool refreshing,  int? cancellingId,  MyBookingsEffect? effect,  String? message)  ready,required TResult Function( TicketsFailure failure)  failure,}) {final _that = this;
switch (_that) {
case MyBookingsInitial():
return initial();case MyBookingsLoading():
return loading();case MyBookingsReady():
return ready(_that.bookings,_that.refreshing,_that.cancellingId,_that.effect,_that.message);case MyBookingsFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BookingSummary> bookings,  bool refreshing,  int? cancellingId,  MyBookingsEffect? effect,  String? message)?  ready,TResult? Function( TicketsFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case MyBookingsInitial() when initial != null:
return initial();case MyBookingsLoading() when loading != null:
return loading();case MyBookingsReady() when ready != null:
return ready(_that.bookings,_that.refreshing,_that.cancellingId,_that.effect,_that.message);case MyBookingsFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MyBookingsInitial extends MyBookingsState {
  const MyBookingsInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MyBookingsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MyBookingsState.initial()';
}


}




/// @nodoc


class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MyBookingsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MyBookingsState.loading()';
}


}




/// @nodoc


class MyBookingsReady extends MyBookingsState {
  const MyBookingsReady({required  List<BookingSummary> bookings, this.refreshing = false, this.cancellingId, this.effect, this.message}): _bookings = bookings,super._();
  

/// Server order: newest first.
 final  List<BookingSummary> _bookings;
/// Server order: newest first.
 List<BookingSummary> get bookings {
  if (_bookings is EqualUnmodifiableListView) return _bookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookings);
}

@JsonKey() final  bool refreshing;
/// The booking whose cancel is in flight.
 final  int? cancellingId;
 final  MyBookingsEffect? effect;
/// Server message for [effect]; empty when the network failed.
 final  String? message;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyBookingsReadyCopyWith<MyBookingsReady> get copyWith => _$MyBookingsReadyCopyWithImpl<MyBookingsReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MyBookingsReady&&const DeepCollectionEquality().equals(other.bookings, _bookings)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.cancellingId, cancellingId) || other.cancellingId == cancellingId)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookings),refreshing,cancellingId,effect,message);
}

@override
String toString() {
    return 'MyBookingsState.ready(bookings: $bookings, refreshing: $refreshing, cancellingId: $cancellingId, effect: $effect, message: $message)';
}


}

/// @nodoc
abstract mixin class $MyBookingsReadyCopyWith<$Res> implements $MyBookingsStateCopyWith<$Res> {
  factory $MyBookingsReadyCopyWith(MyBookingsReady value, $Res Function(MyBookingsReady) _then) = _$MyBookingsReadyCopyWithImpl;
@useResult
$Res call({
 List<BookingSummary> bookings, bool refreshing, int? cancellingId, MyBookingsEffect? effect, String? message
});




}
/// @nodoc
class _$MyBookingsReadyCopyWithImpl<$Res>
    implements $MyBookingsReadyCopyWith<$Res> {
  _$MyBookingsReadyCopyWithImpl(this._self, this._then);

  final MyBookingsReady _self;
  final $Res Function(MyBookingsReady) _then;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookings = null,Object? refreshing = null,Object? cancellingId = freezed,Object? effect = freezed,Object? message = freezed,}) {
  return _then(MyBookingsReady(
bookings: null == bookings ? _self._bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<BookingSummary>,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,cancellingId: freezed == cancellingId ? _self.cancellingId : cancellingId // ignore: cast_nullable_to_non_nullable
as int?,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as MyBookingsEffect?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class MyBookingsFailure extends MyBookingsState {
  const MyBookingsFailure(this.failure): super._();
  

 final  TicketsFailure failure;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyBookingsFailureCopyWith<MyBookingsFailure> get copyWith => _$MyBookingsFailureCopyWithImpl<MyBookingsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MyBookingsFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'MyBookingsState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MyBookingsFailureCopyWith<$Res> implements $MyBookingsStateCopyWith<$Res> {
  factory $MyBookingsFailureCopyWith(MyBookingsFailure value, $Res Function(MyBookingsFailure) _then) = _$MyBookingsFailureCopyWithImpl;
@useResult
$Res call({
 TicketsFailure failure
});


$TicketsFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$MyBookingsFailureCopyWithImpl<$Res>
    implements $MyBookingsFailureCopyWith<$Res> {
  _$MyBookingsFailureCopyWithImpl(this._self, this._then);

  final MyBookingsFailure _self;
  final $Res Function(MyBookingsFailure) _then;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MyBookingsFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TicketsFailure,
  ));
}

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketsFailureCopyWith<$Res> get failure {
  
  return $TicketsFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
