// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodItem {

 int get id; String get name; String? get description; num get price; String? get imageUrl;/// 0 = unlimited.
 int get stockQuantity;
/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodItemCopyWith<FoodItem> get copyWith => _$FoodItemCopyWithImpl<FoodItem>(this as FoodItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.stockQuantity, _this.stockQuantity) || other.stockQuantity == _this.stockQuantity));
}


@override
int get hashCode {
  final _this = this as FoodItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.price,_this.imageUrl,_this.stockQuantity);
}

@override
String toString() {
  final _this = this as FoodItem;
  return 'FoodItem(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, imageUrl: ${_this.imageUrl}, stockQuantity: ${_this.stockQuantity})';
}


}

/// @nodoc
abstract mixin class $FoodItemCopyWith<$Res>  {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) _then) = _$FoodItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, num price, String? imageUrl, int stockQuantity
});




}
/// @nodoc
class _$FoodItemCopyWithImpl<$Res>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._self, this._then);

  final FoodItem _self;
  final $Res Function(FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? price = null,Object? imageUrl = freezed,Object? stockQuantity = null,}) {
  return _then(FoodItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodItem].
extension FoodItemPatterns on FoodItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodItem value)  $default,){
final _that = this;
switch (_that) {
case _FoodItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodItem value)?  $default,){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  num price,  String? imageUrl,  int stockQuantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.imageUrl,_that.stockQuantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  num price,  String? imageUrl,  int stockQuantity)  $default,) {final _that = this;
switch (_that) {
case _FoodItem():
return $default(_that.id,_that.name,_that.description,_that.price,_that.imageUrl,_that.stockQuantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  num price,  String? imageUrl,  int stockQuantity)?  $default,) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.imageUrl,_that.stockQuantity);case _:
  return null;

}
}

}

/// @nodoc


class _FoodItem extends FoodItem {
  const _FoodItem({required this.id, required this.name, this.description, required this.price, this.imageUrl, required this.stockQuantity}): super._();
  

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  num price;
@override final  String? imageUrl;
/// 0 = unlimited.
@override final  int stockQuantity;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodItemCopyWith<_FoodItem> get copyWith => __$FoodItemCopyWithImpl<_FoodItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,price,imageUrl,stockQuantity);
}

@override
String toString() {
    return 'FoodItem(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, stockQuantity: $stockQuantity)';
}


}

/// @nodoc
abstract mixin class _$FoodItemCopyWith<$Res> implements $FoodItemCopyWith<$Res> {
  factory _$FoodItemCopyWith(_FoodItem value, $Res Function(_FoodItem) _then) = __$FoodItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, num price, String? imageUrl, int stockQuantity
});




}
/// @nodoc
class __$FoodItemCopyWithImpl<$Res>
    implements _$FoodItemCopyWith<$Res> {
  __$FoodItemCopyWithImpl(this._self, this._then);

  final _FoodItem _self;
  final $Res Function(_FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? price = null,Object? imageUrl = freezed,Object? stockQuantity = null,}) {
  return _then(_FoodItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$FoodLine {

 int get foodItemId; String get name; num get unitPrice; int get quantity; num get lineTotal;
/// Create a copy of FoodLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodLineCopyWith<FoodLine> get copyWith => _$FoodLineCopyWithImpl<FoodLine>(this as FoodLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodLine&&(identical(other.foodItemId, _this.foodItemId) || other.foodItemId == _this.foodItemId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.lineTotal, _this.lineTotal) || other.lineTotal == _this.lineTotal));
}


@override
int get hashCode {
  final _this = this as FoodLine;
  return Object.hash(runtimeType,_this.foodItemId,_this.name,_this.unitPrice,_this.quantity,_this.lineTotal);
}

@override
String toString() {
  final _this = this as FoodLine;
  return 'FoodLine(foodItemId: ${_this.foodItemId}, name: ${_this.name}, unitPrice: ${_this.unitPrice}, quantity: ${_this.quantity}, lineTotal: ${_this.lineTotal})';
}


}

/// @nodoc
abstract mixin class $FoodLineCopyWith<$Res>  {
  factory $FoodLineCopyWith(FoodLine value, $Res Function(FoodLine) _then) = _$FoodLineCopyWithImpl;
@useResult
$Res call({
 int foodItemId, String name, num unitPrice, int quantity, num lineTotal
});




}
/// @nodoc
class _$FoodLineCopyWithImpl<$Res>
    implements $FoodLineCopyWith<$Res> {
  _$FoodLineCopyWithImpl(this._self, this._then);

  final FoodLine _self;
  final $Res Function(FoodLine) _then;

/// Create a copy of FoodLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodItemId = null,Object? name = null,Object? unitPrice = null,Object? quantity = null,Object? lineTotal = null,}) {
  return _then(FoodLine(
foodItemId: null == foodItemId ? _self.foodItemId : foodItemId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodLine].
extension FoodLinePatterns on FoodLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodLine value)  $default,){
final _that = this;
switch (_that) {
case _FoodLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodLine value)?  $default,){
final _that = this;
switch (_that) {
case _FoodLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int foodItemId,  String name,  num unitPrice,  int quantity,  num lineTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodLine() when $default != null:
return $default(_that.foodItemId,_that.name,_that.unitPrice,_that.quantity,_that.lineTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int foodItemId,  String name,  num unitPrice,  int quantity,  num lineTotal)  $default,) {final _that = this;
switch (_that) {
case _FoodLine():
return $default(_that.foodItemId,_that.name,_that.unitPrice,_that.quantity,_that.lineTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int foodItemId,  String name,  num unitPrice,  int quantity,  num lineTotal)?  $default,) {final _that = this;
switch (_that) {
case _FoodLine() when $default != null:
return $default(_that.foodItemId,_that.name,_that.unitPrice,_that.quantity,_that.lineTotal);case _:
  return null;

}
}

}

/// @nodoc


class _FoodLine implements FoodLine {
  const _FoodLine({required this.foodItemId, required this.name, required this.unitPrice, required this.quantity, required this.lineTotal});
  

@override final  int foodItemId;
@override final  String name;
@override final  num unitPrice;
@override final  int quantity;
@override final  num lineTotal;

/// Create a copy of FoodLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodLineCopyWith<_FoodLine> get copyWith => __$FoodLineCopyWithImpl<_FoodLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodLine&&(identical(other.foodItemId, foodItemId) || other.foodItemId == foodItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,foodItemId,name,unitPrice,quantity,lineTotal);
}

@override
String toString() {
    return 'FoodLine(foodItemId: $foodItemId, name: $name, unitPrice: $unitPrice, quantity: $quantity, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class _$FoodLineCopyWith<$Res> implements $FoodLineCopyWith<$Res> {
  factory _$FoodLineCopyWith(_FoodLine value, $Res Function(_FoodLine) _then) = __$FoodLineCopyWithImpl;
@override @useResult
$Res call({
 int foodItemId, String name, num unitPrice, int quantity, num lineTotal
});




}
/// @nodoc
class __$FoodLineCopyWithImpl<$Res>
    implements _$FoodLineCopyWith<$Res> {
  __$FoodLineCopyWithImpl(this._self, this._then);

  final _FoodLine _self;
  final $Res Function(_FoodLine) _then;

/// Create a copy of FoodLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodItemId = null,Object? name = null,Object? unitPrice = null,Object? quantity = null,Object? lineTotal = null,}) {
  return _then(_FoodLine(
foodItemId: null == foodItemId ? _self.foodItemId : foodItemId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

/// @nodoc
mixin _$Quote {

 String get movieTitle; String get hallName; String? get showDate; String? get showTime; List<String> get seatCodes; num get baseAmount; num get morningDiscount; num get weekendSurcharge; num get subtotal; String? get promoCode; num get discountAmount; num get taxAmount; num get serviceFee; List<FoodLine> get foodLines; num get foodTotal; num get totalAmount; List<FoodItem> get foodItems;/// Signed-in customer; null for a guest.
 QuoteUser? get user;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Quote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.movieTitle, _this.movieTitle) || other.movieTitle == _this.movieTitle)&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.showDate, _this.showDate) || other.showDate == _this.showDate)&&(identical(other.showTime, _this.showTime) || other.showTime == _this.showTime)&&const DeepCollectionEquality().equals(other.seatCodes, _this.seatCodes)&&(identical(other.baseAmount, _this.baseAmount) || other.baseAmount == _this.baseAmount)&&(identical(other.morningDiscount, _this.morningDiscount) || other.morningDiscount == _this.morningDiscount)&&(identical(other.weekendSurcharge, _this.weekendSurcharge) || other.weekendSurcharge == _this.weekendSurcharge)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.promoCode, _this.promoCode) || other.promoCode == _this.promoCode)&&(identical(other.discountAmount, _this.discountAmount) || other.discountAmount == _this.discountAmount)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount)&&(identical(other.serviceFee, _this.serviceFee) || other.serviceFee == _this.serviceFee)&&const DeepCollectionEquality().equals(other.foodLines, _this.foodLines)&&(identical(other.foodTotal, _this.foodTotal) || other.foodTotal == _this.foodTotal)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&const DeepCollectionEquality().equals(other.foodItems, _this.foodItems)&&(identical(other.user, _this.user) || other.user == _this.user));
}


@override
int get hashCode {
  final _this = this as Quote;
  return Object.hash(runtimeType,_this.movieTitle,_this.hallName,_this.showDate,_this.showTime,const DeepCollectionEquality().hash(_this.seatCodes),_this.baseAmount,_this.morningDiscount,_this.weekendSurcharge,_this.subtotal,_this.promoCode,_this.discountAmount,_this.taxAmount,_this.serviceFee,const DeepCollectionEquality().hash(_this.foodLines),_this.foodTotal,_this.totalAmount,const DeepCollectionEquality().hash(_this.foodItems),_this.user);
}

@override
String toString() {
  final _this = this as Quote;
  return 'Quote(movieTitle: ${_this.movieTitle}, hallName: ${_this.hallName}, showDate: ${_this.showDate}, showTime: ${_this.showTime}, seatCodes: ${_this.seatCodes}, baseAmount: ${_this.baseAmount}, morningDiscount: ${_this.morningDiscount}, weekendSurcharge: ${_this.weekendSurcharge}, subtotal: ${_this.subtotal}, promoCode: ${_this.promoCode}, discountAmount: ${_this.discountAmount}, taxAmount: ${_this.taxAmount}, serviceFee: ${_this.serviceFee}, foodLines: ${_this.foodLines}, foodTotal: ${_this.foodTotal}, totalAmount: ${_this.totalAmount}, foodItems: ${_this.foodItems}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 String movieTitle, String hallName, String? showDate, String? showTime, List<String> seatCodes, num baseAmount, num morningDiscount, num weekendSurcharge, num subtotal, String? promoCode, num discountAmount, num taxAmount, num serviceFee, List<FoodLine> foodLines, num foodTotal, num totalAmount, List<FoodItem> foodItems, QuoteUser? user
});


$QuoteUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movieTitle = null,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? seatCodes = null,Object? baseAmount = null,Object? morningDiscount = null,Object? weekendSurcharge = null,Object? subtotal = null,Object? promoCode = freezed,Object? discountAmount = null,Object? taxAmount = null,Object? serviceFee = null,Object? foodLines = null,Object? foodTotal = null,Object? totalAmount = null,Object? foodItems = null,Object? user = freezed,}) {
  return _then(Quote(
movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,seatCodes: null == seatCodes ? _self.seatCodes : seatCodes // ignore: cast_nullable_to_non_nullable
as List<String>,baseAmount: null == baseAmount ? _self.baseAmount : baseAmount // ignore: cast_nullable_to_non_nullable
as num,morningDiscount: null == morningDiscount ? _self.morningDiscount : morningDiscount // ignore: cast_nullable_to_non_nullable
as num,weekendSurcharge: null == weekendSurcharge ? _self.weekendSurcharge : weekendSurcharge // ignore: cast_nullable_to_non_nullable
as num,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as num,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as num,serviceFee: null == serviceFee ? _self.serviceFee : serviceFee // ignore: cast_nullable_to_non_nullable
as num,foodLines: null == foodLines ? _self.foodLines : foodLines // ignore: cast_nullable_to_non_nullable
as List<FoodLine>,foodTotal: null == foodTotal ? _self.foodTotal : foodTotal // ignore: cast_nullable_to_non_nullable
as num,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num,foodItems: null == foodItems ? _self.foodItems : foodItems // ignore: cast_nullable_to_non_nullable
as List<FoodItem>,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as QuoteUser?,
  ));
}
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $QuoteUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [Quote].
extension QuotePatterns on Quote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quote value)  $default,){
final _that = this;
switch (_that) {
case _Quote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quote value)?  $default,){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String movieTitle,  String hallName,  String? showDate,  String? showTime,  List<String> seatCodes,  num baseAmount,  num morningDiscount,  num weekendSurcharge,  num subtotal,  String? promoCode,  num discountAmount,  num taxAmount,  num serviceFee,  List<FoodLine> foodLines,  num foodTotal,  num totalAmount,  List<FoodItem> foodItems,  QuoteUser? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.seatCodes,_that.baseAmount,_that.morningDiscount,_that.weekendSurcharge,_that.subtotal,_that.promoCode,_that.discountAmount,_that.taxAmount,_that.serviceFee,_that.foodLines,_that.foodTotal,_that.totalAmount,_that.foodItems,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String movieTitle,  String hallName,  String? showDate,  String? showTime,  List<String> seatCodes,  num baseAmount,  num morningDiscount,  num weekendSurcharge,  num subtotal,  String? promoCode,  num discountAmount,  num taxAmount,  num serviceFee,  List<FoodLine> foodLines,  num foodTotal,  num totalAmount,  List<FoodItem> foodItems,  QuoteUser? user)  $default,) {final _that = this;
switch (_that) {
case _Quote():
return $default(_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.seatCodes,_that.baseAmount,_that.morningDiscount,_that.weekendSurcharge,_that.subtotal,_that.promoCode,_that.discountAmount,_that.taxAmount,_that.serviceFee,_that.foodLines,_that.foodTotal,_that.totalAmount,_that.foodItems,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String movieTitle,  String hallName,  String? showDate,  String? showTime,  List<String> seatCodes,  num baseAmount,  num morningDiscount,  num weekendSurcharge,  num subtotal,  String? promoCode,  num discountAmount,  num taxAmount,  num serviceFee,  List<FoodLine> foodLines,  num foodTotal,  num totalAmount,  List<FoodItem> foodItems,  QuoteUser? user)?  $default,) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.movieTitle,_that.hallName,_that.showDate,_that.showTime,_that.seatCodes,_that.baseAmount,_that.morningDiscount,_that.weekendSurcharge,_that.subtotal,_that.promoCode,_that.discountAmount,_that.taxAmount,_that.serviceFee,_that.foodLines,_that.foodTotal,_that.totalAmount,_that.foodItems,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _Quote implements Quote {
  const _Quote({required this.movieTitle, required this.hallName, this.showDate, this.showTime, required  List<String> seatCodes, required this.baseAmount, required this.morningDiscount, required this.weekendSurcharge, required this.subtotal, this.promoCode, required this.discountAmount, required this.taxAmount, required this.serviceFee, required  List<FoodLine> foodLines, required this.foodTotal, required this.totalAmount, required  List<FoodItem> foodItems, this.user}): _seatCodes = seatCodes,_foodLines = foodLines,_foodItems = foodItems;
  

@override final  String movieTitle;
@override final  String hallName;
@override final  String? showDate;
@override final  String? showTime;
 final  List<String> _seatCodes;
@override List<String> get seatCodes {
  if (_seatCodes is EqualUnmodifiableListView) return _seatCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seatCodes);
}

@override final  num baseAmount;
@override final  num morningDiscount;
@override final  num weekendSurcharge;
@override final  num subtotal;
@override final  String? promoCode;
@override final  num discountAmount;
@override final  num taxAmount;
@override final  num serviceFee;
 final  List<FoodLine> _foodLines;
@override List<FoodLine> get foodLines {
  if (_foodLines is EqualUnmodifiableListView) return _foodLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foodLines);
}

@override final  num foodTotal;
@override final  num totalAmount;
 final  List<FoodItem> _foodItems;
@override List<FoodItem> get foodItems {
  if (_foodItems is EqualUnmodifiableListView) return _foodItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foodItems);
}

/// Signed-in customer; null for a guest.
@override final  QuoteUser? user;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.movieTitle, movieTitle) || other.movieTitle == movieTitle)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.showDate, showDate) || other.showDate == showDate)&&(identical(other.showTime, showTime) || other.showTime == showTime)&&const DeepCollectionEquality().equals(other.seatCodes, _seatCodes)&&(identical(other.baseAmount, baseAmount) || other.baseAmount == baseAmount)&&(identical(other.morningDiscount, morningDiscount) || other.morningDiscount == morningDiscount)&&(identical(other.weekendSurcharge, weekendSurcharge) || other.weekendSurcharge == weekendSurcharge)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.serviceFee, serviceFee) || other.serviceFee == serviceFee)&&const DeepCollectionEquality().equals(other.foodLines, _foodLines)&&(identical(other.foodTotal, foodTotal) || other.foodTotal == foodTotal)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.foodItems, _foodItems)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movieTitle,hallName,showDate,showTime,const DeepCollectionEquality().hash(_seatCodes),baseAmount,morningDiscount,weekendSurcharge,subtotal,promoCode,discountAmount,taxAmount,serviceFee,const DeepCollectionEquality().hash(_foodLines),foodTotal,totalAmount,const DeepCollectionEquality().hash(_foodItems),user);
}

@override
String toString() {
    return 'Quote(movieTitle: $movieTitle, hallName: $hallName, showDate: $showDate, showTime: $showTime, seatCodes: $seatCodes, baseAmount: $baseAmount, morningDiscount: $morningDiscount, weekendSurcharge: $weekendSurcharge, subtotal: $subtotal, promoCode: $promoCode, discountAmount: $discountAmount, taxAmount: $taxAmount, serviceFee: $serviceFee, foodLines: $foodLines, foodTotal: $foodTotal, totalAmount: $totalAmount, foodItems: $foodItems, user: $user)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 String movieTitle, String hallName, String? showDate, String? showTime, List<String> seatCodes, num baseAmount, num morningDiscount, num weekendSurcharge, num subtotal, String? promoCode, num discountAmount, num taxAmount, num serviceFee, List<FoodLine> foodLines, num foodTotal, num totalAmount, List<FoodItem> foodItems, QuoteUser? user
});


@override $QuoteUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movieTitle = null,Object? hallName = null,Object? showDate = freezed,Object? showTime = freezed,Object? seatCodes = null,Object? baseAmount = null,Object? morningDiscount = null,Object? weekendSurcharge = null,Object? subtotal = null,Object? promoCode = freezed,Object? discountAmount = null,Object? taxAmount = null,Object? serviceFee = null,Object? foodLines = null,Object? foodTotal = null,Object? totalAmount = null,Object? foodItems = null,Object? user = freezed,}) {
  return _then(_Quote(
movieTitle: null == movieTitle ? _self.movieTitle : movieTitle // ignore: cast_nullable_to_non_nullable
as String,hallName: null == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String,showDate: freezed == showDate ? _self.showDate : showDate // ignore: cast_nullable_to_non_nullable
as String?,showTime: freezed == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as String?,seatCodes: null == seatCodes ? _self._seatCodes : seatCodes // ignore: cast_nullable_to_non_nullable
as List<String>,baseAmount: null == baseAmount ? _self.baseAmount : baseAmount // ignore: cast_nullable_to_non_nullable
as num,morningDiscount: null == morningDiscount ? _self.morningDiscount : morningDiscount // ignore: cast_nullable_to_non_nullable
as num,weekendSurcharge: null == weekendSurcharge ? _self.weekendSurcharge : weekendSurcharge // ignore: cast_nullable_to_non_nullable
as num,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as num,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as num,serviceFee: null == serviceFee ? _self.serviceFee : serviceFee // ignore: cast_nullable_to_non_nullable
as num,foodLines: null == foodLines ? _self._foodLines : foodLines // ignore: cast_nullable_to_non_nullable
as List<FoodLine>,foodTotal: null == foodTotal ? _self.foodTotal : foodTotal // ignore: cast_nullable_to_non_nullable
as num,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num,foodItems: null == foodItems ? _self._foodItems : foodItems // ignore: cast_nullable_to_non_nullable
as List<FoodItem>,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as QuoteUser?,
  ));
}

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $QuoteUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$QuoteUser {

 String get name; String? get email; String? get phone;
/// Create a copy of QuoteUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteUserCopyWith<QuoteUser> get copyWith => _$QuoteUserCopyWithImpl<QuoteUser>(this as QuoteUser, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuoteUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteUser&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}


@override
int get hashCode {
  final _this = this as QuoteUser;
  return Object.hash(runtimeType,_this.name,_this.email,_this.phone);
}

@override
String toString() {
  final _this = this as QuoteUser;
  return 'QuoteUser(name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $QuoteUserCopyWith<$Res>  {
  factory $QuoteUserCopyWith(QuoteUser value, $Res Function(QuoteUser) _then) = _$QuoteUserCopyWithImpl;
@useResult
$Res call({
 String name, String? email, String? phone
});




}
/// @nodoc
class _$QuoteUserCopyWithImpl<$Res>
    implements $QuoteUserCopyWith<$Res> {
  _$QuoteUserCopyWithImpl(this._self, this._then);

  final QuoteUser _self;
  final $Res Function(QuoteUser) _then;

/// Create a copy of QuoteUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = freezed,Object? phone = freezed,}) {
  return _then(QuoteUser(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteUser].
extension QuoteUserPatterns on QuoteUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteUser value)  $default,){
final _that = this;
switch (_that) {
case _QuoteUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteUser value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteUser() when $default != null:
return $default(_that.name,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _QuoteUser():
return $default(_that.name,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _QuoteUser() when $default != null:
return $default(_that.name,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _QuoteUser implements QuoteUser {
  const _QuoteUser({required this.name, this.email, this.phone});
  

@override final  String name;
@override final  String? email;
@override final  String? phone;

/// Create a copy of QuoteUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteUserCopyWith<_QuoteUser> get copyWith => __$QuoteUserCopyWithImpl<_QuoteUser>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteUser&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,email,phone);
}

@override
String toString() {
    return 'QuoteUser(name: $name, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$QuoteUserCopyWith<$Res> implements $QuoteUserCopyWith<$Res> {
  factory _$QuoteUserCopyWith(_QuoteUser value, $Res Function(_QuoteUser) _then) = __$QuoteUserCopyWithImpl;
@override @useResult
$Res call({
 String name, String? email, String? phone
});




}
/// @nodoc
class __$QuoteUserCopyWithImpl<$Res>
    implements _$QuoteUserCopyWith<$Res> {
  __$QuoteUserCopyWithImpl(this._self, this._then);

  final _QuoteUser _self;
  final $Res Function(_QuoteUser) _then;

/// Create a copy of QuoteUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = freezed,Object? phone = freezed,}) {
  return _then(_QuoteUser(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$GuestInfo {

 String get name; String get phone; String get email;
/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestInfoCopyWith<GuestInfo> get copyWith => _$GuestInfoCopyWithImpl<GuestInfo>(this as GuestInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuestInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuestInfo&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email));
}


@override
int get hashCode {
  final _this = this as GuestInfo;
  return Object.hash(runtimeType,_this.name,_this.phone,_this.email);
}

@override
String toString() {
  final _this = this as GuestInfo;
  return 'GuestInfo(name: ${_this.name}, phone: ${_this.phone}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $GuestInfoCopyWith<$Res>  {
  factory $GuestInfoCopyWith(GuestInfo value, $Res Function(GuestInfo) _then) = _$GuestInfoCopyWithImpl;
@useResult
$Res call({
 String name, String phone, String email
});




}
/// @nodoc
class _$GuestInfoCopyWithImpl<$Res>
    implements $GuestInfoCopyWith<$Res> {
  _$GuestInfoCopyWithImpl(this._self, this._then);

  final GuestInfo _self;
  final $Res Function(GuestInfo) _then;

/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = null,Object? email = null,}) {
  return _then(GuestInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GuestInfo].
extension GuestInfoPatterns on GuestInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuestInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuestInfo value)  $default,){
final _that = this;
switch (_that) {
case _GuestInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuestInfo value)?  $default,){
final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
return $default(_that.name,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone,  String email)  $default,) {final _that = this;
switch (_that) {
case _GuestInfo():
return $default(_that.name,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone,  String email)?  $default,) {final _that = this;
switch (_that) {
case _GuestInfo() when $default != null:
return $default(_that.name,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _GuestInfo implements GuestInfo {
  const _GuestInfo({this.name = '', this.phone = '', this.email = ''});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String email;

/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuestInfoCopyWith<_GuestInfo> get copyWith => __$GuestInfoCopyWithImpl<_GuestInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuestInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,phone,email);
}

@override
String toString() {
    return 'GuestInfo(name: $name, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$GuestInfoCopyWith<$Res> implements $GuestInfoCopyWith<$Res> {
  factory _$GuestInfoCopyWith(_GuestInfo value, $Res Function(_GuestInfo) _then) = __$GuestInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone, String email
});




}
/// @nodoc
class __$GuestInfoCopyWithImpl<$Res>
    implements _$GuestInfoCopyWith<$Res> {
  __$GuestInfoCopyWithImpl(this._self, this._then);

  final _GuestInfo _self;
  final $Res Function(_GuestInfo) _then;

/// Create a copy of GuestInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,Object? email = null,}) {
  return _then(_GuestInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
