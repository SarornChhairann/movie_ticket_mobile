// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payway.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaywaySession {

 int get bookingId;/// The booking reference; empty from a server older than sprint 13.
 String get reference; String get tranId; num get amount; String get checkoutUrl;/// `abapay_deeplink`; empty when PayWay sent none.
 String get abaDeeplink;
/// Create a copy of PaywaySession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywaySessionCopyWith<PaywaySession> get copyWith => _$PaywaySessionCopyWithImpl<PaywaySession>(this as PaywaySession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaywaySession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywaySession&&(identical(other.bookingId, _this.bookingId) || other.bookingId == _this.bookingId)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.tranId, _this.tranId) || other.tranId == _this.tranId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.checkoutUrl, _this.checkoutUrl) || other.checkoutUrl == _this.checkoutUrl)&&(identical(other.abaDeeplink, _this.abaDeeplink) || other.abaDeeplink == _this.abaDeeplink));
}


@override
int get hashCode {
  final _this = this as PaywaySession;
  return Object.hash(runtimeType,_this.bookingId,_this.reference,_this.tranId,_this.amount,_this.checkoutUrl,_this.abaDeeplink);
}

@override
String toString() {
  final _this = this as PaywaySession;
  return 'PaywaySession(bookingId: ${_this.bookingId}, reference: ${_this.reference}, tranId: ${_this.tranId}, amount: ${_this.amount}, checkoutUrl: ${_this.checkoutUrl}, abaDeeplink: ${_this.abaDeeplink})';
}


}

/// @nodoc
abstract mixin class $PaywaySessionCopyWith<$Res>  {
  factory $PaywaySessionCopyWith(PaywaySession value, $Res Function(PaywaySession) _then) = _$PaywaySessionCopyWithImpl;
@useResult
$Res call({
 int bookingId, String reference, String tranId, num amount, String checkoutUrl, String abaDeeplink
});




}
/// @nodoc
class _$PaywaySessionCopyWithImpl<$Res>
    implements $PaywaySessionCopyWith<$Res> {
  _$PaywaySessionCopyWithImpl(this._self, this._then);

  final PaywaySession _self;
  final $Res Function(PaywaySession) _then;

/// Create a copy of PaywaySession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingId = null,Object? reference = null,Object? tranId = null,Object? amount = null,Object? checkoutUrl = null,Object? abaDeeplink = null,}) {
  return _then(PaywaySession(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,tranId: null == tranId ? _self.tranId : tranId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,checkoutUrl: null == checkoutUrl ? _self.checkoutUrl : checkoutUrl // ignore: cast_nullable_to_non_nullable
as String,abaDeeplink: null == abaDeeplink ? _self.abaDeeplink : abaDeeplink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaywaySession].
extension PaywaySessionPatterns on PaywaySession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywaySession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywaySession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywaySession value)  $default,){
final _that = this;
switch (_that) {
case _PaywaySession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywaySession value)?  $default,){
final _that = this;
switch (_that) {
case _PaywaySession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bookingId,  String reference,  String tranId,  num amount,  String checkoutUrl,  String abaDeeplink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywaySession() when $default != null:
return $default(_that.bookingId,_that.reference,_that.tranId,_that.amount,_that.checkoutUrl,_that.abaDeeplink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bookingId,  String reference,  String tranId,  num amount,  String checkoutUrl,  String abaDeeplink)  $default,) {final _that = this;
switch (_that) {
case _PaywaySession():
return $default(_that.bookingId,_that.reference,_that.tranId,_that.amount,_that.checkoutUrl,_that.abaDeeplink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bookingId,  String reference,  String tranId,  num amount,  String checkoutUrl,  String abaDeeplink)?  $default,) {final _that = this;
switch (_that) {
case _PaywaySession() when $default != null:
return $default(_that.bookingId,_that.reference,_that.tranId,_that.amount,_that.checkoutUrl,_that.abaDeeplink);case _:
  return null;

}
}

}

/// @nodoc


class _PaywaySession implements PaywaySession {
  const _PaywaySession({required this.bookingId, this.reference = '', required this.tranId, required this.amount, required this.checkoutUrl, this.abaDeeplink = ''});
  

@override final  int bookingId;
/// The booking reference; empty from a server older than sprint 13.
@override@JsonKey() final  String reference;
@override final  String tranId;
@override final  num amount;
@override final  String checkoutUrl;
/// `abapay_deeplink`; empty when PayWay sent none.
@override@JsonKey() final  String abaDeeplink;

/// Create a copy of PaywaySession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywaySessionCopyWith<_PaywaySession> get copyWith => __$PaywaySessionCopyWithImpl<_PaywaySession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywaySession&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.tranId, tranId) || other.tranId == tranId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.checkoutUrl, checkoutUrl) || other.checkoutUrl == checkoutUrl)&&(identical(other.abaDeeplink, abaDeeplink) || other.abaDeeplink == abaDeeplink));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bookingId,reference,tranId,amount,checkoutUrl,abaDeeplink);
}

@override
String toString() {
    return 'PaywaySession(bookingId: $bookingId, reference: $reference, tranId: $tranId, amount: $amount, checkoutUrl: $checkoutUrl, abaDeeplink: $abaDeeplink)';
}


}

/// @nodoc
abstract mixin class _$PaywaySessionCopyWith<$Res> implements $PaywaySessionCopyWith<$Res> {
  factory _$PaywaySessionCopyWith(_PaywaySession value, $Res Function(_PaywaySession) _then) = __$PaywaySessionCopyWithImpl;
@override @useResult
$Res call({
 int bookingId, String reference, String tranId, num amount, String checkoutUrl, String abaDeeplink
});




}
/// @nodoc
class __$PaywaySessionCopyWithImpl<$Res>
    implements _$PaywaySessionCopyWith<$Res> {
  __$PaywaySessionCopyWithImpl(this._self, this._then);

  final _PaywaySession _self;
  final $Res Function(_PaywaySession) _then;

/// Create a copy of PaywaySession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? reference = null,Object? tranId = null,Object? amount = null,Object? checkoutUrl = null,Object? abaDeeplink = null,}) {
  return _then(_PaywaySession(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,tranId: null == tranId ? _self.tranId : tranId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,checkoutUrl: null == checkoutUrl ? _self.checkoutUrl : checkoutUrl // ignore: cast_nullable_to_non_nullable
as String,abaDeeplink: null == abaDeeplink ? _self.abaDeeplink : abaDeeplink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PaywayLaunch {

 PaywaySession get session; bool get canOpenAba; DateTime get holdExpiresAt;/// The guest's phone; null when signed in. Kept with the pending payment so a
/// paid guest booking can be found again by reference + phone.
 String? get guestPhone;
/// Create a copy of PaywayLaunch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywayLaunchCopyWith<PaywayLaunch> get copyWith => _$PaywayLaunchCopyWithImpl<PaywayLaunch>(this as PaywayLaunch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaywayLaunch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayLaunch&&(identical(other.session, _this.session) || other.session == _this.session)&&(identical(other.canOpenAba, _this.canOpenAba) || other.canOpenAba == _this.canOpenAba)&&(identical(other.holdExpiresAt, _this.holdExpiresAt) || other.holdExpiresAt == _this.holdExpiresAt)&&(identical(other.guestPhone, _this.guestPhone) || other.guestPhone == _this.guestPhone));
}


@override
int get hashCode {
  final _this = this as PaywayLaunch;
  return Object.hash(runtimeType,_this.session,_this.canOpenAba,_this.holdExpiresAt,_this.guestPhone);
}

@override
String toString() {
  final _this = this as PaywayLaunch;
  return 'PaywayLaunch(session: ${_this.session}, canOpenAba: ${_this.canOpenAba}, holdExpiresAt: ${_this.holdExpiresAt}, guestPhone: ${_this.guestPhone})';
}


}

/// @nodoc
abstract mixin class $PaywayLaunchCopyWith<$Res>  {
  factory $PaywayLaunchCopyWith(PaywayLaunch value, $Res Function(PaywayLaunch) _then) = _$PaywayLaunchCopyWithImpl;
@useResult
$Res call({
 PaywaySession session, bool canOpenAba, DateTime holdExpiresAt, String? guestPhone
});


$PaywaySessionCopyWith<$Res> get session;

}
/// @nodoc
class _$PaywayLaunchCopyWithImpl<$Res>
    implements $PaywayLaunchCopyWith<$Res> {
  _$PaywayLaunchCopyWithImpl(this._self, this._then);

  final PaywayLaunch _self;
  final $Res Function(PaywayLaunch) _then;

/// Create a copy of PaywayLaunch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? canOpenAba = null,Object? holdExpiresAt = null,Object? guestPhone = freezed,}) {
  return _then(PaywayLaunch(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PaywaySession,canOpenAba: null == canOpenAba ? _self.canOpenAba : canOpenAba // ignore: cast_nullable_to_non_nullable
as bool,holdExpiresAt: null == holdExpiresAt ? _self.holdExpiresAt : holdExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,guestPhone: freezed == guestPhone ? _self.guestPhone : guestPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PaywayLaunch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywaySessionCopyWith<$Res> get session {
  
  return $PaywaySessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaywayLaunch].
extension PaywayLaunchPatterns on PaywayLaunch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywayLaunch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywayLaunch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywayLaunch value)  $default,){
final _that = this;
switch (_that) {
case _PaywayLaunch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywayLaunch value)?  $default,){
final _that = this;
switch (_that) {
case _PaywayLaunch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaywaySession session,  bool canOpenAba,  DateTime holdExpiresAt,  String? guestPhone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywayLaunch() when $default != null:
return $default(_that.session,_that.canOpenAba,_that.holdExpiresAt,_that.guestPhone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaywaySession session,  bool canOpenAba,  DateTime holdExpiresAt,  String? guestPhone)  $default,) {final _that = this;
switch (_that) {
case _PaywayLaunch():
return $default(_that.session,_that.canOpenAba,_that.holdExpiresAt,_that.guestPhone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaywaySession session,  bool canOpenAba,  DateTime holdExpiresAt,  String? guestPhone)?  $default,) {final _that = this;
switch (_that) {
case _PaywayLaunch() when $default != null:
return $default(_that.session,_that.canOpenAba,_that.holdExpiresAt,_that.guestPhone);case _:
  return null;

}
}

}

/// @nodoc


class _PaywayLaunch implements PaywayLaunch {
  const _PaywayLaunch({required this.session, required this.canOpenAba, required this.holdExpiresAt, this.guestPhone});
  

@override final  PaywaySession session;
@override final  bool canOpenAba;
@override final  DateTime holdExpiresAt;
/// The guest's phone; null when signed in. Kept with the pending payment so a
/// paid guest booking can be found again by reference + phone.
@override final  String? guestPhone;

/// Create a copy of PaywayLaunch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywayLaunchCopyWith<_PaywayLaunch> get copyWith => __$PaywayLaunchCopyWithImpl<_PaywayLaunch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywayLaunch&&(identical(other.session, session) || other.session == session)&&(identical(other.canOpenAba, canOpenAba) || other.canOpenAba == canOpenAba)&&(identical(other.holdExpiresAt, holdExpiresAt) || other.holdExpiresAt == holdExpiresAt)&&(identical(other.guestPhone, guestPhone) || other.guestPhone == guestPhone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,session,canOpenAba,holdExpiresAt,guestPhone);
}

@override
String toString() {
    return 'PaywayLaunch(session: $session, canOpenAba: $canOpenAba, holdExpiresAt: $holdExpiresAt, guestPhone: $guestPhone)';
}


}

/// @nodoc
abstract mixin class _$PaywayLaunchCopyWith<$Res> implements $PaywayLaunchCopyWith<$Res> {
  factory _$PaywayLaunchCopyWith(_PaywayLaunch value, $Res Function(_PaywayLaunch) _then) = __$PaywayLaunchCopyWithImpl;
@override @useResult
$Res call({
 PaywaySession session, bool canOpenAba, DateTime holdExpiresAt, String? guestPhone
});


@override $PaywaySessionCopyWith<$Res> get session;

}
/// @nodoc
class __$PaywayLaunchCopyWithImpl<$Res>
    implements _$PaywayLaunchCopyWith<$Res> {
  __$PaywayLaunchCopyWithImpl(this._self, this._then);

  final _PaywayLaunch _self;
  final $Res Function(_PaywayLaunch) _then;

/// Create a copy of PaywayLaunch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? canOpenAba = null,Object? holdExpiresAt = null,Object? guestPhone = freezed,}) {
  return _then(_PaywayLaunch(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PaywaySession,canOpenAba: null == canOpenAba ? _self.canOpenAba : canOpenAba // ignore: cast_nullable_to_non_nullable
as bool,holdExpiresAt: null == holdExpiresAt ? _self.holdExpiresAt : holdExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,guestPhone: freezed == guestPhone ? _self.guestPhone : guestPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PaywayLaunch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywaySessionCopyWith<$Res> get session {
  
  return $PaywaySessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc
mixin _$PaywayStatus {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayStatus()';
}


}

/// @nodoc
class $PaywayStatusCopyWith<$Res>  {
$PaywayStatusCopyWith(PaywayStatus _, $Res Function(PaywayStatus) __);
}


/// Adds pattern-matching-related methods to [PaywayStatus].
extension PaywayStatusPatterns on PaywayStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaywayPending value)?  pending,TResult Function( PaywayApproved value)?  approved,TResult Function( PaywayDeclined value)?  declined,TResult Function( PaywayCancelled value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaywayPending() when pending != null:
return pending(_that);case PaywayApproved() when approved != null:
return approved(_that);case PaywayDeclined() when declined != null:
return declined(_that);case PaywayCancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaywayPending value)  pending,required TResult Function( PaywayApproved value)  approved,required TResult Function( PaywayDeclined value)  declined,required TResult Function( PaywayCancelled value)  cancelled,}){
final _that = this;
switch (_that) {
case PaywayPending():
return pending(_that);case PaywayApproved():
return approved(_that);case PaywayDeclined():
return declined(_that);case PaywayCancelled():
return cancelled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaywayPending value)?  pending,TResult? Function( PaywayApproved value)?  approved,TResult? Function( PaywayDeclined value)?  declined,TResult? Function( PaywayCancelled value)?  cancelled,}){
final _that = this;
switch (_that) {
case PaywayPending() when pending != null:
return pending(_that);case PaywayApproved() when approved != null:
return approved(_that);case PaywayDeclined() when declined != null:
return declined(_that);case PaywayCancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  pending,TResult Function( BookingSummary confirmation)?  approved,TResult Function()?  declined,TResult Function()?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaywayPending() when pending != null:
return pending();case PaywayApproved() when approved != null:
return approved(_that.confirmation);case PaywayDeclined() when declined != null:
return declined();case PaywayCancelled() when cancelled != null:
return cancelled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  pending,required TResult Function( BookingSummary confirmation)  approved,required TResult Function()  declined,required TResult Function()  cancelled,}) {final _that = this;
switch (_that) {
case PaywayPending():
return pending();case PaywayApproved():
return approved(_that.confirmation);case PaywayDeclined():
return declined();case PaywayCancelled():
return cancelled();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  pending,TResult? Function( BookingSummary confirmation)?  approved,TResult? Function()?  declined,TResult? Function()?  cancelled,}) {final _that = this;
switch (_that) {
case PaywayPending() when pending != null:
return pending();case PaywayApproved() when approved != null:
return approved(_that.confirmation);case PaywayDeclined() when declined != null:
return declined();case PaywayCancelled() when cancelled != null:
return cancelled();case _:
  return null;

}
}

}

/// @nodoc


class PaywayPending implements PaywayStatus {
  const PaywayPending();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayPending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayStatus.pending()';
}


}




/// @nodoc


class PaywayApproved implements PaywayStatus {
  const PaywayApproved(this.confirmation);
  

 final  BookingSummary confirmation;

/// Create a copy of PaywayStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywayApprovedCopyWith<PaywayApproved> get copyWith => _$PaywayApprovedCopyWithImpl<PaywayApproved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayApproved&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,confirmation);
}

@override
String toString() {
    return 'PaywayStatus.approved(confirmation: $confirmation)';
}


}

/// @nodoc
abstract mixin class $PaywayApprovedCopyWith<$Res> implements $PaywayStatusCopyWith<$Res> {
  factory $PaywayApprovedCopyWith(PaywayApproved value, $Res Function(PaywayApproved) _then) = _$PaywayApprovedCopyWithImpl;
@useResult
$Res call({
 BookingSummary confirmation
});


$BookingSummaryCopyWith<$Res> get confirmation;

}
/// @nodoc
class _$PaywayApprovedCopyWithImpl<$Res>
    implements $PaywayApprovedCopyWith<$Res> {
  _$PaywayApprovedCopyWithImpl(this._self, this._then);

  final PaywayApproved _self;
  final $Res Function(PaywayApproved) _then;

/// Create a copy of PaywayStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? confirmation = null,}) {
  return _then(PaywayApproved(
null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as BookingSummary,
  ));
}

/// Create a copy of PaywayStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSummaryCopyWith<$Res> get confirmation {
  
  return $BookingSummaryCopyWith<$Res>(_self.confirmation, (value) {
    return _then(_self.copyWith(confirmation: value));
  });
}
}

/// @nodoc


class PaywayDeclined implements PaywayStatus {
  const PaywayDeclined();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayDeclined);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayStatus.declined()';
}


}




/// @nodoc


class PaywayCancelled implements PaywayStatus {
  const PaywayCancelled();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayStatus.cancelled()';
}


}




/// @nodoc
mixin _$PaywayOutcome {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayOutcome()';
}


}

/// @nodoc
class $PaywayOutcomeCopyWith<$Res>  {
$PaywayOutcomeCopyWith(PaywayOutcome _, $Res Function(PaywayOutcome) __);
}


/// Adds pattern-matching-related methods to [PaywayOutcome].
extension PaywayOutcomePatterns on PaywayOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaywayOutcomeApproved value)?  approved,TResult Function( PaywayOutcomeDeclined value)?  declined,TResult Function( PaywayOutcomeCancelled value)?  cancelled,TResult Function( PaywayOutcomeDismissed value)?  dismissed,TResult Function( PaywayOutcomeHoldExpired value)?  holdExpired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaywayOutcomeApproved() when approved != null:
return approved(_that);case PaywayOutcomeDeclined() when declined != null:
return declined(_that);case PaywayOutcomeCancelled() when cancelled != null:
return cancelled(_that);case PaywayOutcomeDismissed() when dismissed != null:
return dismissed(_that);case PaywayOutcomeHoldExpired() when holdExpired != null:
return holdExpired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaywayOutcomeApproved value)  approved,required TResult Function( PaywayOutcomeDeclined value)  declined,required TResult Function( PaywayOutcomeCancelled value)  cancelled,required TResult Function( PaywayOutcomeDismissed value)  dismissed,required TResult Function( PaywayOutcomeHoldExpired value)  holdExpired,}){
final _that = this;
switch (_that) {
case PaywayOutcomeApproved():
return approved(_that);case PaywayOutcomeDeclined():
return declined(_that);case PaywayOutcomeCancelled():
return cancelled(_that);case PaywayOutcomeDismissed():
return dismissed(_that);case PaywayOutcomeHoldExpired():
return holdExpired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaywayOutcomeApproved value)?  approved,TResult? Function( PaywayOutcomeDeclined value)?  declined,TResult? Function( PaywayOutcomeCancelled value)?  cancelled,TResult? Function( PaywayOutcomeDismissed value)?  dismissed,TResult? Function( PaywayOutcomeHoldExpired value)?  holdExpired,}){
final _that = this;
switch (_that) {
case PaywayOutcomeApproved() when approved != null:
return approved(_that);case PaywayOutcomeDeclined() when declined != null:
return declined(_that);case PaywayOutcomeCancelled() when cancelled != null:
return cancelled(_that);case PaywayOutcomeDismissed() when dismissed != null:
return dismissed(_that);case PaywayOutcomeHoldExpired() when holdExpired != null:
return holdExpired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BookingSummary confirmation)?  approved,TResult Function()?  declined,TResult Function()?  cancelled,TResult Function()?  dismissed,TResult Function()?  holdExpired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaywayOutcomeApproved() when approved != null:
return approved(_that.confirmation);case PaywayOutcomeDeclined() when declined != null:
return declined();case PaywayOutcomeCancelled() when cancelled != null:
return cancelled();case PaywayOutcomeDismissed() when dismissed != null:
return dismissed();case PaywayOutcomeHoldExpired() when holdExpired != null:
return holdExpired();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BookingSummary confirmation)  approved,required TResult Function()  declined,required TResult Function()  cancelled,required TResult Function()  dismissed,required TResult Function()  holdExpired,}) {final _that = this;
switch (_that) {
case PaywayOutcomeApproved():
return approved(_that.confirmation);case PaywayOutcomeDeclined():
return declined();case PaywayOutcomeCancelled():
return cancelled();case PaywayOutcomeDismissed():
return dismissed();case PaywayOutcomeHoldExpired():
return holdExpired();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BookingSummary confirmation)?  approved,TResult? Function()?  declined,TResult? Function()?  cancelled,TResult? Function()?  dismissed,TResult? Function()?  holdExpired,}) {final _that = this;
switch (_that) {
case PaywayOutcomeApproved() when approved != null:
return approved(_that.confirmation);case PaywayOutcomeDeclined() when declined != null:
return declined();case PaywayOutcomeCancelled() when cancelled != null:
return cancelled();case PaywayOutcomeDismissed() when dismissed != null:
return dismissed();case PaywayOutcomeHoldExpired() when holdExpired != null:
return holdExpired();case _:
  return null;

}
}

}

/// @nodoc


class PaywayOutcomeApproved implements PaywayOutcome {
  const PaywayOutcomeApproved(this.confirmation);
  

 final  BookingSummary confirmation;

/// Create a copy of PaywayOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywayOutcomeApprovedCopyWith<PaywayOutcomeApproved> get copyWith => _$PaywayOutcomeApprovedCopyWithImpl<PaywayOutcomeApproved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayOutcomeApproved&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,confirmation);
}

@override
String toString() {
    return 'PaywayOutcome.approved(confirmation: $confirmation)';
}


}

/// @nodoc
abstract mixin class $PaywayOutcomeApprovedCopyWith<$Res> implements $PaywayOutcomeCopyWith<$Res> {
  factory $PaywayOutcomeApprovedCopyWith(PaywayOutcomeApproved value, $Res Function(PaywayOutcomeApproved) _then) = _$PaywayOutcomeApprovedCopyWithImpl;
@useResult
$Res call({
 BookingSummary confirmation
});


$BookingSummaryCopyWith<$Res> get confirmation;

}
/// @nodoc
class _$PaywayOutcomeApprovedCopyWithImpl<$Res>
    implements $PaywayOutcomeApprovedCopyWith<$Res> {
  _$PaywayOutcomeApprovedCopyWithImpl(this._self, this._then);

  final PaywayOutcomeApproved _self;
  final $Res Function(PaywayOutcomeApproved) _then;

/// Create a copy of PaywayOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? confirmation = null,}) {
  return _then(PaywayOutcomeApproved(
null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as BookingSummary,
  ));
}

/// Create a copy of PaywayOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSummaryCopyWith<$Res> get confirmation {
  
  return $BookingSummaryCopyWith<$Res>(_self.confirmation, (value) {
    return _then(_self.copyWith(confirmation: value));
  });
}
}

/// @nodoc


class PaywayOutcomeDeclined implements PaywayOutcome {
  const PaywayOutcomeDeclined();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayOutcomeDeclined);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayOutcome.declined()';
}


}




/// @nodoc


class PaywayOutcomeCancelled implements PaywayOutcome {
  const PaywayOutcomeCancelled();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayOutcomeCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayOutcome.cancelled()';
}


}




/// @nodoc


class PaywayOutcomeDismissed implements PaywayOutcome {
  const PaywayOutcomeDismissed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayOutcomeDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayOutcome.dismissed()';
}


}




/// @nodoc


class PaywayOutcomeHoldExpired implements PaywayOutcome {
  const PaywayOutcomeHoldExpired();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywayOutcomeHoldExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PaywayOutcome.holdExpired()';
}


}




// dart format on
