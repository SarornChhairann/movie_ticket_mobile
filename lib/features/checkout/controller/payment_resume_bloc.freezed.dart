// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_resume_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResumeOutcome {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResumeOutcome()';
}


}

/// @nodoc
class $ResumeOutcomeCopyWith<$Res>  {
$ResumeOutcomeCopyWith(ResumeOutcome _, $Res Function(ResumeOutcome) __);
}


/// Adds pattern-matching-related methods to [ResumeOutcome].
extension ResumeOutcomePatterns on ResumeOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResumeApproved value)?  approved,TResult Function( ResumeFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResumeApproved() when approved != null:
return approved(_that);case ResumeFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResumeApproved value)  approved,required TResult Function( ResumeFailed value)  failed,}){
final _that = this;
switch (_that) {
case ResumeApproved():
return approved(_that);case ResumeFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResumeApproved value)?  approved,TResult? Function( ResumeFailed value)?  failed,}){
final _that = this;
switch (_that) {
case ResumeApproved() when approved != null:
return approved(_that);case ResumeFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BookingSummary confirmation)?  approved,TResult Function()?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResumeApproved() when approved != null:
return approved(_that.confirmation);case ResumeFailed() when failed != null:
return failed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BookingSummary confirmation)  approved,required TResult Function()  failed,}) {final _that = this;
switch (_that) {
case ResumeApproved():
return approved(_that.confirmation);case ResumeFailed():
return failed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BookingSummary confirmation)?  approved,TResult? Function()?  failed,}) {final _that = this;
switch (_that) {
case ResumeApproved() when approved != null:
return approved(_that.confirmation);case ResumeFailed() when failed != null:
return failed();case _:
  return null;

}
}

}

/// @nodoc


class ResumeApproved implements ResumeOutcome {
  const ResumeApproved(this.confirmation);
  

 final  BookingSummary confirmation;

/// Create a copy of ResumeOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeApprovedCopyWith<ResumeApproved> get copyWith => _$ResumeApprovedCopyWithImpl<ResumeApproved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeApproved&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,confirmation);
}

@override
String toString() {
    return 'ResumeOutcome.approved(confirmation: $confirmation)';
}


}

/// @nodoc
abstract mixin class $ResumeApprovedCopyWith<$Res> implements $ResumeOutcomeCopyWith<$Res> {
  factory $ResumeApprovedCopyWith(ResumeApproved value, $Res Function(ResumeApproved) _then) = _$ResumeApprovedCopyWithImpl;
@useResult
$Res call({
 BookingSummary confirmation
});


$BookingSummaryCopyWith<$Res> get confirmation;

}
/// @nodoc
class _$ResumeApprovedCopyWithImpl<$Res>
    implements $ResumeApprovedCopyWith<$Res> {
  _$ResumeApprovedCopyWithImpl(this._self, this._then);

  final ResumeApproved _self;
  final $Res Function(ResumeApproved) _then;

/// Create a copy of ResumeOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? confirmation = null,}) {
  return _then(ResumeApproved(
null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as BookingSummary,
  ));
}

/// Create a copy of ResumeOutcome
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


class ResumeFailed implements ResumeOutcome {
  const ResumeFailed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResumeOutcome.failed()';
}


}




/// @nodoc
mixin _$PaymentResumeState {

 PendingPayment get payment;/// Polls that failed in a row on the network; the offline note shows from the third.
 int get failures;/// Set once; the view leaves with it.
 ResumeOutcome? get outcome;
/// Create a copy of PaymentResumeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentResumeStateCopyWith<PaymentResumeState> get copyWith => _$PaymentResumeStateCopyWithImpl<PaymentResumeState>(this as PaymentResumeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentResumeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentResumeState&&(identical(other.payment, _this.payment) || other.payment == _this.payment)&&(identical(other.failures, _this.failures) || other.failures == _this.failures)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome));
}


@override
int get hashCode {
  final _this = this as PaymentResumeState;
  return Object.hash(runtimeType,_this.payment,_this.failures,_this.outcome);
}

@override
String toString() {
  final _this = this as PaymentResumeState;
  return 'PaymentResumeState(payment: ${_this.payment}, failures: ${_this.failures}, outcome: ${_this.outcome})';
}


}

/// @nodoc
abstract mixin class $PaymentResumeStateCopyWith<$Res>  {
  factory $PaymentResumeStateCopyWith(PaymentResumeState value, $Res Function(PaymentResumeState) _then) = _$PaymentResumeStateCopyWithImpl;
@useResult
$Res call({
 PendingPayment payment, int failures, ResumeOutcome? outcome
});


$ResumeOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class _$PaymentResumeStateCopyWithImpl<$Res>
    implements $PaymentResumeStateCopyWith<$Res> {
  _$PaymentResumeStateCopyWithImpl(this._self, this._then);

  final PaymentResumeState _self;
  final $Res Function(PaymentResumeState) _then;

/// Create a copy of PaymentResumeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payment = null,Object? failures = null,Object? outcome = freezed,}) {
  return _then(PaymentResumeState(
payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PendingPayment,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as int,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ResumeOutcome?,
  ));
}
/// Create a copy of PaymentResumeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResumeOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $ResumeOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentResumeState].
extension PaymentResumeStatePatterns on PaymentResumeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentResumeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentResumeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentResumeState value)  $default,){
final _that = this;
switch (_that) {
case _PaymentResumeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentResumeState value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentResumeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PendingPayment payment,  int failures,  ResumeOutcome? outcome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentResumeState() when $default != null:
return $default(_that.payment,_that.failures,_that.outcome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PendingPayment payment,  int failures,  ResumeOutcome? outcome)  $default,) {final _that = this;
switch (_that) {
case _PaymentResumeState():
return $default(_that.payment,_that.failures,_that.outcome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PendingPayment payment,  int failures,  ResumeOutcome? outcome)?  $default,) {final _that = this;
switch (_that) {
case _PaymentResumeState() when $default != null:
return $default(_that.payment,_that.failures,_that.outcome);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentResumeState implements PaymentResumeState {
  const _PaymentResumeState({required this.payment, this.failures = 0, this.outcome});
  

@override final  PendingPayment payment;
/// Polls that failed in a row on the network; the offline note shows from the third.
@override@JsonKey() final  int failures;
/// Set once; the view leaves with it.
@override final  ResumeOutcome? outcome;

/// Create a copy of PaymentResumeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentResumeStateCopyWith<_PaymentResumeState> get copyWith => __$PaymentResumeStateCopyWithImpl<_PaymentResumeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentResumeState&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.failures, failures) || other.failures == failures)&&(identical(other.outcome, outcome) || other.outcome == outcome));
}


@override
int get hashCode {
    return Object.hash(runtimeType,payment,failures,outcome);
}

@override
String toString() {
    return 'PaymentResumeState(payment: $payment, failures: $failures, outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class _$PaymentResumeStateCopyWith<$Res> implements $PaymentResumeStateCopyWith<$Res> {
  factory _$PaymentResumeStateCopyWith(_PaymentResumeState value, $Res Function(_PaymentResumeState) _then) = __$PaymentResumeStateCopyWithImpl;
@override @useResult
$Res call({
 PendingPayment payment, int failures, ResumeOutcome? outcome
});


@override $ResumeOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class __$PaymentResumeStateCopyWithImpl<$Res>
    implements _$PaymentResumeStateCopyWith<$Res> {
  __$PaymentResumeStateCopyWithImpl(this._self, this._then);

  final _PaymentResumeState _self;
  final $Res Function(_PaymentResumeState) _then;

/// Create a copy of PaymentResumeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payment = null,Object? failures = null,Object? outcome = freezed,}) {
  return _then(_PaymentResumeState(
payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PendingPayment,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as int,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ResumeOutcome?,
  ));
}

/// Create a copy of PaymentResumeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResumeOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $ResumeOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}

// dart format on
