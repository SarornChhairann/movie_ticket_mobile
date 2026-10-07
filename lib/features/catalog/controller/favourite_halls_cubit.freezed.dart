// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favourite_halls_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavouriteHallsState {

 List<int> get ids; Map<int, String> get nextTimes;
/// Create a copy of FavouriteHallsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavouriteHallsStateCopyWith<FavouriteHallsState> get copyWith => _$FavouriteHallsStateCopyWithImpl<FavouriteHallsState>(this as FavouriteHallsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FavouriteHallsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavouriteHallsState&&const DeepCollectionEquality().equals(other.ids, _this.ids)&&const DeepCollectionEquality().equals(other.nextTimes, _this.nextTimes));
}


@override
int get hashCode {
  final _this = this as FavouriteHallsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.ids),const DeepCollectionEquality().hash(_this.nextTimes));
}

@override
String toString() {
  final _this = this as FavouriteHallsState;
  return 'FavouriteHallsState(ids: ${_this.ids}, nextTimes: ${_this.nextTimes})';
}


}

/// @nodoc
abstract mixin class $FavouriteHallsStateCopyWith<$Res>  {
  factory $FavouriteHallsStateCopyWith(FavouriteHallsState value, $Res Function(FavouriteHallsState) _then) = _$FavouriteHallsStateCopyWithImpl;
@useResult
$Res call({
 List<int> ids, Map<int, String> nextTimes
});




}
/// @nodoc
class _$FavouriteHallsStateCopyWithImpl<$Res>
    implements $FavouriteHallsStateCopyWith<$Res> {
  _$FavouriteHallsStateCopyWithImpl(this._self, this._then);

  final FavouriteHallsState _self;
  final $Res Function(FavouriteHallsState) _then;

/// Create a copy of FavouriteHallsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ids = null,Object? nextTimes = null,}) {
  return _then(FavouriteHallsState(
ids: null == ids ? _self.ids : ids // ignore: cast_nullable_to_non_nullable
as List<int>,nextTimes: null == nextTimes ? _self.nextTimes : nextTimes // ignore: cast_nullable_to_non_nullable
as Map<int, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FavouriteHallsState].
extension FavouriteHallsStatePatterns on FavouriteHallsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavouriteHallsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavouriteHallsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavouriteHallsState value)  $default,){
final _that = this;
switch (_that) {
case _FavouriteHallsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavouriteHallsState value)?  $default,){
final _that = this;
switch (_that) {
case _FavouriteHallsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> ids,  Map<int, String> nextTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavouriteHallsState() when $default != null:
return $default(_that.ids,_that.nextTimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> ids,  Map<int, String> nextTimes)  $default,) {final _that = this;
switch (_that) {
case _FavouriteHallsState():
return $default(_that.ids,_that.nextTimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> ids,  Map<int, String> nextTimes)?  $default,) {final _that = this;
switch (_that) {
case _FavouriteHallsState() when $default != null:
return $default(_that.ids,_that.nextTimes);case _:
  return null;

}
}

}

/// @nodoc


class _FavouriteHallsState extends FavouriteHallsState {
  const _FavouriteHallsState({ List<int> ids = const [],  Map<int, String> nextTimes = const {}}): _ids = ids,_nextTimes = nextTimes,super._();
  

 final  List<int> _ids;
@override@JsonKey() List<int> get ids {
  if (_ids is EqualUnmodifiableListView) return _ids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ids);
}

 final  Map<int, String> _nextTimes;
@override@JsonKey() Map<int, String> get nextTimes {
  if (_nextTimes is EqualUnmodifiableMapView) return _nextTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nextTimes);
}


/// Create a copy of FavouriteHallsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavouriteHallsStateCopyWith<_FavouriteHallsState> get copyWith => __$FavouriteHallsStateCopyWithImpl<_FavouriteHallsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavouriteHallsState&&const DeepCollectionEquality().equals(other.ids, _ids)&&const DeepCollectionEquality().equals(other.nextTimes, _nextTimes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_ids),const DeepCollectionEquality().hash(_nextTimes));
}

@override
String toString() {
    return 'FavouriteHallsState(ids: $ids, nextTimes: $nextTimes)';
}


}

/// @nodoc
abstract mixin class _$FavouriteHallsStateCopyWith<$Res> implements $FavouriteHallsStateCopyWith<$Res> {
  factory _$FavouriteHallsStateCopyWith(_FavouriteHallsState value, $Res Function(_FavouriteHallsState) _then) = __$FavouriteHallsStateCopyWithImpl;
@override @useResult
$Res call({
 List<int> ids, Map<int, String> nextTimes
});




}
/// @nodoc
class __$FavouriteHallsStateCopyWithImpl<$Res>
    implements _$FavouriteHallsStateCopyWith<$Res> {
  __$FavouriteHallsStateCopyWithImpl(this._self, this._then);

  final _FavouriteHallsState _self;
  final $Res Function(_FavouriteHallsState) _then;

/// Create a copy of FavouriteHallsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ids = null,Object? nextTimes = null,}) {
  return _then(_FavouriteHallsState(
ids: null == ids ? _self._ids : ids // ignore: cast_nullable_to_non_nullable
as List<int>,nextTimes: null == nextTimes ? _self._nextTimes : nextTimes // ignore: cast_nullable_to_non_nullable
as Map<int, String>,
  ));
}


}

// dart format on
