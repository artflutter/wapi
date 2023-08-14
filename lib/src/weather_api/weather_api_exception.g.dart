// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_api_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherApiError _$WeatherApiErrorFromJson(Map<String, dynamic> json) =>
    WeatherApiError(
      code: json['code'] as int,
      message: json['message'] as String,
    );

Map<String, dynamic> _$WeatherApiErrorToJson(WeatherApiError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
