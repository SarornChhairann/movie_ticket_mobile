// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure()';
}


}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInvalidCredentials value)?  invalidCredentials,TResult Function( AuthBlocked value)?  blocked,TResult Function( AuthEmailInUse value)?  emailInUse,TResult Function( AuthValidation value)?  validation,TResult Function( AuthResetCodeInvalid value)?  resetCodeInvalid,TResult Function( AuthSessionExpired value)?  sessionExpired,TResult Function( AuthNetwork value)?  network,TResult Function( AuthUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case AuthBlocked() when blocked != null:
return blocked(_that);case AuthEmailInUse() when emailInUse != null:
return emailInUse(_that);case AuthValidation() when validation != null:
return validation(_that);case AuthResetCodeInvalid() when resetCodeInvalid != null:
return resetCodeInvalid(_that);case AuthSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case AuthNetwork() when network != null:
return network(_that);case AuthUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInvalidCredentials value)  invalidCredentials,required TResult Function( AuthBlocked value)  blocked,required TResult Function( AuthEmailInUse value)  emailInUse,required TResult Function( AuthValidation value)  validation,required TResult Function( AuthResetCodeInvalid value)  resetCodeInvalid,required TResult Function( AuthSessionExpired value)  sessionExpired,required TResult Function( AuthNetwork value)  network,required TResult Function( AuthUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case AuthInvalidCredentials():
return invalidCredentials(_that);case AuthBlocked():
return blocked(_that);case AuthEmailInUse():
return emailInUse(_that);case AuthValidation():
return validation(_that);case AuthResetCodeInvalid():
return resetCodeInvalid(_that);case AuthSessionExpired():
return sessionExpired(_that);case AuthNetwork():
return network(_that);case AuthUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInvalidCredentials value)?  invalidCredentials,TResult? Function( AuthBlocked value)?  blocked,TResult? Function( AuthEmailInUse value)?  emailInUse,TResult? Function( AuthValidation value)?  validation,TResult? Function( AuthResetCodeInvalid value)?  resetCodeInvalid,TResult? Function( AuthSessionExpired value)?  sessionExpired,TResult? Function( AuthNetwork value)?  network,TResult? Function( AuthUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case AuthInvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case AuthBlocked() when blocked != null:
return blocked(_that);case AuthEmailInUse() when emailInUse != null:
return emailInUse(_that);case AuthValidation() when validation != null:
return validation(_that);case AuthResetCodeInvalid() when resetCodeInvalid != null:
return resetCodeInvalid(_that);case AuthSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case AuthNetwork() when network != null:
return network(_that);case AuthUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function( String message)?  blocked,TResult Function( String message)?  emailInUse,TResult Function( String message)?  validation,TResult Function()?  resetCodeInvalid,TResult Function()?  sessionExpired,TResult Function()?  network,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case AuthBlocked() when blocked != null:
return blocked(_that.message);case AuthEmailInUse() when emailInUse != null:
return emailInUse(_that.message);case AuthValidation() when validation != null:
return validation(_that.message);case AuthResetCodeInvalid() when resetCodeInvalid != null:
return resetCodeInvalid();case AuthSessionExpired() when sessionExpired != null:
return sessionExpired();case AuthNetwork() when network != null:
return network();case AuthUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function( String message)  blocked,required TResult Function( String message)  emailInUse,required TResult Function( String message)  validation,required TResult Function()  resetCodeInvalid,required TResult Function()  sessionExpired,required TResult Function()  network,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case AuthInvalidCredentials():
return invalidCredentials();case AuthBlocked():
return blocked(_that.message);case AuthEmailInUse():
return emailInUse(_that.message);case AuthValidation():
return validation(_that.message);case AuthResetCodeInvalid():
return resetCodeInvalid();case AuthSessionExpired():
return sessionExpired();case AuthNetwork():
return network();case AuthUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function( String message)?  blocked,TResult? Function( String message)?  emailInUse,TResult? Function( String message)?  validation,TResult? Function()?  resetCodeInvalid,TResult? Function()?  sessionExpired,TResult? Function()?  network,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case AuthInvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case AuthBlocked() when blocked != null:
return blocked(_that.message);case AuthEmailInUse() when emailInUse != null:
return emailInUse(_that.message);case AuthValidation() when validation != null:
return validation(_that.message);case AuthResetCodeInvalid() when resetCodeInvalid != null:
return resetCodeInvalid();case AuthSessionExpired() when sessionExpired != null:
return sessionExpired();case AuthNetwork() when network != null:
return network();case AuthUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthInvalidCredentials extends AuthFailure {
  const AuthInvalidCredentials(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInvalidCredentials);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.invalidCredentials()';
}


}




/// @nodoc


class AuthBlocked extends AuthFailure {
  const AuthBlocked(this.message): super._();
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthBlockedCopyWith<AuthBlocked> get copyWith => _$AuthBlockedCopyWithImpl<AuthBlocked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthBlocked&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthFailure.blocked(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthBlockedCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthBlockedCopyWith(AuthBlocked value, $Res Function(AuthBlocked) _then) = _$AuthBlockedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthBlockedCopyWithImpl<$Res>
    implements $AuthBlockedCopyWith<$Res> {
  _$AuthBlockedCopyWithImpl(this._self, this._then);

  final AuthBlocked _self;
  final $Res Function(AuthBlocked) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthBlocked(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthEmailInUse extends AuthFailure {
  const AuthEmailInUse(this.message): super._();
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEmailInUseCopyWith<AuthEmailInUse> get copyWith => _$AuthEmailInUseCopyWithImpl<AuthEmailInUse>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEmailInUse&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthFailure.emailInUse(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthEmailInUseCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthEmailInUseCopyWith(AuthEmailInUse value, $Res Function(AuthEmailInUse) _then) = _$AuthEmailInUseCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthEmailInUseCopyWithImpl<$Res>
    implements $AuthEmailInUseCopyWith<$Res> {
  _$AuthEmailInUseCopyWithImpl(this._self, this._then);

  final AuthEmailInUse _self;
  final $Res Function(AuthEmailInUse) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthEmailInUse(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthValidation extends AuthFailure {
  const AuthValidation(this.message): super._();
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthValidationCopyWith<AuthValidation> get copyWith => _$AuthValidationCopyWithImpl<AuthValidation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthValidation&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthFailure.validation(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthValidationCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthValidationCopyWith(AuthValidation value, $Res Function(AuthValidation) _then) = _$AuthValidationCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthValidationCopyWithImpl<$Res>
    implements $AuthValidationCopyWith<$Res> {
  _$AuthValidationCopyWithImpl(this._self, this._then);

  final AuthValidation _self;
  final $Res Function(AuthValidation) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthValidation(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthResetCodeInvalid extends AuthFailure {
  const AuthResetCodeInvalid(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResetCodeInvalid);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.resetCodeInvalid()';
}


}




/// @nodoc


class AuthSessionExpired extends AuthFailure {
  const AuthSessionExpired(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.sessionExpired()';
}


}




/// @nodoc


class AuthNetwork extends AuthFailure {
  const AuthNetwork(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFailure.network()';
}


}




/// @nodoc


class AuthUnknown extends AuthFailure {
  const AuthUnknown(this.message): super._();
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUnknownCopyWith<AuthUnknown> get copyWith => _$AuthUnknownCopyWithImpl<AuthUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthUnknownCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthUnknownCopyWith(AuthUnknown value, $Res Function(AuthUnknown) _then) = _$AuthUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthUnknownCopyWithImpl<$Res>
    implements $AuthUnknownCopyWith<$Res> {
  _$AuthUnknownCopyWithImpl(this._self, this._then);

  final AuthUnknown _self;
  final $Res Function(AuthUnknown) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
