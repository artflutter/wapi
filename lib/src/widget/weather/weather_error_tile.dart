import 'package:flutter/material.dart';

/// A widget that displays a tile with an error icon and an error message.
class WeatherErrorTile extends StatelessWidget {
  /// The error object that provides information about the error.
  final Object? error;

  /// Creates a [WeatherErrorTile] widget.
  ///
  /// The [key] argument is used to provide a specific key for the widget.
  /// The [error] argument is the error object that provides information about the error.
  /// Returns a widget that represents the tile for displaying an error.
  /// If the [error] is provided, its string representation will be used as the error message.
  /// If [error] is null, a default 'Error' message will be displayed.
  const WeatherErrorTile({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox.square(
        dimension: 64,
        child: Icon(Icons.cloud_off, size: 48),
      ),
      title: Text(error?.toString() ?? 'Error'),
    );
  }
}
