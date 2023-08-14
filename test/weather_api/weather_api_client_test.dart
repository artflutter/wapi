import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:wapi/src/weather_api/models/weather.dart';
import 'package:wapi/src/weather_api/weather_api_client.dart';
import 'package:wapi/src/weather_api/models/weather_location.dart';
import 'package:wapi/src/weather_api/weather_http_client.dart';

class MockWeatherHttpClient extends Mock implements WeatherHttpClient {}

final location = {
  "id": 456,
  "name": 'New York',
  "region": "Demo Region",
  "country": "Demo Country",
  "lat": 42.123,
  "lon": -73.456,
  "url": "https://sampleville.example"
};

void main() {
  late WeatherApiClient weatherApiClient;
  late MockWeatherHttpClient mockHttpClient;
  const path = 'https://api.weatherapi.com/some_endpoint';

  setUp(() {
    mockHttpClient = MockWeatherHttpClient();
    weatherApiClient = WeatherApiClient(
      apiKey: 'your_api_key',
      httpClient: mockHttpClient,
    );
  });

  group('WeatherApiClient', () {
    test('search - returns a list of WeatherLocation', () async {
      const query = 'New York';
      final fakeResponse = [
        {
          "id": 12345,
          "name": query,
          "region": "Sunshine Coast",
          "country": "FakeLand",
          "lat": 35.6789,
          "lon": -120.8765,
          "url": "https://www.fakeweather.com/sunnyville",
        },
        {
          "id": 12345,
          "name": "New yourk 2",
          "region": "Sunshine Coast",
          "country": "FakeLand",
          "lat": 35.6789,
          "lon": -120.8765,
          "url": "https://www.fakeweather.com/sunnyville",
        },
      ];

      when(
        () => mockHttpClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: fakeResponse,
          statusCode: 200,
        ),
      );

      final locations = await weatherApiClient.search(query);

      expect(locations, isA<List<WeatherLocation>>());
      expect(locations.length, fakeResponse.length);
    });

    test('forecast - returns a Weather object for a specific date', () async {
      const query = 'New York';
      final fakeDate = DateTime(2023, 8, 14);
      final fakeResponse = {
        "location": location,
        "forecast": {
          "forecastday": [
            {
              "date": "2023-08-14T00:00:00Z",
              "date_epoch": 1678953600,
              "day": {
                "maxtemp_c": 28.5,
                "maxtemp_f": 83.3,
                "mintemp_c": 20.7,
                "mintemp_f": 69.3,
                "avgtemp_c": 24.8,
                "avgtemp_f": 76.6,
                "maxwind_mph": 12.5,
                "maxwind_kph": 20.1,
                "totalprecip_mm": 2.5,
                "totalprecip_in": 0.1,
                "totalsnow_cm": 0.0,
                "avgvis_km": 10.0,
                "avgvis_miles": 6.2,
                "avghumidity": 75.0,
                "daily_will_it_rain": 1.0,
                "daily_chance_of_rain": 80.0,
                "daily_will_it_snow": 0.0,
                "daily_chance_of_snow": 0.0,
                "condition": {
                  "text": "Partly Cloudy",
                  "icon": "https://example.com/icons/partly_cloudy.png",
                  "code": 1003
                },
                "uv": 7.8
              }
            }
          ]
        }
      };

      when(
        () => mockHttpClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: fakeResponse,
          statusCode: 200,
        ),
      );

      final weather = await weatherApiClient.forecast(query, fakeDate, 1);

      expect(weather, isA<Weather>());
      // Add more assertions based on the expected response data
    });

    // Add similar tests for history and future methods

    test('weather - returns appropriate data for a specific date', () async {
      const query = 'New York';
      final pastDate = DateTime(2023, 1, 1);
      final futureDate = DateTime(2023, 8, 21);
      final futureDate2 = DateTime(2023, 11, 21);
      final forecastResponse = {
        "location": location,
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
      final historyResponse = {
        "location": location,
        "forecast": {
          "forecastday": [
            {
              "date": "2023-08-16T00:00:00Z",
              "date_epoch": 1679126400,
              "day": {
                "maxtemp_c": 22.8,
                "maxtemp_f": 73.0,
                "mintemp_c": 16.2,
                "mintemp_f": 61.2,
                "avgtemp_c": 19.5,
                "avgtemp_f": 67.1,
                "maxwind_mph": 8.7,
                "maxwind_kph": 14.0,
                "totalprecip_mm": 0.5,
                "totalprecip_in": 0.02,
                "totalsnow_cm": 0.0,
                "avgvis_km": 8.8,
                "avgvis_miles": 5.5,
                "avghumidity": 71.2,
                "daily_will_it_rain": 0.0,
                "daily_chance_of_rain": 20.0,
                "daily_will_it_snow": 0.0,
                "daily_chance_of_snow": 0.0,
                "condition": {
                  "text": "Clear Sky",
                  "icon": "https://fictitious.example/icons/clear_sky.png",
                  "code": 1001
                },
                "uv": 6.7
              }
            }
          ]
        }
      };
      final futureResponse = {
        "location": location,
        "forecast": {
          "forecastday": [
            {
              "date": "2023-08-17T00:00:00Z",
              "date_epoch": 1679212800,
              "day": {
                "maxtemp_c": 30.0,
                "maxtemp_f": 86.0,
                "mintemp_c": 22.3,
                "mintemp_f": 72.1,
                "avgtemp_c": 26.7,
                "avgtemp_f": 80.1,
                "maxwind_mph": 14.2,
                "maxwind_kph": 22.9,
                "totalprecip_mm": 3.0,
                "totalprecip_in": 0.12,
                "totalsnow_cm": 0.0,
                "avgvis_km": 9.0,
                "avgvis_miles": 5.6,
                "avghumidity": 77.8,
                "daily_will_it_rain": 1.0,
                "daily_chance_of_rain": 70.0,
                "daily_will_it_snow": 0.0,
                "daily_chance_of_snow": 0.0,
                "condition": {
                  "text": "Showers",
                  "icon": "https://jsonville.example/icons/showers.png",
                  "code": 1030
                },
                "uv": 7.2
              }
            }
          ]
        }
      };

      when(
        () => mockHttpClient.get(
          '/v1/forecast.json',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: forecastResponse,
          statusCode: 200,
        ),
      );
      when(
        () => mockHttpClient.get(
          '/v1/history.json',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: historyResponse,
          statusCode: 200,
        ),
      );
      when(
        () => mockHttpClient.get(
          '/v1/future.json',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: futureResponse,
          statusCode: 200,
        ),
      );

      final forecastWeather = await weatherApiClient.weather(query, pastDate);
      verify(
        () => mockHttpClient.get(
          '/v1/history.json',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);

      final historyWeather = await weatherApiClient.weather(query, futureDate);
      verify(
        () => mockHttpClient.get(
          '/v1/forecast.json',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);

      final futureWeather = await weatherApiClient.weather(query, futureDate2);
      verify(
        () => mockHttpClient.get(
          '/v1/future.json',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);

      expect(forecastWeather, isNotNull);
      expect(forecastWeather, isA<Weather>());

      expect(historyWeather, isNotNull);
      expect(historyWeather, isA<Weather>());

      expect(futureWeather, isA<Weather>());
      expect(futureWeather, isNotNull);

      verifyNoMoreInteractions(mockHttpClient);
    });
  });
}
