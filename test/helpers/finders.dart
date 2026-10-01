import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The FilledButton inside a keyed `PrimaryButton`.
FilledButton filledButtonIn(WidgetTester tester, Key key) =>
    tester.widget<FilledButton>(find.descendant(of: find.byKey(key), matching: find.byWidgetPredicate((w) => w is FilledButton)));
