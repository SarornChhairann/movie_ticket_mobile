// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seat_map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeatMapState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatMapState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SeatMapState()';
}


}

/// @nodoc
class $SeatMapStateCopyWith<$Res>  {
$SeatMapStateCopyWith(SeatMapState _, $Res Function(SeatMapState) __);
}


/// Adds pattern-matching-related methods to [SeatMapState].
extension SeatMapStatePatterns on SeatMapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SeatMapInitial value)?  initial,TResult Function( SeatMapLoading value)?  loading,TResult Function( SeatMapReady value)?  ready,TResult Function( SeatMapFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SeatMapInitial() when initial != null:
return initial(_that);case SeatMapLoading() when loading != null:
return loading(_that);case SeatMapReady() when ready != null:
return ready(_that);case SeatMapFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SeatMapInitial value)  initial,required TResult Function( SeatMapLoading value)  loading,required TResult Function( SeatMapReady value)  ready,required TResult Function( SeatMapFailure value)  failure,}){
final _that = this;
switch (_that) {
case SeatMapInitial():
return initial(_that);case SeatMapLoading():
return loading(_that);case SeatMapReady():
return ready(_that);case SeatMapFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SeatMapInitial value)?  initial,TResult? Function( SeatMapLoading value)?  loading,TResult? Function( SeatMapReady value)?  ready,TResult? Function( SeatMapFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SeatMapInitial() when initial != null:
return initial(_that);case SeatMapLoading() when loading != null:
return loading(_that);case SeatMapReady() when ready != null:
return ready(_that);case SeatMapFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( SeatMapData data,  Set<int> heldByOthers,  Set<int> booked,  Set<int> selected,  Hold? hold,  bool holding,  int? secondsLeft,  SeatMapEffect? effect,  String? message)?  ready,TResult Function( ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SeatMapInitial() when initial != null:
return initial();case SeatMapLoading() when loading != null:
return loading();case SeatMapReady() when ready != null:
return ready(_that.data,_that.heldByOthers,_that.booked,_that.selected,_that.hold,_that.holding,_that.secondsLeft,_that.effect,_that.message);case SeatMapFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( SeatMapData data,  Set<int> heldByOthers,  Set<int> booked,  Set<int> selected,  Hold? hold,  bool holding,  int? secondsLeft,  SeatMapEffect? effect,  String? message)  ready,required TResult Function( ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case SeatMapInitial():
return initial();case SeatMapLoading():
return loading();case SeatMapReady():
return ready(_that.data,_that.heldByOthers,_that.booked,_that.selected,_that.hold,_that.holding,_that.secondsLeft,_that.effect,_that.message);case SeatMapFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( SeatMapData data,  Set<int> heldByOthers,  Set<int> booked,  Set<int> selected,  Hold? hold,  bool holding,  int? secondsLeft,  SeatMapEffect? effect,  String? message)?  ready,TResult? Function( ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case SeatMapInitial() when initial != null:
return initial();case SeatMapLoading() when loading != null:
return loading();case SeatMapReady() when ready != null:
return ready(_that.data,_that.heldByOthers,_that.booked,_that.selected,_that.hold,_that.holding,_that.secondsLeft,_that.effect,_that.message);case SeatMapFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SeatMapInitial extends SeatMapState {
  const SeatMapInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatMapInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SeatMapState.initial()';
}


}




/// @nodoc


class SeatMapLoading extends SeatMapState {
  const SeatMapLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatMapLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SeatMapState.loading()';
}


}




/// @nodoc


class SeatMapReady extends SeatMapState {
  const SeatMapReady({required this.data, required  Set<int> heldByOthers, required  Set<int> booked,  Set<int> selected = const <int>{}, this.hold, this.holding = false, this.secondsLeft, this.effect, this.message}): _heldByOthers = heldByOthers,_booked = booked,_selected = selected,super._();
  

 final  SeatMapData data;
 final  Set<int> _heldByOthers;
 Set<int> get heldByOthers {
  if (_heldByOthers is EqualUnmodifiableSetView) return _heldByOthers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_heldByOthers);
}

 final  Set<int> _booked;
 Set<int> get booked {
  if (_booked is EqualUnmodifiableSetView) return _booked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_booked);
}

 final  Set<int> _selected;
@JsonKey() Set<int> get selected {
  if (_selected is EqualUnmodifiableSetView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selected);
}

 final  Hold? hold;
@JsonKey() final  bool holding;
 final  int? secondsLeft;
 final  SeatMapEffect? effect;
/// Server message for [SeatMapEffect.conflict].
 final  String? message;

/// Create a copy of SeatMapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatMapReadyCopyWith<SeatMapReady> get copyWith => _$SeatMapReadyCopyWithImpl<SeatMapReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatMapReady&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.heldByOthers, _heldByOthers)&&const DeepCollectionEquality().equals(other.booked, _booked)&&const DeepCollectionEquality().equals(other.selected, _selected)&&(identical(other.hold, hold) || other.hold == hold)&&(identical(other.holding, holding) || other.holding == holding)&&(identical(other.secondsLeft, secondsLeft) || other.secondsLeft == secondsLeft)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,data,const DeepCollectionEquality().hash(_heldByOthers),const DeepCollectionEquality().hash(_booked),const DeepCollectionEquality().hash(_selected),hold,holding,secondsLeft,effect,message);
}

@override
String toString() {
    return 'SeatMapState.ready(data: $data, heldByOthers: $heldByOthers, booked: $booked, selected: $selected, hold: $hold, holding: $holding, secondsLeft: $secondsLeft, effect: $effect, message: $message)';
}


}

/// @nodoc
abstract mixin class $SeatMapReadyCopyWith<$Res> implements $SeatMapStateCopyWith<$Res> {
  factory $SeatMapReadyCopyWith(SeatMapReady value, $Res Function(SeatMapReady) _then) = _$SeatMapReadyCopyWithImpl;
@useResult
$Res call({
 SeatMapData data, Set<int> heldByOthers, Set<int> booked, Set<int> selected, Hold? hold, bool holding, int? secondsLeft, SeatMapEffect? effect, String? message
});


$SeatMapDataCopyWith<$Res> get data;$HoldCopyWith<$Res>? get hold;

}
/// @nodoc
class _$SeatMapReadyCopyWithImpl<$Res>
    implements $SeatMapReadyCopyWith<$Res> {
  _$SeatMapReadyCopyWithImpl(this._self, this._then);

  final SeatMapReady _self;
  final $Res Function(SeatMapReady) _then;

/// Create a copy of SeatMapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? heldByOthers = null,Object? booked = null,Object? selected = null,Object? hold = freezed,Object? holding = null,Object? secondsLeft = freezed,Object? effect = freezed,Object? message = freezed,}) {
  return _then(SeatMapReady(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SeatMapData,heldByOthers: null == heldByOthers ? _self._heldByOthers : heldByOthers // ignore: cast_nullable_to_non_nullable
as Set<int>,booked: null == booked ? _self._booked : booked // ignore: cast_nullable_to_non_nullable
as Set<int>,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as Set<int>,hold: freezed == hold ? _self.hold : hold // ignore: cast_nullable_to_non_nullable
as Hold?,holding: null == holding ? _self.holding : holding // ignore: cast_nullable_to_non_nullable
as bool,secondsLeft: freezed == secondsLeft ? _self.secondsLeft : secondsLeft // ignore: cast_nullable_to_non_nullable
as int?,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as SeatMapEffect?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SeatMapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeatMapDataCopyWith<$Res> get data {
  
  return $SeatMapDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of SeatMapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldCopyWith<$Res>? get hold {
    if (_self.hold == null) {
    return null;
  }

  return $HoldCopyWith<$Res>(_self.hold!, (value) {
    return _then(_self.copyWith(hold: value));
  });
}
}

/// @nodoc


class SeatMapFailure extends SeatMapState {
  const SeatMapFailure(this.failure): super._();
  

 final  ApiFailure failure;

/// Create a copy of SeatMapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatMapFailureCopyWith<SeatMapFailure> get copyWith => _$SeatMapFailureCopyWithImpl<SeatMapFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatMapFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'SeatMapState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SeatMapFailureCopyWith<$Res> implements $SeatMapStateCopyWith<$Res> {
  factory $SeatMapFailureCopyWith(SeatMapFailure value, $Res Function(SeatMapFailure) _then) = _$SeatMapFailureCopyWithImpl;
@useResult
$Res call({
 ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SeatMapFailureCopyWithImpl<$Res>
    implements $SeatMapFailureCopyWith<$Res> {
  _$SeatMapFailureCopyWithImpl(this._self, this._then);

  final SeatMapFailure _self;
  final $Res Function(SeatMapFailure) _then;

/// Create a copy of SeatMapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SeatMapFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of SeatMapState
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
