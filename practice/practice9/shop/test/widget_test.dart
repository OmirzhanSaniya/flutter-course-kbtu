import 'package:flutter_test/flutter_test.dart';

import 'package:shop/main.dart';

void main() {
  testWidgets('Books screen shows the books', (WidgetTester tester) async {
    await tester.pumpWidget(const Shell());

    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Widgets All the Way Down'), findsOneWidget);
  });
}
