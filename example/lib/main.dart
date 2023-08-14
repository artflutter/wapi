import 'package:wapi/wapi.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final apiClient = WeatherApiClient(apiKey: 'your_api_key');
  String location = 'London';
  DateTime date = DateTime.now();
  TemperatureUnits unit = TemperatureUnits.celsius;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WApi demo'),
      ),
      body: ListView(
        children: [
          InputDecorator(
            decoration: const InputDecoration(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Location'),
              ),
              border: InputBorder.none,
            ),
            child: ListTile(
              title: Text(location),
              onTap: () async {
                final updatedLocation =
                    await showModalBottomSheet<WeatherLocation>(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  useSafeArea: true,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      color: Colors.white,
                      child: Location(
                        apiClient: apiClient,
                      ),
                    );
                  },
                );

                if (updatedLocation != null) {
                  setState(() => location = updatedLocation.name);
                }
              },
            ),
          ),
          InputDecorator(
            decoration: const InputDecoration(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Date'),
              ),
              border: InputBorder.none,
            ),
            child: ListTile(
              title: Text('${date.year}-${date.month}-${date.day}'),
              onTap: () async {
                final updatedDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2023, 1, 1),
                  lastDate: DateTime.now().add(const Duration(days: 314)),
                );

                if (updatedDate != null) {
                  setState(() => date = updatedDate);
                }
              },
            ),
          ),
          InputDecorator(
            decoration: const InputDecoration(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Temperature units'),
              ),
              border: InputBorder.none,
            ),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  title: Text(
                    'Fahrenheit ${TemperatureUnits.fahrenheit.toString()}',
                  ),
                  value: TemperatureUnits.fahrenheit,
                  groupValue: unit,
                  onChanged: (value) => setState(() => unit = value!),
                ),
                RadioListTile(
                  title: Text('Celsius ${TemperatureUnits.celsius.toString()}'),
                  value: TemperatureUnits.celsius,
                  groupValue: unit,
                  onChanged: (value) => setState(() => unit = value!),
                )
              ],
            ),
          ),
          const Divider(thickness: 2),
          WeatherTile(
            apiClient: apiClient,
            query: location,
            date: date,
            unit: unit,
          ),
        ],
      ),
    );
  }
}
