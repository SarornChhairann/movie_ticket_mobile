// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tickets_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketsFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TicketsFailure()';
}


}

/// @nodoc
class $TicketsFailureCopyWith<$Res>  {
$TicketsFailureCopyWith(TicketsFailure _, $Res Function(TicketsFailure) __);
}


/// Adds pattern-matching-related methods to [TicketsFailure].
extension TicketsFailurePatterns on TicketsFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TicketsNotOwner value)?  notOwner,TResult Function( TicketsAlreadyCancelled value)?  alreadyCancelled,TResult Function( TicketsCancelWindow value)?  cancelWindow,TResult Function( TicketsNotFound value)?  notFound,TResult Function( TicketsTooManyAttempts value)?  tooManyAttempts,TResult Function( TicketsNetwork value)?  network,TResult Function( TicketsUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TicketsNotOwner() when notOwner != null:
return notOwner(_that);case TicketsAlreadyCancelled() when alreadyCancelled != null:
return alreadyCancelled(_that);case TicketsCancelWindow() when cancelWindow != null:
return cancelWindow(_that);case TicketsNotFound() when notFound != null:
return notFound(_that);case TicketsTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts(_that);case TicketsNetwork() when network != null:
return network(_that);case TicketsUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TicketsNotOwner value)  notOwner,required TResult Function( TicketsAlreadyCancelled value)  alreadyCancelled,required TResult Function( TicketsCancelWindow value)  cancelWindow,required TResult Function( TicketsNotFound value)  notFound,required TResult Function( TicketsTooManyAttempts value)  tooManyAttempts,required TResult Function( TicketsNetwork value)  network,required TResult Function( TicketsUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case TicketsNotOwner():
return notOwner(_that);case TicketsAlreadyCancelled():
return alreadyCancelled(_that);case TicketsCancelWindow():
return cancelWindow(_that);case TicketsNotFound():
return notFound(_that);case TicketsTooManyAttempts():
return tooManyAttempts(_that);case TicketsNetwork():
return network(_that);case TicketsUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TicketsNotOwner value)?  notOwner,TResult? Function( TicketsAlreadyCancelled value)?  alreadyCancelled,TResult? Function( TicketsCancelWindow value)?  cancelWindow,TResult? Function( TicketsNotFound value)?  notFound,TResult? Function( TicketsTooManyAttempts value)?  tooManyAttempts,TResult? Function( TicketsNetwork value)?  network,TResult? Function( TicketsUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case TicketsNotOwner() when notOwner != null:
return notOwner(_that);case TicketsAlreadyCancelled() when alreadyCancelled != null:
return alreadyCancelled(_that);case TicketsCancelWindow() when cancelWindow != null:
return cancelWindow(_that);case TicketsNotFound() when notFound != null:
return notFound(_that);case TicketsTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts(_that);case TicketsNetwork() when network != null:
return network(_that);case TicketsUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  notOwner,TResult Function( String message)?  alreadyCancelled,TResult Function( String message)?  cancelWindow,TResult Function( String message)?  notFound,TResult Function( String message)?  tooManyAttempts,TResult Function()?  network,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TicketsNotOwner() when notOwner != null:
return notOwner(_that.message);case TicketsAlreadyCancelled() when alreadyCancelled != null:
return alreadyCancelled(_that.message);case TicketsCancelWindow() when cancelWindow != null:
return cancelWindow(_that.message);case TicketsNotFound() when notFound != null:
return notFound(_that.message);case TicketsTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts(_that.message);case TicketsNetwork() when network != null:
return network();case TicketsUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  notOwner,required TResult Function( String message)  alreadyCancelled,required TResult Function( String message)  cancelWindow,required TResult Function( String message)  notFound,required TResult Function( String message)  tooManyAttempts,required TResult Function()  network,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case TicketsNotOwner():
return notOwner(_that.message);case TicketsAlreadyCancelled():
return alreadyCancelled(_that.message);case TicketsCancelWindow():
return cancelWindow(_that.message);case TicketsNotFound():
return notFound(_that.message);case TicketsTooManyAttempts():
return tooManyAttempts(_that.message);case TicketsNetwork():
return network();case TicketsUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  notOwner,TResult? Function( String message)?  alreadyCancelled,TResult? Function( String message)?  cancelWindow,TResult? Function( String message)?  notFound,TResult? Function( String message)?  tooManyAttempts,TResult? Function()?  network,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case TicketsNotOwner() when notOwner != null:
return notOwner(_that.message);case TicketsAlreadyCancelled() when alreadyCancelled != null:
return alreadyCancelled(_that.message);case TicketsCancelWindow() when cancelWindow != null:
return cancelWindow(_that.message);case TicketsNotFound() when notFound != null:
return notFound(_that.message);case TicketsTooManyAttempts() when tooManyAttempts != null:
return tooManyAttempts(_that.message);case TicketsNetwork() when network != null:
return network();case TicketsUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TicketsNotOwner extends TicketsFailure {
  const TicketsNotOwner(this.message): super._();
  

 final  String message;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsNotOwnerCopyWith<TicketsNotOwner> get copyWith => _$TicketsNotOwnerCopyWithImpl<TicketsNotOwner>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsNotOwner&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TicketsFailure.notOwner(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsNotOwnerCopyWith<$Res> implements $TicketsFailureCopyWith<$Res> {
  factory $TicketsNotOwnerCopyWith(TicketsNotOwner value, $Res Function(TicketsNotOwner) _then) = _$TicketsNotOwnerCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsNotOwnerCopyWithImpl<$Res>
    implements $TicketsNotOwnerCopyWith<$Res> {
  _$TicketsNotOwnerCopyWithImpl(this._self, this._then);

  final TicketsNotOwner _self;
  final $Res Function(TicketsNotOwner) _then;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsNotOwner(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketsAlreadyCancelled extends TicketsFailure {
  const TicketsAlreadyCancelled(this.message): super._();
  

 final  String message;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsAlreadyCancelledCopyWith<TicketsAlreadyCancelled> get copyWith => _$TicketsAlreadyCancelledCopyWithImpl<TicketsAlreadyCancelled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsAlreadyCancelled&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TicketsFailure.alreadyCancelled(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsAlreadyCancelledCopyWith<$Res> implements $TicketsFailureCopyWith<$Res> {
  factory $TicketsAlreadyCancelledCopyWith(TicketsAlreadyCancelled value, $Res Function(TicketsAlreadyCancelled) _then) = _$TicketsAlreadyCancelledCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsAlreadyCancelledCopyWithImpl<$Res>
    implements $TicketsAlreadyCancelledCopyWith<$Res> {
  _$TicketsAlreadyCancelledCopyWithImpl(this._self, this._then);

  final TicketsAlreadyCancelled _self;
  final $Res Function(TicketsAlreadyCancelled) _then;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsAlreadyCancelled(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketsCancelWindow extends TicketsFailure {
  const TicketsCancelWindow(this.message): super._();
  

 final  String message;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsCancelWindowCopyWith<TicketsCancelWindow> get copyWith => _$TicketsCancelWindowCopyWithImpl<TicketsCancelWindow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsCancelWindow&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TicketsFailure.cancelWindow(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsCancelWindowCopyWith<$Res> implements $TicketsFailureCopyWith<$Res> {
  factory $TicketsCancelWindowCopyWith(TicketsCancelWindow value, $Res Function(TicketsCancelWindow) _then) = _$TicketsCancelWindowCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsCancelWindowCopyWithImpl<$Res>
    implements $TicketsCancelWindowCopyWith<$Res> {
  _$TicketsCancelWindowCopyWithImpl(this._self, this._then);

  final TicketsCancelWindow _self;
  final $Res Function(TicketsCancelWindow) _then;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsCancelWindow(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketsNotFound extends TicketsFailure {
  const TicketsNotFound(this.message): super._();
  

 final  String message;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsNotFoundCopyWith<TicketsNotFound> get copyWith => _$TicketsNotFoundCopyWithImpl<TicketsNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsNotFound&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TicketsFailure.notFound(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsNotFoundCopyWith<$Res> implements $TicketsFailureCopyWith<$Res> {
  factory $TicketsNotFoundCopyWith(TicketsNotFound value, $Res Function(TicketsNotFound) _then) = _$TicketsNotFoundCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsNotFoundCopyWithImpl<$Res>
    implements $TicketsNotFoundCopyWith<$Res> {
  _$TicketsNotFoundCopyWithImpl(this._self, this._then);

  final TicketsNotFound _self;
  final $Res Function(TicketsNotFound) _then;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsNotFound(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketsTooManyAttempts extends TicketsFailure {
  const TicketsTooManyAttempts(this.message): super._();
  

 final  String message;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsTooManyAttemptsCopyWith<TicketsTooManyAttempts> get copyWith => _$TicketsTooManyAttemptsCopyWithImpl<TicketsTooManyAttempts>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsTooManyAttempts&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TicketsFailure.tooManyAttempts(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsTooManyAttemptsCopyWith<$Res> implements $TicketsFailureCopyWith<$Res> {
  factory $TicketsTooManyAttemptsCopyWith(TicketsTooManyAttempts value, $Res Function(TicketsTooManyAttempts) _then) = _$TicketsTooManyAttemptsCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsTooManyAttemptsCopyWithImpl<$Res>
    implements $TicketsTooManyAttemptsCopyWith<$Res> {
  _$TicketsTooManyAttemptsCopyWithImpl(this._self, this._then);

  final TicketsTooManyAttempts _self;
  final $Res Function(TicketsTooManyAttempts) _then;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsTooManyAttempts(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketsNetwork extends TicketsFailure {
  const TicketsNetwork(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TicketsFailure.network()';
}


}




/// @nodoc


class TicketsUnknown extends TicketsFailure {
  const TicketsUnknown(this.message): super._();
  

 final  String message;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsUnknownCopyWith<TicketsUnknown> get copyWith => _$TicketsUnknownCopyWithImpl<TicketsUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TicketsFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsUnknownCopyWith<$Res> implements $TicketsFailureCopyWith<$Res> {
  factory $TicketsUnknownCopyWith(TicketsUnknown value, $Res Function(TicketsUnknown) _then) = _$TicketsUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsUnknownCopyWithImpl<$Res>
    implements $TicketsUnknownCopyWith<$Res> {
  _$TicketsUnknownCopyWithImpl(this._self, this._then);

  final TicketsUnknown _self;
  final $Res Function(TicketsUnknown) _then;

/// Create a copy of TicketsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
