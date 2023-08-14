enum TemperatureUnits {
  fahrenheit,
  celsius;

  @override
  String toString() {
    switch (this) {
      case TemperatureUnits.celsius:
        return '°C';
      case TemperatureUnits.fahrenheit:
        return '°F';
    }
  }
}
