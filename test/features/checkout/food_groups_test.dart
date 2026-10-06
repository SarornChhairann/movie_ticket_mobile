import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/features/checkout/model/food_groups.dart';
import 'package:movie_ticket_mobile/features/checkout/model/quote.dart';

const caramel = FoodItem(id: 1, name: 'Caramel Popcorn', price: 4, stockQuantity: 0);
const cola = FoodItem(id: 2, name: 'Coca-Cola', description: 'Chilled can', price: 2, stockQuantity: 0);
const nachos = FoodItem(id: 3, name: 'Nachos', description: 'With cheese dip', price: 5, stockQuantity: 0);
const khmerCorn = FoodItem(id: 4, name: 'ពោតលីង', price: 3, stockQuantity: 0);
const icedTea = FoodItem(id: 5, name: 'Snack box', description: 'Comes with iced tea', price: 6, stockQuantity: 0);
const menu = [caramel, cola, nachos, khmerCorn, icedTea];

void main() {
  test('a popcorn name is Popcorn, a cola name is Drinks, an unmatched name is Snacks', () {
    expect(FoodGroup.of(caramel), FoodGroup.popcorn);
    expect(FoodGroup.of(khmerCorn), FoodGroup.popcorn);
    expect(FoodGroup.of(cola), FoodGroup.drinks);
    expect(FoodGroup.of(icedTea), FoodGroup.drinks, reason: 'the description counts too');
    expect(FoodGroup.of(nachos), FoodGroup.snacks);
  });

  test('every item is under All; Popcorn and Drinks items are not also Snacks', () {
    expect(menu.where(FoodGroup.all.includes), menu);
    expect(menu.where(FoodGroup.snacks.includes), [nachos]);
    expect(menu.where(FoodGroup.popcorn.includes), [caramel, khmerCorn]);
  });

  test('search is case-insensitive over name and description, including Khmer', () {
    expect(searchFood(menu, 'POPCORN'), [caramel]);
    expect(searchFood(menu, 'cheese'), [nachos]);
    expect(searchFood(menu, 'ពោត'), [khmerCorn]);
    expect(searchFood(menu, '  '), menu);
    expect(searchFood(menu, 'pizza'), isEmpty);
  });

  test('tabs with no items are hidden; order is fixed and All stays', () {
    expect(visibleGroups(menu), FoodGroup.values);
    expect(visibleGroups(searchFood(menu, 'cola')), [FoodGroup.all, FoodGroup.drinks]);
    expect(visibleGroups(const []), [FoodGroup.all]);
  });
}
