import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:wapi/wapi.dart';

class MockDio extends Mock implements Dio {
  BaseOptions? _options;

  @override
  BaseOptions get options => _options ??= BaseOptions();

  Interceptors? _interceptors;

  @override
  Interceptors get interceptors => _interceptors ??= Interceptors();
}

void main() {
  late WeatherHttpClient weatherHttpClient;
  late MockDio mockDio;
  const path = 'https://api.weatherapi.com/some_endpoint';

  setUp(() {
    mockDio = MockDio();
    weatherHttpClient = WeatherHttpClient(
      apiKey: 'your_api_key',
      httpClient: mockDio,
    );
  });

  group('get', () {
    test('successful API request', () async {
      final json = {'key': 'value'};
      final mockResponse = Response(
        requestOptions: RequestOptions(path: path),
        data: json,
        statusCode: 200,
      );
      when(
        () => mockDio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final response = await weatherHttpClient.get(path);

      expect(response, isNotNull);
      expect(response.requestOptions.path, path);
      expect(response.statusCode, 200);
      expect(response.data, json);
      verify(
        () => mockDio.get(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test('API error response', () async {
      final json = {
        'error': {'code': 123, 'message': 'API error'}
      };

      final mockResponse = Response(
        requestOptions: RequestOptions(path: path),
        data: json,
        statusCode: 400,
      );
      when(
        () => mockDio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockResponse);

      try {
        await weatherHttpClient.get(path);
      } catch (e) {
        expect(e, isA<WeatherApiException>());
      }

      verify(
        () => mockDio.get(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test('Network error', () async {
      when(
        () => mockDio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: path)),
      );

      try {
        await weatherHttpClient.get(path);
      } catch (e) {
        expect(e, isA<WeatherApiUnknownException>());
      }

      verify(
        () => mockDio.get(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });
  });
}
