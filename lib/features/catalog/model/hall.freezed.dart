// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hall.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Hall {

 int get id; String get name;/// `ATMOS`, `STANDARD`, or whatever the server sent.
 String? get type; String? get city; String? get address; int? get totalSeats; bool get dolby; bool get screenX; String? get amenities; String get cinemaId; String get cinemaName; String? get openingHours;
/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallCopyWith<Hall> get copyWith => _$HallCopyWithImpl<Hall>(this as Hall, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Hall;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hall&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.totalSeats, _this.totalSeats) || other.totalSeats == _this.totalSeats)&&(identical(other.dolby, _this.dolby) || other.dolby == _this.dolby)&&(identical(other.screenX, _this.screenX) || other.screenX == _this.screenX)&&(identical(other.amenities, _this.amenities) || other.amenities == _this.amenities)&&(identical(other.cinemaId, _this.cinemaId) || other.cinemaId == _this.cinemaId)&&(identical(other.cinemaName, _this.cinemaName) || other.cinemaName == _this.cinemaName)&&(identical(other.openingHours, _this.openingHours) || other.openingHours == _this.openingHours));
}


@override
int get hashCode {
  final _this = this as Hall;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.city,_this.address,_this.totalSeats,_this.dolby,_this.screenX,_this.amenities,_this.cinemaId,_this.cinemaName,_this.openingHours);
}

@override
String toString() {
  final _this = this as Hall;
  return 'Hall(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, city: ${_this.city}, address: ${_this.address}, totalSeats: ${_this.totalSeats}, dolby: ${_this.dolby}, screenX: ${_this.screenX}, amenities: ${_this.amenities}, cinemaId: ${_this.cinemaId}, cinemaName: ${_this.cinemaName}, openingHours: ${_this.openingHours})';
}


}

/// @nodoc
abstract mixin class $HallCopyWith<$Res>  {
  factory $HallCopyWith(Hall value, $Res Function(Hall) _then) = _$HallCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? type, String? city, String? address, int? totalSeats, bool dolby, bool screenX, String? amenities, String cinemaId, String cinemaName, String? openingHours
});




}
/// @nodoc
class _$HallCopyWithImpl<$Res>
    implements $HallCopyWith<$Res> {
  _$HallCopyWithImpl(this._self, this._then);

  final Hall _self;
  final $Res Function(Hall) _then;

/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = freezed,Object? city = freezed,Object? address = freezed,Object? totalSeats = freezed,Object? dolby = null,Object? screenX = null,Object? amenities = freezed,Object? cinemaId = null,Object? cinemaName = null,Object? openingHours = freezed,}) {
  return _then(Hall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,totalSeats: freezed == totalSeats ? _self.totalSeats : totalSeats // ignore: cast_nullable_to_non_nullable
as int?,dolby: null == dolby ? _self.dolby : dolby // ignore: cast_nullable_to_non_nullable
as bool,screenX: null == screenX ? _self.screenX : screenX // ignore: cast_nullable_to_non_nullable
as bool,amenities: freezed == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as String?,cinemaId: null == cinemaId ? _self.cinemaId : cinemaId // ignore: cast_nullable_to_non_nullable
as String,cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Hall].
extension HallPatterns on Hall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hall value)  $default,){
final _that = this;
switch (_that) {
case _Hall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hall value)?  $default,){
final _that = this;
switch (_that) {
case _Hall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? type,  String? city,  String? address,  int? totalSeats,  bool dolby,  bool screenX,  String? amenities,  String cinemaId,  String cinemaName,  String? openingHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hall() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.city,_that.address,_that.totalSeats,_that.dolby,_that.screenX,_that.amenities,_that.cinemaId,_that.cinemaName,_that.openingHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? type,  String? city,  String? address,  int? totalSeats,  bool dolby,  bool screenX,  String? amenities,  String cinemaId,  String cinemaName,  String? openingHours)  $default,) {final _that = this;
switch (_that) {
case _Hall():
return $default(_that.id,_that.name,_that.type,_that.city,_that.address,_that.totalSeats,_that.dolby,_that.screenX,_that.amenities,_that.cinemaId,_that.cinemaName,_that.openingHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? type,  String? city,  String? address,  int? totalSeats,  bool dolby,  bool screenX,  String? amenities,  String cinemaId,  String cinemaName,  String? openingHours)?  $default,) {final _that = this;
switch (_that) {
case _Hall() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.city,_that.address,_that.totalSeats,_that.dolby,_that.screenX,_that.amenities,_that.cinemaId,_that.cinemaName,_that.openingHours);case _:
  return null;

}
}

}

/// @nodoc


class _Hall implements Hall {
  const _Hall({required this.id, required this.name, this.type, this.city, this.address, this.totalSeats, this.dolby = false, this.screenX = false, this.amenities, required this.cinemaId, required this.cinemaName, this.openingHours});
  

@override final  int id;
@override final  String name;
/// `ATMOS`, `STANDARD`, or whatever the server sent.
@override final  String? type;
@override final  String? city;
@override final  String? address;
@override final  int? totalSeats;
@override@JsonKey() final  bool dolby;
@override@JsonKey() final  bool screenX;
@override final  String? amenities;
@override final  String cinemaId;
@override final  String cinemaName;
@override final  String? openingHours;

/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallCopyWith<_Hall> get copyWith => __$HallCopyWithImpl<_Hall>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hall&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.city, city) || other.city == city)&&(identical(other.address, address) || other.address == address)&&(identical(other.totalSeats, totalSeats) || other.totalSeats == totalSeats)&&(identical(other.dolby, dolby) || other.dolby == dolby)&&(identical(other.screenX, screenX) || other.screenX == screenX)&&(identical(other.amenities, amenities) || other.amenities == amenities)&&(identical(other.cinemaId, cinemaId) || other.cinemaId == cinemaId)&&(identical(other.cinemaName, cinemaName) || other.cinemaName == cinemaName)&&(identical(other.openingHours, openingHours) || other.openingHours == openingHours));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,city,address,totalSeats,dolby,screenX,amenities,cinemaId,cinemaName,openingHours);
}

@override
String toString() {
    return 'Hall(id: $id, name: $name, type: $type, city: $city, address: $address, totalSeats: $totalSeats, dolby: $dolby, screenX: $screenX, amenities: $amenities, cinemaId: $cinemaId, cinemaName: $cinemaName, openingHours: $openingHours)';
}


}

/// @nodoc
abstract mixin class _$HallCopyWith<$Res> implements $HallCopyWith<$Res> {
  factory _$HallCopyWith(_Hall value, $Res Function(_Hall) _then) = __$HallCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? type, String? city, String? address, int? totalSeats, bool dolby, bool screenX, String? amenities, String cinemaId, String cinemaName, String? openingHours
});




}
/// @nodoc
class __$HallCopyWithImpl<$Res>
    implements _$HallCopyWith<$Res> {
  __$HallCopyWithImpl(this._self, this._then);

  final _Hall _self;
  final $Res Function(_Hall) _then;

/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = freezed,Object? city = freezed,Object? address = freezed,Object? totalSeats = freezed,Object? dolby = null,Object? screenX = null,Object? amenities = freezed,Object? cinemaId = null,Object? cinemaName = null,Object? openingHours = freezed,}) {
  return _then(_Hall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,totalSeats: freezed == totalSeats ? _self.totalSeats : totalSeats // ignore: cast_nullable_to_non_nullable
as int?,dolby: null == dolby ? _self.dolby : dolby // ignore: cast_nullable_to_non_nullable
as bool,screenX: null == screenX ? _self.screenX : screenX // ignore: cast_nullable_to_non_nullable
as bool,amenities: freezed == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as String?,cinemaId: null == cinemaId ? _self.cinemaId : cinemaId // ignore: cast_nullable_to_non_nullable
as String,cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$HallGroup {

 String get cinemaId; String get cinemaName; String? get city; List<Hall> get halls;
/// Create a copy of HallGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallGroupCopyWith<HallGroup> get copyWith => _$HallGroupCopyWithImpl<HallGroup>(this as HallGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HallGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallGroup&&(identical(other.cinemaId, _this.cinemaId) || other.cinemaId == _this.cinemaId)&&(identical(other.cinemaName, _this.cinemaName) || other.cinemaName == _this.cinemaName)&&(identical(other.city, _this.city) || other.city == _this.city)&&const DeepCollectionEquality().equals(other.halls, _this.halls));
}


@override
int get hashCode {
  final _this = this as HallGroup;
  return Object.hash(runtimeType,_this.cinemaId,_this.cinemaName,_this.city,const DeepCollectionEquality().hash(_this.halls));
}

@override
String toString() {
  final _this = this as HallGroup;
  return 'HallGroup(cinemaId: ${_this.cinemaId}, cinemaName: ${_this.cinemaName}, city: ${_this.city}, halls: ${_this.halls})';
}


}

/// @nodoc
abstract mixin class $HallGroupCopyWith<$Res>  {
  factory $HallGroupCopyWith(HallGroup value, $Res Function(HallGroup) _then) = _$HallGroupCopyWithImpl;
@useResult
$Res call({
 String cinemaId, String cinemaName, String? city, List<Hall> halls
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
@pragma('vm:prefer-inline') @override $Res call({Object? cinemaId = null,Object? cinemaName = null,Object? city = freezed,Object? halls = null,}) {
  return _then(HallGroup(
cinemaId: null == cinemaId ? _self.cinemaId : cinemaId // ignore: cast_nullable_to_non_nullable
as String,cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,halls: null == halls ? _self.halls : halls // ignore: cast_nullable_to_non_nullable
as List<Hall>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cinemaId,  String cinemaName,  String? city,  List<Hall> halls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallGroup() when $default != null:
return $default(_that.cinemaId,_that.cinemaName,_that.city,_that.halls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cinemaId,  String cinemaName,  String? city,  List<Hall> halls)  $default,) {final _that = this;
switch (_that) {
case _HallGroup():
return $default(_that.cinemaId,_that.cinemaName,_that.city,_that.halls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cinemaId,  String cinemaName,  String? city,  List<Hall> halls)?  $default,) {final _that = this;
switch (_that) {
case _HallGroup() when $default != null:
return $default(_that.cinemaId,_that.cinemaName,_that.city,_that.halls);case _:
  return null;

}
}

}

/// @nodoc


class _HallGroup implements HallGroup {
  const _HallGroup({required this.cinemaId, required this.cinemaName, this.city, required  List<Hall> halls}): _halls = halls;
  

@override final  String cinemaId;
@override final  String cinemaName;
@override final  String? city;
 final  List<Hall> _halls;
@override List<Hall> get halls {
  if (_halls is EqualUnmodifiableListView) return _halls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_halls);
}


/// Create a copy of HallGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallGroupCopyWith<_HallGroup> get copyWith => __$HallGroupCopyWithImpl<_HallGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallGroup&&(identical(other.cinemaId, cinemaId) || other.cinemaId == cinemaId)&&(identical(other.cinemaName, cinemaName) || other.cinemaName == cinemaName)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.halls, _halls));
}


@override
int get hashCode {
    return Object.hash(runtimeType,cinemaId,cinemaName,city,const DeepCollectionEquality().hash(_halls));
}

@override
String toString() {
    return 'HallGroup(cinemaId: $cinemaId, cinemaName: $cinemaName, city: $city, halls: $halls)';
}


}

/// @nodoc
abstract mixin class _$HallGroupCopyWith<$Res> implements $HallGroupCopyWith<$Res> {
  factory _$HallGroupCopyWith(_HallGroup value, $Res Function(_HallGroup) _then) = __$HallGroupCopyWithImpl;
@override @useResult
$Res call({
 String cinemaId, String cinemaName, String? city, List<Hall> halls
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
@override @pragma('vm:prefer-inline') $Res call({Object? cinemaId = null,Object? cinemaName = null,Object? city = freezed,Object? halls = null,}) {
  return _then(_HallGroup(
cinemaId: null == cinemaId ? _self.cinemaId : cinemaId // ignore: cast_nullable_to_non_nullable
as String,cinemaName: null == cinemaName ? _self.cinemaName : cinemaName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,halls: null == halls ? _self._halls : halls // ignore: cast_nullable_to_non_nullable
as List<Hall>,
  ));
}


}

/// @nodoc
mixin _$HallShowtime {

 int get id; DateTime get date; String get time; int get movieId; String get movieTitle; String? get posterUrl; num? get normalPrice; num? get couplePrice;
/// Create a copy of HallShowtime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallShowtimeCopyWith<HallShowtime> get copyWith => _$HallShowtimeCopyWithImpl<HallShowtime>(this as HallShowtime, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HallShowtime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallShowtime&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.movieId, _this.movieId) || other.movieId == _this.movieId)&&(identical(other.movieTitle, _this.movieTitle) || other.movieTitle == _this.movieTitle)&&(identical(other.posterUrl, _this.posterUrl) || other.posterUrl == _this.posterUrl)&&(identical(other.normalPrice, _this.normalPrice) || other.normalPrice == _this.normalPrice)&&(identical(other.couplePrice, _this.couplePrice) || other.couplePrice == _this.couplePrice));
}


@override
int get hashCode {
  final _this = this as HallShowtime;
  return Object.hash(runtimeType,_this.id,_this.date,_this.time,_this.movieId,_this.movieTitle,_this.posterUrl,_this.normalPrice,_this.couplePrice);
}

@override
String toString() {
  final _this = this as HallShowtime;
  return 'HallShowtime(id: ${_this.id}, date: ${_this.date}, time: ${_this.time}, movieId: ${_this.movieId}, movieTitle: ${_this.movieTitle}, posterUrl: ${_this.posterUrl}, normalPrice: ${_this.normalPrice}, couplePrice: ${_this.couplePrice})';
}


}

/// @nodoc
abstract mixin class $HallShowtimeCopyWith<$Res>  {
  factory $HallShowtimeCopyWith(HallShowtime value, $Res Function(HallShowtime) _then) = _$HallShowtimeCopyWithImpl;
@useResult
$Res call({
 int id, DateTime date, String time, int movieId, String movieTitle, String? posterUrl, num? normalPrice, num? couplePrice
});




}
/// @nodoc
class _$HallShowtimeCopyWithImpl<$Res>
    implements $HallShowtimeCopyWith<$Res> {
  _$HallShowtimeCopyWithImpl(this._self, this._then);

  final HallShowtime _self;
  final $Res Function(HallShowtime) _then;

/// Create a copy of HallShowtime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? time = null,Object? movieId = null,Object? movieTitle = null,Object? posterUrl = freezed,Object? normalPrice = freezed,Object? couplePrice = freezed,}) {
  return _then(HallShowtime(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,movieId: null == movieId ? _self.movieId : movieId // ignore: cast_nullable_to_non_nullable
as int,movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,normalPrice: freezed == normalPrice ? _self.normalPrice : normalPrice // ignore: cast_nullable_to_non_nullable
as num?,couplePrice: freezed == couplePrice ? _self.couplePrice : couplePrice // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [HallShowtime].
extension HallShowtimePatterns on HallShowtime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallShowtime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallShowtime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallShowtime value)  $default,){
final _that = this;
switch (_that) {
case _HallShowtime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallShowtime value)?  $default,){
final _that = this;
switch (_that) {
case _HallShowtime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime date,  String time,  int movieId,  String movieTitle,  String? posterUrl,  num? normalPrice,  num? couplePrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallShowtime() when $default != null:
return $default(_that.id,_that.date,_that.time,_that.movieId,_that.movieTitle,_that.posterUrl,_that.normalPrice,_that.couplePrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime date,  String time,  int movieId,  String movieTitle,  String? posterUrl,  num? normalPrice,  num? couplePrice)  $default,) {final _that = this;
switch (_that) {
case _HallShowtime():
return $default(_that.id,_that.date,_that.time,_that.movieId,_that.movieTitle,_that.posterUrl,_that.normalPrice,_that.couplePrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime date,  String time,  int movieId,  String movieTitle,  String? posterUrl,  num? normalPrice,  num? couplePrice)?  $default,) {final _that = this;
switch (_that) {
case _HallShowtime() when $default != null:
return $default(_that.id,_that.date,_that.time,_that.movieId,_that.movieTitle,_that.posterUrl,_that.normalPrice,_that.couplePrice);case _:
  return null;

}
}

}

/// @nodoc


class _HallShowtime implements HallShowtime {
  const _HallShowtime({required this.id, required this.date, required this.time, required this.movieId, required this.movieTitle, this.posterUrl, this.normalPrice, this.couplePrice});
  

@override final  int id;
@override final  DateTime date;
@override final  String time;
@override final  int movieId;
@override final  String movieTitle;
@override final  String? posterUrl;
@override final  num? normalPrice;
@override final  num? couplePrice;

/// Create a copy of HallShowtime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallShowtimeCopyWith<_HallShowtime> get copyWith => __$HallShowtimeCopyWithImpl<_HallShowtime>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallShowtime&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.movieId, movieId) || other.movieId == movieId)&&(identical(other.movieTitle, movieTitle) || other.movieTitle == movieTitle)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.normalPrice, normalPrice) || other.normalPrice == normalPrice)&&(identical(other.couplePrice, couplePrice) || other.couplePrice == couplePrice));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,date,time,movieId,movieTitle,posterUrl,normalPrice,couplePrice);
}

@override
String toString() {
    return 'HallShowtime(id: $id, date: $date, time: $time, movieId: $movieId, movieTitle: $movieTitle, posterUrl: $posterUrl, normalPrice: $normalPrice, couplePrice: $couplePrice)';
}


}

/// @nodoc
abstract mixin class _$HallShowtimeCopyWith<$Res> implements $HallShowtimeCopyWith<$Res> {
  factory _$HallShowtimeCopyWith(_HallShowtime value, $Res Function(_HallShowtime) _then) = __$HallShowtimeCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime date, String time, int movieId, String movieTitle, String? posterUrl, num? normalPrice, num? couplePrice
});




}
/// @nodoc
class __$HallShowtimeCopyWithImpl<$Res>
    implements _$HallShowtimeCopyWith<$Res> {
  __$HallShowtimeCopyWithImpl(this._self, this._then);

  final _HallShowtime _self;
  final $Res Function(_HallShowtime) _then;

/// Create a copy of HallShowtime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? time = null,Object? movieId = null,Object? movieTitle = null,Object? posterUrl = freezed,Object? normalPrice = freezed,Object? couplePrice = freezed,}) {
  return _then(_HallShowtime(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,movieId: null == movieId ? _self.movieId : movieId // ignore: cast_nullable_to_non_nullable
as int,movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,normalPrice: freezed == normalPrice ? _self.normalPrice : normalPrice // ignore: cast_nullable_to_non_nullable
as num?,couplePrice: freezed == couplePrice ? _self.couplePrice : couplePrice // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

/// @nodoc
mixin _$HallSchedule {

 Hall get hall; List<DateTime> get availableDates; DateTime? get selectedDate; List<HallShowtime> get showtimes;
/// Create a copy of HallSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallScheduleCopyWith<HallSchedule> get copyWith => _$HallScheduleCopyWithImpl<HallSchedule>(this as HallSchedule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HallSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallSchedule&&(identical(other.hall, _this.hall) || other.hall == _this.hall)&&const DeepCollectionEquality().equals(other.availableDates, _this.availableDates)&&(identical(other.selectedDate, _this.selectedDate) || other.selectedDate == _this.selectedDate)&&const DeepCollectionEquality().equals(other.showtimes, _this.showtimes));
}


@override
int get hashCode {
  final _this = this as HallSchedule;
  return Object.hash(runtimeType,_this.hall,const DeepCollectionEquality().hash(_this.availableDates),_this.selectedDate,const DeepCollectionEquality().hash(_this.showtimes));
}

@override
String toString() {
  final _this = this as HallSchedule;
  return 'HallSchedule(hall: ${_this.hall}, availableDates: ${_this.availableDates}, selectedDate: ${_this.selectedDate}, showtimes: ${_this.showtimes})';
}


}

/// @nodoc
abstract mixin class $HallScheduleCopyWith<$Res>  {
  factory $HallScheduleCopyWith(HallSchedule value, $Res Function(HallSchedule) _then) = _$HallScheduleCopyWithImpl;
@useResult
$Res call({
 Hall hall, List<DateTime> availableDates, DateTime? selectedDate, List<HallShowtime> showtimes
});


$HallCopyWith<$Res> get hall;

}
/// @nodoc
class _$HallScheduleCopyWithImpl<$Res>
    implements $HallScheduleCopyWith<$Res> {
  _$HallScheduleCopyWithImpl(this._self, this._then);

  final HallSchedule _self;
  final $Res Function(HallSchedule) _then;

/// Create a copy of HallSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hall = null,Object? availableDates = null,Object? selectedDate = freezed,Object? showtimes = null,}) {
  return _then(HallSchedule(
hall: null == hall ? _self.hall : hall // ignore: cast_nullable_to_non_nullable
as Hall,availableDates: null == availableDates ? _self.availableDates : availableDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,showtimes: null == showtimes ? _self.showtimes : showtimes // ignore: cast_nullable_to_non_nullable
as List<HallShowtime>,
  ));
}
/// Create a copy of HallSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HallCopyWith<$Res> get hall {
  
  return $HallCopyWith<$Res>(_self.hall, (value) {
    return _then(_self.copyWith(hall: value));
  });
}
}


/// Adds pattern-matching-related methods to [HallSchedule].
extension HallSchedulePatterns on HallSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallSchedule value)  $default,){
final _that = this;
switch (_that) {
case _HallSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _HallSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Hall hall,  List<DateTime> availableDates,  DateTime? selectedDate,  List<HallShowtime> showtimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallSchedule() when $default != null:
return $default(_that.hall,_that.availableDates,_that.selectedDate,_that.showtimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Hall hall,  List<DateTime> availableDates,  DateTime? selectedDate,  List<HallShowtime> showtimes)  $default,) {final _that = this;
switch (_that) {
case _HallSchedule():
return $default(_that.hall,_that.availableDates,_that.selectedDate,_that.showtimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Hall hall,  List<DateTime> availableDates,  DateTime? selectedDate,  List<HallShowtime> showtimes)?  $default,) {final _that = this;
switch (_that) {
case _HallSchedule() when $default != null:
return $default(_that.hall,_that.availableDates,_that.selectedDate,_that.showtimes);case _:
  return null;

}
}

}

/// @nodoc


class _HallSchedule extends HallSchedule {
  const _HallSchedule({required this.hall, required  List<DateTime> availableDates, this.selectedDate, required  List<HallShowtime> showtimes}): _availableDates = availableDates,_showtimes = showtimes,super._();
  

@override final  Hall hall;
 final  List<DateTime> _availableDates;
@override List<DateTime> get availableDates {
  if (_availableDates is EqualUnmodifiableListView) return _availableDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableDates);
}

@override final  DateTime? selectedDate;
 final  List<HallShowtime> _showtimes;
@override List<HallShowtime> get showtimes {
  if (_showtimes is EqualUnmodifiableListView) return _showtimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_showtimes);
}


/// Create a copy of HallSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallScheduleCopyWith<_HallSchedule> get copyWith => __$HallScheduleCopyWithImpl<_HallSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallSchedule&&(identical(other.hall, hall) || other.hall == hall)&&const DeepCollectionEquality().equals(other.availableDates, _availableDates)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&const DeepCollectionEquality().equals(other.showtimes, _showtimes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hall,const DeepCollectionEquality().hash(_availableDates),selectedDate,const DeepCollectionEquality().hash(_showtimes));
}

@override
String toString() {
    return 'HallSchedule(hall: $hall, availableDates: $availableDates, selectedDate: $selectedDate, showtimes: $showtimes)';
}


}

/// @nodoc
abstract mixin class _$HallScheduleCopyWith<$Res> implements $HallScheduleCopyWith<$Res> {
  factory _$HallScheduleCopyWith(_HallSchedule value, $Res Function(_HallSchedule) _then) = __$HallScheduleCopyWithImpl;
@override @useResult
$Res call({
 Hall hall, List<DateTime> availableDates, DateTime? selectedDate, List<HallShowtime> showtimes
});


@override $HallCopyWith<$Res> get hall;

}
/// @nodoc
class __$HallScheduleCopyWithImpl<$Res>
    implements _$HallScheduleCopyWith<$Res> {
  __$HallScheduleCopyWithImpl(this._self, this._then);

  final _HallSchedule _self;
  final $Res Function(_HallSchedule) _then;

/// Create a copy of HallSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hall = null,Object? availableDates = null,Object? selectedDate = freezed,Object? showtimes = null,}) {
  return _then(_HallSchedule(
hall: null == hall ? _self.hall : hall // ignore: cast_nullable_to_non_nullable
as Hall,availableDates: null == availableDates ? _self._availableDates : availableDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,showtimes: null == showtimes ? _self._showtimes : showtimes // ignore: cast_nullable_to_non_nullable
as List<HallShowtime>,
  ));
}

/// Create a copy of HallSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HallCopyWith<$Res> get hall {
  
  return $HallCopyWith<$Res>(_self.hall, (value) {
    return _then(_self.copyWith(hall: value));
  });
}
}

// dart format on
