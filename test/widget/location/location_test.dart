import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wapi/src/weather_api/models/weather_location.dart';
import 'package:wapi/src/widget/location/location.dart';
import 'package:wapi/src/widget/location/location_search.dart';
import 'package:wapi/src/weather_api/weather_api_client.dart';

// Mock the WeatherApiClient for the purpose of the test
class MockWeatherApiClient extends Mock implements WeatherApiClient {}

void main() {
  final mockApiClient = MockWeatherApiClient();

  group('Location widget tests', () {
    testWidgets('renders the initial message correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Material(child: Location(apiClient: mockApiClient))));
      expect(
          find.text('Enter 3 or more letters to start search'), findsOneWidget);
    });

    testWidgets('renders the default search widget for a query of length >= 3',
        (WidgetTester tester) async {
      when(
        () => mockApiClient.search(any()),
      ).thenAnswer(
        (_) async => [
          WeatherLocation.fromJson(
            {
              "id": 12345,
              "name": 'test',
              "region": "Sunshine Coast",
              "country": "FakeLand",
              "lat": 35.6789,
              "lon": -120.8765,
              "url": "https://www.fakeweather.com/sunnyville",
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: Location(apiClient: mockApiClient)),
        ),
      );
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle(
        const Duration(milliseconds: 400),
      );
      expect(find.byType(LocationSearch), findsOneWidget);
    });

    testWidgets('renders the custom search builder if provided',
        (WidgetTester tester) async {
      locationSearchBuilder(
          BuildContext context, String query, WeatherApiClient apiClient) {
        return const Text('Custom Search');
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Location(
              apiClient: mockApiClient,
              locationSearchBuilder: locationSearchBuilder,
            ),
          ),
        ),
      );
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle(
        const Duration(milliseconds: 400),
      );

      expect(find.text('Custom Search'), findsOneWidget);
    });

    testWidgets('contains a BackButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: Location(apiClient: mockApiClient)),
        ),
      );
      expect(find.byType(BackButton), findsOneWidget);
    });
  });

  group('LocationNoData widget tests', () {
    testWidgets('renders "No data" text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(child: LocationNoData()),
        ),
      );
      expect(find.text('No data'), findsOneWidget);
    });
  });
}
