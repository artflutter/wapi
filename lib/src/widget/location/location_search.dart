import 'package:flutter/material.dart';
import 'package:wapi/wapi.dart';

typedef WeatherLocationDataBuilder = Widget Function(
  BuildContext context,
  WeatherLocation weather,
);

class LocationSearch extends StatefulWidget {
  final WeatherApiClient apiClient;

  final String query;

  final NoDataBuilder? noDataBuilder;

  final ErrorDataBuilder? errorDataBuilder;

  final WeatherLocationDataBuilder? dataBuilder;

  final ValueChanged<WeatherLocation> onChanged;

  const LocationSearch({
    Key? key,
    required this.query,
    required this.apiClient,
    this.noDataBuilder,
    this.errorDataBuilder,
    this.dataBuilder,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  late Future<List<WeatherLocation>> _searchFuture;

  @override
  void initState() {
    _searchFuture = fetchWeatherLocation(widget.query);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LocationSearch oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isSameQuery = widget.query == oldWidget.query;

    if (!isSameQuery) {
      _searchFuture = fetchWeatherLocation(widget.query);
    }
  }

  Future<List<WeatherLocation>> fetchWeatherLocation(String query) =>
      widget.apiClient.search(query);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WeatherLocation>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        final data = snapshot.data;
        Widget tile = Center(
          child:
              widget.noDataBuilder?.call(context) ?? const WeatherNoDataTile(),
        );

        if (data != null) {
          tile = ListView.builder(
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () => widget.onChanged(data[i]),
                child: widget.dataBuilder?.call(context, data[i]) ??
                    WeatherLocationDataTile(weatherLocation: data[i]),
              );
            },
            itemCount: data.length,
          );
        }

        if (snapshot.hasError) {
          tile = widget.errorDataBuilder?.call(context, snapshot.error) ??
              WeatherLocationErrorTile(error: snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            children: [
              Opacity(opacity: 0.4, child: tile),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        }

        return tile;
      },
    );
  }
}

class WeatherLocationDataTile extends StatelessWidget {
  final WeatherLocation weatherLocation;

  const WeatherLocationDataTile({super.key, required this.weatherLocation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox.square(
        dimension: 64,
        child: Icon(Icons.pin_drop, size: 32),
      ),
      title: Text('${weatherLocation.country} ${weatherLocation.name}'),
    );
  }
}

class WeatherLocationErrorTile extends StatelessWidget {
  final Object? error;

  const WeatherLocationErrorTile({Key? key, required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox.square(
        dimension: 64,
        child: Icon(Icons.pin_drop, size: 32),
      ),
      title: Text(error?.toString() ?? 'Error'),
    );
  }
}
