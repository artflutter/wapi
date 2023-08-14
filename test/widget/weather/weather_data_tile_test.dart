import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wapi/src/weather_api/models/weather.dart';
import 'package:wapi/src/weather_api/models/weather_location.dart';
import 'package:wapi/src/widget/weather/temperature_units.dart';
import 'package:wapi/src/widget/weather/weather_data_tile.dart';
import 'package:wapi/src/widget/weather/weather_no_data_tile.dart';

final weather = Weather(
  location: WeatherLocation(
    id: 1,
    name: 'TestCity',
    region: 'TestRegion',
    country: 'TestCountry',
    lat: 0.0,
    lon: 0.0,
    url: null,
  ),
  forecast: WeatherForecast([
    WeatherForecastDay(
      date: DateTime.now(),
      dateEpoch: DateTime.now().millisecondsSinceEpoch,
      day: WeatherDaily(
        maxTempC: 20,
        maxTempF: 68,
        minTempC: 10,
        minTempF: 50,
        avgTempC: 15,
        avgTempF: 59,
        maxWindMph: 10,
        maxWindKph: 16,
        totalPrecipMm: 0.2,
        totalPrecipIn: 0.008,
        totalSnowCm: null,
        avgVisKm: 10,
        avgVisMiles: 6.2,
        avgHumidity: 80,
        dailyWillItRain: 1,
        dailyChanceOfRain: 80,
        dailyWillItSnow: 0,
        dailyChanceOfSnow: 0,
        condition: WeatherCondition(
          text: "Rainy",
          icon: "/path/to/icon",
          code: 123,
        ),
        uv: 5,
      ),
    ),
  ]),
);

void main() {
  testWidgets('WeatherDataTile displays celsius temperature',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: WeatherDataTile(
              weather: weather,
              unit: TemperatureUnits.celsius,
            ),
          ),
        ),
      );

      expect(
        find.text('Temp: 15.0 ${TemperatureUnits.celsius}'),
        findsOneWidget,
      );
    });
  });

  testWidgets('WeatherDataTile displays fahrenheit temperature',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: WeatherDataTile(
              weather: weather,
              unit: TemperatureUnits.fahrenheit,
            ),
          ),
        ),
      );

      expect(
        find.text('Temp: 59.0 ${TemperatureUnits.fahrenheit}'),
        findsOneWidget,
      );
    });
  });

  testWidgets('WeatherDataTile displays no data tile when forecast is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: WeatherDataTile(
            weather: Weather(
              location: weather.location,
              forecast: WeatherForecast([]), // Empty forecast
            ),
            unit: TemperatureUnits.celsius,
          ),
        ),
      ),
    );

    expect(find.byType(WeatherNoDataTile), findsOneWidget);
  });
}
