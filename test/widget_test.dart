import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trekka/app/app.dart';

void main() {
  testWidgets('splash animates and navigates to placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TrekkaApp()),
    );

    expect(find.byKey(const ValueKey<String>('splash_logo_image')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('splash_loader_image')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100 + 500 * 4 + 10000 + 400));
    await tester.pumpAndSettle();

    expect(find.text('Placeholder Screen'), findsOneWidget);
  });
}
