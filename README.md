## WAPI

This package provides access to the [WeatherApi](https://www.weatherapi.com/) api requests.

## Getting started

Register on the [WeatherApi.com](https://www.weatherapi.com/signup.aspx)
Obtain the API key from [dashboard](https://www.weatherapi.com/my/)

## Usage

```
WeatherTile(
    apiClient: WeatherApiClient(apiKey: 'your_api_key'),
    query: 'London',
    date: DateTime.now(),
    unit: TemperatureUnits.celsius,
);
```

```
WeatherTile.lanLng(
    apiClient: WeatherApiClient(apiKey: 'your_api_key'),
    lat: 50.43,
    lng: 30.52,
    date: DateTime.now(),
    unit: TemperatureUnits.celsius,
);
```

## Caching

You can use Dio interceptors to implement caching to reduce api calls.
Like https://pub.dev/packages/dio_cache_interceptor

```
WeatherTile(
    apiClient: WeatherApiClient(
        apiKey: 'your_api_key',
        httpClient: WeatherHttpClient(
            apiKey: 'd8264ed2c7d24da5ab194736231208',
            interceptors: [DioCacheInterceptor(options: options)],
        ),
    ),
    query: 'London',
    date: DateTime.now(),
    unit: TemperatureUnits.celsius,
);
```

## Additional information

For more features - run example app included in this repo.
