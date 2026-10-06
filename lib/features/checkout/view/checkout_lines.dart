part of 'checkout_page.dart';

/// The server's lines, in analytics 3.4 order. Zero discount/surcharge lines are hidden.
class _PriceLines extends StatelessWidget {
  const _PriceLines({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    Widget line(
      String key,
      num amount, {
      bool negative = false,
      bool bold = false,
    }) {
      final style = bold ? Theme.of(context).textTheme.titleMedium : null;
      return Padding(
        key: Key('line.$key'),
        padding: const EdgeInsets.symmetric(vertical: Space.x0_5),
        child: Row(
          children: [
            Expanded(
              child: Text('checkout.$key'.tr(context: context), style: style),
            ),
            CrossfadeText(
              '${negative ? '−' : ''}${context.money(amount)}',
              style: style,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        line('base', quote.baseAmount),
        if (quote.morningDiscount != 0)
          line('morningDiscount', quote.morningDiscount, negative: true),
        if (quote.weekendSurcharge != 0)
          line('weekendSurcharge', quote.weekendSurcharge),
        line('subtotal', quote.subtotal),
        if (quote.discountAmount != 0)
          line('promoDiscount', quote.discountAmount, negative: true),
        line('tax', quote.taxAmount),
        line('serviceFee', quote.serviceFee),
        if (quote.foodTotal != 0) line('food', quote.foodTotal),
        const Divider(),
        line('total', quote.totalAmount, bold: true),
      ],
    );
  }
}
