import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asistencia_app/main.dart';

void main() {
  testWidgets('LoginScreen se muestra correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(AsistenciaApp());
    await tester.pumpAndSettle();

    // Verificar AppBar
    expect(find.descendant(
      of: find.byType(AppBar),
      matching: find.text('Login')
    ), findsOneWidget);

    // Verificar campos de texto
    expect(find.byType(TextField), findsNWidgets(2));

    // Verificar botones
    expect(find.text('Login'), findsOneWidget); // este encuentra el botón
    expect(find.text('Registrarse'), findsOneWidget);
  });
}
