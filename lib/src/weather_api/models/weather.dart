import 'package:json_annotation/json_annotation.dart';
import 'package:wapi/src/weather_api/models/weather_location.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  final WeatherLocation location;
  final WeatherForecast forecast;

  Weather({
    required this.location,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class WeatherForecastDay {
  final DateTime date;
  @JsonKey(name: 'date_epoch')
  final int dateEpoch;
  final WeatherDaily day;

  WeatherForecastDay({
    required this.date,
    required this.dateEpoch,
    required this.day,
  });

  factory WeatherForecastDay.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastDayFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastDayToJson(this);
}

@JsonSerializable()
class WeatherDaily {
  @JsonKey(name: 'maxtemp_c')
  final double maxTempC;
  @JsonKey(name: 'maxtemp_f')
  final double maxTempF;
  @JsonKey(name: 'mintemp_c')
  final double minTempC;
  @JsonKey(name: 'mintemp_f')
  final double minTempF;
  @JsonKey(name: 'avgtemp_c')
  final double avgTempC;
  @JsonKey(name: 'avgtemp_f')
  final double avgTempF;
  @JsonKey(name: 'maxwind_mph')
  final double maxWindMph;
  @JsonKey(name: 'maxwind_kph')
  final double maxWindKph;
  @JsonKey(name: 'totalprecip_mm')
  final double totalPrecipMm;
  @JsonKey(name: 'totalprecip_in')
  final double totalPrecipIn;
  @JsonKey(name: 'totalsnow_cm')
  final double? totalSnowCm;
  @JsonKey(name: 'avgvis_km')
  final double avgVisKm;
  @JsonKey(name: 'avgvis_miles')
  final double avgVisMiles;
  @JsonKey(name: 'avghumidity')
  final double avgHumidity;
  @JsonKey(name: 'daily_will_it_rain')
  final double? dailyWillItRain;
  @JsonKey(name: 'daily_chance_of_rain')
  final double? dailyChanceOfRain;
  @JsonKey(name: 'daily_will_it_snow')
  final double? dailyWillItSnow;
  @JsonKey(name: 'daily_chance_of_snow')
  final double? dailyChanceOfSnow;
  final WeatherCondition condition;
  final double uv;

  WeatherDaily({
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindMph,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.totalPrecipIn,
    required this.totalSnowCm,
    required this.avgVisKm,
    required this.avgVisMiles,
    required this.avgHumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
  });

  factory WeatherDaily.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyToJson(this);
}

@JsonSerializable()
class WeatherCondition {
  final String text;
  final String icon;
  final int code;

  WeatherCondition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherConditionToJson(this);
}

@JsonSerializable()
class WeatherForecast {
  @JsonKey(name: 'forecastday')
  final List<WeatherForecastDay> forecastDay;

  WeatherForecast(this.forecastDay);

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}
