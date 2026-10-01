/// Display-only money formatting. Never use the result for arithmetic; totals
/// come from the server.
String formatMoney(num amount) => '\$${amount.toStringAsFixed(2)}';
