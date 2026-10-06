import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/motion/crossfade_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/genre_chip.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/search_pill.dart';
import '../controller/checkout_bloc.dart';
import '../model/food_groups.dart';
import '../model/quote.dart';

/// The food shop over the checkout bloc's menu and cart. Pushed with the
/// checkout route's bloc, so popping keeps the quantities. Hold expiry and
/// re-quote errors are handled by the checkout page's listener underneath,
/// which pops this route too when the hold runs out.
class ConcessionsPage extends StatefulWidget {
  const ConcessionsPage({super.key});

  static const searchDebounce = Duration(milliseconds: 200);

  @override
  State<ConcessionsPage> createState() => _ConcessionsPageState();
}

class _ConcessionsPageState extends State<ConcessionsPage> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
  FoodGroup _group = FoodGroup.all;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(ConcessionsPage.searchDebounce, () {
      if (mounted) setState(() => _query = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('checkout.foodTitle'.tr(context: context)),
          actions: [
            if (state is CheckoutReady && state.secondsLeft != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Space.x2),
                child: Center(child: HoldLabel(secondsLeft: state.secondsLeft!, textKey: const Key('concessions.countdown'))),
              ),
          ],
        ),
        body: state is CheckoutReady ? _body(context, state) : const LoadingView(),
        bottomNavigationBar: state is CheckoutReady ? _DoneBar(state: state) : null,
      ),
    );
  }

  Widget _body(BuildContext context, CheckoutReady state) {
    final menu = state.quote.foodItems;
    final results = searchFood(menu, _query);
    // A search miss keeps the tab row of the whole menu.
    final groups = visibleGroups(results.isEmpty ? menu : results);
    final group = groups.contains(_group) ? _group : FoodGroup.all;
    final shown = [for (final item in results) if (group.includes(item)) item];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.screen, Space.x1, Space.screen, 0),
          child: SearchPill(
            fieldKey: const Key('concessions.search'),
            controller: _search,
            hint: 'checkout.foodSearch'.tr(context: context),
            onChanged: _onSearchChanged,
          ),
        ),
        SizedBox(
          height: Space.x6 + Space.x1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: Space.x1),
            children: [
              for (final g in groups)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: Space.x1),
                  child: GenreChip(
                    key: Key('concessions.tab.${g.name}'),
                    label: g.labelKey.tr(context: context),
                    selected: g == group,
                    onSelected: () => setState(() => _group = g),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Space.x3),
                  child: Text(
                    'checkout.foodEmpty'.tr(context: context),
                    key: const Key('concessions.empty'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final cell = (constraints.maxWidth - Space.screen * 2 - Space.x2) / 2;
                    return GridView.builder(
                      key: const Key('concessions.grid'),
                      padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, Space.x2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: Space.x2,
                        crossAxisSpacing: Space.x2,
                        // Square photo on top, then name, price, and the button.
                        mainAxisExtent: cell + 120,
                      ),
                      itemCount: shown.length,
                      itemBuilder: (context, i) =>
                          _FoodCard(item: shown[i], quantity: state.food[shown[i].id] ?? 0),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.item, required this.quantity});

  final FoodItem item;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      key: Key('food.${item.id}.card'),
      color: AppColors.navyRaised,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(aspectRatio: 1, child: FoodImage(url: item.imageUrl)),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.x1 + 4, Space.x1, Space.x1 + 4, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.titleSmall),
                Text(context.money(item.price), style: textTheme.bodySmall),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.x1, 0, Space.x1, Space.x1),
            child: _FoodStepper(item: item, quantity: quantity),
          ),
        ],
      ),
    );
  }
}

/// **Add** at quantity 0, otherwise `−  n  +`. Each tap sends [FoodChanged];
/// the bloc clamps to the stock. Plus is disabled at a limited stock's cap.
class _FoodStepper extends StatelessWidget {
  const _FoodStepper({required this.item, required this.quantity});

  final FoodItem item;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CheckoutBloc>();
    if (quantity == 0) {
      return FilledButton(
        key: Key('food.${item.id}.add'),
        onPressed: () => bloc.add(FoodChanged(item.id, 1)),
        child: Text('checkout.foodAdd'.tr(context: context)),
      );
    }
    final atMax = item.maxQuantity != null && quantity >= item.maxQuantity!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          key: Key('food.${item.id}.minus'),
          icon: const Icon(Icons.remove),
          onPressed: () => bloc.add(FoodChanged(item.id, quantity - 1)),
        ),
        Text('$quantity', key: Key('food.${item.id}.qty'), style: Theme.of(context).textTheme.titleMedium),
        IconButton.filled(
          key: Key('food.${item.id}.plus'),
          icon: const Icon(Icons.add),
          onPressed: atMax ? null : () => bloc.add(FoodChanged(item.id, quantity + 1)),
        ),
      ],
    );
  }
}

class _DoneBar extends StatelessWidget {
  const _DoneBar({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final units = state.food.values.fold(0, (sum, q) => sum + q);
    // The server's food total, once a quote including food has come back. While
    // a re-quote runs, the previous quote (and its total) stays.
    final hasFoodQuote = state.quote.foodLines.isNotEmpty;
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2, child: state.quoting ? const LinearProgressIndicator() : null),
            Padding(
              padding: const EdgeInsets.all(Space.x2),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'checkout.foodCount'.plural(units, context: context),
                          key: const Key('concessions.count'),
                          style: textTheme.bodySmall,
                        ),
                        if (hasFoodQuote && units > 0)
                          CrossfadeText(
                            context.money(state.quote.foodTotal),
                            textKey: const Key('concessions.foodTotal'),
                            style: textTheme.titleLarge,
                          ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: const Key('concessions.done'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('checkout.foodDone'.tr(context: context)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A food photo, or a simple food placeholder when there is none or it fails.
class FoodImage extends StatelessWidget {
  const FoodImage({super.key, required this.url});

  final String? url;

  static Widget _placeholder() => const ColoredBox(
        key: Key('food.placeholder'),
        color: AppColors.navyHigh,
        child: Center(child: Icon(Icons.fastfood_outlined, color: AppColors.mist)),
      );

  @override
  Widget build(BuildContext context) {
    final u = url?.trim();
    if (u == null || u.isEmpty) return _placeholder();
    return Image.network(
      u,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }
}

/// `seats.expiresIn` with the hold's `mm:ss`, shared by checkout and concessions.
class HoldLabel extends StatelessWidget {
  const HoldLabel({super.key, required this.secondsLeft, this.textKey});

  final int secondsLeft;
  final Key? textKey;

  static String mmss(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => Text(
        'seats.expiresIn'.tr(context: context, namedArgs: {'time': mmss(secondsLeft)}),
        key: textKey,
        style: Theme.of(context).textTheme.bodySmall,
      );
}
