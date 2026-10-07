// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hall_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HallListState {

 String? get city; String? get type; bool get dolbyOnly; bool get screenXOnly;
/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallListStateCopyWith<HallListState> get copyWith => _$HallListStateCopyWithImpl<HallListState>(this as HallListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HallListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallListState&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.dolbyOnly, _this.dolbyOnly) || other.dolbyOnly == _this.dolbyOnly)&&(identical(other.screenXOnly, _this.screenXOnly) || other.screenXOnly == _this.screenXOnly));
}


@override
int get hashCode {
  final _this = this as HallListState;
  return Object.hash(runtimeType,_this.city,_this.type,_this.dolbyOnly,_this.screenXOnly);
}

@override
String toString() {
  final _this = this as HallListState;
  return 'HallListState(city: ${_this.city}, type: ${_this.type}, dolbyOnly: ${_this.dolbyOnly}, screenXOnly: ${_this.screenXOnly})';
}


}

/// @nodoc
abstract mixin class $HallListStateCopyWith<$Res>  {
  factory $HallListStateCopyWith(HallListState value, $Res Function(HallListState) _then) = _$HallListStateCopyWithImpl;
@useResult
$Res call({
 String? city, String? type, bool dolbyOnly, bool screenXOnly
});




}
/// @nodoc
class _$HallListStateCopyWithImpl<$Res>
    implements $HallListStateCopyWith<$Res> {
  _$HallListStateCopyWithImpl(this._self, this._then);

  final HallListState _self;
  final $Res Function(HallListState) _then;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = freezed,Object? type = freezed,Object? dolbyOnly = null,Object? screenXOnly = null,}) {
  return _then(_self.copyWith(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dolbyOnly: null == dolbyOnly ? _self.dolbyOnly : dolbyOnly // ignore: cast_nullable_to_non_nullable
as bool,screenXOnly: null == screenXOnly ? _self.screenXOnly : screenXOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HallListState].
extension HallListStatePatterns on HallListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HallListInitial value)?  initial,TResult Function( HallListLoading value)?  loading,TResult Function( HallListReady value)?  ready,TResult Function( HallListFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HallListInitial() when initial != null:
return initial(_that);case HallListLoading() when loading != null:
return loading(_that);case HallListReady() when ready != null:
return ready(_that);case HallListFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HallListInitial value)  initial,required TResult Function( HallListLoading value)  loading,required TResult Function( HallListReady value)  ready,required TResult Function( HallListFailure value)  failure,}){
final _that = this;
switch (_that) {
case HallListInitial():
return initial(_that);case HallListLoading():
return loading(_that);case HallListReady():
return ready(_that);case HallListFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HallListInitial value)?  initial,TResult? Function( HallListLoading value)?  loading,TResult? Function( HallListReady value)?  ready,TResult? Function( HallListFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HallListInitial() when initial != null:
return initial(_that);case HallListLoading() when loading != null:
return loading(_that);case HallListReady() when ready != null:
return ready(_that);case HallListFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)?  initial,TResult Function( String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)?  loading,TResult Function( List<Hall> halls,  String? city,  String? type,  bool dolbyOnly,  bool screenXOnly,  DateTime? savedAt)?  ready,TResult Function( ApiFailure failure,  String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HallListInitial() when initial != null:
return initial(_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case HallListLoading() when loading != null:
return loading(_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case HallListReady() when ready != null:
return ready(_that.halls,_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly,_that.savedAt);case HallListFailure() when failure != null:
return failure(_that.failure,_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)  initial,required TResult Function( String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)  loading,required TResult Function( List<Hall> halls,  String? city,  String? type,  bool dolbyOnly,  bool screenXOnly,  DateTime? savedAt)  ready,required TResult Function( ApiFailure failure,  String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)  failure,}) {final _that = this;
switch (_that) {
case HallListInitial():
return initial(_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case HallListLoading():
return loading(_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case HallListReady():
return ready(_that.halls,_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly,_that.savedAt);case HallListFailure():
return failure(_that.failure,_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)?  initial,TResult? Function( String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)?  loading,TResult? Function( List<Hall> halls,  String? city,  String? type,  bool dolbyOnly,  bool screenXOnly,  DateTime? savedAt)?  ready,TResult? Function( ApiFailure failure,  String? city,  String? type,  bool dolbyOnly,  bool screenXOnly)?  failure,}) {final _that = this;
switch (_that) {
case HallListInitial() when initial != null:
return initial(_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case HallListLoading() when loading != null:
return loading(_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case HallListReady() when ready != null:
return ready(_that.halls,_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly,_that.savedAt);case HallListFailure() when failure != null:
return failure(_that.failure,_that.city,_that.type,_that.dolbyOnly,_that.screenXOnly);case _:
  return null;

}
}

}

/// @nodoc


class HallListInitial extends HallListState {
  const HallListInitial({this.city, this.type, this.dolbyOnly = false, this.screenXOnly = false}): super._();
  

@override final  String? city;
@override final  String? type;
@override@JsonKey() final  bool dolbyOnly;
@override@JsonKey() final  bool screenXOnly;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallListInitialCopyWith<HallListInitial> get copyWith => _$HallListInitialCopyWithImpl<HallListInitial>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallListInitial&&(identical(other.city, city) || other.city == city)&&(identical(other.type, type) || other.type == type)&&(identical(other.dolbyOnly, dolbyOnly) || other.dolbyOnly == dolbyOnly)&&(identical(other.screenXOnly, screenXOnly) || other.screenXOnly == screenXOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,city,type,dolbyOnly,screenXOnly);
}

@override
String toString() {
    return 'HallListState.initial(city: $city, type: $type, dolbyOnly: $dolbyOnly, screenXOnly: $screenXOnly)';
}


}

/// @nodoc
abstract mixin class $HallListInitialCopyWith<$Res> implements $HallListStateCopyWith<$Res> {
  factory $HallListInitialCopyWith(HallListInitial value, $Res Function(HallListInitial) _then) = _$HallListInitialCopyWithImpl;
@override @useResult
$Res call({
 String? city, String? type, bool dolbyOnly, bool screenXOnly
});




}
/// @nodoc
class _$HallListInitialCopyWithImpl<$Res>
    implements $HallListInitialCopyWith<$Res> {
  _$HallListInitialCopyWithImpl(this._self, this._then);

  final HallListInitial _self;
  final $Res Function(HallListInitial) _then;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = freezed,Object? type = freezed,Object? dolbyOnly = null,Object? screenXOnly = null,}) {
  return _then(HallListInitial(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dolbyOnly: null == dolbyOnly ? _self.dolbyOnly : dolbyOnly // ignore: cast_nullable_to_non_nullable
as bool,screenXOnly: null == screenXOnly ? _self.screenXOnly : screenXOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class HallListLoading extends HallListState {
  const HallListLoading({this.city, this.type, this.dolbyOnly = false, this.screenXOnly = false}): super._();
  

@override final  String? city;
@override final  String? type;
@override@JsonKey() final  bool dolbyOnly;
@override@JsonKey() final  bool screenXOnly;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallListLoadingCopyWith<HallListLoading> get copyWith => _$HallListLoadingCopyWithImpl<HallListLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallListLoading&&(identical(other.city, city) || other.city == city)&&(identical(other.type, type) || other.type == type)&&(identical(other.dolbyOnly, dolbyOnly) || other.dolbyOnly == dolbyOnly)&&(identical(other.screenXOnly, screenXOnly) || other.screenXOnly == screenXOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,city,type,dolbyOnly,screenXOnly);
}

@override
String toString() {
    return 'HallListState.loading(city: $city, type: $type, dolbyOnly: $dolbyOnly, screenXOnly: $screenXOnly)';
}


}

/// @nodoc
abstract mixin class $HallListLoadingCopyWith<$Res> implements $HallListStateCopyWith<$Res> {
  factory $HallListLoadingCopyWith(HallListLoading value, $Res Function(HallListLoading) _then) = _$HallListLoadingCopyWithImpl;
@override @useResult
$Res call({
 String? city, String? type, bool dolbyOnly, bool screenXOnly
});




}
/// @nodoc
class _$HallListLoadingCopyWithImpl<$Res>
    implements $HallListLoadingCopyWith<$Res> {
  _$HallListLoadingCopyWithImpl(this._self, this._then);

  final HallListLoading _self;
  final $Res Function(HallListLoading) _then;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = freezed,Object? type = freezed,Object? dolbyOnly = null,Object? screenXOnly = null,}) {
  return _then(HallListLoading(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dolbyOnly: null == dolbyOnly ? _self.dolbyOnly : dolbyOnly // ignore: cast_nullable_to_non_nullable
as bool,screenXOnly: null == screenXOnly ? _self.screenXOnly : screenXOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class HallListReady extends HallListState {
  const HallListReady( List<Hall> halls, {this.city, this.type, this.dolbyOnly = false, this.screenXOnly = false, this.savedAt}): _halls = halls,super._();
  

 final  List<Hall> _halls;
 List<Hall> get halls {
  if (_halls is EqualUnmodifiableListView) return _halls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_halls);
}

@override final  String? city;
@override final  String? type;
@override@JsonKey() final  bool dolbyOnly;
@override@JsonKey() final  bool screenXOnly;
 final  DateTime? savedAt;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallListReadyCopyWith<HallListReady> get copyWith => _$HallListReadyCopyWithImpl<HallListReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallListReady&&const DeepCollectionEquality().equals(other.halls, _halls)&&(identical(other.city, city) || other.city == city)&&(identical(other.type, type) || other.type == type)&&(identical(other.dolbyOnly, dolbyOnly) || other.dolbyOnly == dolbyOnly)&&(identical(other.screenXOnly, screenXOnly) || other.screenXOnly == screenXOnly)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_halls),city,type,dolbyOnly,screenXOnly,savedAt);
}

@override
String toString() {
    return 'HallListState.ready(halls: $halls, city: $city, type: $type, dolbyOnly: $dolbyOnly, screenXOnly: $screenXOnly, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $HallListReadyCopyWith<$Res> implements $HallListStateCopyWith<$Res> {
  factory $HallListReadyCopyWith(HallListReady value, $Res Function(HallListReady) _then) = _$HallListReadyCopyWithImpl;
@override @useResult
$Res call({
 List<Hall> halls, String? city, String? type, bool dolbyOnly, bool screenXOnly, DateTime? savedAt
});




}
/// @nodoc
class _$HallListReadyCopyWithImpl<$Res>
    implements $HallListReadyCopyWith<$Res> {
  _$HallListReadyCopyWithImpl(this._self, this._then);

  final HallListReady _self;
  final $Res Function(HallListReady) _then;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? halls = null,Object? city = freezed,Object? type = freezed,Object? dolbyOnly = null,Object? screenXOnly = null,Object? savedAt = freezed,}) {
  return _then(HallListReady(
null == halls ? _self._halls : halls // ignore: cast_nullable_to_non_nullable
as List<Hall>,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dolbyOnly: null == dolbyOnly ? _self.dolbyOnly : dolbyOnly // ignore: cast_nullable_to_non_nullable
as bool,screenXOnly: null == screenXOnly ? _self.screenXOnly : screenXOnly // ignore: cast_nullable_to_non_nullable
as bool,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class HallListFailure extends HallListState {
  const HallListFailure(this.failure, {this.city, this.type, this.dolbyOnly = false, this.screenXOnly = false}): super._();
  

 final  ApiFailure failure;
@override final  String? city;
@override final  String? type;
@override@JsonKey() final  bool dolbyOnly;
@override@JsonKey() final  bool screenXOnly;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallListFailureCopyWith<HallListFailure> get copyWith => _$HallListFailureCopyWithImpl<HallListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HallListFailure&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.city, city) || other.city == city)&&(identical(other.type, type) || other.type == type)&&(identical(other.dolbyOnly, dolbyOnly) || other.dolbyOnly == dolbyOnly)&&(identical(other.screenXOnly, screenXOnly) || other.screenXOnly == screenXOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure,city,type,dolbyOnly,screenXOnly);
}

@override
String toString() {
    return 'HallListState.failure(failure: $failure, city: $city, type: $type, dolbyOnly: $dolbyOnly, screenXOnly: $screenXOnly)';
}


}

/// @nodoc
abstract mixin class $HallListFailureCopyWith<$Res> implements $HallListStateCopyWith<$Res> {
  factory $HallListFailureCopyWith(HallListFailure value, $Res Function(HallListFailure) _then) = _$HallListFailureCopyWithImpl;
@override @useResult
$Res call({
 ApiFailure failure, String? city, String? type, bool dolbyOnly, bool screenXOnly
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$HallListFailureCopyWithImpl<$Res>
    implements $HallListFailureCopyWith<$Res> {
  _$HallListFailureCopyWithImpl(this._self, this._then);

  final HallListFailure _self;
  final $Res Function(HallListFailure) _then;

/// Create a copy of HallListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? city = freezed,Object? type = freezed,Object? dolbyOnly = null,Object? screenXOnly = null,}) {
  return _then(HallListFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dolbyOnly: null == dolbyOnly ? _self.dolbyOnly : dolbyOnly // ignore: cast_nullable_to_non_nullable
as bool,screenXOnly: null == screenXOnly ? _self.screenXOnly : screenXOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HallListState
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
