import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_organizador/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Ruta inicial que debe existir en tu Routes.routes
    const String testRoute = '/home'; // o cualquier otra ruta válida

    await tester.pumpWidget(const MyApp(initialRoute: testRoute));

    await tester.pumpAndSettle();

    // Verifica que el contador inicie en 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Simula tap en el botón '+'
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador incrementó
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
