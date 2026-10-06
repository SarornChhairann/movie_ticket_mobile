// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hall_schedule_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HallScheduleState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallScheduleState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HallScheduleState()';
}


}

/// @nodoc
class $HallScheduleStateCopyWith<$Res>  {
$HallScheduleStateCopyWith(HallScheduleState _, $Res Function(HallScheduleState) __);
}


/// Adds pattern-matching-related methods to [HallScheduleState].
extension HallScheduleStatePatterns on HallScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HallScheduleInitial value)?  initial,TResult Function( HallScheduleLoading value)?  loading,TResult Function( HallScheduleReady value)?  ready,TResult Function( HallScheduleFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HallScheduleInitial() when initial != null:
return initial(_that);case HallScheduleLoading() when loading != null:
return loading(_that);case HallScheduleReady() when ready != null:
return ready(_that);case HallScheduleFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HallScheduleInitial value)  initial,required TResult Function( HallScheduleLoading value)  loading,required TResult Function( HallScheduleReady value)  ready,required TResult Function( HallScheduleFailure value)  failure,}){
final _that = this;
switch (_that) {
case HallScheduleInitial():
return initial(_that);case HallScheduleLoading():
return loading(_that);case HallScheduleReady():
return ready(_that);case HallScheduleFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HallScheduleInitial value)?  initial,TResult? Function( HallScheduleLoading value)?  loading,TResult? Function( HallScheduleReady value)?  ready,TResult? Function( HallScheduleFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HallScheduleInitial() when initial != null:
return initial(_that);case HallScheduleLoading() when loading != null:
return loading(_that);case HallScheduleReady() when ready != null:
return ready(_that);case HallScheduleFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int hallId)?  loading,TResult Function( int hallId,  HallSchedule schedule,  bool refreshing)?  ready,TResult Function( int hallId,  ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HallScheduleInitial() when initial != null:
return initial();case HallScheduleLoading() when loading != null:
return loading(_that.hallId);case HallScheduleReady() when ready != null:
return ready(_that.hallId,_that.schedule,_that.refreshing);case HallScheduleFailure() when failure != null:
return failure(_that.hallId,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int hallId)  loading,required TResult Function( int hallId,  HallSchedule schedule,  bool refreshing)  ready,required TResult Function( int hallId,  ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case HallScheduleInitial():
return initial();case HallScheduleLoading():
return loading(_that.hallId);case HallScheduleReady():
return ready(_that.hallId,_that.schedule,_that.refreshing);case HallScheduleFailure():
return failure(_that.hallId,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int hallId)?  loading,TResult? Function( int hallId,  HallSchedule schedule,  bool refreshing)?  ready,TResult? Function( int hallId,  ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case HallScheduleInitial() when initial != null:
return initial();case HallScheduleLoading() when loading != null:
return loading(_that.hallId);case HallScheduleReady() when ready != null:
return ready(_that.hallId,_that.schedule,_that.refreshing);case HallScheduleFailure() when failure != null:
return failure(_that.hallId,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class HallScheduleInitial implements HallScheduleState {
  const HallScheduleInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallScheduleInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HallScheduleState.initial()';
}


}




/// @nodoc


class HallScheduleLoading implements HallScheduleState {
  const HallScheduleLoading(this.hallId);
  

 final  int hallId;

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallScheduleLoadingCopyWith<HallScheduleLoading> get copyWith => _$HallScheduleLoadingCopyWithImpl<HallScheduleLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallScheduleLoading&&(identical(other.hallId, hallId) || other.hallId == hallId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hallId);
}

@override
String toString() {
    return 'HallScheduleState.loading(hallId: $hallId)';
}


}

/// @nodoc
abstract mixin class $HallScheduleLoadingCopyWith<$Res> implements $HallScheduleStateCopyWith<$Res> {
  factory $HallScheduleLoadingCopyWith(HallScheduleLoading value, $Res Function(HallScheduleLoading) _then) = _$HallScheduleLoadingCopyWithImpl;
@useResult
$Res call({
 int hallId
});




}
/// @nodoc
class _$HallScheduleLoadingCopyWithImpl<$Res>
    implements $HallScheduleLoadingCopyWith<$Res> {
  _$HallScheduleLoadingCopyWithImpl(this._self, this._then);

  final HallScheduleLoading _self;
  final $Res Function(HallScheduleLoading) _then;

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hallId = null,}) {
  return _then(HallScheduleLoading(
null == hallId ? _self.hallId : hallId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class HallScheduleReady implements HallScheduleState {
  const HallScheduleReady({required this.hallId, required this.schedule, this.refreshing = false});
  

 final  int hallId;
 final  HallSchedule schedule;
/// A date change is loading; the previous date stays on screen.
@JsonKey() final  bool refreshing;

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallScheduleReadyCopyWith<HallScheduleReady> get copyWith => _$HallScheduleReadyCopyWithImpl<HallScheduleReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallScheduleReady&&(identical(other.hallId, hallId) || other.hallId == hallId)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hallId,schedule,refreshing);
}

@override
String toString() {
    return 'HallScheduleState.ready(hallId: $hallId, schedule: $schedule, refreshing: $refreshing)';
}


}

/// @nodoc
abstract mixin class $HallScheduleReadyCopyWith<$Res> implements $HallScheduleStateCopyWith<$Res> {
  factory $HallScheduleReadyCopyWith(HallScheduleReady value, $Res Function(HallScheduleReady) _then) = _$HallScheduleReadyCopyWithImpl;
@useResult
$Res call({
 int hallId, HallSchedule schedule, bool refreshing
});


$HallScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$HallScheduleReadyCopyWithImpl<$Res>
    implements $HallScheduleReadyCopyWith<$Res> {
  _$HallScheduleReadyCopyWithImpl(this._self, this._then);

  final HallScheduleReady _self;
  final $Res Function(HallScheduleReady) _then;

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hallId = null,Object? schedule = null,Object? refreshing = null,}) {
  return _then(HallScheduleReady(
hallId: null == hallId ? _self.hallId : hallId // ignore: cast_nullable_to_non_nullable
as int,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as HallSchedule,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HallScheduleCopyWith<$Res> get schedule {
  
  return $HallScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

/// @nodoc


class HallScheduleFailure implements HallScheduleState {
  const HallScheduleFailure(this.hallId, this.failure);
  

 final  int hallId;
 final  ApiFailure failure;

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallScheduleFailureCopyWith<HallScheduleFailure> get copyWith => _$HallScheduleFailureCopyWithImpl<HallScheduleFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallScheduleFailure&&(identical(other.hallId, hallId) || other.hallId == hallId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hallId,failure);
}

@override
String toString() {
    return 'HallScheduleState.failure(hallId: $hallId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HallScheduleFailureCopyWith<$Res> implements $HallScheduleStateCopyWith<$Res> {
  factory $HallScheduleFailureCopyWith(HallScheduleFailure value, $Res Function(HallScheduleFailure) _then) = _$HallScheduleFailureCopyWithImpl;
@useResult
$Res call({
 int hallId, ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$HallScheduleFailureCopyWithImpl<$Res>
    implements $HallScheduleFailureCopyWith<$Res> {
  _$HallScheduleFailureCopyWithImpl(this._self, this._then);

  final HallScheduleFailure _self;
  final $Res Function(HallScheduleFailure) _then;

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hallId = null,Object? failure = null,}) {
  return _then(HallScheduleFailure(
null == hallId ? _self.hallId : hallId // ignore: cast_nullable_to_non_nullable
as int,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of HallScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiFailureCopyWith<$Res> get failure {
  
  return $ApiFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
