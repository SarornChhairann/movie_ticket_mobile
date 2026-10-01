// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiFailure()';
}


}

/// @nodoc
class $ApiFailureCopyWith<$Res>  {
$ApiFailureCopyWith(ApiFailure _, $Res Function(ApiFailure) __);
}


/// Adds pattern-matching-related methods to [ApiFailure].
extension ApiFailurePatterns on ApiFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiFailureServer value)?  server,TResult Function( ApiFailureNetwork value)?  network,TResult Function( ApiFailureUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiFailureServer() when server != null:
return server(_that);case ApiFailureNetwork() when network != null:
return network(_that);case ApiFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiFailureServer value)  server,required TResult Function( ApiFailureNetwork value)  network,required TResult Function( ApiFailureUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case ApiFailureServer():
return server(_that);case ApiFailureNetwork():
return network(_that);case ApiFailureUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiFailureServer value)?  server,TResult? Function( ApiFailureNetwork value)?  network,TResult? Function( ApiFailureUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case ApiFailureServer() when server != null:
return server(_that);case ApiFailureNetwork() when network != null:
return network(_that);case ApiFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int status,  String? code,  String message)?  server,TResult Function()?  network,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiFailureServer() when server != null:
return server(_that.status,_that.code,_that.message);case ApiFailureNetwork() when network != null:
return network();case ApiFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int status,  String? code,  String message)  server,required TResult Function()  network,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case ApiFailureServer():
return server(_that.status,_that.code,_that.message);case ApiFailureNetwork():
return network();case ApiFailureUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int status,  String? code,  String message)?  server,TResult? Function()?  network,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case ApiFailureServer() when server != null:
return server(_that.status,_that.code,_that.message);case ApiFailureNetwork() when network != null:
return network();case ApiFailureUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ApiFailureServer extends ApiFailure {
  const ApiFailureServer({required this.status, this.code, required this.message}): super._();
  

 final  int status;
 final  String? code;
 final  String message;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiFailureServerCopyWith<ApiFailureServer> get copyWith => _$ApiFailureServerCopyWithImpl<ApiFailureServer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailureServer&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,code,message);
}

@override
String toString() {
    return 'ApiFailure.server(status: $status, code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $ApiFailureServerCopyWith<$Res> implements $ApiFailureCopyWith<$Res> {
  factory $ApiFailureServerCopyWith(ApiFailureServer value, $Res Function(ApiFailureServer) _then) = _$ApiFailureServerCopyWithImpl;
@useResult
$Res call({
 int status, String? code, String message
});




}
/// @nodoc
class _$ApiFailureServerCopyWithImpl<$Res>
    implements $ApiFailureServerCopyWith<$Res> {
  _$ApiFailureServerCopyWithImpl(this._self, this._then);

  final ApiFailureServer _self;
  final $Res Function(ApiFailureServer) _then;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,Object? code = freezed,Object? message = null,}) {
  return _then(ApiFailureServer(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ApiFailureNetwork extends ApiFailure {
  const ApiFailureNetwork(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailureNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiFailure.network()';
}


}




/// @nodoc


class ApiFailureUnknown extends ApiFailure {
  const ApiFailureUnknown([this.message]): super._();
  

 final  String? message;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiFailureUnknownCopyWith<ApiFailureUnknown> get copyWith => _$ApiFailureUnknownCopyWithImpl<ApiFailureUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailureUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ApiFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $ApiFailureUnknownCopyWith<$Res> implements $ApiFailureCopyWith<$Res> {
  factory $ApiFailureUnknownCopyWith(ApiFailureUnknown value, $Res Function(ApiFailureUnknown) _then) = _$ApiFailureUnknownCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ApiFailureUnknownCopyWithImpl<$Res>
    implements $ApiFailureUnknownCopyWith<$Res> {
  _$ApiFailureUnknownCopyWithImpl(this._self, this._then);

  final ApiFailureUnknown _self;
  final $Res Function(ApiFailureUnknown) _then;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ApiFailureUnknown(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
