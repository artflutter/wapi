import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wapi/src/widget/weather/weather_no_data_tile.dart';

void main() {
  testWidgets('WeatherNoDataTile displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: WeatherNoDataTile(),
        ),
      ),
    );

    expect(find.byIcon(Icons.cloud_queue_rounded), findsOneWidget);

    expect(find.text('No data'), findsOneWidget);
  });
}
