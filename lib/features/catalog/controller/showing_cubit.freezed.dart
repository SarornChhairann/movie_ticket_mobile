// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'showing_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShowingState {

 List<DateTime> get dates; DateTime? get date;
/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowingStateCopyWith<ShowingState> get copyWith => _$ShowingStateCopyWithImpl<ShowingState>(this as ShowingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShowingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowingState&&const DeepCollectionEquality().equals(other.dates, _this.dates)&&(identical(other.date, _this.date) || other.date == _this.date));
}


@override
int get hashCode {
  final _this = this as ShowingState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.dates),_this.date);
}

@override
String toString() {
  final _this = this as ShowingState;
  return 'ShowingState(dates: ${_this.dates}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $ShowingStateCopyWith<$Res>  {
  factory $ShowingStateCopyWith(ShowingState value, $Res Function(ShowingState) _then) = _$ShowingStateCopyWithImpl;
@useResult
$Res call({
 List<DateTime> dates, DateTime date
});




}
/// @nodoc
class _$ShowingStateCopyWithImpl<$Res>
    implements $ShowingStateCopyWith<$Res> {
  _$ShowingStateCopyWithImpl(this._self, this._then);

  final ShowingState _self;
  final $Res Function(ShowingState) _then;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dates = null,Object? date = null,}) {
  return _then(_self.copyWith(
dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,date: null == date ? _self.date! : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ShowingState].
extension ShowingStatePatterns on ShowingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShowingInitial value)?  initial,TResult Function( ShowingLoading value)?  loading,TResult Function( ShowingReady value)?  ready,TResult Function( ShowingFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShowingInitial() when initial != null:
return initial(_that);case ShowingLoading() when loading != null:
return loading(_that);case ShowingReady() when ready != null:
return ready(_that);case ShowingFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShowingInitial value)  initial,required TResult Function( ShowingLoading value)  loading,required TResult Function( ShowingReady value)  ready,required TResult Function( ShowingFailure value)  failure,}){
final _that = this;
switch (_that) {
case ShowingInitial():
return initial(_that);case ShowingLoading():
return loading(_that);case ShowingReady():
return ready(_that);case ShowingFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShowingInitial value)?  initial,TResult? Function( ShowingLoading value)?  loading,TResult? Function( ShowingReady value)?  ready,TResult? Function( ShowingFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ShowingInitial() when initial != null:
return initial(_that);case ShowingLoading() when loading != null:
return loading(_that);case ShowingReady() when ready != null:
return ready(_that);case ShowingFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<DateTime> dates,  DateTime? date)?  initial,TResult Function( List<DateTime> dates,  DateTime date)?  loading,TResult Function( List<DateTime> dates,  DateTime date,  List<ShowingMovie> movies,  DateTime? nextDate,  DateTime? savedAt)?  ready,TResult Function( List<DateTime> dates,  DateTime date,  ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShowingInitial() when initial != null:
return initial(_that.dates,_that.date);case ShowingLoading() when loading != null:
return loading(_that.dates,_that.date);case ShowingReady() when ready != null:
return ready(_that.dates,_that.date,_that.movies,_that.nextDate,_that.savedAt);case ShowingFailure() when failure != null:
return failure(_that.dates,_that.date,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<DateTime> dates,  DateTime? date)  initial,required TResult Function( List<DateTime> dates,  DateTime date)  loading,required TResult Function( List<DateTime> dates,  DateTime date,  List<ShowingMovie> movies,  DateTime? nextDate,  DateTime? savedAt)  ready,required TResult Function( List<DateTime> dates,  DateTime date,  ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case ShowingInitial():
return initial(_that.dates,_that.date);case ShowingLoading():
return loading(_that.dates,_that.date);case ShowingReady():
return ready(_that.dates,_that.date,_that.movies,_that.nextDate,_that.savedAt);case ShowingFailure():
return failure(_that.dates,_that.date,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<DateTime> dates,  DateTime? date)?  initial,TResult? Function( List<DateTime> dates,  DateTime date)?  loading,TResult? Function( List<DateTime> dates,  DateTime date,  List<ShowingMovie> movies,  DateTime? nextDate,  DateTime? savedAt)?  ready,TResult? Function( List<DateTime> dates,  DateTime date,  ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case ShowingInitial() when initial != null:
return initial(_that.dates,_that.date);case ShowingLoading() when loading != null:
return loading(_that.dates,_that.date);case ShowingReady() when ready != null:
return ready(_that.dates,_that.date,_that.movies,_that.nextDate,_that.savedAt);case ShowingFailure() when failure != null:
return failure(_that.dates,_that.date,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ShowingInitial implements ShowingState {
  const ShowingInitial({ List<DateTime> dates = const [], this.date}): _dates = dates;
  

 final  List<DateTime> _dates;
@override@JsonKey() List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override final  DateTime? date;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowingInitialCopyWith<ShowingInitial> get copyWith => _$ShowingInitialCopyWithImpl<ShowingInitial>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowingInitial&&const DeepCollectionEquality().equals(other.dates, _dates)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_dates),date);
}

@override
String toString() {
    return 'ShowingState.initial(dates: $dates, date: $date)';
}


}

/// @nodoc
abstract mixin class $ShowingInitialCopyWith<$Res> implements $ShowingStateCopyWith<$Res> {
  factory $ShowingInitialCopyWith(ShowingInitial value, $Res Function(ShowingInitial) _then) = _$ShowingInitialCopyWithImpl;
@override @useResult
$Res call({
 List<DateTime> dates, DateTime? date
});




}
/// @nodoc
class _$ShowingInitialCopyWithImpl<$Res>
    implements $ShowingInitialCopyWith<$Res> {
  _$ShowingInitialCopyWithImpl(this._self, this._then);

  final ShowingInitial _self;
  final $Res Function(ShowingInitial) _then;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dates = null,Object? date = freezed,}) {
  return _then(ShowingInitial(
dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class ShowingLoading implements ShowingState {
  const ShowingLoading({required  List<DateTime> dates, required this.date}): _dates = dates;
  

 final  List<DateTime> _dates;
@override List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override final  DateTime date;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowingLoadingCopyWith<ShowingLoading> get copyWith => _$ShowingLoadingCopyWithImpl<ShowingLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowingLoading&&const DeepCollectionEquality().equals(other.dates, _dates)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_dates),date);
}

@override
String toString() {
    return 'ShowingState.loading(dates: $dates, date: $date)';
}


}

/// @nodoc
abstract mixin class $ShowingLoadingCopyWith<$Res> implements $ShowingStateCopyWith<$Res> {
  factory $ShowingLoadingCopyWith(ShowingLoading value, $Res Function(ShowingLoading) _then) = _$ShowingLoadingCopyWithImpl;
@override @useResult
$Res call({
 List<DateTime> dates, DateTime date
});




}
/// @nodoc
class _$ShowingLoadingCopyWithImpl<$Res>
    implements $ShowingLoadingCopyWith<$Res> {
  _$ShowingLoadingCopyWithImpl(this._self, this._then);

  final ShowingLoading _self;
  final $Res Function(ShowingLoading) _then;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dates = null,Object? date = null,}) {
  return _then(ShowingLoading(
dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class ShowingReady implements ShowingState {
  const ShowingReady({required  List<DateTime> dates, required this.date, required  List<ShowingMovie> movies, this.nextDate, this.savedAt}): _dates = dates,_movies = movies;
  

 final  List<DateTime> _dates;
@override List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override final  DateTime date;
 final  List<ShowingMovie> _movies;
 List<ShowingMovie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

 final  DateTime? nextDate;
 final  DateTime? savedAt;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowingReadyCopyWith<ShowingReady> get copyWith => _$ShowingReadyCopyWithImpl<ShowingReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowingReady&&const DeepCollectionEquality().equals(other.dates, _dates)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.movies, _movies)&&(identical(other.nextDate, nextDate) || other.nextDate == nextDate)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_dates),date,const DeepCollectionEquality().hash(_movies),nextDate,savedAt);
}

@override
String toString() {
    return 'ShowingState.ready(dates: $dates, date: $date, movies: $movies, nextDate: $nextDate, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $ShowingReadyCopyWith<$Res> implements $ShowingStateCopyWith<$Res> {
  factory $ShowingReadyCopyWith(ShowingReady value, $Res Function(ShowingReady) _then) = _$ShowingReadyCopyWithImpl;
@override @useResult
$Res call({
 List<DateTime> dates, DateTime date, List<ShowingMovie> movies, DateTime? nextDate, DateTime? savedAt
});




}
/// @nodoc
class _$ShowingReadyCopyWithImpl<$Res>
    implements $ShowingReadyCopyWith<$Res> {
  _$ShowingReadyCopyWithImpl(this._self, this._then);

  final ShowingReady _self;
  final $Res Function(ShowingReady) _then;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dates = null,Object? date = null,Object? movies = null,Object? nextDate = freezed,Object? savedAt = freezed,}) {
  return _then(ShowingReady(
dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<ShowingMovie>,nextDate: freezed == nextDate ? _self.nextDate : nextDate // ignore: cast_nullable_to_non_nullable
as DateTime?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class ShowingFailure implements ShowingState {
  const ShowingFailure({required  List<DateTime> dates, required this.date, required this.failure}): _dates = dates;
  

 final  List<DateTime> _dates;
@override List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override final  DateTime date;
 final  ApiFailure failure;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowingFailureCopyWith<ShowingFailure> get copyWith => _$ShowingFailureCopyWithImpl<ShowingFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowingFailure&&const DeepCollectionEquality().equals(other.dates, _dates)&&(identical(other.date, date) || other.date == date)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_dates),date,failure);
}

@override
String toString() {
    return 'ShowingState.failure(dates: $dates, date: $date, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ShowingFailureCopyWith<$Res> implements $ShowingStateCopyWith<$Res> {
  factory $ShowingFailureCopyWith(ShowingFailure value, $Res Function(ShowingFailure) _then) = _$ShowingFailureCopyWithImpl;
@override @useResult
$Res call({
 List<DateTime> dates, DateTime date, ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ShowingFailureCopyWithImpl<$Res>
    implements $ShowingFailureCopyWith<$Res> {
  _$ShowingFailureCopyWithImpl(this._self, this._then);

  final ShowingFailure _self;
  final $Res Function(ShowingFailure) _then;

/// Create a copy of ShowingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dates = null,Object? date = null,Object? failure = null,}) {
  return _then(ShowingFailure(
dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of ShowingState
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
