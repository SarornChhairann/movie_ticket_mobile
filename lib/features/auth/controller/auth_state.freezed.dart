// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthUnknownState value)?  unknown,TResult Function( AuthUnauthenticated value)?  unauthenticated,TResult Function( AuthGuest value)?  guest,TResult Function( AuthAuthenticated value)?  authenticated,TResult Function( AuthBlockedState value)?  blocked,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthUnknownState() when unknown != null:
return unknown(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthGuest() when guest != null:
return guest(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case AuthBlockedState() when blocked != null:
return blocked(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthUnknownState value)  unknown,required TResult Function( AuthUnauthenticated value)  unauthenticated,required TResult Function( AuthGuest value)  guest,required TResult Function( AuthAuthenticated value)  authenticated,required TResult Function( AuthBlockedState value)  blocked,}){
final _that = this;
switch (_that) {
case AuthUnknownState():
return unknown(_that);case AuthUnauthenticated():
return unauthenticated(_that);case AuthGuest():
return guest(_that);case AuthAuthenticated():
return authenticated(_that);case AuthBlockedState():
return blocked(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthUnknownState value)?  unknown,TResult? Function( AuthUnauthenticated value)?  unauthenticated,TResult? Function( AuthGuest value)?  guest,TResult? Function( AuthAuthenticated value)?  authenticated,TResult? Function( AuthBlockedState value)?  blocked,}){
final _that = this;
switch (_that) {
case AuthUnknownState() when unknown != null:
return unknown(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthGuest() when guest != null:
return guest(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case AuthBlockedState() when blocked != null:
return blocked(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( bool submitting,  AuthFailure? failure)?  unauthenticated,TResult Function()?  guest,TResult Function( User user)?  authenticated,TResult Function( String message)?  blocked,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthUnknownState() when unknown != null:
return unknown();case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.submitting,_that.failure);case AuthGuest() when guest != null:
return guest();case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthBlockedState() when blocked != null:
return blocked(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( bool submitting,  AuthFailure? failure)  unauthenticated,required TResult Function()  guest,required TResult Function( User user)  authenticated,required TResult Function( String message)  blocked,}) {final _that = this;
switch (_that) {
case AuthUnknownState():
return unknown();case AuthUnauthenticated():
return unauthenticated(_that.submitting,_that.failure);case AuthGuest():
return guest();case AuthAuthenticated():
return authenticated(_that.user);case AuthBlockedState():
return blocked(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( bool submitting,  AuthFailure? failure)?  unauthenticated,TResult? Function()?  guest,TResult? Function( User user)?  authenticated,TResult? Function( String message)?  blocked,}) {final _that = this;
switch (_that) {
case AuthUnknownState() when unknown != null:
return unknown();case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.submitting,_that.failure);case AuthGuest() when guest != null:
return guest();case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthBlockedState() when blocked != null:
return blocked(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthUnknownState implements AuthState {
  const AuthUnknownState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknownState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.unknown()';
}


}




/// @nodoc


class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated({this.submitting = false, this.failure});
  

@JsonKey() final  bool submitting;
 final  AuthFailure? failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUnauthenticatedCopyWith<AuthUnauthenticated> get copyWith => _$AuthUnauthenticatedCopyWithImpl<AuthUnauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnauthenticated&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,submitting,failure);
}

@override
String toString() {
    return 'AuthState.unauthenticated(submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AuthUnauthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthUnauthenticatedCopyWith(AuthUnauthenticated value, $Res Function(AuthUnauthenticated) _then) = _$AuthUnauthenticatedCopyWithImpl;
@useResult
$Res call({
 bool submitting, AuthFailure? failure
});


$AuthFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$AuthUnauthenticatedCopyWithImpl<$Res>
    implements $AuthUnauthenticatedCopyWith<$Res> {
  _$AuthUnauthenticatedCopyWithImpl(this._self, this._then);

  final AuthUnauthenticated _self;
  final $Res Function(AuthUnauthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? submitting = null,Object? failure = freezed,}) {
  return _then(AuthUnauthenticated(
submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AuthFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc


class AuthGuest implements AuthState {
  const AuthGuest();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthGuest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.guest()';
}


}




/// @nodoc


class AuthAuthenticated implements AuthState {
  const AuthAuthenticated(this.user);
  

 final  User user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith => _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user);
}

@override
String toString() {
    return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) = _$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 User user
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthAuthenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class AuthBlockedState implements AuthState {
  const AuthBlockedState(this.message);
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthBlockedStateCopyWith<AuthBlockedState> get copyWith => _$AuthBlockedStateCopyWithImpl<AuthBlockedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthBlockedState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthState.blocked(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthBlockedStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthBlockedStateCopyWith(AuthBlockedState value, $Res Function(AuthBlockedState) _then) = _$AuthBlockedStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthBlockedStateCopyWithImpl<$Res>
    implements $AuthBlockedStateCopyWith<$Res> {
  _$AuthBlockedStateCopyWithImpl(this._self, this._then);

  final AuthBlockedState _self;
  final $Res Function(AuthBlockedState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthBlockedState(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
