// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      location:
          WeatherLocation.fromJson(json['location'] as Map<String, dynamic>),
      forecast:
          WeatherForecast.fromJson(json['forecast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'location': instance.location,
      'forecast': instance.forecast,
    };

WeatherForecastDay _$WeatherForecastDayFromJson(Map<String, dynamic> json) =>
    WeatherForecastDay(
      date: DateTime.parse(json['date'] as String),
      dateEpoch: json['date_epoch'] as int,
      day: WeatherDaily.fromJson(json['day'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherForecastDayToJson(WeatherForecastDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'date_epoch': instance.dateEpoch,
      'day': instance.day,
    };

WeatherDaily _$WeatherDailyFromJson(Map<String, dynamic> json) => WeatherDaily(
      maxTempC: (json['maxtemp_c'] as num).toDouble(),
      maxTempF: (json['maxtemp_f'] as num).toDouble(),
      minTempC: (json['mintemp_c'] as num).toDouble(),
      minTempF: (json['mintemp_f'] as num).toDouble(),
      avgTempC: (json['avgtemp_c'] as num).toDouble(),
      avgTempF: (json['avgtemp_f'] as num).toDouble(),
      maxWindMph: (json['maxwind_mph'] as num).toDouble(),
      maxWindKph: (json['maxwind_kph'] as num).toDouble(),
      totalPrecipMm: (json['totalprecip_mm'] as num).toDouble(),
      totalPrecipIn: (json['totalprecip_in'] as num).toDouble(),
      totalSnowCm: (json['totalsnow_cm'] as num?)?.toDouble(),
      avgVisKm: (json['avgvis_km'] as num).toDouble(),
      avgVisMiles: (json['avgvis_miles'] as num).toDouble(),
      avgHumidity: (json['avghumidity'] as num).toDouble(),
      dailyWillItRain: (json['daily_will_it_rain'] as num?)?.toDouble(),
      dailyChanceOfRain: (json['daily_chance_of_rain'] as num?)?.toDouble(),
      dailyWillItSnow: (json['daily_will_it_snow'] as num?)?.toDouble(),
      dailyChanceOfSnow: (json['daily_chance_of_snow'] as num?)?.toDouble(),
      condition:
          WeatherCondition.fromJson(json['condition'] as Map<String, dynamic>),
      uv: (json['uv'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherDailyToJson(WeatherDaily instance) =>
    <String, dynamic>{
      'maxtemp_c': instance.maxTempC,
      'maxtemp_f': instance.maxTempF,
      'mintemp_c': instance.minTempC,
      'mintemp_f': instance.minTempF,
      'avgtemp_c': instance.avgTempC,
      'avgtemp_f': instance.avgTempF,
      'maxwind_mph': instance.maxWindMph,
      'maxwind_kph': instance.maxWindKph,
      'totalprecip_mm': instance.totalPrecipMm,
      'totalprecip_in': instance.totalPrecipIn,
      'totalsnow_cm': instance.totalSnowCm,
      'avgvis_km': instance.avgVisKm,
      'avgvis_miles': instance.avgVisMiles,
      'avghumidity': instance.avgHumidity,
      'daily_will_it_rain': instance.dailyWillItRain,
      'daily_chance_of_rain': instance.dailyChanceOfRain,
      'daily_will_it_snow': instance.dailyWillItSnow,
      'daily_chance_of_snow': instance.dailyChanceOfSnow,
      'condition': instance.condition,
      'uv': instance.uv,
    };

WeatherCondition _$WeatherConditionFromJson(Map<String, dynamic> json) =>
    WeatherCondition(
      text: json['text'] as String,
      icon: json['icon'] as String,
      code: json['code'] as int,
    );

Map<String, dynamic> _$WeatherConditionToJson(WeatherCondition instance) =>
    <String, dynamic>{
      'text': instance.text,
      'icon': instance.icon,
      'code': instance.code,
    };

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    WeatherForecast(
      (json['forecastday'] as List<dynamic>)
          .map((e) => WeatherForecastDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherForecastToJson(WeatherForecast instance) =>
    <String, dynamic>{
      'forecastday': instance.forecastDay,
    };
