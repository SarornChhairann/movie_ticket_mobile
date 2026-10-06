// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_flow_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingFlowState {

 FlowStep get step; bool get snacksSkipped; int? get showtimeId; String get title; String? get posterUrl; String get hallName; String? get showDate; String? get showTime; List<String> get seatCodes; int get foodCount;/// The server's total, once a quote has come back; never computed here.
 num? get totalAmount;/// When the hold ends; null while nothing is held.
 DateTime? get holdExpiresAt;
/// Create a copy of BookingFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingFlowStateCopyWith<BookingFlowState> get copyWith => _$BookingFlowStateCopyWithImpl<BookingFlowState>(this as BookingFlowState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingFlowState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingFlowState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.snacksSkipped, _this.snacksSkipped) || other.snacksSkipped == _this.snacksSkipped)&&(identical(other.showtimeId, _this.showtimeId) || other.showtimeId == _this.showtimeId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.posterUrl, _this.posterUrl) || other.posterUrl == _this.posterUrl)&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.showDate, _this.showDate) || other.showDate == _this.showDate)&&(identical(other.showTime, _this.showTime) || other.showTime == _this.showTime)&&const DeepCollectionEquality().equals(other.seatCodes, _this.seatCodes)&&(identical(other.foodCount, _this.foodCount) || other.foodCount == _this.foodCount)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.holdExpiresAt, _this.holdExpiresAt) || other.holdExpiresAt == _this.holdExpiresAt));
}


@override
int get hashCode {
  final _this = this as BookingFlowState;
  return Object.hash(runtimeType,_this.step,_this.snacksSkipped,_this.showtimeId,_this.title,_this.posterUrl,_this.hallName,_this.showDate,_this.showTime,const DeepCollectionEquality().hash(_this.seatCodes),_this.foodCount,_this.totalAmount,_this.holdExpiresAt);
}

@override
String toString() {
  final _this = this as BookingFlowState;
  return 'BookingFlowState(step: ${_this.step}, snacksSkipped: ${_this.snacksSkipped}, showtimeId: ${_this.showtimeId}, title: ${_this.title}, posterUrl: ${_this.posterUrl}, hallName: ${_this.hallName}, showDate: ${_this.showDate}, showTime: ${_this.showTime}, seatCodes: ${_this.seatCodes}, foodCount: ${_this.foodCount}, totalAmount: ${_this.totalAmount}, holdExpiresAt: ${_this.holdExpiresAt})';
}


}

/// @nodoc
abstract mixin class $BookingFlowStateCopyWith<$Res>  {
  factory $BookingFlowStateCopyWith(BookingFlowState value, $Res Function(BookingFlowState) _then) = _$BookingFlowStateCopyWithImpl;
@useResult
$Res call({
 FlowStep step, bool snacksSkipped, int? showtimeId, String title, String? posterUrl, String hallName, String? showDate, String? showTime, List<String> seatCodes, int foodCount, num? totalAmount, DateTime? holdExpiresAt
});




}
/// @nodoc
class _$BookingFlowStateCopyWithImpl<$Res>
    implements $BookingFlowStateCopyWith<$Res> {
  _$BookingFlowStateCopyWithImpl(this._self, this._then);

  final BookingFlowState _self;
  final $Res Function(BookingFlowState) _then;

/// Create a copy of BookingFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? snacksSkipped = null,Object? showtimeId = freezed,Object? title = null,Object? posterUrl = freezed,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? seatCodes = null,Object? foodCount = null,Object? totalAmount = freezed,Object? holdExpiresAt = freezed,}) {
  return _then(BookingFlowState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as FlowStep,snacksSkipped: null == snacksSkipped ? _self.snacksSkipped : snacksSkipped // ignore: cast_nullable_to_non_nullable
as bool,showtimeId: freezed == showtimeId ? _self.showtimeId : showtimeId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,seatCodes: null == seatCodes ? _self.seatCodes : seatCodes // ignore: cast_nullable_to_non_nullable
as List<String>,foodCount: null == foodCount ? _self.foodCount : foodCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num?,holdExpiresAt: freezed == holdExpiresAt ? _self.holdExpiresAt : holdExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingFlowState].
extension BookingFlowStatePatterns on BookingFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingFlowState value)  $default,){
final _that = this;
switch (_that) {
case _BookingFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowStep step,  bool snacksSkipped,  int? showtimeId,  String title,  String? posterUrl,  String hallName,  String? showDate,  String? showTime,  List<String> seatCodes,  int foodCount,  num? totalAmount,  DateTime? holdExpiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingFlowState() when $default != null:
return $default(_that.step,_that.snacksSkipped,_that.showtimeId,_that.title,_that.posterUrl,_that.hallName,_that.showDate,_that.showTime,_that.seatCodes,_that.foodCount,_that.totalAmount,_that.holdExpiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowStep step,  bool snacksSkipped,  int? showtimeId,  String title,  String? posterUrl,  String hallName,  String? showDate,  String? showTime,  List<String> seatCodes,  int foodCount,  num? totalAmount,  DateTime? holdExpiresAt)  $default,) {final _that = this;
switch (_that) {
case _BookingFlowState():
return $default(_that.step,_that.snacksSkipped,_that.showtimeId,_that.title,_that.posterUrl,_that.hallName,_that.showDate,_that.showTime,_that.seatCodes,_that.foodCount,_that.totalAmount,_that.holdExpiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowStep step,  bool snacksSkipped,  int? showtimeId,  String title,  String? posterUrl,  String hallName,  String? showDate,  String? showTime,  List<String> seatCodes,  int foodCount,  num? totalAmount,  DateTime? holdExpiresAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingFlowState() when $default != null:
return $default(_that.step,_that.snacksSkipped,_that.showtimeId,_that.title,_that.posterUrl,_that.hallName,_that.showDate,_that.showTime,_that.seatCodes,_that.foodCount,_that.totalAmount,_that.holdExpiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _BookingFlowState implements BookingFlowState {
  const _BookingFlowState({this.step = FlowStep.seats, this.snacksSkipped = false, this.showtimeId, this.title = '', this.posterUrl, this.hallName = '', this.showDate, this.showTime,  List<String> seatCodes = const <String>[], this.foodCount = 0, this.totalAmount, this.holdExpiresAt}): _seatCodes = seatCodes;
  

@override@JsonKey() final  FlowStep step;
@override@JsonKey() final  bool snacksSkipped;
@override final  int? showtimeId;
@override@JsonKey() final  String title;
@override final  String? posterUrl;
@override@JsonKey() final  String hallName;
@override final  String? showDate;
@override final  String? showTime;
 final  List<String> _seatCodes;
@override@JsonKey() List<String> get seatCodes {
  if (_seatCodes is EqualUnmodifiableListView) return _seatCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seatCodes);
}

@override@JsonKey() final  int foodCount;
/// The server's total, once a quote has come back; never computed here.
@override final  num? totalAmount;
/// When the hold ends; null while nothing is held.
@override final  DateTime? holdExpiresAt;

/// Create a copy of BookingFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingFlowStateCopyWith<_BookingFlowState> get copyWith => __$BookingFlowStateCopyWithImpl<_BookingFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingFlowState&&(identical(other.step, step) || other.step == step)&&(identical(other.snacksSkipped, snacksSkipped) || other.snacksSkipped == snacksSkipped)&&(identical(other.showtimeId, showtimeId) || other.showtimeId == showtimeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.showDate, showDate) || other.showDate == showDate)&&(identical(other.showTime, showTime) || other.showTime == showTime)&&const DeepCollectionEquality().equals(other.seatCodes, _seatCodes)&&(identical(other.foodCount, foodCount) || other.foodCount == foodCount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.holdExpiresAt, holdExpiresAt) || other.holdExpiresAt == holdExpiresAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,snacksSkipped,showtimeId,title,posterUrl,hallName,showDate,showTime,const DeepCollectionEquality().hash(_seatCodes),foodCount,totalAmount,holdExpiresAt);
}

@override
String toString() {
    return 'BookingFlowState(step: $step, snacksSkipped: $snacksSkipped, showtimeId: $showtimeId, title: $title, posterUrl: $posterUrl, hallName: $hallName, showDate: $showDate, showTime: $showTime, seatCodes: $seatCodes, foodCount: $foodCount, totalAmount: $totalAmount, holdExpiresAt: $holdExpiresAt)';
}


}

/// @nodoc
abstract mixin class _$BookingFlowStateCopyWith<$Res> implements $BookingFlowStateCopyWith<$Res> {
  factory _$BookingFlowStateCopyWith(_BookingFlowState value, $Res Function(_BookingFlowState) _then) = __$BookingFlowStateCopyWithImpl;
@override @useResult
$Res call({
 FlowStep step, bool snacksSkipped, int? showtimeId, String title, String? posterUrl, String hallName, String? showDate, String? showTime, List<String> seatCodes, int foodCount, num? totalAmount, DateTime? holdExpiresAt
});




}
/// @nodoc
class __$BookingFlowStateCopyWithImpl<$Res>
    implements _$BookingFlowStateCopyWith<$Res> {
  __$BookingFlowStateCopyWithImpl(this._self, this._then);

  final _BookingFlowState _self;
  final $Res Function(_BookingFlowState) _then;

/// Create a copy of BookingFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? snacksSkipped = null,Object? showtimeId = freezed,Object? title = null,Object? posterUrl = freezed,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? seatCodes = null,Object? foodCount = null,Object? totalAmount = freezed,Object? holdExpiresAt = freezed,}) {
  return _then(_BookingFlowState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as FlowStep,snacksSkipped: null == snacksSkipped ? _self.snacksSkipped : snacksSkipped // ignore: cast_nullable_to_non_nullable
as bool,showtimeId: freezed == showtimeId ? _self.showtimeId : showtimeId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,seatCodes: null == seatCodes ? _self._seatCodes : seatCodes // ignore: cast_nullable_to_non_nullable
as List<String>,foodCount: null == foodCount ? _self.foodCount : foodCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num?,holdExpiresAt: freezed == holdExpiresAt ? _self.holdExpiresAt : holdExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
