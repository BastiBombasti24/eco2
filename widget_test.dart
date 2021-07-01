// @dart=2.9

import 'package:code/MainWindow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // Converts the output string from a find (example: find.text("Auto").toString()) into the number of found Objects (int)
  int getCountOfFoundWidgets (String string) {
    if (string.contains("zero")) {
      return 0;
    } else if (string.contains("one")) {
      return 1;
    } else {
      return int.parse(string.substring(0, 1));
    }
  }

  // Adds one activity "Autofahrt" to activities
  // Tests, if one "Autofahrt" activity was added
  Future<void> _addActivity (WidgetTester tester) async {

    // Go to "Erfassen"
    await tester.tap(find.byIcon(Icons.playlist_add));
    await tester.pump();

    // Get count of "Autofahrt" activities
    int autoEntryCount = getCountOfFoundWidgets(find.text("Auto").toString());

    // Click add Button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text("Kategorie"), findsOneWidget);

    // Open Dropdown
    await tester.tap(find.text("Kategorie"));
    await tester.pump();

    expect(find.text("Autofahrt"), findsWidgets);

    // Chose "Autofahrt" from Dropdown
    await tester.tap(find.text("Autofahrt").last);
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);

    // Type 200 into TextField
    await tester.enterText(find.byType(TextField), '200');
    await tester.pump();

    // Click check Button
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    
    expect(find.text("Auto"), findsNWidgets(autoEntryCount + 1));
    expect(find.text("5.85 kg"), findsNWidgets(autoEntryCount + 1));
  }

  testWidgets('Test adding Activity', (WidgetTester tester) async {

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MainWindow(
      ),
    ));

    // Add activity
    await _addActivity(tester);
  });

  testWidgets('Test Dashboard after adding Activity', (WidgetTester tester) async {

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MainWindow(
      ),
    ));

    // Add activity
    await _addActivity(tester);

    // Get count of "Autofahrt" activities
    int autoEntryCount = getCountOfFoundWidgets(find.text("Auto").toString());

    // Go to "Dashboard"
    await tester.tap(find.byIcon(Icons.home));
    await tester.pump();

    expect(find.text("Dein monatlicher CO2-Ausstoß"), findsOneWidget);

    // Calculate actual CO" output
    double calculatedCO2output = autoEntryCount * 5.85;

    expect(find.text( calculatedCO2output.toStringAsFixed(2) + " kg"), findsOneWidget);

    // Go down to Category List
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pump();

    expect(find.text( calculatedCO2output.toStringAsFixed(2) + " kg"), findsWidgets);

  });

  testWidgets('Test Profil', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MainWindow(
      ),
    ));

    // Go to "Profil"
    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();

    expect(find.text("Basti hats drauf"), findsNothing);

  });

}
