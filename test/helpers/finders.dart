import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The FilledButton at [key]: the keyed widget itself, or the one inside a keyed
/// `PrimaryButton` / `AppButton`.
FilledButton filledButtonIn(WidgetTester tester, Key key) => tester.widget<FilledButton>(find
    .descendant(of: find.byKey(key), matching: find.byWidgetPredicate((w) => w is FilledButton), matchRoot: true)
    .first);
