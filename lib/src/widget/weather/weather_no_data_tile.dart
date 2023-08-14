import 'package:flutter/material.dart';

class WeatherNoDataTile extends StatelessWidget {
  const WeatherNoDataTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: SizedBox.square(
        dimension: 64,
        child: Icon(Icons.cloud_queue_rounded, size: 48),
      ),
      title: Text('No data'),
    );
  }
}
