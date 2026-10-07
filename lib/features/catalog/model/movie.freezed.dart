// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Movie {

 int get id; String get title; String? get description; String? get genre; String? get director; String? get language; String? get format; String? get cast; String? get trailerUrl; String? get rating; DateTime? get releaseDate; int? get durationMinutes; bool get comingSoon; String? get posterUrl; String? get bannerUrl;
/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieCopyWith<Movie> get copyWith => _$MovieCopyWithImpl<Movie>(this as Movie, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Movie;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Movie&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.director, _this.director) || other.director == _this.director)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.cast, _this.cast) || other.cast == _this.cast)&&(identical(other.trailerUrl, _this.trailerUrl) || other.trailerUrl == _this.trailerUrl)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.releaseDate, _this.releaseDate) || other.releaseDate == _this.releaseDate)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.comingSoon, _this.comingSoon) || other.comingSoon == _this.comingSoon)&&(identical(other.posterUrl, _this.posterUrl) || other.posterUrl == _this.posterUrl)&&(identical(other.bannerUrl, _this.bannerUrl) || other.bannerUrl == _this.bannerUrl));
}


@override
int get hashCode {
  final _this = this as Movie;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,_this.genre,_this.director,_this.language,_this.format,_this.cast,_this.trailerUrl,_this.rating,_this.releaseDate,_this.durationMinutes,_this.comingSoon,_this.posterUrl,_this.bannerUrl);
}

@override
String toString() {
  final _this = this as Movie;
  return 'Movie(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, genre: ${_this.genre}, director: ${_this.director}, language: ${_this.language}, format: ${_this.format}, cast: ${_this.cast}, trailerUrl: ${_this.trailerUrl}, rating: ${_this.rating}, releaseDate: ${_this.releaseDate}, durationMinutes: ${_this.durationMinutes}, comingSoon: ${_this.comingSoon}, posterUrl: ${_this.posterUrl}, bannerUrl: ${_this.bannerUrl})';
}


}

/// @nodoc
abstract mixin class $MovieCopyWith<$Res>  {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) _then) = _$MovieCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? description, String? genre, String? director, String? language, String? format, String? cast, String? trailerUrl, String? rating, DateTime? releaseDate, int? durationMinutes, bool comingSoon, String? posterUrl, String? bannerUrl
});




}
/// @nodoc
class _$MovieCopyWithImpl<$Res>
    implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._self, this._then);

  final Movie _self;
  final $Res Function(Movie) _then;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? genre = freezed,Object? director = freezed,Object? language = freezed,Object? format = freezed,Object? cast = freezed,Object? trailerUrl = freezed,Object? rating = freezed,Object? releaseDate = freezed,Object? durationMinutes = freezed,Object? comingSoon = null,Object? posterUrl = freezed,Object? bannerUrl = freezed,}) {
  return _then(Movie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,director: freezed == director ? _self.director : director // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,cast: freezed == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as String?,trailerUrl: freezed == trailerUrl ? _self.trailerUrl : trailerUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Movie].
extension MoviePatterns on Movie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Movie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Movie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Movie value)  $default,){
final _that = this;
switch (_that) {
case _Movie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Movie value)?  $default,){
final _that = this;
switch (_that) {
case _Movie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String? genre,  String? director,  String? language,  String? format,  String? cast,  String? trailerUrl,  String? rating,  DateTime? releaseDate,  int? durationMinutes,  bool comingSoon,  String? posterUrl,  String? bannerUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Movie() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.genre,_that.director,_that.language,_that.format,_that.cast,_that.trailerUrl,_that.rating,_that.releaseDate,_that.durationMinutes,_that.comingSoon,_that.posterUrl,_that.bannerUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String? genre,  String? director,  String? language,  String? format,  String? cast,  String? trailerUrl,  String? rating,  DateTime? releaseDate,  int? durationMinutes,  bool comingSoon,  String? posterUrl,  String? bannerUrl)  $default,) {final _that = this;
switch (_that) {
case _Movie():
return $default(_that.id,_that.title,_that.description,_that.genre,_that.director,_that.language,_that.format,_that.cast,_that.trailerUrl,_that.rating,_that.releaseDate,_that.durationMinutes,_that.comingSoon,_that.posterUrl,_that.bannerUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? description,  String? genre,  String? director,  String? language,  String? format,  String? cast,  String? trailerUrl,  String? rating,  DateTime? releaseDate,  int? durationMinutes,  bool comingSoon,  String? posterUrl,  String? bannerUrl)?  $default,) {final _that = this;
switch (_that) {
case _Movie() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.genre,_that.director,_that.language,_that.format,_that.cast,_that.trailerUrl,_that.rating,_that.releaseDate,_that.durationMinutes,_that.comingSoon,_that.posterUrl,_that.bannerUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Movie implements Movie {
  const _Movie({required this.id, required this.title, this.description, this.genre, this.director, this.language, this.format, this.cast, this.trailerUrl, this.rating, this.releaseDate, this.durationMinutes, required this.comingSoon, this.posterUrl, this.bannerUrl});
  

@override final  int id;
@override final  String title;
@override final  String? description;
@override final  String? genre;
@override final  String? director;
@override final  String? language;
@override final  String? format;
@override final  String? cast;
@override final  String? trailerUrl;
@override final  String? rating;
@override final  DateTime? releaseDate;
@override final  int? durationMinutes;
@override final  bool comingSoon;
@override final  String? posterUrl;
@override final  String? bannerUrl;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieCopyWith<_Movie> get copyWith => __$MovieCopyWithImpl<_Movie>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Movie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.director, director) || other.director == director)&&(identical(other.language, language) || other.language == language)&&(identical(other.format, format) || other.format == format)&&(identical(other.cast, cast) || other.cast == cast)&&(identical(other.trailerUrl, trailerUrl) || other.trailerUrl == trailerUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.comingSoon, comingSoon) || other.comingSoon == comingSoon)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,genre,director,language,format,cast,trailerUrl,rating,releaseDate,durationMinutes,comingSoon,posterUrl,bannerUrl);
}

@override
String toString() {
    return 'Movie(id: $id, title: $title, description: $description, genre: $genre, director: $director, language: $language, format: $format, cast: $cast, trailerUrl: $trailerUrl, rating: $rating, releaseDate: $releaseDate, durationMinutes: $durationMinutes, comingSoon: $comingSoon, posterUrl: $posterUrl, bannerUrl: $bannerUrl)';
}


}

/// @nodoc
abstract mixin class _$MovieCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$MovieCopyWith(_Movie value, $Res Function(_Movie) _then) = __$MovieCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? description, String? genre, String? director, String? language, String? format, String? cast, String? trailerUrl, String? rating, DateTime? releaseDate, int? durationMinutes, bool comingSoon, String? posterUrl, String? bannerUrl
});




}
/// @nodoc
class __$MovieCopyWithImpl<$Res>
    implements _$MovieCopyWith<$Res> {
  __$MovieCopyWithImpl(this._self, this._then);

  final _Movie _self;
  final $Res Function(_Movie) _then;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? genre = freezed,Object? director = freezed,Object? language = freezed,Object? format = freezed,Object? cast = freezed,Object? trailerUrl = freezed,Object? rating = freezed,Object? releaseDate = freezed,Object? durationMinutes = freezed,Object? comingSoon = null,Object? posterUrl = freezed,Object? bannerUrl = freezed,}) {
  return _then(_Movie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,director: freezed == director ? _self.director : director // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,cast: freezed == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as String?,trailerUrl: freezed == trailerUrl ? _self.trailerUrl : trailerUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ShowtimeSlot {

 int get id;/// `HH:mm`, cinema local time.
 String get time; String get hallName; String get cinemaName; bool get dolby; bool get screenX;/// Hint only; the quote is computed by the server.
 num? get normalPrice;
/// Create a copy of ShowtimeSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowtimeSlotCopyWith<ShowtimeSlot> get copyWith => _$ShowtimeSlotCopyWithImpl<ShowtimeSlot>(this as ShowtimeSlot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShowtimeSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowtimeSlot&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.cinemaName, _this.cinemaName) || other.cinemaName == _this.cinemaName)&&(identical(other.dolby, _this.dolby) || other.dolby == _this.dolby)&&(identical(other.screenX, _this.screenX) || other.screenX == _this.screenX)&&(identical(other.normalPrice, _this.normalPrice) || other.normalPrice == _this.normalPrice));
}


@override
int get hashCode {
  final _this = this as ShowtimeSlot;
  return Object.hash(runtimeType,_this.id,_this.time,_this.hallName,_this.cinemaName,_this.dolby,_this.screenX,_this.normalPrice);
}

@override
String toString() {
  final _this = this as ShowtimeSlot;
  return 'ShowtimeSlot(id: ${_this.id}, time: ${_this.time}, hallName: ${_this.hallName}, cinemaName: ${_this.cinemaName}, dolby: ${_this.dolby}, screenX: ${_this.screenX}, normalPrice: ${_this.normalPrice})';
}


}

/// @nodoc
abstract mixin class $ShowtimeSlotCopyWith<$Res>  {
  factory $ShowtimeSlotCopyWith(ShowtimeSlot value, $Res Function(ShowtimeSlot) _then) = _$ShowtimeSlotCopyWithImpl;
@useResult
$Res call({
 int id, String time, String hallName, String cinemaName, bool dolby, bool screenX, num? normalPrice
});




}
/// @nodoc
class _$ShowtimeSlotCopyWithImpl<$Res>
    implements $ShowtimeSlotCopyWith<$Res> {
  _$ShowtimeSlotCopyWithImpl(this._self, this._then);

  final ShowtimeSlot _self;
  final $Res Function(ShowtimeSlot) _then;

/// Create a copy of ShowtimeSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? time = null,Object? hallName = null,Object? cinemaName = null,Object? dolby = null,Object? screenX = null,Object? normalPrice = freezed,}) {
  return _then(ShowtimeSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,dolby: null == dolby ? _self.dolby : dolby // ignore: cast_nullable_to_non_nullable
as bool,screenX: null == screenX ? _self.screenX : screenX // ignore: cast_nullable_to_non_nullable
as bool,normalPrice: freezed == normalPrice ? _self.normalPrice : normalPrice // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShowtimeSlot].
extension ShowtimeSlotPatterns on ShowtimeSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShowtimeSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShowtimeSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShowtimeSlot value)  $default,){
final _that = this;
switch (_that) {
case _ShowtimeSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShowtimeSlot value)?  $default,){
final _that = this;
switch (_that) {
case _ShowtimeSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String time,  String hallName,  String cinemaName,  bool dolby,  bool screenX,  num? normalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShowtimeSlot() when $default != null:
return $default(_that.id,_that.time,_that.hallName,_that.cinemaName,_that.dolby,_that.screenX,_that.normalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String time,  String hallName,  String cinemaName,  bool dolby,  bool screenX,  num? normalPrice)  $default,) {final _that = this;
switch (_that) {
case _ShowtimeSlot():
return $default(_that.id,_that.time,_that.hallName,_that.cinemaName,_that.dolby,_that.screenX,_that.normalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String time,  String hallName,  String cinemaName,  bool dolby,  bool screenX,  num? normalPrice)?  $default,) {final _that = this;
switch (_that) {
case _ShowtimeSlot() when $default != null:
return $default(_that.id,_that.time,_that.hallName,_that.cinemaName,_that.dolby,_that.screenX,_that.normalPrice);case _:
  return null;

}
}

}

/// @nodoc


class _ShowtimeSlot implements ShowtimeSlot {
  const _ShowtimeSlot({required this.id, required this.time, required this.hallName, required this.cinemaName, required this.dolby, required this.screenX, this.normalPrice});
  

@override final  int id;
/// `HH:mm`, cinema local time.
@override final  String time;
@override final  String hallName;
@override final  String cinemaName;
@override final  bool dolby;
@override final  bool screenX;
/// Hint only; the quote is computed by the server.
@override final  num? normalPrice;

/// Create a copy of ShowtimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShowtimeSlotCopyWith<_ShowtimeSlot> get copyWith => __$ShowtimeSlotCopyWithImpl<_ShowtimeSlot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShowtimeSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.cinemaName, cinemaName) || other.cinemaName == cinemaName)&&(identical(other.dolby, dolby) || other.dolby == dolby)&&(identical(other.screenX, screenX) || other.screenX == screenX)&&(identical(other.normalPrice, normalPrice) || other.normalPrice == normalPrice));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,time,hallName,cinemaName,dolby,screenX,normalPrice);
}

@override
String toString() {
    return 'ShowtimeSlot(id: $id, time: $time, hallName: $hallName, cinemaName: $cinemaName, dolby: $dolby, screenX: $screenX, normalPrice: $normalPrice)';
}


}

/// @nodoc
abstract mixin class _$ShowtimeSlotCopyWith<$Res> implements $ShowtimeSlotCopyWith<$Res> {
  factory _$ShowtimeSlotCopyWith(_ShowtimeSlot value, $Res Function(_ShowtimeSlot) _then) = __$ShowtimeSlotCopyWithImpl;
@override @useResult
$Res call({
 int id, String time, String hallName, String cinemaName, bool dolby, bool screenX, num? normalPrice
});




}
/// @nodoc
class __$ShowtimeSlotCopyWithImpl<$Res>
    implements _$ShowtimeSlotCopyWith<$Res> {
  __$ShowtimeSlotCopyWithImpl(this._self, this._then);

  final _ShowtimeSlot _self;
  final $Res Function(_ShowtimeSlot) _then;

/// Create a copy of ShowtimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? time = null,Object? hallName = null,Object? cinemaName = null,Object? dolby = null,Object? screenX = null,Object? normalPrice = freezed,}) {
  return _then(_ShowtimeSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,dolby: null == dolby ? _self.dolby : dolby // ignore: cast_nullable_to_non_nullable
as bool,screenX: null == screenX ? _self.screenX : screenX // ignore: cast_nullable_to_non_nullable
as bool,normalPrice: freezed == normalPrice ? _self.normalPrice : normalPrice // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

/// @nodoc
mixin _$ShowingMovie {

 Movie get movie; List<ShowtimeSlot> get slots;
/// Create a copy of ShowingMovie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowingMovieCopyWith<ShowingMovie> get copyWith => _$ShowingMovieCopyWithImpl<ShowingMovie>(this as ShowingMovie, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShowingMovie;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowingMovie&&(identical(other.movie, _this.movie) || other.movie == _this.movie)&&const DeepCollectionEquality().equals(other.slots, _this.slots));
}


@override
int get hashCode {
  final _this = this as ShowingMovie;
  return Object.hash(runtimeType,_this.movie,const DeepCollectionEquality().hash(_this.slots));
}

@override
String toString() {
  final _this = this as ShowingMovie;
  return 'ShowingMovie(movie: ${_this.movie}, slots: ${_this.slots})';
}


}

/// @nodoc
abstract mixin class $ShowingMovieCopyWith<$Res>  {
  factory $ShowingMovieCopyWith(ShowingMovie value, $Res Function(ShowingMovie) _then) = _$ShowingMovieCopyWithImpl;
@useResult
$Res call({
 Movie movie, List<ShowtimeSlot> slots
});


$MovieCopyWith<$Res> get movie;

}
/// @nodoc
class _$ShowingMovieCopyWithImpl<$Res>
    implements $ShowingMovieCopyWith<$Res> {
  _$ShowingMovieCopyWithImpl(this._self, this._then);

  final ShowingMovie _self;
  final $Res Function(ShowingMovie) _then;

/// Create a copy of ShowingMovie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movie = null,Object? slots = null,}) {
  return _then(ShowingMovie(
movie: null == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as Movie,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<ShowtimeSlot>,
  ));
}
/// Create a copy of ShowingMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res> get movie {
  
  return $MovieCopyWith<$Res>(_self.movie, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShowingMovie].
extension ShowingMoviePatterns on ShowingMovie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShowingMovie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShowingMovie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShowingMovie value)  $default,){
final _that = this;
switch (_that) {
case _ShowingMovie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShowingMovie value)?  $default,){
final _that = this;
switch (_that) {
case _ShowingMovie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Movie movie,  List<ShowtimeSlot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShowingMovie() when $default != null:
return $default(_that.movie,_that.slots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Movie movie,  List<ShowtimeSlot> slots)  $default,) {final _that = this;
switch (_that) {
case _ShowingMovie():
return $default(_that.movie,_that.slots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Movie movie,  List<ShowtimeSlot> slots)?  $default,) {final _that = this;
switch (_that) {
case _ShowingMovie() when $default != null:
return $default(_that.movie,_that.slots);case _:
  return null;

}
}

}

/// @nodoc


class _ShowingMovie extends ShowingMovie {
  const _ShowingMovie({required this.movie, required  List<ShowtimeSlot> slots}): _slots = slots,super._();
  

@override final  Movie movie;
 final  List<ShowtimeSlot> _slots;
@override List<ShowtimeSlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of ShowingMovie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShowingMovieCopyWith<_ShowingMovie> get copyWith => __$ShowingMovieCopyWithImpl<_ShowingMovie>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShowingMovie&&(identical(other.movie, movie) || other.movie == movie)&&const DeepCollectionEquality().equals(other.slots, _slots));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movie,const DeepCollectionEquality().hash(_slots));
}

@override
String toString() {
    return 'ShowingMovie(movie: $movie, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$ShowingMovieCopyWith<$Res> implements $ShowingMovieCopyWith<$Res> {
  factory _$ShowingMovieCopyWith(_ShowingMovie value, $Res Function(_ShowingMovie) _then) = __$ShowingMovieCopyWithImpl;
@override @useResult
$Res call({
 Movie movie, List<ShowtimeSlot> slots
});


@override $MovieCopyWith<$Res> get movie;

}
/// @nodoc
class __$ShowingMovieCopyWithImpl<$Res>
    implements _$ShowingMovieCopyWith<$Res> {
  __$ShowingMovieCopyWithImpl(this._self, this._then);

  final _ShowingMovie _self;
  final $Res Function(_ShowingMovie) _then;

/// Create a copy of ShowingMovie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movie = null,Object? slots = null,}) {
  return _then(_ShowingMovie(
movie: null == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as Movie,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<ShowtimeSlot>,
  ));
}

/// Create a copy of ShowingMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res> get movie {
  
  return $MovieCopyWith<$Res>(_self.movie, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}

/// @nodoc
mixin _$HallGroup {

 String get hallName; bool get dolby; bool get screenX; List<ShowtimeSlot> get slots;
/// Create a copy of HallGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallGroupCopyWith<HallGroup> get copyWith => _$HallGroupCopyWithImpl<HallGroup>(this as HallGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HallGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallGroup&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.dolby, _this.dolby) || other.dolby == _this.dolby)&&(identical(other.screenX, _this.screenX) || other.screenX == _this.screenX)&&const DeepCollectionEquality().equals(other.slots, _this.slots));
}


@override
int get hashCode {
  final _this = this as HallGroup;
  return Object.hash(runtimeType,_this.hallName,_this.dolby,_this.screenX,const DeepCollectionEquality().hash(_this.slots));
}

@override
String toString() {
  final _this = this as HallGroup;
  return 'HallGroup(hallName: ${_this.hallName}, dolby: ${_this.dolby}, screenX: ${_this.screenX}, slots: ${_this.slots})';
}


}

/// @nodoc
abstract mixin class $HallGroupCopyWith<$Res>  {
  factory $HallGroupCopyWith(HallGroup value, $Res Function(HallGroup) _then) = _$HallGroupCopyWithImpl;
@useResult
$Res call({
 String hallName, bool dolby, bool screenX, List<ShowtimeSlot> slots
});




}
/// @nodoc
class _$HallGroupCopyWithImpl<$Res>
    implements $HallGroupCopyWith<$Res> {
  _$HallGroupCopyWithImpl(this._self, this._then);

  final HallGroup _self;
  final $Res Function(HallGroup) _then;

/// Create a copy of HallGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hallName = null,Object? dolby = null,Object? screenX = null,Object? slots = null,}) {
  return _then(HallGroup(
hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,dolby: null == dolby ? _self.dolby : dolby // ignore: cast_nullable_to_non_nullable
as bool,screenX: null == screenX ? _self.screenX : screenX // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<ShowtimeSlot>,
  ));
}

}


/// Adds pattern-matching-related methods to [HallGroup].
extension HallGroupPatterns on HallGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallGroup value)  $default,){
final _that = this;
switch (_that) {
case _HallGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallGroup value)?  $default,){
final _that = this;
switch (_that) {
case _HallGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hallName,  bool dolby,  bool screenX,  List<ShowtimeSlot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallGroup() when $default != null:
return $default(_that.hallName,_that.dolby,_that.screenX,_that.slots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hallName,  bool dolby,  bool screenX,  List<ShowtimeSlot> slots)  $default,) {final _that = this;
switch (_that) {
case _HallGroup():
return $default(_that.hallName,_that.dolby,_that.screenX,_that.slots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hallName,  bool dolby,  bool screenX,  List<ShowtimeSlot> slots)?  $default,) {final _that = this;
switch (_that) {
case _HallGroup() when $default != null:
return $default(_that.hallName,_that.dolby,_that.screenX,_that.slots);case _:
  return null;

}
}

}

/// @nodoc


class _HallGroup implements HallGroup {
  const _HallGroup({required this.hallName, required this.dolby, required this.screenX, required  List<ShowtimeSlot> slots}): _slots = slots;
  

@override final  String hallName;
@override final  bool dolby;
@override final  bool screenX;
 final  List<ShowtimeSlot> _slots;
@override List<ShowtimeSlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of HallGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallGroupCopyWith<_HallGroup> get copyWith => __$HallGroupCopyWithImpl<_HallGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallGroup&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.dolby, dolby) || other.dolby == dolby)&&(identical(other.screenX, screenX) || other.screenX == screenX)&&const DeepCollectionEquality().equals(other.slots, _slots));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hallName,dolby,screenX,const DeepCollectionEquality().hash(_slots));
}

@override
String toString() {
    return 'HallGroup(hallName: $hallName, dolby: $dolby, screenX: $screenX, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$HallGroupCopyWith<$Res> implements $HallGroupCopyWith<$Res> {
  factory _$HallGroupCopyWith(_HallGroup value, $Res Function(_HallGroup) _then) = __$HallGroupCopyWithImpl;
@override @useResult
$Res call({
 String hallName, bool dolby, bool screenX, List<ShowtimeSlot> slots
});




}
/// @nodoc
class __$HallGroupCopyWithImpl<$Res>
    implements _$HallGroupCopyWith<$Res> {
  __$HallGroupCopyWithImpl(this._self, this._then);

  final _HallGroup _self;
  final $Res Function(_HallGroup) _then;

/// Create a copy of HallGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hallName = null,Object? dolby = null,Object? screenX = null,Object? slots = null,}) {
  return _then(_HallGroup(
hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,dolby: null == dolby ? _self.dolby : dolby // ignore: cast_nullable_to_non_nullable
as bool,screenX: null == screenX ? _self.screenX : screenX // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<ShowtimeSlot>,
  ));
}


}

/// @nodoc
mixin _$CinemaGroup {

 String get cinemaName; List<HallGroup> get halls;
/// Create a copy of CinemaGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CinemaGroupCopyWith<CinemaGroup> get copyWith => _$CinemaGroupCopyWithImpl<CinemaGroup>(this as CinemaGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CinemaGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CinemaGroup&&(identical(other.cinemaName, _this.cinemaName) || other.cinemaName == _this.cinemaName)&&const DeepCollectionEquality().equals(other.halls, _this.halls));
}


@override
int get hashCode {
  final _this = this as CinemaGroup;
  return Object.hash(runtimeType,_this.cinemaName,const DeepCollectionEquality().hash(_this.halls));
}

@override
String toString() {
  final _this = this as CinemaGroup;
  return 'CinemaGroup(cinemaName: ${_this.cinemaName}, halls: ${_this.halls})';
}


}

/// @nodoc
abstract mixin class $CinemaGroupCopyWith<$Res>  {
  factory $CinemaGroupCopyWith(CinemaGroup value, $Res Function(CinemaGroup) _then) = _$CinemaGroupCopyWithImpl;
@useResult
$Res call({
 String cinemaName, List<HallGroup> halls
});




}
/// @nodoc
class _$CinemaGroupCopyWithImpl<$Res>
    implements $CinemaGroupCopyWith<$Res> {
  _$CinemaGroupCopyWithImpl(this._self, this._then);

  final CinemaGroup _self;
  final $Res Function(CinemaGroup) _then;

/// Create a copy of CinemaGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cinemaName = null,Object? halls = null,}) {
  return _then(CinemaGroup(
cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,halls: null == halls ? _self.halls : halls // ignore: cast_nullable_to_non_nullable
as List<HallGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [CinemaGroup].
extension CinemaGroupPatterns on CinemaGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CinemaGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CinemaGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CinemaGroup value)  $default,){
final _that = this;
switch (_that) {
case _CinemaGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CinemaGroup value)?  $default,){
final _that = this;
switch (_that) {
case _CinemaGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cinemaName,  List<HallGroup> halls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CinemaGroup() when $default != null:
return $default(_that.cinemaName,_that.halls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cinemaName,  List<HallGroup> halls)  $default,) {final _that = this;
switch (_that) {
case _CinemaGroup():
return $default(_that.cinemaName,_that.halls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cinemaName,  List<HallGroup> halls)?  $default,) {final _that = this;
switch (_that) {
case _CinemaGroup() when $default != null:
return $default(_that.cinemaName,_that.halls);case _:
  return null;

}
}

}

/// @nodoc


class _CinemaGroup implements CinemaGroup {
  const _CinemaGroup({required this.cinemaName, required  List<HallGroup> halls}): _halls = halls;
  

@override final  String cinemaName;
 final  List<HallGroup> _halls;
@override List<HallGroup> get halls {
  if (_halls is EqualUnmodifiableListView) return _halls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_halls);
}


/// Create a copy of CinemaGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CinemaGroupCopyWith<_CinemaGroup> get copyWith => __$CinemaGroupCopyWithImpl<_CinemaGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CinemaGroup&&(identical(other.cinemaName, cinemaName) || other.cinemaName == cinemaName)&&const DeepCollectionEquality().equals(other.halls, _halls));
}


@override
int get hashCode {
    return Object.hash(runtimeType,cinemaName,const DeepCollectionEquality().hash(_halls));
}

@override
String toString() {
    return 'CinemaGroup(cinemaName: $cinemaName, halls: $halls)';
}


}

/// @nodoc
abstract mixin class _$CinemaGroupCopyWith<$Res> implements $CinemaGroupCopyWith<$Res> {
  factory _$CinemaGroupCopyWith(_CinemaGroup value, $Res Function(_CinemaGroup) _then) = __$CinemaGroupCopyWithImpl;
@override @useResult
$Res call({
 String cinemaName, List<HallGroup> halls
});




}
/// @nodoc
class __$CinemaGroupCopyWithImpl<$Res>
    implements _$CinemaGroupCopyWith<$Res> {
  __$CinemaGroupCopyWithImpl(this._self, this._then);

  final _CinemaGroup _self;
  final $Res Function(_CinemaGroup) _then;

/// Create a copy of CinemaGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cinemaName = null,Object? halls = null,}) {
  return _then(_CinemaGroup(
cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,halls: null == halls ? _self._halls : halls // ignore: cast_nullable_to_non_nullable
as List<HallGroup>,
  ));
}


}

/// @nodoc
mixin _$MovieDetail {

 Movie get movie; List<DateTime> get availableDates; DateTime? get selectedDate; List<CinemaGroup> get cinemas;
/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailCopyWith<MovieDetail> get copyWith => _$MovieDetailCopyWithImpl<MovieDetail>(this as MovieDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MovieDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetail&&(identical(other.movie, _this.movie) || other.movie == _this.movie)&&const DeepCollectionEquality().equals(other.availableDates, _this.availableDates)&&(identical(other.selectedDate, _this.selectedDate) || other.selectedDate == _this.selectedDate)&&const DeepCollectionEquality().equals(other.cinemas, _this.cinemas));
}


@override
int get hashCode {
  final _this = this as MovieDetail;
  return Object.hash(runtimeType,_this.movie,const DeepCollectionEquality().hash(_this.availableDates),_this.selectedDate,const DeepCollectionEquality().hash(_this.cinemas));
}

@override
String toString() {
  final _this = this as MovieDetail;
  return 'MovieDetail(movie: ${_this.movie}, availableDates: ${_this.availableDates}, selectedDate: ${_this.selectedDate}, cinemas: ${_this.cinemas})';
}


}

/// @nodoc
abstract mixin class $MovieDetailCopyWith<$Res>  {
  factory $MovieDetailCopyWith(MovieDetail value, $Res Function(MovieDetail) _then) = _$MovieDetailCopyWithImpl;
@useResult
$Res call({
 Movie movie, List<DateTime> availableDates, DateTime? selectedDate, List<CinemaGroup> cinemas
});


$MovieCopyWith<$Res> get movie;

}
/// @nodoc
class _$MovieDetailCopyWithImpl<$Res>
    implements $MovieDetailCopyWith<$Res> {
  _$MovieDetailCopyWithImpl(this._self, this._then);

  final MovieDetail _self;
  final $Res Function(MovieDetail) _then;

/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movie = null,Object? availableDates = null,Object? selectedDate = freezed,Object? cinemas = null,}) {
  return _then(MovieDetail(
movie: null == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as Movie,availableDates: null == availableDates ? _self.availableDates : availableDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cinemas: null == cinemas ? _self.cinemas : cinemas // ignore: cast_nullable_to_non_nullable
as List<CinemaGroup>,
  ));
}
/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res> get movie {
  
  return $MovieCopyWith<$Res>(_self.movie, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}


/// Adds pattern-matching-related methods to [MovieDetail].
extension MovieDetailPatterns on MovieDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieDetail value)  $default,){
final _that = this;
switch (_that) {
case _MovieDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Movie movie,  List<DateTime> availableDates,  DateTime? selectedDate,  List<CinemaGroup> cinemas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
return $default(_that.movie,_that.availableDates,_that.selectedDate,_that.cinemas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Movie movie,  List<DateTime> availableDates,  DateTime? selectedDate,  List<CinemaGroup> cinemas)  $default,) {final _that = this;
switch (_that) {
case _MovieDetail():
return $default(_that.movie,_that.availableDates,_that.selectedDate,_that.cinemas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Movie movie,  List<DateTime> availableDates,  DateTime? selectedDate,  List<CinemaGroup> cinemas)?  $default,) {final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
return $default(_that.movie,_that.availableDates,_that.selectedDate,_that.cinemas);case _:
  return null;

}
}

}

/// @nodoc


class _MovieDetail implements MovieDetail {
  const _MovieDetail({required this.movie, required  List<DateTime> availableDates, this.selectedDate, required  List<CinemaGroup> cinemas}): _availableDates = availableDates,_cinemas = cinemas;
  

@override final  Movie movie;
 final  List<DateTime> _availableDates;
@override List<DateTime> get availableDates {
  if (_availableDates is EqualUnmodifiableListView) return _availableDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableDates);
}

@override final  DateTime? selectedDate;
 final  List<CinemaGroup> _cinemas;
@override List<CinemaGroup> get cinemas {
  if (_cinemas is EqualUnmodifiableListView) return _cinemas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cinemas);
}


/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailCopyWith<_MovieDetail> get copyWith => __$MovieDetailCopyWithImpl<_MovieDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetail&&(identical(other.movie, movie) || other.movie == movie)&&const DeepCollectionEquality().equals(other.availableDates, _availableDates)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&const DeepCollectionEquality().equals(other.cinemas, _cinemas));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movie,const DeepCollectionEquality().hash(_availableDates),selectedDate,const DeepCollectionEquality().hash(_cinemas));
}

@override
String toString() {
    return 'MovieDetail(movie: $movie, availableDates: $availableDates, selectedDate: $selectedDate, cinemas: $cinemas)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailCopyWith<$Res> implements $MovieDetailCopyWith<$Res> {
  factory _$MovieDetailCopyWith(_MovieDetail value, $Res Function(_MovieDetail) _then) = __$MovieDetailCopyWithImpl;
@override @useResult
$Res call({
 Movie movie, List<DateTime> availableDates, DateTime? selectedDate, List<CinemaGroup> cinemas
});


@override $MovieCopyWith<$Res> get movie;

}
/// @nodoc
class __$MovieDetailCopyWithImpl<$Res>
    implements _$MovieDetailCopyWith<$Res> {
  __$MovieDetailCopyWithImpl(this._self, this._then);

  final _MovieDetail _self;
  final $Res Function(_MovieDetail) _then;

/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movie = null,Object? availableDates = null,Object? selectedDate = freezed,Object? cinemas = null,}) {
  return _then(_MovieDetail(
movie: null == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as Movie,availableDates: null == availableDates ? _self._availableDates : availableDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cinemas: null == cinemas ? _self._cinemas : cinemas // ignore: cast_nullable_to_non_nullable
as List<CinemaGroup>,
  ));
}

/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res> get movie {
  
  return $MovieCopyWith<$Res>(_self.movie, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}

// dart format on
