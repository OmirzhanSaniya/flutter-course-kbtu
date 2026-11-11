import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:students_async/main.dart';

void main() {
  testWidgets('home has three ways in', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('By hand'), findsOneWidget);
    expect(find.text('FutureBuilder'), findsOneWidget);
    expect(find.text('Countdown'), findsOneWidget);
  });

  testWidgets('by hand: spinner, then the list', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('By hand'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Loading students…'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Aida Nurlanova'), findsOneWidget);
    expect(find.text('—'), findsOneWidget); // Aruzhan has no gpa
  });

  testWidgets('by hand: Back during loading is clean', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('By hand'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pageBack(); // Back while the request is still running
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Loading students…'), findsNothing); // screen is gone
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('FutureBuilder: the Switch does not reload', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('FutureBuilder'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Aida Nurlanova'), findsOneWidget);
    for (var i = 0; i < 10; i++) {
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Aida Nurlanova'), findsOneWidget);
    }
  });

  testWidgets('countdown B: Back mid-count is clean', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Countdown'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('B: listen'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('7'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
    expect(tester.takeException(), isNull);
  });

  testWidgets('save: first pops, second shows the error', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final expectPop in [true, false]) {
      await tester.tap(find.text('By hand'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      // in flight: the button is disabled
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.onPressed, isNull);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      if (expectPop) {
        expect(find.text('By hand'), findsOneWidget);
      } else {
        expect(find.text('server rejected 6'), findsOneWidget);
      }
    }
  });
}
