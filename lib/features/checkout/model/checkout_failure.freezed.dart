// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckoutFailure()';
}


}

/// @nodoc
class $CheckoutFailureCopyWith<$Res>  {
$CheckoutFailureCopyWith(CheckoutFailure _, $Res Function(CheckoutFailure) __);
}


/// Adds pattern-matching-related methods to [CheckoutFailure].
extension CheckoutFailurePatterns on CheckoutFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckoutHoldExpired value)?  holdExpired,TResult Function( CheckoutSeatConflict value)?  seatConflict,TResult Function( CheckoutPromoInvalid value)?  promoInvalid,TResult Function( CheckoutPairInvalid value)?  pairInvalid,TResult Function( CheckoutPaymentFailed value)?  paymentFailed,TResult Function( CheckoutBlocked value)?  blocked,TResult Function( CheckoutSeatLimit value)?  seatLimit,TResult Function( CheckoutBookingNotFound value)?  bookingNotFound,TResult Function( CheckoutNetwork value)?  network,TResult Function( CheckoutUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckoutHoldExpired() when holdExpired != null:
return holdExpired(_that);case CheckoutSeatConflict() when seatConflict != null:
return seatConflict(_that);case CheckoutPromoInvalid() when promoInvalid != null:
return promoInvalid(_that);case CheckoutPairInvalid() when pairInvalid != null:
return pairInvalid(_that);case CheckoutPaymentFailed() when paymentFailed != null:
return paymentFailed(_that);case CheckoutBlocked() when blocked != null:
return blocked(_that);case CheckoutSeatLimit() when seatLimit != null:
return seatLimit(_that);case CheckoutBookingNotFound() when bookingNotFound != null:
return bookingNotFound(_that);case CheckoutNetwork() when network != null:
return network(_that);case CheckoutUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckoutHoldExpired value)  holdExpired,required TResult Function( CheckoutSeatConflict value)  seatConflict,required TResult Function( CheckoutPromoInvalid value)  promoInvalid,required TResult Function( CheckoutPairInvalid value)  pairInvalid,required TResult Function( CheckoutPaymentFailed value)  paymentFailed,required TResult Function( CheckoutBlocked value)  blocked,required TResult Function( CheckoutSeatLimit value)  seatLimit,required TResult Function( CheckoutBookingNotFound value)  bookingNotFound,required TResult Function( CheckoutNetwork value)  network,required TResult Function( CheckoutUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case CheckoutHoldExpired():
return holdExpired(_that);case CheckoutSeatConflict():
return seatConflict(_that);case CheckoutPromoInvalid():
return promoInvalid(_that);case CheckoutPairInvalid():
return pairInvalid(_that);case CheckoutPaymentFailed():
return paymentFailed(_that);case CheckoutBlocked():
return blocked(_that);case CheckoutSeatLimit():
return seatLimit(_that);case CheckoutBookingNotFound():
return bookingNotFound(_that);case CheckoutNetwork():
return network(_that);case CheckoutUnknown():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckoutHoldExpired value)?  holdExpired,TResult? Function( CheckoutSeatConflict value)?  seatConflict,TResult? Function( CheckoutPromoInvalid value)?  promoInvalid,TResult? Function( CheckoutPairInvalid value)?  pairInvalid,TResult? Function( CheckoutPaymentFailed value)?  paymentFailed,TResult? Function( CheckoutBlocked value)?  blocked,TResult? Function( CheckoutSeatLimit value)?  seatLimit,TResult? Function( CheckoutBookingNotFound value)?  bookingNotFound,TResult? Function( CheckoutNetwork value)?  network,TResult? Function( CheckoutUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case CheckoutHoldExpired() when holdExpired != null:
return holdExpired(_that);case CheckoutSeatConflict() when seatConflict != null:
return seatConflict(_that);case CheckoutPromoInvalid() when promoInvalid != null:
return promoInvalid(_that);case CheckoutPairInvalid() when pairInvalid != null:
return pairInvalid(_that);case CheckoutPaymentFailed() when paymentFailed != null:
return paymentFailed(_that);case CheckoutBlocked() when blocked != null:
return blocked(_that);case CheckoutSeatLimit() when seatLimit != null:
return seatLimit(_that);case CheckoutBookingNotFound() when bookingNotFound != null:
return bookingNotFound(_that);case CheckoutNetwork() when network != null:
return network(_that);case CheckoutUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  holdExpired,TResult Function( String message)?  seatConflict,TResult Function( String message)?  promoInvalid,TResult Function()?  pairInvalid,TResult Function( String message)?  paymentFailed,TResult Function( String message)?  blocked,TResult Function( String message)?  seatLimit,TResult Function( String message)?  bookingNotFound,TResult Function()?  network,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckoutHoldExpired() when holdExpired != null:
return holdExpired();case CheckoutSeatConflict() when seatConflict != null:
return seatConflict(_that.message);case CheckoutPromoInvalid() when promoInvalid != null:
return promoInvalid(_that.message);case CheckoutPairInvalid() when pairInvalid != null:
return pairInvalid();case CheckoutPaymentFailed() when paymentFailed != null:
return paymentFailed(_that.message);case CheckoutBlocked() when blocked != null:
return blocked(_that.message);case CheckoutSeatLimit() when seatLimit != null:
return seatLimit(_that.message);case CheckoutBookingNotFound() when bookingNotFound != null:
return bookingNotFound(_that.message);case CheckoutNetwork() when network != null:
return network();case CheckoutUnknown() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  holdExpired,required TResult Function( String message)  seatConflict,required TResult Function( String message)  promoInvalid,required TResult Function()  pairInvalid,required TResult Function( String message)  paymentFailed,required TResult Function( String message)  blocked,required TResult Function( String message)  seatLimit,required TResult Function( String message)  bookingNotFound,required TResult Function()  network,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case CheckoutHoldExpired():
return holdExpired();case CheckoutSeatConflict():
return seatConflict(_that.message);case CheckoutPromoInvalid():
return promoInvalid(_that.message);case CheckoutPairInvalid():
return pairInvalid();case CheckoutPaymentFailed():
return paymentFailed(_that.message);case CheckoutBlocked():
return blocked(_that.message);case CheckoutSeatLimit():
return seatLimit(_that.message);case CheckoutBookingNotFound():
return bookingNotFound(_that.message);case CheckoutNetwork():
return network();case CheckoutUnknown():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  holdExpired,TResult? Function( String message)?  seatConflict,TResult? Function( String message)?  promoInvalid,TResult? Function()?  pairInvalid,TResult? Function( String message)?  paymentFailed,TResult? Function( String message)?  blocked,TResult? Function( String message)?  seatLimit,TResult? Function( String message)?  bookingNotFound,TResult? Function()?  network,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case CheckoutHoldExpired() when holdExpired != null:
return holdExpired();case CheckoutSeatConflict() when seatConflict != null:
return seatConflict(_that.message);case CheckoutPromoInvalid() when promoInvalid != null:
return promoInvalid(_that.message);case CheckoutPairInvalid() when pairInvalid != null:
return pairInvalid();case CheckoutPaymentFailed() when paymentFailed != null:
return paymentFailed(_that.message);case CheckoutBlocked() when blocked != null:
return blocked(_that.message);case CheckoutSeatLimit() when seatLimit != null:
return seatLimit(_that.message);case CheckoutBookingNotFound() when bookingNotFound != null:
return bookingNotFound(_that.message);case CheckoutNetwork() when network != null:
return network();case CheckoutUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CheckoutHoldExpired implements CheckoutFailure {
  const CheckoutHoldExpired();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutHoldExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckoutFailure.holdExpired()';
}


}




/// @nodoc


class CheckoutSeatConflict implements CheckoutFailure {
  const CheckoutSeatConflict(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSeatConflictCopyWith<CheckoutSeatConflict> get copyWith => _$CheckoutSeatConflictCopyWithImpl<CheckoutSeatConflict>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSeatConflict&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.seatConflict(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutSeatConflictCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutSeatConflictCopyWith(CheckoutSeatConflict value, $Res Function(CheckoutSeatConflict) _then) = _$CheckoutSeatConflictCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutSeatConflictCopyWithImpl<$Res>
    implements $CheckoutSeatConflictCopyWith<$Res> {
  _$CheckoutSeatConflictCopyWithImpl(this._self, this._then);

  final CheckoutSeatConflict _self;
  final $Res Function(CheckoutSeatConflict) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutSeatConflict(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckoutPromoInvalid implements CheckoutFailure {
  const CheckoutPromoInvalid(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutPromoInvalidCopyWith<CheckoutPromoInvalid> get copyWith => _$CheckoutPromoInvalidCopyWithImpl<CheckoutPromoInvalid>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutPromoInvalid&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.promoInvalid(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutPromoInvalidCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutPromoInvalidCopyWith(CheckoutPromoInvalid value, $Res Function(CheckoutPromoInvalid) _then) = _$CheckoutPromoInvalidCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutPromoInvalidCopyWithImpl<$Res>
    implements $CheckoutPromoInvalidCopyWith<$Res> {
  _$CheckoutPromoInvalidCopyWithImpl(this._self, this._then);

  final CheckoutPromoInvalid _self;
  final $Res Function(CheckoutPromoInvalid) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutPromoInvalid(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckoutPairInvalid implements CheckoutFailure {
  const CheckoutPairInvalid();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutPairInvalid);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckoutFailure.pairInvalid()';
}


}




/// @nodoc


class CheckoutPaymentFailed implements CheckoutFailure {
  const CheckoutPaymentFailed(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutPaymentFailedCopyWith<CheckoutPaymentFailed> get copyWith => _$CheckoutPaymentFailedCopyWithImpl<CheckoutPaymentFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutPaymentFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.paymentFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutPaymentFailedCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutPaymentFailedCopyWith(CheckoutPaymentFailed value, $Res Function(CheckoutPaymentFailed) _then) = _$CheckoutPaymentFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutPaymentFailedCopyWithImpl<$Res>
    implements $CheckoutPaymentFailedCopyWith<$Res> {
  _$CheckoutPaymentFailedCopyWithImpl(this._self, this._then);

  final CheckoutPaymentFailed _self;
  final $Res Function(CheckoutPaymentFailed) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutPaymentFailed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckoutBlocked implements CheckoutFailure {
  const CheckoutBlocked(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutBlockedCopyWith<CheckoutBlocked> get copyWith => _$CheckoutBlockedCopyWithImpl<CheckoutBlocked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutBlocked&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.blocked(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutBlockedCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutBlockedCopyWith(CheckoutBlocked value, $Res Function(CheckoutBlocked) _then) = _$CheckoutBlockedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutBlockedCopyWithImpl<$Res>
    implements $CheckoutBlockedCopyWith<$Res> {
  _$CheckoutBlockedCopyWithImpl(this._self, this._then);

  final CheckoutBlocked _self;
  final $Res Function(CheckoutBlocked) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutBlocked(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckoutSeatLimit implements CheckoutFailure {
  const CheckoutSeatLimit(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSeatLimitCopyWith<CheckoutSeatLimit> get copyWith => _$CheckoutSeatLimitCopyWithImpl<CheckoutSeatLimit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSeatLimit&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.seatLimit(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutSeatLimitCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutSeatLimitCopyWith(CheckoutSeatLimit value, $Res Function(CheckoutSeatLimit) _then) = _$CheckoutSeatLimitCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutSeatLimitCopyWithImpl<$Res>
    implements $CheckoutSeatLimitCopyWith<$Res> {
  _$CheckoutSeatLimitCopyWithImpl(this._self, this._then);

  final CheckoutSeatLimit _self;
  final $Res Function(CheckoutSeatLimit) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutSeatLimit(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckoutBookingNotFound implements CheckoutFailure {
  const CheckoutBookingNotFound(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutBookingNotFoundCopyWith<CheckoutBookingNotFound> get copyWith => _$CheckoutBookingNotFoundCopyWithImpl<CheckoutBookingNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutBookingNotFound&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.bookingNotFound(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutBookingNotFoundCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutBookingNotFoundCopyWith(CheckoutBookingNotFound value, $Res Function(CheckoutBookingNotFound) _then) = _$CheckoutBookingNotFoundCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutBookingNotFoundCopyWithImpl<$Res>
    implements $CheckoutBookingNotFoundCopyWith<$Res> {
  _$CheckoutBookingNotFoundCopyWithImpl(this._self, this._then);

  final CheckoutBookingNotFound _self;
  final $Res Function(CheckoutBookingNotFound) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutBookingNotFound(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckoutNetwork implements CheckoutFailure {
  const CheckoutNetwork();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckoutFailure.network()';
}


}




/// @nodoc


class CheckoutUnknown implements CheckoutFailure {
  const CheckoutUnknown(this.message);
  

 final  String message;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutUnknownCopyWith<CheckoutUnknown> get copyWith => _$CheckoutUnknownCopyWithImpl<CheckoutUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckoutFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutUnknownCopyWith<$Res> implements $CheckoutFailureCopyWith<$Res> {
  factory $CheckoutUnknownCopyWith(CheckoutUnknown value, $Res Function(CheckoutUnknown) _then) = _$CheckoutUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckoutUnknownCopyWithImpl<$Res>
    implements $CheckoutUnknownCopyWith<$Res> {
  _$CheckoutUnknownCopyWithImpl(this._self, this._then);

  final CheckoutUnknown _self;
  final $Res Function(CheckoutUnknown) _then;

/// Create a copy of CheckoutFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckoutUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
