// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailState()';
}


}

/// @nodoc
class $MovieDetailStateCopyWith<$Res>  {
$MovieDetailStateCopyWith(MovieDetailState _, $Res Function(MovieDetailState) __);
}


/// Adds pattern-matching-related methods to [MovieDetailState].
extension MovieDetailStatePatterns on MovieDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovieDetailInitial value)?  initial,TResult Function( MovieDetailLoading value)?  loading,TResult Function( MovieDetailReady value)?  ready,TResult Function( MovieDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovieDetailInitial() when initial != null:
return initial(_that);case MovieDetailLoading() when loading != null:
return loading(_that);case MovieDetailReady() when ready != null:
return ready(_that);case MovieDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovieDetailInitial value)  initial,required TResult Function( MovieDetailLoading value)  loading,required TResult Function( MovieDetailReady value)  ready,required TResult Function( MovieDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case MovieDetailInitial():
return initial(_that);case MovieDetailLoading():
return loading(_that);case MovieDetailReady():
return ready(_that);case MovieDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovieDetailInitial value)?  initial,TResult? Function( MovieDetailLoading value)?  loading,TResult? Function( MovieDetailReady value)?  ready,TResult? Function( MovieDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MovieDetailInitial() when initial != null:
return initial(_that);case MovieDetailLoading() when loading != null:
return loading(_that);case MovieDetailReady() when ready != null:
return ready(_that);case MovieDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( MovieDetail detail,  bool refreshing)?  ready,TResult Function( ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovieDetailInitial() when initial != null:
return initial();case MovieDetailLoading() when loading != null:
return loading();case MovieDetailReady() when ready != null:
return ready(_that.detail,_that.refreshing);case MovieDetailFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( MovieDetail detail,  bool refreshing)  ready,required TResult Function( ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case MovieDetailInitial():
return initial();case MovieDetailLoading():
return loading();case MovieDetailReady():
return ready(_that.detail,_that.refreshing);case MovieDetailFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( MovieDetail detail,  bool refreshing)?  ready,TResult? Function( ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case MovieDetailInitial() when initial != null:
return initial();case MovieDetailLoading() when loading != null:
return loading();case MovieDetailReady() when ready != null:
return ready(_that.detail,_that.refreshing);case MovieDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MovieDetailInitial implements MovieDetailState {
  const MovieDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailState.initial()';
}


}




/// @nodoc


class MovieDetailLoading implements MovieDetailState {
  const MovieDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailState.loading()';
}


}




/// @nodoc


class MovieDetailReady implements MovieDetailState {
  const MovieDetailReady(this.detail, {this.refreshing = false});
  

 final  MovieDetail detail;
@JsonKey() final  bool refreshing;

/// Create a copy of MovieDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailReadyCopyWith<MovieDetailReady> get copyWith => _$MovieDetailReadyCopyWithImpl<MovieDetailReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailReady&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,detail,refreshing);
}

@override
String toString() {
    return 'MovieDetailState.ready(detail: $detail, refreshing: $refreshing)';
}


}

/// @nodoc
abstract mixin class $MovieDetailReadyCopyWith<$Res> implements $MovieDetailStateCopyWith<$Res> {
  factory $MovieDetailReadyCopyWith(MovieDetailReady value, $Res Function(MovieDetailReady) _then) = _$MovieDetailReadyCopyWithImpl;
@useResult
$Res call({
 MovieDetail detail, bool refreshing
});


$MovieDetailCopyWith<$Res> get detail;

}
/// @nodoc
class _$MovieDetailReadyCopyWithImpl<$Res>
    implements $MovieDetailReadyCopyWith<$Res> {
  _$MovieDetailReadyCopyWithImpl(this._self, this._then);

  final MovieDetailReady _self;
  final $Res Function(MovieDetailReady) _then;

/// Create a copy of MovieDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,Object? refreshing = null,}) {
  return _then(MovieDetailReady(
null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as MovieDetail,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MovieDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieDetailCopyWith<$Res> get detail {
  
  return $MovieDetailCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

/// @nodoc


class MovieDetailFailure implements MovieDetailState {
  const MovieDetailFailure(this.failure);
  

 final  ApiFailure failure;

/// Create a copy of MovieDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailFailureCopyWith<MovieDetailFailure> get copyWith => _$MovieDetailFailureCopyWithImpl<MovieDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'MovieDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MovieDetailFailureCopyWith<$Res> implements $MovieDetailStateCopyWith<$Res> {
  factory $MovieDetailFailureCopyWith(MovieDetailFailure value, $Res Function(MovieDetailFailure) _then) = _$MovieDetailFailureCopyWithImpl;
@useResult
$Res call({
 ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$MovieDetailFailureCopyWithImpl<$Res>
    implements $MovieDetailFailureCopyWith<$Res> {
  _$MovieDetailFailureCopyWithImpl(this._self, this._then);

  final MovieDetailFailure _self;
  final $Res Function(MovieDetailFailure) _then;

/// Create a copy of MovieDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MovieDetailFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of MovieDetailState
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
