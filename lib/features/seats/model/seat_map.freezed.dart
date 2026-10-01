// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seat_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeatView {

/// `showtime_seats.id`.
 int get id; String get code; int get row; int get number; bool get couple; bool get booked;
/// Create a copy of SeatView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatViewCopyWith<SeatView> get copyWith => _$SeatViewCopyWithImpl<SeatView>(this as SeatView, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SeatView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatView&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.row, _this.row) || other.row == _this.row)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.couple, _this.couple) || other.couple == _this.couple)&&(identical(other.booked, _this.booked) || other.booked == _this.booked));
}


@override
int get hashCode {
  final _this = this as SeatView;
  return Object.hash(runtimeType,_this.id,_this.code,_this.row,_this.number,_this.couple,_this.booked);
}

@override
String toString() {
  final _this = this as SeatView;
  return 'SeatView(id: ${_this.id}, code: ${_this.code}, row: ${_this.row}, number: ${_this.number}, couple: ${_this.couple}, booked: ${_this.booked})';
}


}

/// @nodoc
abstract mixin class $SeatViewCopyWith<$Res>  {
  factory $SeatViewCopyWith(SeatView value, $Res Function(SeatView) _then) = _$SeatViewCopyWithImpl;
@useResult
$Res call({
 int id, String code, int row, int number, bool couple, bool booked
});




}
/// @nodoc
class _$SeatViewCopyWithImpl<$Res>
    implements $SeatViewCopyWith<$Res> {
  _$SeatViewCopyWithImpl(this._self, this._then);

  final SeatView _self;
  final $Res Function(SeatView) _then;

/// Create a copy of SeatView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? row = null,Object? number = null,Object? couple = null,Object? booked = null,}) {
  return _then(SeatView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,couple: null == couple ? _self.couple : couple // ignore: cast_nullable_to_non_nullable
as bool,booked: null == booked ? _self.booked : booked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SeatView].
extension SeatViewPatterns on SeatView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeatView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeatView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeatView value)  $default,){
final _that = this;
switch (_that) {
case _SeatView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeatView value)?  $default,){
final _that = this;
switch (_that) {
case _SeatView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  int row,  int number,  bool couple,  bool booked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeatView() when $default != null:
return $default(_that.id,_that.code,_that.row,_that.number,_that.couple,_that.booked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  int row,  int number,  bool couple,  bool booked)  $default,) {final _that = this;
switch (_that) {
case _SeatView():
return $default(_that.id,_that.code,_that.row,_that.number,_that.couple,_that.booked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  int row,  int number,  bool couple,  bool booked)?  $default,) {final _that = this;
switch (_that) {
case _SeatView() when $default != null:
return $default(_that.id,_that.code,_that.row,_that.number,_that.couple,_that.booked);case _:
  return null;

}
}

}

/// @nodoc


class _SeatView implements SeatView {
  const _SeatView({required this.id, required this.code, required this.row, required this.number, required this.couple, required this.booked});
  

/// `showtime_seats.id`.
@override final  int id;
@override final  String code;
@override final  int row;
@override final  int number;
@override final  bool couple;
@override final  bool booked;

/// Create a copy of SeatView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeatViewCopyWith<_SeatView> get copyWith => __$SeatViewCopyWithImpl<_SeatView>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeatView&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.row, row) || other.row == row)&&(identical(other.number, number) || other.number == number)&&(identical(other.couple, couple) || other.couple == couple)&&(identical(other.booked, booked) || other.booked == booked));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,code,row,number,couple,booked);
}

@override
String toString() {
    return 'SeatView(id: $id, code: $code, row: $row, number: $number, couple: $couple, booked: $booked)';
}


}

/// @nodoc
abstract mixin class _$SeatViewCopyWith<$Res> implements $SeatViewCopyWith<$Res> {
  factory _$SeatViewCopyWith(_SeatView value, $Res Function(_SeatView) _then) = __$SeatViewCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, int row, int number, bool couple, bool booked
});




}
/// @nodoc
class __$SeatViewCopyWithImpl<$Res>
    implements _$SeatViewCopyWith<$Res> {
  __$SeatViewCopyWithImpl(this._self, this._then);

  final _SeatView _self;
  final $Res Function(_SeatView) _then;

/// Create a copy of SeatView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? row = null,Object? number = null,Object? couple = null,Object? booked = null,}) {
  return _then(_SeatView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,couple: null == couple ? _self.couple : couple // ignore: cast_nullable_to_non_nullable
as bool,booked: null == booked ? _self.booked : booked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SeatMapData {

 int get showtimeId; String get movieTitle; String get hallName; String? get showDate; String? get showTime; List<SeatView> get seats; Set<int> get heldByOthers; int get holdMinutes;
/// Create a copy of SeatMapData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatMapDataCopyWith<SeatMapData> get copyWith => _$SeatMapDataCopyWithImpl<SeatMapData>(this as SeatMapData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SeatMapData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatMapData&&(identical(other.showtimeId, _this.showtimeId) || other.showtimeId == _this.showtimeId)&&(identical(other.movieTitle, _this.movieTitle) || other.movieTitle == _this.movieTitle)&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.showDate, _this.showDate) || other.showDate == _this.showDate)&&(identical(other.showTime, _this.showTime) || other.showTime == _this.showTime)&&const DeepCollectionEquality().equals(other.seats, _this.seats)&&const DeepCollectionEquality().equals(other.heldByOthers, _this.heldByOthers)&&(identical(other.holdMinutes, _this.holdMinutes) || other.holdMinutes == _this.holdMinutes));
}


@override
int get hashCode {
  final _this = this as SeatMapData;
  return Object.hash(runtimeType,_this.showtimeId,_this.movieTitle,_this.hallName,_this.showDate,_this.showTime,const DeepCollectionEquality().hash(_this.seats),const DeepCollectionEquality().hash(_this.heldByOthers),_this.holdMinutes);
}

@override
String toString() {
  final _this = this as SeatMapData;
  return 'SeatMapData(showtimeId: ${_this.showtimeId}, movieTitle: ${_this.movieTitle}, hallName: ${_this.hallName}, showDate: ${_this.showDate}, showTime: ${_this.showTime}, seats: ${_this.seats}, heldByOthers: ${_this.heldByOthers}, holdMinutes: ${_this.holdMinutes})';
}


}

/// @nodoc
abstract mixin class $SeatMapDataCopyWith<$Res>  {
  factory $SeatMapDataCopyWith(SeatMapData value, $Res Function(SeatMapData) _then) = _$SeatMapDataCopyWithImpl;
@useResult
$Res call({
 int showtimeId, String movieTitle, String hallName, String? showDate, String? showTime, List<SeatView> seats, Set<int> heldByOthers, int holdMinutes
});




}
/// @nodoc
class _$SeatMapDataCopyWithImpl<$Res>
    implements $SeatMapDataCopyWith<$Res> {
  _$SeatMapDataCopyWithImpl(this._self, this._then);

  final SeatMapData _self;
  final $Res Function(SeatMapData) _then;

/// Create a copy of SeatMapData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showtimeId = null,Object? movieTitle = null,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? seats = null,Object? heldByOthers = null,Object? holdMinutes = null,}) {
  return _then(SeatMapData(
showtimeId: null == showtimeId ? _self.showtimeId : showtimeId // ignore: cast_nullable_to_non_nullable
as int,movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as List<SeatView>,heldByOthers: null == heldByOthers ? _self.heldByOthers : heldByOthers // ignore: cast_nullable_to_non_nullable
as Set<int>,holdMinutes: null == holdMinutes ? _self.holdMinutes : holdMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SeatMapData].
extension SeatMapDataPatterns on SeatMapData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeatMapData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeatMapData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeatMapData value)  $default,){
final _that = this;
switch (_that) {
case _SeatMapData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeatMapData value)?  $default,){
final _that = this;
switch (_that) {
case _SeatMapData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int showtimeId,  String movieTitle,  String hallName,  String? showDate,  String? showTime,  List<SeatView> seats,  Set<int> heldByOthers,  int holdMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeatMapData() when $default != null:
return $default(_that.showtimeId,_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.seats,_that.heldByOthers,_that.holdMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int showtimeId,  String movieTitle,  String hallName,  String? showDate,  String? showTime,  List<SeatView> seats,  Set<int> heldByOthers,  int holdMinutes)  $default,) {final _that = this;
switch (_that) {
case _SeatMapData():
return $default(_that.showtimeId,_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.seats,_that.heldByOthers,_that.holdMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int showtimeId,  String movieTitle,  String hallName,  String? showDate,  String? showTime,  List<SeatView> seats,  Set<int> heldByOthers,  int holdMinutes)?  $default,) {final _that = this;
switch (_that) {
case _SeatMapData() when $default != null:
return $default(_that.showtimeId,_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.seats,_that.heldByOthers,_that.holdMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _SeatMapData implements SeatMapData {
  const _SeatMapData({required this.showtimeId, required this.movieTitle, required this.hallName, this.showDate, this.showTime, required  List<SeatView> seats, required  Set<int> heldByOthers, required this.holdMinutes}): _seats = seats,_heldByOthers = heldByOthers;
  

@override final  int showtimeId;
@override final  String movieTitle;
@override final  String hallName;
@override final  String? showDate;
@override final  String? showTime;
 final  List<SeatView> _seats;
@override List<SeatView> get seats {
  if (_seats is EqualUnmodifiableListView) return _seats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seats);
}

 final  Set<int> _heldByOthers;
@override Set<int> get heldByOthers {
  if (_heldByOthers is EqualUnmodifiableSetView) return _heldByOthers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_heldByOthers);
}

@override final  int holdMinutes;

/// Create a copy of SeatMapData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeatMapDataCopyWith<_SeatMapData> get copyWith => __$SeatMapDataCopyWithImpl<_SeatMapData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeatMapData&&(identical(other.showtimeId, showtimeId) || other.showtimeId == showtimeId)&&(identical(other.movieTitle, movieTitle) || other.movieTitle == movieTitle)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.showDate, showDate) || other.showDate == showDate)&&(identical(other.showTime, showTime) || other.showTime == showTime)&&const DeepCollectionEquality().equals(other.seats, _seats)&&const DeepCollectionEquality().equals(other.heldByOthers, _heldByOthers)&&(identical(other.holdMinutes, holdMinutes) || other.holdMinutes == holdMinutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,showtimeId,movieTitle,hallName,showDate,showTime,const DeepCollectionEquality().hash(_seats),const DeepCollectionEquality().hash(_heldByOthers),holdMinutes);
}

@override
String toString() {
    return 'SeatMapData(showtimeId: $showtimeId, movieTitle: $movieTitle, hallName: $hallName, showDate: $showDate, showTime: $showTime, seats: $seats, heldByOthers: $heldByOthers, holdMinutes: $holdMinutes)';
}


}

/// @nodoc
abstract mixin class _$SeatMapDataCopyWith<$Res> implements $SeatMapDataCopyWith<$Res> {
  factory _$SeatMapDataCopyWith(_SeatMapData value, $Res Function(_SeatMapData) _then) = __$SeatMapDataCopyWithImpl;
@override @useResult
$Res call({
 int showtimeId, String movieTitle, String hallName, String? showDate, String? showTime, List<SeatView> seats, Set<int> heldByOthers, int holdMinutes
});




}
/// @nodoc
class __$SeatMapDataCopyWithImpl<$Res>
    implements _$SeatMapDataCopyWith<$Res> {
  __$SeatMapDataCopyWithImpl(this._self, this._then);

  final _SeatMapData _self;
  final $Res Function(_SeatMapData) _then;

/// Create a copy of SeatMapData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showtimeId = null,Object? movieTitle = null,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? seats = null,Object? heldByOthers = null,Object? holdMinutes = null,}) {
  return _then(_SeatMapData(
showtimeId: null == showtimeId ? _self.showtimeId : showtimeId // ignore: cast_nullable_to_non_nullable
as int,movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,seats: null == seats ? _self._seats : seats // ignore: cast_nullable_to_non_nullable
as List<SeatView>,heldByOthers: null == heldByOthers ? _self._heldByOthers : heldByOthers // ignore: cast_nullable_to_non_nullable
as Set<int>,holdMinutes: null == holdMinutes ? _self.holdMinutes : holdMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Hold {

 int get showtimeId; Set<int> get seatIds; DateTime get expiresAt;
/// Create a copy of Hold
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldCopyWith<Hold> get copyWith => _$HoldCopyWithImpl<Hold>(this as Hold, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Hold;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hold&&(identical(other.showtimeId, _this.showtimeId) || other.showtimeId == _this.showtimeId)&&const DeepCollectionEquality().equals(other.seatIds, _this.seatIds)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}


@override
int get hashCode {
  final _this = this as Hold;
  return Object.hash(runtimeType,_this.showtimeId,const DeepCollectionEquality().hash(_this.seatIds),_this.expiresAt);
}

@override
String toString() {
  final _this = this as Hold;
  return 'Hold(showtimeId: ${_this.showtimeId}, seatIds: ${_this.seatIds}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $HoldCopyWith<$Res>  {
  factory $HoldCopyWith(Hold value, $Res Function(Hold) _then) = _$HoldCopyWithImpl;
@useResult
$Res call({
 int showtimeId, Set<int> seatIds, DateTime expiresAt
});




}
/// @nodoc
class _$HoldCopyWithImpl<$Res>
    implements $HoldCopyWith<$Res> {
  _$HoldCopyWithImpl(this._self, this._then);

  final Hold _self;
  final $Res Function(Hold) _then;

/// Create a copy of Hold
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showtimeId = null,Object? seatIds = null,Object? expiresAt = null,}) {
  return _then(Hold(
showtimeId: null == showtimeId ? _self.showtimeId : showtimeId // ignore: cast_nullable_to_non_nullable
as int,seatIds: null == seatIds ? _self.seatIds : seatIds // ignore: cast_nullable_to_non_nullable
as Set<int>,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Hold].
extension HoldPatterns on Hold {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hold value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hold() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hold value)  $default,){
final _that = this;
switch (_that) {
case _Hold():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hold value)?  $default,){
final _that = this;
switch (_that) {
case _Hold() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int showtimeId,  Set<int> seatIds,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hold() when $default != null:
return $default(_that.showtimeId,_that.seatIds,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int showtimeId,  Set<int> seatIds,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Hold():
return $default(_that.showtimeId,_that.seatIds,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int showtimeId,  Set<int> seatIds,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Hold() when $default != null:
return $default(_that.showtimeId,_that.seatIds,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _Hold implements Hold {
  const _Hold({required this.showtimeId, required  Set<int> seatIds, required this.expiresAt}): _seatIds = seatIds;
  

@override final  int showtimeId;
 final  Set<int> _seatIds;
@override Set<int> get seatIds {
  if (_seatIds is EqualUnmodifiableSetView) return _seatIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_seatIds);
}

@override final  DateTime expiresAt;

/// Create a copy of Hold
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldCopyWith<_Hold> get copyWith => __$HoldCopyWithImpl<_Hold>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hold&&(identical(other.showtimeId, showtimeId) || other.showtimeId == showtimeId)&&const DeepCollectionEquality().equals(other.seatIds, _seatIds)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,showtimeId,const DeepCollectionEquality().hash(_seatIds),expiresAt);
}

@override
String toString() {
    return 'Hold(showtimeId: $showtimeId, seatIds: $seatIds, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$HoldCopyWith<$Res> implements $HoldCopyWith<$Res> {
  factory _$HoldCopyWith(_Hold value, $Res Function(_Hold) _then) = __$HoldCopyWithImpl;
@override @useResult
$Res call({
 int showtimeId, Set<int> seatIds, DateTime expiresAt
});




}
/// @nodoc
class __$HoldCopyWithImpl<$Res>
    implements _$HoldCopyWith<$Res> {
  __$HoldCopyWithImpl(this._self, this._then);

  final _Hold _self;
  final $Res Function(_Hold) _then;

/// Create a copy of Hold
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showtimeId = null,Object? seatIds = null,Object? expiresAt = null,}) {
  return _then(_Hold(
showtimeId: null == showtimeId ? _self.showtimeId : showtimeId // ignore: cast_nullable_to_non_nullable
as int,seatIds: null == seatIds ? _self._seatIds : seatIds // ignore: cast_nullable_to_non_nullable
as Set<int>,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$SeatEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SeatEvent()';
}


}

/// @nodoc
class $SeatEventCopyWith<$Res>  {
$SeatEventCopyWith(SeatEvent _, $Res Function(SeatEvent) __);
}


/// Adds pattern-matching-related methods to [SeatEvent].
extension SeatEventPatterns on SeatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SeatChange value)?  change,TResult Function( SeatSnapshot value)?  snapshot,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SeatChange() when change != null:
return change(_that);case SeatSnapshot() when snapshot != null:
return snapshot(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SeatChange value)  change,required TResult Function( SeatSnapshot value)  snapshot,}){
final _that = this;
switch (_that) {
case SeatChange():
return change(_that);case SeatSnapshot():
return snapshot(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SeatChange value)?  change,TResult? Function( SeatSnapshot value)?  snapshot,}){
final _that = this;
switch (_that) {
case SeatChange() when change != null:
return change(_that);case SeatSnapshot() when snapshot != null:
return snapshot(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SeatEventType type,  Set<int> seatIds,  String? sessionId)?  change,TResult Function( Set<int> heldByOthers)?  snapshot,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SeatChange() when change != null:
return change(_that.type,_that.seatIds,_that.sessionId);case SeatSnapshot() when snapshot != null:
return snapshot(_that.heldByOthers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SeatEventType type,  Set<int> seatIds,  String? sessionId)  change,required TResult Function( Set<int> heldByOthers)  snapshot,}) {final _that = this;
switch (_that) {
case SeatChange():
return change(_that.type,_that.seatIds,_that.sessionId);case SeatSnapshot():
return snapshot(_that.heldByOthers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SeatEventType type,  Set<int> seatIds,  String? sessionId)?  change,TResult? Function( Set<int> heldByOthers)?  snapshot,}) {final _that = this;
switch (_that) {
case SeatChange() when change != null:
return change(_that.type,_that.seatIds,_that.sessionId);case SeatSnapshot() when snapshot != null:
return snapshot(_that.heldByOthers);case _:
  return null;

}
}

}

/// @nodoc


class SeatChange implements SeatEvent {
  const SeatChange({required this.type, required  Set<int> seatIds, this.sessionId}): _seatIds = seatIds;
  

 final  SeatEventType type;
 final  Set<int> _seatIds;
 Set<int> get seatIds {
  if (_seatIds is EqualUnmodifiableSetView) return _seatIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_seatIds);
}

 final  String? sessionId;

/// Create a copy of SeatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatChangeCopyWith<SeatChange> get copyWith => _$SeatChangeCopyWithImpl<SeatChange>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatChange&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.seatIds, _seatIds)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_seatIds),sessionId);
}

@override
String toString() {
    return 'SeatEvent.change(type: $type, seatIds: $seatIds, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $SeatChangeCopyWith<$Res> implements $SeatEventCopyWith<$Res> {
  factory $SeatChangeCopyWith(SeatChange value, $Res Function(SeatChange) _then) = _$SeatChangeCopyWithImpl;
@useResult
$Res call({
 SeatEventType type, Set<int> seatIds, String? sessionId
});




}
/// @nodoc
class _$SeatChangeCopyWithImpl<$Res>
    implements $SeatChangeCopyWith<$Res> {
  _$SeatChangeCopyWithImpl(this._self, this._then);

  final SeatChange _self;
  final $Res Function(SeatChange) _then;

/// Create a copy of SeatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seatIds = null,Object? sessionId = freezed,}) {
  return _then(SeatChange(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SeatEventType,seatIds: null == seatIds ? _self._seatIds : seatIds // ignore: cast_nullable_to_non_nullable
as Set<int>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SeatSnapshot implements SeatEvent {
  const SeatSnapshot({required  Set<int> heldByOthers}): _heldByOthers = heldByOthers;
  

 final  Set<int> _heldByOthers;
 Set<int> get heldByOthers {
  if (_heldByOthers is EqualUnmodifiableSetView) return _heldByOthers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_heldByOthers);
}


/// Create a copy of SeatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatSnapshotCopyWith<SeatSnapshot> get copyWith => _$SeatSnapshotCopyWithImpl<SeatSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatSnapshot&&const DeepCollectionEquality().equals(other.heldByOthers, _heldByOthers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_heldByOthers));
}

@override
String toString() {
    return 'SeatEvent.snapshot(heldByOthers: $heldByOthers)';
}


}

/// @nodoc
abstract mixin class $SeatSnapshotCopyWith<$Res> implements $SeatEventCopyWith<$Res> {
  factory $SeatSnapshotCopyWith(SeatSnapshot value, $Res Function(SeatSnapshot) _then) = _$SeatSnapshotCopyWithImpl;
@useResult
$Res call({
 Set<int> heldByOthers
});




}
/// @nodoc
class _$SeatSnapshotCopyWithImpl<$Res>
    implements $SeatSnapshotCopyWith<$Res> {
  _$SeatSnapshotCopyWithImpl(this._self, this._then);

  final SeatSnapshot _self;
  final $Res Function(SeatSnapshot) _then;

/// Create a copy of SeatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? heldByOthers = null,}) {
  return _then(SeatSnapshot(
heldByOthers: null == heldByOthers ? _self._heldByOthers : heldByOthers // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on
