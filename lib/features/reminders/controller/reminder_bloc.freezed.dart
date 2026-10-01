// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReminderState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReminderState()';
}


}

/// @nodoc
class $ReminderStateCopyWith<$Res>  {
$ReminderStateCopyWith(ReminderState _, $Res Function(ReminderState) __);
}


/// Adds pattern-matching-related methods to [ReminderState].
extension ReminderStatePatterns on ReminderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReminderIdle value)?  idle,TResult Function( ReminderSubmitting value)?  submitting,TResult Function( ReminderSuccess value)?  success,TResult Function( ReminderAlreadySubscribed value)?  alreadySubscribed,TResult Function( ReminderFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReminderIdle() when idle != null:
return idle(_that);case ReminderSubmitting() when submitting != null:
return submitting(_that);case ReminderSuccess() when success != null:
return success(_that);case ReminderAlreadySubscribed() when alreadySubscribed != null:
return alreadySubscribed(_that);case ReminderFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReminderIdle value)  idle,required TResult Function( ReminderSubmitting value)  submitting,required TResult Function( ReminderSuccess value)  success,required TResult Function( ReminderAlreadySubscribed value)  alreadySubscribed,required TResult Function( ReminderFailureState value)  failure,}){
final _that = this;
switch (_that) {
case ReminderIdle():
return idle(_that);case ReminderSubmitting():
return submitting(_that);case ReminderSuccess():
return success(_that);case ReminderAlreadySubscribed():
return alreadySubscribed(_that);case ReminderFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReminderIdle value)?  idle,TResult? Function( ReminderSubmitting value)?  submitting,TResult? Function( ReminderSuccess value)?  success,TResult? Function( ReminderAlreadySubscribed value)?  alreadySubscribed,TResult? Function( ReminderFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case ReminderIdle() when idle != null:
return idle(_that);case ReminderSubmitting() when submitting != null:
return submitting(_that);case ReminderSuccess() when success != null:
return success(_that);case ReminderAlreadySubscribed() when alreadySubscribed != null:
return alreadySubscribed(_that);case ReminderFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function()?  alreadySubscribed,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReminderIdle() when idle != null:
return idle();case ReminderSubmitting() when submitting != null:
return submitting();case ReminderSuccess() when success != null:
return success();case ReminderAlreadySubscribed() when alreadySubscribed != null:
return alreadySubscribed();case ReminderFailureState() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function()  alreadySubscribed,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case ReminderIdle():
return idle();case ReminderSubmitting():
return submitting();case ReminderSuccess():
return success();case ReminderAlreadySubscribed():
return alreadySubscribed();case ReminderFailureState():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function()?  alreadySubscribed,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case ReminderIdle() when idle != null:
return idle();case ReminderSubmitting() when submitting != null:
return submitting();case ReminderSuccess() when success != null:
return success();case ReminderAlreadySubscribed() when alreadySubscribed != null:
return alreadySubscribed();case ReminderFailureState() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ReminderIdle implements ReminderState {
  const ReminderIdle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReminderState.idle()';
}


}




/// @nodoc


class ReminderSubmitting implements ReminderState {
  const ReminderSubmitting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReminderState.submitting()';
}


}




/// @nodoc


class ReminderSuccess implements ReminderState {
  const ReminderSuccess();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReminderState.success()';
}


}




/// @nodoc


class ReminderAlreadySubscribed implements ReminderState {
  const ReminderAlreadySubscribed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderAlreadySubscribed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReminderState.alreadySubscribed()';
}


}




/// @nodoc


class ReminderFailureState implements ReminderState {
  const ReminderFailureState(this.message);
  

 final  String message;

/// Create a copy of ReminderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderFailureStateCopyWith<ReminderFailureState> get copyWith => _$ReminderFailureStateCopyWithImpl<ReminderFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderFailureState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ReminderState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $ReminderFailureStateCopyWith<$Res> implements $ReminderStateCopyWith<$Res> {
  factory $ReminderFailureStateCopyWith(ReminderFailureState value, $Res Function(ReminderFailureState) _then) = _$ReminderFailureStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ReminderFailureStateCopyWithImpl<$Res>
    implements $ReminderFailureStateCopyWith<$Res> {
  _$ReminderFailureStateCopyWithImpl(this._self, this._then);

  final ReminderFailureState _self;
  final $Res Function(ReminderFailureState) _then;

/// Create a copy of ReminderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ReminderFailureState(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
