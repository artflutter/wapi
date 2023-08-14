import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wapi/src/weather_api/models/weather.dart';
import 'package:wapi/src/weather_api/weather_api_client.dart';
import 'package:wapi/src/widget/weather/weather_data_tile.dart';
import 'package:wapi/src/widget/weather/weather_error_tile.dart';
import 'package:wapi/src/widget/weather/weather_tile.dart';

final weather = {
  "location": {
    "id": 456,
    "name": 'New York',
    "region": "Demo Region",
    "country": "Demo Country",
    "lat": 42.123,
    "lon": -73.456,
    "url": "https://sampleville.example"
  },
  "forecast": {
    "forecastday": [
      {
        "date": "2023-08-15T00:00:00Z",
        "date_epoch": 1679040000,
        "day": {
          "maxtemp_c": 25.2,
          "maxtemp_f": 77.4,
          "mintemp_c": 18.6,
          "mintemp_f": 65.5,
          "avgtemp_c": 22.4,
          "avgtemp_f": 72.3,
          "maxwind_mph": 10.2,
          "maxwind_kph": 16.4,
          "totalprecip_mm": 1.8,
          "totalprecip_in": 0.07,
          "totalsnow_cm": 0.0,
          "avgvis_km": 9.5,
          "avgvis_miles": 5.9,
          "avghumidity": 68.5,
          "daily_will_it_rain": 1.0,
          "daily_chance_of_rain": 60.0,
          "daily_will_it_snow": 0.0,
          "daily_chance_of_snow": 0.0,
          "condition": {
            "text": "Sunny",
            "icon": "https://sampleville.example/icons/sunny.png",
            "code": 1000
          },
          "uv": 8.5
        }
      }
    ]
  }
};

class MockWeatherApiClient extends Mock implements WeatherApiClient {}

void main() {
  late MockWeatherApiClient mockApiClient;

  setUpAll(() {
    registerFallbackValue(DateTime(2000)); // Some arbitrary fallback value
    registerFallbackValue(''); // Some arbitrary fallback value
  });

  setUp(() {
    mockApiClient = MockWeatherApiClient();
  });

  Future<void> pumpWeatherTile(WidgetTester tester, WeatherTile widget) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );
  }

  testWidgets('displays loading indicator while fetching data', (tester) async {
    when(() => mockApiClient.weather(any(), any())).thenAnswer((_) async {
      return Weather.fromJson(weather); // Replace with sample data
    });

    final widget = WeatherTile(
      apiClient: mockApiClient,
      query: 'query',
    );

    await pumpWeatherTile(tester, widget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays data when loaded', (tester) async {
    final sampleWeather = Weather.fromJson(weather);

    when(() => mockApiClient.weather(any(), any()))
        .thenAnswer((_) async => sampleWeather);

    mockNetworkImagesFor(() async {
      final widget = WeatherTile(
        apiClient: mockApiClient,
        query: 'query',
      );

      await pumpWeatherTile(tester, widget);
      await tester.pumpAndSettle();

      expect(find.byType(WeatherDataTile), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });
  });

  testWidgets('displays error tile when an error occurs', (tester) async {
    when(() => mockApiClient.weather(any(), any())).thenAnswer(
      (invocation) async => throw Exception('Error loading data'),
    );

    final widget = WeatherTile(
      apiClient: mockApiClient,
      query: 'query',
    );

    await pumpWeatherTile(tester, widget);
    await tester.pumpAndSettle();

    expect(find.byType(WeatherErrorTile), findsOneWidget);
  });
}
