import 'package:flutter_test/flutter_test.dart';
import 'package:wapi/src/widget/weather/temperature_units.dart';

void main() {
  test('TemperatureUnits toString method', () {
    expect(TemperatureUnits.celsius.toString(), '°C');
    expect(TemperatureUnits.fahrenheit.toString(), '°F');
  });
}
