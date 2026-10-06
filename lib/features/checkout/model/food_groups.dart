import 'quote.dart';

/// Display groups over the quote's food list. The API has no category column:
/// this is a label for the concessions screen, never a stored category.
enum FoodGroup {
  all('checkout.foodAll'),
  popcorn('checkout.foodPopcorn'),
  drinks('checkout.foodDrinks'),
  snacks('checkout.foodSnacks');

  const FoodGroup(this.labelKey);

  final String labelKey;

  /// The one keyword map. Checked in order; an item that matches none is a snack.
  static const _keywords = <FoodGroup, List<String>>{
    FoodGroup.popcorn: ['popcorn', 'ពោត'],
    FoodGroup.drinks: ['cola', 'coffee', 'tea', 'soda', 'សូដា', 'កាហ្វេ', 'តែ'],
  };

  /// The single named group of [item]: popcorn, drinks, or snacks (never [all]).
  static FoodGroup of(FoodItem item) {
    final text = _text(item);
    for (final e in _keywords.entries) {
      if (e.value.any(text.contains)) return e.key;
    }
    return FoodGroup.snacks;
  }

  bool includes(FoodItem item) => this == FoodGroup.all || of(item) == this;

  static String _text(FoodItem item) => '${item.name} ${item.description ?? ''}'.toLowerCase();
}

/// Case-insensitive search over name and description; a blank query keeps all.
List<FoodItem> searchFood(List<FoodItem> items, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return items;
  return [
    for (final item in items)
      if (item.name.toLowerCase().contains(q) || (item.description?.toLowerCase().contains(q) ?? false)) item,
  ];
}

/// The tabs to show for [items] (already searched), in fixed order. [FoodGroup.all]
/// always stays so a search miss keeps the tab row; other empty groups are hidden.
List<FoodGroup> visibleGroups(List<FoodItem> items) => [
      for (final group in FoodGroup.values)
        if (group == FoodGroup.all || items.any(group.includes)) group,
    ];
