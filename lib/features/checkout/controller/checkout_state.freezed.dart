// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckoutState()';
}


}

/// @nodoc
class $CheckoutStateCopyWith<$Res>  {
$CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckoutInitial value)?  initial,TResult Function( CheckoutLoading value)?  loading,TResult Function( CheckoutReady value)?  ready,TResult Function( CheckoutFailureState value)?  failure,TResult Function( CheckoutSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckoutInitial() when initial != null:
return initial(_that);case CheckoutLoading() when loading != null:
return loading(_that);case CheckoutReady() when ready != null:
return ready(_that);case CheckoutFailureState() when failure != null:
return failure(_that);case CheckoutSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckoutInitial value)  initial,required TResult Function( CheckoutLoading value)  loading,required TResult Function( CheckoutReady value)  ready,required TResult Function( CheckoutFailureState value)  failure,required TResult Function( CheckoutSuccess value)  success,}){
final _that = this;
switch (_that) {
case CheckoutInitial():
return initial(_that);case CheckoutLoading():
return loading(_that);case CheckoutReady():
return ready(_that);case CheckoutFailureState():
return failure(_that);case CheckoutSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckoutInitial value)?  initial,TResult? Function( CheckoutLoading value)?  loading,TResult? Function( CheckoutReady value)?  ready,TResult? Function( CheckoutFailureState value)?  failure,TResult? Function( CheckoutSuccess value)?  success,}){
final _that = this;
switch (_that) {
case CheckoutInitial() when initial != null:
return initial(_that);case CheckoutLoading() when loading != null:
return loading(_that);case CheckoutReady() when ready != null:
return ready(_that);case CheckoutFailureState() when failure != null:
return failure(_that);case CheckoutSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( Hold hold)?  loading,TResult Function( Hold hold,  Quote quote,  Map<int, int> food,  GuestInfo guest,  bool quoting,  bool submitting,  int? secondsLeft,  CheckoutEffect? effect,  String? message)?  ready,TResult Function( Hold hold,  CheckoutFailure failure)?  failure,TResult Function( BookingSummary confirmation)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckoutInitial() when initial != null:
return initial();case CheckoutLoading() when loading != null:
return loading(_that.hold);case CheckoutReady() when ready != null:
return ready(_that.hold,_that.quote,_that.food,_that.guest,_that.quoting,_that.submitting,_that.secondsLeft,_that.effect,_that.message);case CheckoutFailureState() when failure != null:
return failure(_that.hold,_that.failure);case CheckoutSuccess() when success != null:
return success(_that.confirmation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( Hold hold)  loading,required TResult Function( Hold hold,  Quote quote,  Map<int, int> food,  GuestInfo guest,  bool quoting,  bool submitting,  int? secondsLeft,  CheckoutEffect? effect,  String? message)  ready,required TResult Function( Hold hold,  CheckoutFailure failure)  failure,required TResult Function( BookingSummary confirmation)  success,}) {final _that = this;
switch (_that) {
case CheckoutInitial():
return initial();case CheckoutLoading():
return loading(_that.hold);case CheckoutReady():
return ready(_that.hold,_that.quote,_that.food,_that.guest,_that.quoting,_that.submitting,_that.secondsLeft,_that.effect,_that.message);case CheckoutFailureState():
return failure(_that.hold,_that.failure);case CheckoutSuccess():
return success(_that.confirmation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( Hold hold)?  loading,TResult? Function( Hold hold,  Quote quote,  Map<int, int> food,  GuestInfo guest,  bool quoting,  bool submitting,  int? secondsLeft,  CheckoutEffect? effect,  String? message)?  ready,TResult? Function( Hold hold,  CheckoutFailure failure)?  failure,TResult? Function( BookingSummary confirmation)?  success,}) {final _that = this;
switch (_that) {
case CheckoutInitial() when initial != null:
return initial();case CheckoutLoading() when loading != null:
return loading(_that.hold);case CheckoutReady() when ready != null:
return ready(_that.hold,_that.quote,_that.food,_that.guest,_that.quoting,_that.submitting,_that.secondsLeft,_that.effect,_that.message);case CheckoutFailureState() when failure != null:
return failure(_that.hold,_that.failure);case CheckoutSuccess() when success != null:
return success(_that.confirmation);case _:
  return null;

}
}

}

/// @nodoc


class CheckoutInitial extends CheckoutState {
  const CheckoutInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckoutState.initial()';
}


}




/// @nodoc


class CheckoutLoading extends CheckoutState {
  const CheckoutLoading(this.hold): super._();
  

 final  Hold hold;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutLoadingCopyWith<CheckoutLoading> get copyWith => _$CheckoutLoadingCopyWithImpl<CheckoutLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutLoading&&(identical(other.hold, hold) || other.hold == hold));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hold);
}

@override
String toString() {
    return 'CheckoutState.loading(hold: $hold)';
}


}

/// @nodoc
abstract mixin class $CheckoutLoadingCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutLoadingCopyWith(CheckoutLoading value, $Res Function(CheckoutLoading) _then) = _$CheckoutLoadingCopyWithImpl;
@useResult
$Res call({
 Hold hold
});


$HoldCopyWith<$Res> get hold;

}
/// @nodoc
class _$CheckoutLoadingCopyWithImpl<$Res>
    implements $CheckoutLoadingCopyWith<$Res> {
  _$CheckoutLoadingCopyWithImpl(this._self, this._then);

  final CheckoutLoading _self;
  final $Res Function(CheckoutLoading) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hold = null,}) {
  return _then(CheckoutLoading(
null == hold ? _self.hold : hold // ignore: cast_nullable_to_non_nullable
as Hold,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldCopyWith<$Res> get hold {
  
  return $HoldCopyWith<$Res>(_self.hold, (value) {
    return _then(_self.copyWith(hold: value));
  });
}
}

/// @nodoc


class CheckoutReady extends CheckoutState {
  const CheckoutReady({required this.hold, required this.quote,  Map<int, int> food = const <int, int>{}, this.guest = const GuestInfo(), this.quoting = false, this.submitting = false, this.secondsLeft, this.effect, this.message}): _food = food,super._();
  

 final  Hold hold;
/// Last good server quote; a failed re-quote keeps it on screen.
 final  Quote quote;
/// Food the user picked (`foodItemId → quantity`); may be ahead of [quote]
/// while a re-quote is pending.
 final  Map<int, int> _food;
/// Food the user picked (`foodItemId → quantity`); may be ahead of [quote]
/// while a re-quote is pending.
@JsonKey() Map<int, int> get food {
  if (_food is EqualUnmodifiableMapView) return _food;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_food);
}

@JsonKey() final  GuestInfo guest;
@JsonKey() final  bool quoting;
/// A confirm is in flight.
@JsonKey() final  bool submitting;
 final  int? secondsLeft;
 final  CheckoutEffect? effect;
/// Server message for [CheckoutEffect.error].
 final  String? message;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutReadyCopyWith<CheckoutReady> get copyWith => _$CheckoutReadyCopyWithImpl<CheckoutReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutReady&&(identical(other.hold, hold) || other.hold == hold)&&(identical(other.quote, quote) || other.quote == quote)&&const DeepCollectionEquality().equals(other.food, _food)&&(identical(other.guest, guest) || other.guest == guest)&&(identical(other.quoting, quoting) || other.quoting == quoting)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.secondsLeft, secondsLeft) || other.secondsLeft == secondsLeft)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hold,quote,const DeepCollectionEquality().hash(_food),guest,quoting,submitting,secondsLeft,effect,message);
}

@override
String toString() {
    return 'CheckoutState.ready(hold: $hold, quote: $quote, food: $food, guest: $guest, quoting: $quoting, submitting: $submitting, secondsLeft: $secondsLeft, effect: $effect, message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckoutReadyCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutReadyCopyWith(CheckoutReady value, $Res Function(CheckoutReady) _then) = _$CheckoutReadyCopyWithImpl;
@useResult
$Res call({
 Hold hold, Quote quote, Map<int, int> food, GuestInfo guest, bool quoting, bool submitting, int? secondsLeft, CheckoutEffect? effect, String? message
});


$HoldCopyWith<$Res> get hold;$QuoteCopyWith<$Res> get quote;$GuestInfoCopyWith<$Res> get guest;

}
/// @nodoc
class _$CheckoutReadyCopyWithImpl<$Res>
    implements $CheckoutReadyCopyWith<$Res> {
  _$CheckoutReadyCopyWithImpl(this._self, this._then);

  final CheckoutReady _self;
  final $Res Function(CheckoutReady) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hold = null,Object? quote = null,Object? food = null,Object? guest = null,Object? quoting = null,Object? submitting = null,Object? secondsLeft = freezed,Object? effect = freezed,Object? message = freezed,}) {
  return _then(CheckoutReady(
hold: null == hold ? _self.hold : hold // ignore: cast_nullable_to_non_nullable
as Hold,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,food: null == food ? _self._food : food // ignore: cast_nullable_to_non_nullable
as Map<int, int>,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as GuestInfo,quoting: null == quoting ? _self.quoting : quoting // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,secondsLeft: freezed == secondsLeft ? _self.secondsLeft : secondsLeft // ignore: cast_nullable_to_non_nullable
as int?,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as CheckoutEffect?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldCopyWith<$Res> get hold {
  
  return $HoldCopyWith<$Res>(_self.hold, (value) {
    return _then(_self.copyWith(hold: value));
  });
}/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get quote {
  
  return $QuoteCopyWith<$Res>(_self.quote, (value) {
    return _then(_self.copyWith(quote: value));
  });
}/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuestInfoCopyWith<$Res> get guest {
  
  return $GuestInfoCopyWith<$Res>(_self.guest, (value) {
    return _then(_self.copyWith(guest: value));
  });
}
}

/// @nodoc


class CheckoutFailureState extends CheckoutState {
  const CheckoutFailureState(this.hold, this.failure): super._();
  

 final  Hold hold;
 final  CheckoutFailure failure;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutFailureStateCopyWith<CheckoutFailureState> get copyWith => _$CheckoutFailureStateCopyWithImpl<CheckoutFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutFailureState&&(identical(other.hold, hold) || other.hold == hold)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hold,failure);
}

@override
String toString() {
    return 'CheckoutState.failure(hold: $hold, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CheckoutFailureStateCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutFailureStateCopyWith(CheckoutFailureState value, $Res Function(CheckoutFailureState) _then) = _$CheckoutFailureStateCopyWithImpl;
@useResult
$Res call({
 Hold hold, CheckoutFailure failure
});


$HoldCopyWith<$Res> get hold;$CheckoutFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CheckoutFailureStateCopyWithImpl<$Res>
    implements $CheckoutFailureStateCopyWith<$Res> {
  _$CheckoutFailureStateCopyWithImpl(this._self, this._then);

  final CheckoutFailureState _self;
  final $Res Function(CheckoutFailureState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hold = null,Object? failure = null,}) {
  return _then(CheckoutFailureState(
null == hold ? _self.hold : hold // ignore: cast_nullable_to_non_nullable
as Hold,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CheckoutFailure,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldCopyWith<$Res> get hold {
  
  return $HoldCopyWith<$Res>(_self.hold, (value) {
    return _then(_self.copyWith(hold: value));
  });
}/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckoutFailureCopyWith<$Res> get failure {
  
  return $CheckoutFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc


class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess(this.confirmation): super._();
  

 final  BookingSummary confirmation;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSuccessCopyWith<CheckoutSuccess> get copyWith => _$CheckoutSuccessCopyWithImpl<CheckoutSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSuccess&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,confirmation);
}

@override
String toString() {
    return 'CheckoutState.success(confirmation: $confirmation)';
}


}

/// @nodoc
abstract mixin class $CheckoutSuccessCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutSuccessCopyWith(CheckoutSuccess value, $Res Function(CheckoutSuccess) _then) = _$CheckoutSuccessCopyWithImpl;
@useResult
$Res call({
 BookingSummary confirmation
});


$BookingSummaryCopyWith<$Res> get confirmation;

}
/// @nodoc
class _$CheckoutSuccessCopyWithImpl<$Res>
    implements $CheckoutSuccessCopyWith<$Res> {
  _$CheckoutSuccessCopyWithImpl(this._self, this._then);

  final CheckoutSuccess _self;
  final $Res Function(CheckoutSuccess) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? confirmation = null,}) {
  return _then(CheckoutSuccess(
null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as BookingSummary,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSummaryCopyWith<$Res> get confirmation {
  
  return $BookingSummaryCopyWith<$Res>(_self.confirmation, (value) {
    return _then(_self.copyWith(confirmation: value));
  });
}
}

// dart format on
