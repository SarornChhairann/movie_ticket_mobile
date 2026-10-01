// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieListState {

 MovieTab get tab; String get search;
/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListStateCopyWith<MovieListState> get copyWith => _$MovieListStateCopyWithImpl<MovieListState>(this as MovieListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MovieListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListState&&(identical(other.tab, _this.tab) || other.tab == _this.tab)&&(identical(other.search, _this.search) || other.search == _this.search));
}


@override
int get hashCode {
  final _this = this as MovieListState;
  return Object.hash(runtimeType,_this.tab,_this.search);
}

@override
String toString() {
  final _this = this as MovieListState;
  return 'MovieListState(tab: ${_this.tab}, search: ${_this.search})';
}


}

/// @nodoc
abstract mixin class $MovieListStateCopyWith<$Res>  {
  factory $MovieListStateCopyWith(MovieListState value, $Res Function(MovieListState) _then) = _$MovieListStateCopyWithImpl;
@useResult
$Res call({
 MovieTab tab, String search
});




}
/// @nodoc
class _$MovieListStateCopyWithImpl<$Res>
    implements $MovieListStateCopyWith<$Res> {
  _$MovieListStateCopyWithImpl(this._self, this._then);

  final MovieListState _self;
  final $Res Function(MovieListState) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tab = null,Object? search = null,}) {
  return _then(_self.copyWith(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MovieTab,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListState].
extension MovieListStatePatterns on MovieListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovieListInitial value)?  initial,TResult Function( MovieListLoading value)?  loading,TResult Function( MovieListReady value)?  ready,TResult Function( MovieListFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial(_that);case MovieListLoading() when loading != null:
return loading(_that);case MovieListReady() when ready != null:
return ready(_that);case MovieListFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovieListInitial value)  initial,required TResult Function( MovieListLoading value)  loading,required TResult Function( MovieListReady value)  ready,required TResult Function( MovieListFailure value)  failure,}){
final _that = this;
switch (_that) {
case MovieListInitial():
return initial(_that);case MovieListLoading():
return loading(_that);case MovieListReady():
return ready(_that);case MovieListFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovieListInitial value)?  initial,TResult? Function( MovieListLoading value)?  loading,TResult? Function( MovieListReady value)?  ready,TResult? Function( MovieListFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial(_that);case MovieListLoading() when loading != null:
return loading(_that);case MovieListReady() when ready != null:
return ready(_that);case MovieListFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( MovieTab tab,  String search)?  initial,TResult Function( MovieTab tab,  String search)?  loading,TResult Function( MovieTab tab,  String search,  List<Movie> movies)?  ready,TResult Function( MovieTab tab,  String search,  ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial(_that.tab,_that.search);case MovieListLoading() when loading != null:
return loading(_that.tab,_that.search);case MovieListReady() when ready != null:
return ready(_that.tab,_that.search,_that.movies);case MovieListFailure() when failure != null:
return failure(_that.tab,_that.search,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( MovieTab tab,  String search)  initial,required TResult Function( MovieTab tab,  String search)  loading,required TResult Function( MovieTab tab,  String search,  List<Movie> movies)  ready,required TResult Function( MovieTab tab,  String search,  ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case MovieListInitial():
return initial(_that.tab,_that.search);case MovieListLoading():
return loading(_that.tab,_that.search);case MovieListReady():
return ready(_that.tab,_that.search,_that.movies);case MovieListFailure():
return failure(_that.tab,_that.search,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( MovieTab tab,  String search)?  initial,TResult? Function( MovieTab tab,  String search)?  loading,TResult? Function( MovieTab tab,  String search,  List<Movie> movies)?  ready,TResult? Function( MovieTab tab,  String search,  ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial(_that.tab,_that.search);case MovieListLoading() when loading != null:
return loading(_that.tab,_that.search);case MovieListReady() when ready != null:
return ready(_that.tab,_that.search,_that.movies);case MovieListFailure() when failure != null:
return failure(_that.tab,_that.search,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MovieListInitial implements MovieListState {
  const MovieListInitial({this.tab = MovieTab.nowShowing, this.search = ''});
  

@override@JsonKey() final  MovieTab tab;
@override@JsonKey() final  String search;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListInitialCopyWith<MovieListInitial> get copyWith => _$MovieListInitialCopyWithImpl<MovieListInitial>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListInitial&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tab,search);
}

@override
String toString() {
    return 'MovieListState.initial(tab: $tab, search: $search)';
}


}

/// @nodoc
abstract mixin class $MovieListInitialCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory $MovieListInitialCopyWith(MovieListInitial value, $Res Function(MovieListInitial) _then) = _$MovieListInitialCopyWithImpl;
@override @useResult
$Res call({
 MovieTab tab, String search
});




}
/// @nodoc
class _$MovieListInitialCopyWithImpl<$Res>
    implements $MovieListInitialCopyWith<$Res> {
  _$MovieListInitialCopyWithImpl(this._self, this._then);

  final MovieListInitial _self;
  final $Res Function(MovieListInitial) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? search = null,}) {
  return _then(MovieListInitial(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MovieTab,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MovieListLoading implements MovieListState {
  const MovieListLoading({required this.tab, required this.search});
  

@override final  MovieTab tab;
@override final  String search;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListLoadingCopyWith<MovieListLoading> get copyWith => _$MovieListLoadingCopyWithImpl<MovieListLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListLoading&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tab,search);
}

@override
String toString() {
    return 'MovieListState.loading(tab: $tab, search: $search)';
}


}

/// @nodoc
abstract mixin class $MovieListLoadingCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory $MovieListLoadingCopyWith(MovieListLoading value, $Res Function(MovieListLoading) _then) = _$MovieListLoadingCopyWithImpl;
@override @useResult
$Res call({
 MovieTab tab, String search
});




}
/// @nodoc
class _$MovieListLoadingCopyWithImpl<$Res>
    implements $MovieListLoadingCopyWith<$Res> {
  _$MovieListLoadingCopyWithImpl(this._self, this._then);

  final MovieListLoading _self;
  final $Res Function(MovieListLoading) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? search = null,}) {
  return _then(MovieListLoading(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MovieTab,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MovieListReady implements MovieListState {
  const MovieListReady({required this.tab, required this.search, required  List<Movie> movies}): _movies = movies;
  

@override final  MovieTab tab;
@override final  String search;
 final  List<Movie> _movies;
 List<Movie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}


/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListReadyCopyWith<MovieListReady> get copyWith => _$MovieListReadyCopyWithImpl<MovieListReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListReady&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other.movies, _movies));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tab,search,const DeepCollectionEquality().hash(_movies));
}

@override
String toString() {
    return 'MovieListState.ready(tab: $tab, search: $search, movies: $movies)';
}


}

/// @nodoc
abstract mixin class $MovieListReadyCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory $MovieListReadyCopyWith(MovieListReady value, $Res Function(MovieListReady) _then) = _$MovieListReadyCopyWithImpl;
@override @useResult
$Res call({
 MovieTab tab, String search, List<Movie> movies
});




}
/// @nodoc
class _$MovieListReadyCopyWithImpl<$Res>
    implements $MovieListReadyCopyWith<$Res> {
  _$MovieListReadyCopyWithImpl(this._self, this._then);

  final MovieListReady _self;
  final $Res Function(MovieListReady) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? search = null,Object? movies = null,}) {
  return _then(MovieListReady(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MovieTab,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,
  ));
}


}

/// @nodoc


class MovieListFailure implements MovieListState {
  const MovieListFailure({required this.tab, required this.search, required this.failure});
  

@override final  MovieTab tab;
@override final  String search;
 final  ApiFailure failure;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListFailureCopyWith<MovieListFailure> get copyWith => _$MovieListFailureCopyWithImpl<MovieListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListFailure&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.search, search) || other.search == search)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tab,search,failure);
}

@override
String toString() {
    return 'MovieListState.failure(tab: $tab, search: $search, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MovieListFailureCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory $MovieListFailureCopyWith(MovieListFailure value, $Res Function(MovieListFailure) _then) = _$MovieListFailureCopyWithImpl;
@override @useResult
$Res call({
 MovieTab tab, String search, ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$MovieListFailureCopyWithImpl<$Res>
    implements $MovieListFailureCopyWith<$Res> {
  _$MovieListFailureCopyWithImpl(this._self, this._then);

  final MovieListFailure _self;
  final $Res Function(MovieListFailure) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? search = null,Object? failure = null,}) {
  return _then(MovieListFailure(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MovieTab,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of MovieListState
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
