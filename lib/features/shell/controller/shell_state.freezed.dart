// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shell_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShellState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ShellState()';
}


}

/// @nodoc
class $ShellStateCopyWith<$Res>  {
$ShellStateCopyWith(ShellState _, $Res Function(ShellState) __);
}


/// Adds pattern-matching-related methods to [ShellState].
extension ShellStatePatterns on ShellState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShellInitial value)?  initial,TResult Function( ShellLoading value)?  loading,TResult Function( ShellReady value)?  ready,TResult Function( ShellFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShellInitial() when initial != null:
return initial(_that);case ShellLoading() when loading != null:
return loading(_that);case ShellReady() when ready != null:
return ready(_that);case ShellFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShellInitial value)  initial,required TResult Function( ShellLoading value)  loading,required TResult Function( ShellReady value)  ready,required TResult Function( ShellFailure value)  failure,}){
final _that = this;
switch (_that) {
case ShellInitial():
return initial(_that);case ShellLoading():
return loading(_that);case ShellReady():
return ready(_that);case ShellFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShellInitial value)?  initial,TResult? Function( ShellLoading value)?  loading,TResult? Function( ShellReady value)?  ready,TResult? Function( ShellFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ShellInitial() when initial != null:
return initial(_that);case ShellLoading() when loading != null:
return loading(_that);case ShellReady() when ready != null:
return ready(_that);case ShellFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( HomeSummary summary,  DateTime? savedAt)?  ready,TResult Function( ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShellInitial() when initial != null:
return initial();case ShellLoading() when loading != null:
return loading();case ShellReady() when ready != null:
return ready(_that.summary,_that.savedAt);case ShellFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( HomeSummary summary,  DateTime? savedAt)  ready,required TResult Function( ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case ShellInitial():
return initial();case ShellLoading():
return loading();case ShellReady():
return ready(_that.summary,_that.savedAt);case ShellFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( HomeSummary summary,  DateTime? savedAt)?  ready,TResult? Function( ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case ShellInitial() when initial != null:
return initial();case ShellLoading() when loading != null:
return loading();case ShellReady() when ready != null:
return ready(_that.summary,_that.savedAt);case ShellFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ShellInitial implements ShellState {
  const ShellInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ShellState.initial()';
}


}




/// @nodoc


class ShellLoading implements ShellState {
  const ShellLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ShellState.loading()';
}


}




/// @nodoc


class ShellReady implements ShellState {
  const ShellReady(this.summary, {this.savedAt});
  

 final  HomeSummary summary;
 final  DateTime? savedAt;

/// Create a copy of ShellState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShellReadyCopyWith<ShellReady> get copyWith => _$ShellReadyCopyWithImpl<ShellReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellReady&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,summary,savedAt);
}

@override
String toString() {
    return 'ShellState.ready(summary: $summary, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $ShellReadyCopyWith<$Res> implements $ShellStateCopyWith<$Res> {
  factory $ShellReadyCopyWith(ShellReady value, $Res Function(ShellReady) _then) = _$ShellReadyCopyWithImpl;
@useResult
$Res call({
 HomeSummary summary, DateTime? savedAt
});


$HomeSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$ShellReadyCopyWithImpl<$Res>
    implements $ShellReadyCopyWith<$Res> {
  _$ShellReadyCopyWithImpl(this._self, this._then);

  final ShellReady _self;
  final $Res Function(ShellReady) _then;

/// Create a copy of ShellState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? savedAt = freezed,}) {
  return _then(ShellReady(
null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as HomeSummary,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ShellState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeSummaryCopyWith<$Res> get summary {
  
  return $HomeSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc


class ShellFailure implements ShellState {
  const ShellFailure(this.failure);
  

 final  ApiFailure failure;

/// Create a copy of ShellState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShellFailureCopyWith<ShellFailure> get copyWith => _$ShellFailureCopyWithImpl<ShellFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'ShellState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ShellFailureCopyWith<$Res> implements $ShellStateCopyWith<$Res> {
  factory $ShellFailureCopyWith(ShellFailure value, $Res Function(ShellFailure) _then) = _$ShellFailureCopyWithImpl;
@useResult
$Res call({
 ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ShellFailureCopyWithImpl<$Res>
    implements $ShellFailureCopyWith<$Res> {
  _$ShellFailureCopyWithImpl(this._self, this._then);

  final ShellFailure _self;
  final $Res Function(ShellFailure) _then;

/// Create a copy of ShellState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ShellFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of ShellState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiFailureCopyWith<$Res> get failure {
  
  return $ApiFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
