// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeSummary {

 int get nowShowingCount; int get comingSoonCount; int get cinemaCount;/// Home's hero: the admin's featured movie, else the first hero movie.
 Movie? get featured;
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryCopyWith<HomeSummary> get copyWith => _$HomeSummaryCopyWithImpl<HomeSummary>(this as HomeSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummary&&(identical(other.nowShowingCount, _this.nowShowingCount) || other.nowShowingCount == _this.nowShowingCount)&&(identical(other.comingSoonCount, _this.comingSoonCount) || other.comingSoonCount == _this.comingSoonCount)&&(identical(other.cinemaCount, _this.cinemaCount) || other.cinemaCount == _this.cinemaCount)&&(identical(other.featured, _this.featured) || other.featured == _this.featured));
}


@override
int get hashCode {
  final _this = this as HomeSummary;
  return Object.hash(runtimeType,_this.nowShowingCount,_this.comingSoonCount,_this.cinemaCount,_this.featured);
}

@override
String toString() {
  final _this = this as HomeSummary;
  return 'HomeSummary(nowShowingCount: ${_this.nowShowingCount}, comingSoonCount: ${_this.comingSoonCount}, cinemaCount: ${_this.cinemaCount}, featured: ${_this.featured})';
}


}

/// @nodoc
abstract mixin class $HomeSummaryCopyWith<$Res>  {
  factory $HomeSummaryCopyWith(HomeSummary value, $Res Function(HomeSummary) _then) = _$HomeSummaryCopyWithImpl;
@useResult
$Res call({
 int nowShowingCount, int comingSoonCount, int cinemaCount, Movie? featured
});


$MovieCopyWith<$Res>? get featured;

}
/// @nodoc
class _$HomeSummaryCopyWithImpl<$Res>
    implements $HomeSummaryCopyWith<$Res> {
  _$HomeSummaryCopyWithImpl(this._self, this._then);

  final HomeSummary _self;
  final $Res Function(HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nowShowingCount = null,Object? comingSoonCount = null,Object? cinemaCount = null,Object? featured = freezed,}) {
  return _then(HomeSummary(
nowShowingCount: null == nowShowingCount ? _self.nowShowingCount : nowShowingCount // ignore: cast_nullable_to_non_nullable
as int,comingSoonCount: null == comingSoonCount ? _self.comingSoonCount : comingSoonCount // ignore: cast_nullable_to_non_nullable
as int,cinemaCount: null == cinemaCount ? _self.cinemaCount : cinemaCount // ignore: cast_nullable_to_non_nullable
as int,featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as Movie?,
  ));
}
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res>? get featured {
    if (_self.featured == null) {
    return null;
  }

  return $MovieCopyWith<$Res>(_self.featured!, (value) {
    return _then(_self.copyWith(featured: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeSummary].
extension HomeSummaryPatterns on HomeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSummary value)  $default,){
final _that = this;
switch (_that) {
case _HomeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nowShowingCount,  int comingSoonCount,  int cinemaCount,  Movie? featured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.nowShowingCount,_that.comingSoonCount,_that.cinemaCount,_that.featured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nowShowingCount,  int comingSoonCount,  int cinemaCount,  Movie? featured)  $default,) {final _that = this;
switch (_that) {
case _HomeSummary():
return $default(_that.nowShowingCount,_that.comingSoonCount,_that.cinemaCount,_that.featured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nowShowingCount,  int comingSoonCount,  int cinemaCount,  Movie? featured)?  $default,) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.nowShowingCount,_that.comingSoonCount,_that.cinemaCount,_that.featured);case _:
  return null;

}
}

}

/// @nodoc


class _HomeSummary implements HomeSummary {
  const _HomeSummary({required this.nowShowingCount, required this.comingSoonCount, required this.cinemaCount, this.featured});
  

@override final  int nowShowingCount;
@override final  int comingSoonCount;
@override final  int cinemaCount;
/// Home's hero: the admin's featured movie, else the first hero movie.
@override final  Movie? featured;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSummaryCopyWith<_HomeSummary> get copyWith => __$HomeSummaryCopyWithImpl<_HomeSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSummary&&(identical(other.nowShowingCount, nowShowingCount) || other.nowShowingCount == nowShowingCount)&&(identical(other.comingSoonCount, comingSoonCount) || other.comingSoonCount == comingSoonCount)&&(identical(other.cinemaCount, cinemaCount) || other.cinemaCount == cinemaCount)&&(identical(other.featured, featured) || other.featured == featured));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nowShowingCount,comingSoonCount,cinemaCount,featured);
}

@override
String toString() {
    return 'HomeSummary(nowShowingCount: $nowShowingCount, comingSoonCount: $comingSoonCount, cinemaCount: $cinemaCount, featured: $featured)';
}


}

/// @nodoc
abstract mixin class _$HomeSummaryCopyWith<$Res> implements $HomeSummaryCopyWith<$Res> {
  factory _$HomeSummaryCopyWith(_HomeSummary value, $Res Function(_HomeSummary) _then) = __$HomeSummaryCopyWithImpl;
@override @useResult
$Res call({
 int nowShowingCount, int comingSoonCount, int cinemaCount, Movie? featured
});


@override $MovieCopyWith<$Res>? get featured;

}
/// @nodoc
class __$HomeSummaryCopyWithImpl<$Res>
    implements _$HomeSummaryCopyWith<$Res> {
  __$HomeSummaryCopyWithImpl(this._self, this._then);

  final _HomeSummary _self;
  final $Res Function(_HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nowShowingCount = null,Object? comingSoonCount = null,Object? cinemaCount = null,Object? featured = freezed,}) {
  return _then(_HomeSummary(
nowShowingCount: null == nowShowingCount ? _self.nowShowingCount : nowShowingCount // ignore: cast_nullable_to_non_nullable
as int,comingSoonCount: null == comingSoonCount ? _self.comingSoonCount : comingSoonCount // ignore: cast_nullable_to_non_nullable
as int,cinemaCount: null == cinemaCount ? _self.cinemaCount : cinemaCount // ignore: cast_nullable_to_non_nullable
as int,featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as Movie?,
  ));
}

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res>? get featured {
    if (_self.featured == null) {
    return null;
  }

  return $MovieCopyWith<$Res>(_self.featured!, (value) {
    return _then(_self.copyWith(featured: value));
  });
}
}

// dart format on
