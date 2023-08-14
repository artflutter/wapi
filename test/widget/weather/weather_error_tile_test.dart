import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wapi/src/widget/weather/weather_error_tile.dart';

void main() {
  testWidgets(
      'WeatherErrorTile displays default error message when error is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(child: WeatherErrorTile(error: null)),
    ));

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets(
      'WeatherErrorTile displays the correct error message when error is provided',
      (WidgetTester tester) async {
    const errorMessage = 'Test Error Message';
    await tester.pumpWidget(const MaterialApp(
      home: Material(child: WeatherErrorTile(error: errorMessage)),
    ));

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('WeatherErrorTile has the correct error icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(child: WeatherErrorTile(error: null)),
    ));

    expect(find.byIcon(Icons.cloud_off), findsOneWidget);
  });
}
