// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_results_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchResultsState {

 String get query; List<String> get recent; List<Movie> get nowShowing; List<Movie> get comingSoon; List<Hall> get halls;/// The server search for [query] has not answered yet.
 bool get searching;
/// Create a copy of SearchResultsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultsStateCopyWith<SearchResultsState> get copyWith => _$SearchResultsStateCopyWithImpl<SearchResultsState>(this as SearchResultsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchResultsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultsState&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.recent, _this.recent)&&const DeepCollectionEquality().equals(other.nowShowing, _this.nowShowing)&&const DeepCollectionEquality().equals(other.comingSoon, _this.comingSoon)&&const DeepCollectionEquality().equals(other.halls, _this.halls)&&(identical(other.searching, _this.searching) || other.searching == _this.searching));
}


@override
int get hashCode {
  final _this = this as SearchResultsState;
  return Object.hash(runtimeType,_this.query,const DeepCollectionEquality().hash(_this.recent),const DeepCollectionEquality().hash(_this.nowShowing),const DeepCollectionEquality().hash(_this.comingSoon),const DeepCollectionEquality().hash(_this.halls),_this.searching);
}

@override
String toString() {
  final _this = this as SearchResultsState;
  return 'SearchResultsState(query: ${_this.query}, recent: ${_this.recent}, nowShowing: ${_this.nowShowing}, comingSoon: ${_this.comingSoon}, halls: ${_this.halls}, searching: ${_this.searching})';
}


}

/// @nodoc
abstract mixin class $SearchResultsStateCopyWith<$Res>  {
  factory $SearchResultsStateCopyWith(SearchResultsState value, $Res Function(SearchResultsState) _then) = _$SearchResultsStateCopyWithImpl;
@useResult
$Res call({
 String query, List<String> recent, List<Movie> nowShowing, List<Movie> comingSoon, List<Hall> halls, bool searching
});




}
/// @nodoc
class _$SearchResultsStateCopyWithImpl<$Res>
    implements $SearchResultsStateCopyWith<$Res> {
  _$SearchResultsStateCopyWithImpl(this._self, this._then);

  final SearchResultsState _self;
  final $Res Function(SearchResultsState) _then;

/// Create a copy of SearchResultsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? recent = null,Object? nowShowing = null,Object? comingSoon = null,Object? halls = null,Object? searching = null,}) {
  return _then(SearchResultsState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<String>,nowShowing: null == nowShowing ? _self.nowShowing : nowShowing // ignore: cast_nullable_to_non_nullable
as List<Movie>,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as List<Movie>,halls: null == halls ? _self.halls : halls // ignore: cast_nullable_to_non_nullable
as List<Hall>,searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResultsState].
extension SearchResultsStatePatterns on SearchResultsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResultsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResultsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResultsState value)  $default,){
final _that = this;
switch (_that) {
case _SearchResultsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResultsState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResultsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<String> recent,  List<Movie> nowShowing,  List<Movie> comingSoon,  List<Hall> halls,  bool searching)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResultsState() when $default != null:
return $default(_that.query,_that.recent,_that.nowShowing,_that.comingSoon,_that.halls,_that.searching);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<String> recent,  List<Movie> nowShowing,  List<Movie> comingSoon,  List<Hall> halls,  bool searching)  $default,) {final _that = this;
switch (_that) {
case _SearchResultsState():
return $default(_that.query,_that.recent,_that.nowShowing,_that.comingSoon,_that.halls,_that.searching);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<String> recent,  List<Movie> nowShowing,  List<Movie> comingSoon,  List<Hall> halls,  bool searching)?  $default,) {final _that = this;
switch (_that) {
case _SearchResultsState() when $default != null:
return $default(_that.query,_that.recent,_that.nowShowing,_that.comingSoon,_that.halls,_that.searching);case _:
  return null;

}
}

}

/// @nodoc


class _SearchResultsState extends SearchResultsState {
  const _SearchResultsState({this.query = '',  List<String> recent = const [],  List<Movie> nowShowing = const [],  List<Movie> comingSoon = const [],  List<Hall> halls = const [], this.searching = false}): _recent = recent,_nowShowing = nowShowing,_comingSoon = comingSoon,_halls = halls,super._();
  

@override@JsonKey() final  String query;
 final  List<String> _recent;
@override@JsonKey() List<String> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}

 final  List<Movie> _nowShowing;
@override@JsonKey() List<Movie> get nowShowing {
  if (_nowShowing is EqualUnmodifiableListView) return _nowShowing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nowShowing);
}

 final  List<Movie> _comingSoon;
@override@JsonKey() List<Movie> get comingSoon {
  if (_comingSoon is EqualUnmodifiableListView) return _comingSoon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comingSoon);
}

 final  List<Hall> _halls;
@override@JsonKey() List<Hall> get halls {
  if (_halls is EqualUnmodifiableListView) return _halls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_halls);
}

/// The server search for [query] has not answered yet.
@override@JsonKey() final  bool searching;

/// Create a copy of SearchResultsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultsStateCopyWith<_SearchResultsState> get copyWith => __$SearchResultsStateCopyWithImpl<_SearchResultsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultsState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.recent, _recent)&&const DeepCollectionEquality().equals(other.nowShowing, _nowShowing)&&const DeepCollectionEquality().equals(other.comingSoon, _comingSoon)&&const DeepCollectionEquality().equals(other.halls, _halls)&&(identical(other.searching, searching) || other.searching == searching));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_recent),const DeepCollectionEquality().hash(_nowShowing),const DeepCollectionEquality().hash(_comingSoon),const DeepCollectionEquality().hash(_halls),searching);
}

@override
String toString() {
    return 'SearchResultsState(query: $query, recent: $recent, nowShowing: $nowShowing, comingSoon: $comingSoon, halls: $halls, searching: $searching)';
}


}

/// @nodoc
abstract mixin class _$SearchResultsStateCopyWith<$Res> implements $SearchResultsStateCopyWith<$Res> {
  factory _$SearchResultsStateCopyWith(_SearchResultsState value, $Res Function(_SearchResultsState) _then) = __$SearchResultsStateCopyWithImpl;
@override @useResult
$Res call({
 String query, List<String> recent, List<Movie> nowShowing, List<Movie> comingSoon, List<Hall> halls, bool searching
});




}
/// @nodoc
class __$SearchResultsStateCopyWithImpl<$Res>
    implements _$SearchResultsStateCopyWith<$Res> {
  __$SearchResultsStateCopyWithImpl(this._self, this._then);

  final _SearchResultsState _self;
  final $Res Function(_SearchResultsState) _then;

/// Create a copy of SearchResultsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? recent = null,Object? nowShowing = null,Object? comingSoon = null,Object? halls = null,Object? searching = null,}) {
  return _then(_SearchResultsState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<String>,nowShowing: null == nowShowing ? _self._nowShowing : nowShowing // ignore: cast_nullable_to_non_nullable
as List<Movie>,comingSoon: null == comingSoon ? _self._comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as List<Movie>,halls: null == halls ? _self._halls : halls // ignore: cast_nullable_to_non_nullable
as List<Hall>,searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
