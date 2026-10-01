// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketPass {

 String get code; String get seatCode; String get status;
/// Create a copy of TicketPass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPassCopyWith<TicketPass> get copyWith => _$TicketPassCopyWithImpl<TicketPass>(this as TicketPass, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketPass;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPass&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.seatCode, _this.seatCode) || other.seatCode == _this.seatCode)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as TicketPass;
  return Object.hash(runtimeType,_this.code,_this.seatCode,_this.status);
}

@override
String toString() {
  final _this = this as TicketPass;
  return 'TicketPass(code: ${_this.code}, seatCode: ${_this.seatCode}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $TicketPassCopyWith<$Res>  {
  factory $TicketPassCopyWith(TicketPass value, $Res Function(TicketPass) _then) = _$TicketPassCopyWithImpl;
@useResult
$Res call({
 String code, String seatCode, String status
});




}
/// @nodoc
class _$TicketPassCopyWithImpl<$Res>
    implements $TicketPassCopyWith<$Res> {
  _$TicketPassCopyWithImpl(this._self, this._then);

  final TicketPass _self;
  final $Res Function(TicketPass) _then;

/// Create a copy of TicketPass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? seatCode = null,Object? status = null,}) {
  return _then(TicketPass(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,seatCode: null == seatCode ? _self.seatCode : seatCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketPass].
extension TicketPassPatterns on TicketPass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketPass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketPass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketPass value)  $default,){
final _that = this;
switch (_that) {
case _TicketPass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketPass value)?  $default,){
final _that = this;
switch (_that) {
case _TicketPass() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String seatCode,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketPass() when $default != null:
return $default(_that.code,_that.seatCode,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String seatCode,  String status)  $default,) {final _that = this;
switch (_that) {
case _TicketPass():
return $default(_that.code,_that.seatCode,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String seatCode,  String status)?  $default,) {final _that = this;
switch (_that) {
case _TicketPass() when $default != null:
return $default(_that.code,_that.seatCode,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _TicketPass extends TicketPass {
  const _TicketPass({required this.code, required this.seatCode, required this.status}): super._();
  

@override final  String code;
@override final  String seatCode;
@override final  String status;

/// Create a copy of TicketPass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketPassCopyWith<_TicketPass> get copyWith => __$TicketPassCopyWithImpl<_TicketPass>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketPass&&(identical(other.code, code) || other.code == code)&&(identical(other.seatCode, seatCode) || other.seatCode == seatCode)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,seatCode,status);
}

@override
String toString() {
    return 'TicketPass(code: $code, seatCode: $seatCode, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TicketPassCopyWith<$Res> implements $TicketPassCopyWith<$Res> {
  factory _$TicketPassCopyWith(_TicketPass value, $Res Function(_TicketPass) _then) = __$TicketPassCopyWithImpl;
@override @useResult
$Res call({
 String code, String seatCode, String status
});




}
/// @nodoc
class __$TicketPassCopyWithImpl<$Res>
    implements _$TicketPassCopyWith<$Res> {
  __$TicketPassCopyWithImpl(this._self, this._then);

  final _TicketPass _self;
  final $Res Function(_TicketPass) _then;

/// Create a copy of TicketPass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? seatCode = null,Object? status = null,}) {
  return _then(_TicketPass(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,seatCode: null == seatCode ? _self.seatCode : seatCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookingSummary {

 int get bookingId; BookingStatus get status; String get movieTitle; String get hallName;/// ISO date and `HH:mm[:ss]` in the cinema's zone; never converted.
 String? get showDate; String? get showTime; num get totalAmount; List<TicketPass> get tickets; String? get bookedAt;
/// Create a copy of BookingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingSummaryCopyWith<BookingSummary> get copyWith => _$BookingSummaryCopyWithImpl<BookingSummary>(this as BookingSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSummary&&(identical(other.bookingId, _this.bookingId) || other.bookingId == _this.bookingId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.movieTitle, _this.movieTitle) || other.movieTitle == _this.movieTitle)&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.showDate, _this.showDate) || other.showDate == _this.showDate)&&(identical(other.showTime, _this.showTime) || other.showTime == _this.showTime)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&const DeepCollectionEquality().equals(other.tickets, _this.tickets)&&(identical(other.bookedAt, _this.bookedAt) || other.bookedAt == _this.bookedAt));
}


@override
int get hashCode {
  final _this = this as BookingSummary;
  return Object.hash(runtimeType,_this.bookingId,_this.status,_this.movieTitle,_this.hallName,_this.showDate,_this.showTime,_this.totalAmount,const DeepCollectionEquality().hash(_this.tickets),_this.bookedAt);
}

@override
String toString() {
  final _this = this as BookingSummary;
  return 'BookingSummary(bookingId: ${_this.bookingId}, status: ${_this.status}, movieTitle: ${_this.movieTitle}, hallName: ${_this.hallName}, showDate: ${_this.showDate}, showTime: ${_this.showTime}, totalAmount: ${_this.totalAmount}, tickets: ${_this.tickets}, bookedAt: ${_this.bookedAt})';
}


}

/// @nodoc
abstract mixin class $BookingSummaryCopyWith<$Res>  {
  factory $BookingSummaryCopyWith(BookingSummary value, $Res Function(BookingSummary) _then) = _$BookingSummaryCopyWithImpl;
@useResult
$Res call({
 int bookingId, BookingStatus status, String movieTitle, String hallName, String? showDate, String? showTime, num totalAmount, List<TicketPass> tickets, String? bookedAt
});




}
/// @nodoc
class _$BookingSummaryCopyWithImpl<$Res>
    implements $BookingSummaryCopyWith<$Res> {
  _$BookingSummaryCopyWithImpl(this._self, this._then);

  final BookingSummary _self;
  final $Res Function(BookingSummary) _then;

/// Create a copy of BookingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingId = null,Object? status = null,Object? movieTitle = null,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? totalAmount = null,Object? tickets = null,Object? bookedAt = freezed,}) {
  return _then(BookingSummary(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num,tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<TicketPass>,bookedAt: freezed == bookedAt ? _self.bookedAt : bookedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingSummary].
extension BookingSummaryPatterns on BookingSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingSummary value)  $default,){
final _that = this;
switch (_that) {
case _BookingSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BookingSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bookingId,  BookingStatus status,  String movieTitle,  String hallName,  String? showDate,  String? showTime,  num totalAmount,  List<TicketPass> tickets,  String? bookedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingSummary() when $default != null:
return $default(_that.bookingId,_that.status,_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.totalAmount,_that.tickets,_that.bookedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bookingId,  BookingStatus status,  String movieTitle,  String hallName,  String? showDate,  String? showTime,  num totalAmount,  List<TicketPass> tickets,  String? bookedAt)  $default,) {final _that = this;
switch (_that) {
case _BookingSummary():
return $default(_that.bookingId,_that.status,_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.totalAmount,_that.tickets,_that.bookedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bookingId,  BookingStatus status,  String movieTitle,  String hallName,  String? showDate,  String? showTime,  num totalAmount,  List<TicketPass> tickets,  String? bookedAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingSummary() when $default != null:
return $default(_that.bookingId,_that.status,_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.totalAmount,_that.tickets,_that.bookedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BookingSummary extends BookingSummary {
  const _BookingSummary({required this.bookingId, required this.status, required this.movieTitle, required this.hallName, this.showDate, this.showTime, required this.totalAmount, required  List<TicketPass> tickets, this.bookedAt}): _tickets = tickets,super._();
  

@override final  int bookingId;
@override final  BookingStatus status;
@override final  String movieTitle;
@override final  String hallName;
/// ISO date and `HH:mm[:ss]` in the cinema's zone; never converted.
@override final  String? showDate;
@override final  String? showTime;
@override final  num totalAmount;
 final  List<TicketPass> _tickets;
@override List<TicketPass> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}

@override final  String? bookedAt;

/// Create a copy of BookingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingSummaryCopyWith<_BookingSummary> get copyWith => __$BookingSummaryCopyWithImpl<_BookingSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingSummary&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.status, status) || other.status == status)&&(identical(other.movieTitle, movieTitle) || other.movieTitle == movieTitle)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.showDate, showDate) || other.showDate == showDate)&&(identical(other.showTime, showTime) || other.showTime == showTime)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.tickets, _tickets)&&(identical(other.bookedAt, bookedAt) || other.bookedAt == bookedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bookingId,status,movieTitle,hallName,showDate,showTime,totalAmount,const DeepCollectionEquality().hash(_tickets),bookedAt);
}

@override
String toString() {
    return 'BookingSummary(bookingId: $bookingId, status: $status, movieTitle: $movieTitle, hallName: $hallName, showDate: $showDate, showTime: $showTime, totalAmount: $totalAmount, tickets: $tickets, bookedAt: $bookedAt)';
}


}

/// @nodoc
abstract mixin class _$BookingSummaryCopyWith<$Res> implements $BookingSummaryCopyWith<$Res> {
  factory _$BookingSummaryCopyWith(_BookingSummary value, $Res Function(_BookingSummary) _then) = __$BookingSummaryCopyWithImpl;
@override @useResult
$Res call({
 int bookingId, BookingStatus status, String movieTitle, String hallName, String? showDate, String? showTime, num totalAmount, List<TicketPass> tickets, String? bookedAt
});




}
/// @nodoc
class __$BookingSummaryCopyWithImpl<$Res>
    implements _$BookingSummaryCopyWith<$Res> {
  __$BookingSummaryCopyWithImpl(this._self, this._then);

  final _BookingSummary _self;
  final $Res Function(_BookingSummary) _then;

/// Create a copy of BookingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? status = null,Object? movieTitle = null,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? totalAmount = null,Object? tickets = null,Object? bookedAt = freezed,}) {
  return _then(_BookingSummary(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<TicketPass>,bookedAt: freezed == bookedAt ? _self.bookedAt : bookedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
