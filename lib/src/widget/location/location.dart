import 'package:flutter/material.dart';
import 'package:wapi/src/debouncer.dart';
import 'package:wapi/src/weather_api/weather_api_client.dart';
import 'package:wapi/src/widget/location/location_search.dart';

typedef LocationSearchBuilder = Widget Function(
  BuildContext context,
  String query,
  WeatherApiClient apiClient,
);

class Location extends StatefulWidget {
  final LocationSearchBuilder? locationSearchBuilder;
  final WeatherApiClient apiClient;

  const Location({
    Key? key,
    this.locationSearchBuilder,
    required this.apiClient,
  }) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  String query = '';

  @override
  void initState() {
    _controller.addListener(() {
      _debouncer.run(() {
        if (mounted) {
          setState(() => query = _controller.text);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = const Center(
      child: Text('Enter 3 or more letters to start search'),
    );

    if (query.length >= 3) {
      result = widget.locationSearchBuilder?.call(
            context,
            query,
            widget.apiClient,
          ) ??
          LocationSearch(
            query: query,
            apiClient: widget.apiClient,
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
          );
    }

    return Column(
      children: [
        Row(
          children: [
            const BackButton(),
            Expanded(
              child: TextField(controller: _controller),
            ),
          ],
        ),
        Expanded(child: result),
      ],
    );
  }
}

class LocationNoData extends StatelessWidget {
  const LocationNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No data'));
  }
}
