import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio/main.dart';

void main() {
  testWidgets('Agregar un gasto y verificar que se muestre en la lista',
      (WidgetTester tester) async {
    // Construye la aplicación.
    await tester.pumpWidget(const MyApp());

    // Verifica que inicialmente no hay gastos en la lista.
    // Actualiza esta línea si el texto en pantalla inicial es diferente.
    expect(find.text('No hay gastos registrados'), findsOneWidget);

    // Simula un toque en el botón de agregar gasto.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Espera a que se complete la navegación.

    // Rellena el formulario de agregar gasto.
    // Asegúrate de que los labels "Monto" y "Descripción" coincidan exactamente con los labels de tus TextFields.
    await tester.enterText(find.bySemanticsLabel('Monto'), '100.0');
    await tester.enterText(find.bySemanticsLabel('Descripción'), 'Cena');

    // Toca el botón de 'Guardar' para agregar el gasto.
    await tester.tap(find.text('Guardar'));
    await tester
        .pumpAndSettle(); // Espera a que regrese a la pantalla principal.

    // Verifica que el nuevo gasto se muestra en la lista principal.
    expect(find.text('Cena'), findsOneWidget);
    expect(find.text('\$100.0'), findsOneWidget);
  });
}
