// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TicketState()';
}


}

/// @nodoc
class $TicketStateCopyWith<$Res>  {
$TicketStateCopyWith(TicketState _, $Res Function(TicketState) __);
}


/// Adds pattern-matching-related methods to [TicketState].
extension TicketStatePatterns on TicketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TicketInitial value)?  initial,TResult Function( TicketLoading value)?  loading,TResult Function( TicketReady value)?  ready,TResult Function( TicketFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TicketInitial() when initial != null:
return initial(_that);case TicketLoading() when loading != null:
return loading(_that);case TicketReady() when ready != null:
return ready(_that);case TicketFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TicketInitial value)  initial,required TResult Function( TicketLoading value)  loading,required TResult Function( TicketReady value)  ready,required TResult Function( TicketFailureState value)  failure,}){
final _that = this;
switch (_that) {
case TicketInitial():
return initial(_that);case TicketLoading():
return loading(_that);case TicketReady():
return ready(_that);case TicketFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TicketInitial value)?  initial,TResult? Function( TicketLoading value)?  loading,TResult? Function( TicketReady value)?  ready,TResult? Function( TicketFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case TicketInitial() when initial != null:
return initial(_that);case TicketLoading() when loading != null:
return loading(_that);case TicketReady() when ready != null:
return ready(_that);case TicketFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String code)?  loading,TResult Function( String code,  Uint8List png,  bool offline,  DateTime? savedAt)?  ready,TResult Function( String code,  TicketsFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TicketInitial() when initial != null:
return initial();case TicketLoading() when loading != null:
return loading(_that.code);case TicketReady() when ready != null:
return ready(_that.code,_that.png,_that.offline,_that.savedAt);case TicketFailureState() when failure != null:
return failure(_that.code,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String code)  loading,required TResult Function( String code,  Uint8List png,  bool offline,  DateTime? savedAt)  ready,required TResult Function( String code,  TicketsFailure failure)  failure,}) {final _that = this;
switch (_that) {
case TicketInitial():
return initial();case TicketLoading():
return loading(_that.code);case TicketReady():
return ready(_that.code,_that.png,_that.offline,_that.savedAt);case TicketFailureState():
return failure(_that.code,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String code)?  loading,TResult? Function( String code,  Uint8List png,  bool offline,  DateTime? savedAt)?  ready,TResult? Function( String code,  TicketsFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case TicketInitial() when initial != null:
return initial();case TicketLoading() when loading != null:
return loading(_that.code);case TicketReady() when ready != null:
return ready(_that.code,_that.png,_that.offline,_that.savedAt);case TicketFailureState() when failure != null:
return failure(_that.code,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class TicketInitial implements TicketState {
  const TicketInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TicketState.initial()';
}


}




/// @nodoc


class TicketLoading implements TicketState {
  const TicketLoading(this.code);
  

 final  String code;

/// Create a copy of TicketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketLoadingCopyWith<TicketLoading> get copyWith => _$TicketLoadingCopyWithImpl<TicketLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketLoading&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code);
}

@override
String toString() {
    return 'TicketState.loading(code: $code)';
}


}

/// @nodoc
abstract mixin class $TicketLoadingCopyWith<$Res> implements $TicketStateCopyWith<$Res> {
  factory $TicketLoadingCopyWith(TicketLoading value, $Res Function(TicketLoading) _then) = _$TicketLoadingCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$TicketLoadingCopyWithImpl<$Res>
    implements $TicketLoadingCopyWith<$Res> {
  _$TicketLoadingCopyWithImpl(this._self, this._then);

  final TicketLoading _self;
  final $Res Function(TicketLoading) _then;

/// Create a copy of TicketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(TicketLoading(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketReady implements TicketState {
  const TicketReady({required this.code, required this.png, this.offline = false, this.savedAt});
  

 final  String code;
 final  Uint8List png;
@JsonKey() final  bool offline;
 final  DateTime? savedAt;

/// Create a copy of TicketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketReadyCopyWith<TicketReady> get copyWith => _$TicketReadyCopyWithImpl<TicketReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketReady&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.png, png)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,const DeepCollectionEquality().hash(png),offline,savedAt);
}

@override
String toString() {
    return 'TicketState.ready(code: $code, png: $png, offline: $offline, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $TicketReadyCopyWith<$Res> implements $TicketStateCopyWith<$Res> {
  factory $TicketReadyCopyWith(TicketReady value, $Res Function(TicketReady) _then) = _$TicketReadyCopyWithImpl;
@useResult
$Res call({
 String code, Uint8List png, bool offline, DateTime? savedAt
});




}
/// @nodoc
class _$TicketReadyCopyWithImpl<$Res>
    implements $TicketReadyCopyWith<$Res> {
  _$TicketReadyCopyWithImpl(this._self, this._then);

  final TicketReady _self;
  final $Res Function(TicketReady) _then;

/// Create a copy of TicketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? png = null,Object? offline = null,Object? savedAt = freezed,}) {
  return _then(TicketReady(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,png: null == png ? _self.png : png // ignore: cast_nullable_to_non_nullable
as Uint8List,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class TicketFailureState implements TicketState {
  const TicketFailureState({required this.code, required this.failure});
  

 final  String code;
 final  TicketsFailure failure;

/// Create a copy of TicketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketFailureStateCopyWith<TicketFailureState> get copyWith => _$TicketFailureStateCopyWithImpl<TicketFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketFailureState&&(identical(other.code, code) || other.code == code)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,failure);
}

@override
String toString() {
    return 'TicketState.failure(code: $code, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TicketFailureStateCopyWith<$Res> implements $TicketStateCopyWith<$Res> {
  factory $TicketFailureStateCopyWith(TicketFailureState value, $Res Function(TicketFailureState) _then) = _$TicketFailureStateCopyWithImpl;
@useResult
$Res call({
 String code, TicketsFailure failure
});


$TicketsFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$TicketFailureStateCopyWithImpl<$Res>
    implements $TicketFailureStateCopyWith<$Res> {
  _$TicketFailureStateCopyWithImpl(this._self, this._then);

  final TicketFailureState _self;
  final $Res Function(TicketFailureState) _then;

/// Create a copy of TicketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? failure = null,}) {
  return _then(TicketFailureState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TicketsFailure,
  ));
}

/// Create a copy of TicketState
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
