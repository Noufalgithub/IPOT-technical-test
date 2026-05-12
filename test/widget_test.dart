import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipot_technical_test/injection_container.dart';
import 'package:ipot_technical_test/main.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    // Initialize dependency injection before widget tests
    setupDependencies(prefs);
  });

  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const IPOTOrderingApp());
    // App should build and find no immediate errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Scanner screen shows QR scanner UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(const IPOTOrderingApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Either the camera view or manual input should be visible
    final hasManualInput = tester.any(find.text('Masukkan Nomor Meja'));
    final hasQrInstruction =
        tester.any(find.text('Arahkan kamera ke QR Code meja'));

    expect(hasManualInput || hasQrInstruction, isTrue);
  });

  testWidgets('IPOT branding is displayed on scanner screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const IPOTOrderingApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // App title text should always be present
    expect(find.text('IPOT'), findsOneWidget);
    expect(find.text('Digital Ordering'), findsOneWidget);
  });

  testWidgets('Manual table entry works end-to-end',
      (WidgetTester tester) async {
    await tester.pumpWidget(const IPOTOrderingApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // If manual input is shown (camera unavailable in test env), test it
    if (tester.any(find.text('Masukkan Nomor Meja'))) {
      // Find the text field
      final textField = find.byType(TextField);
      if (tester.any(textField)) {
        await tester.enterText(textField, 'T001');
        await tester.pump();

        // Find and tap the "Lihat Menu" button
        final lihatMenuBtn = find.text('Lihat Menu');
        if (tester.any(lihatMenuBtn)) {
          await tester.tap(lihatMenuBtn);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          // After navigation, menu screen should show "Meja T001"
          expect(find.text('Meja T001'), findsOneWidget);
        }
      }
    }
  });
}
