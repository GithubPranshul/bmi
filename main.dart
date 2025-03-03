import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(BMIGaugeApp());
}

class BMIGaugeApp extends StatefulWidget {
  @override
  State<BMIGaugeApp> createState() => _BMIGaugeAppState();
}

class _BMIGaugeAppState extends State<BMIGaugeApp> {
  bool isDarkMode = false; // Default theme is light

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: TextTheme(titleMedium: TextStyle(color: Colors.white)),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // Manual theme switch
      home: BMIScreen(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class BMIScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final double weight = 72; // kg
  final double height = 1.75; // meters
  final double bmi;
  var isBluetoothOrWifi = false;

  BMIScreen({required this.toggleTheme, required this.isDarkMode})
      : bmi = double.parse((72 / (1.75 * 1.75)).toStringAsFixed(1));

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text("BMI Gauges"),     actions: [
        IconButton(
          icon: Icon(Icons.wifi, color:!isBluetoothOrWifi?Colors.blue: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.bluetooth, color: isBluetoothOrWifi?Colors.blue:isDarkMode ? Colors.white : Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: toggleTheme,
        ),
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row with Weight & Height Gauges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGauge("Weight", weight, 40, 150, "kg", Colors.blue, isDarkMode),
                _buildGauge("Height", height, 1, 2.5, "m", Colors.purple, isDarkMode),
              ],
            ),
            SizedBox(height: 20),
            // Bottom BMI Gauge
            _buildBMIGauge(isDarkMode),
          ],
        ),
      ),
    );
  }

  // Function to build a simple gauge
  Widget _buildGauge(String title, double value, double min, double max, String unit, Color color, bool isDarkMode) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        SizedBox(
          height: 200,
          width: 180,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: min,
                maximum: max,
                axisLineStyle: AxisLineStyle(thickness: 10, color: color.withOpacity(0.3)),
                pointers: <GaugePointer>[
                  NeedlePointer(value: value, enableAnimation: true, needleColor: isDarkMode ? Colors.white : color),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      "$value $unit",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    angle: 90,
                    positionFactor: 0.7,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to build the BMI gauge with categories
  Widget _buildBMIGauge(bool isDarkMode) {
    return Column(
      children: [
        Text("BMI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        SizedBox(
          // height: 200,
          // width: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 10,
                maximum: 40,
                ranges: <GaugeRange>[
                  GaugeRange(startValue: 10, endValue: 18.5, color: Colors.yellow, label: 'Underweight',startWidth: 20,endWidth: 20,),
                  GaugeRange(startValue: 18.5, endValue: 24.9, color: Colors.green, label: 'Normal',startWidth: 20,endWidth: 20,),
                  GaugeRange(startValue: 25, endValue: 29.9, color: Colors.orange, label: 'Overweight',startWidth: 20,endWidth: 20,),
                  GaugeRange(startValue: 30, endValue: 40, color: Colors.red, label: 'Obese',startWidth: 20,endWidth: 20,),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(value: bmi, enableAnimation: true, needleColor: isDarkMode ? Colors.white : Colors.black),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      "$bmi",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    angle: 90,
                    positionFactor: 0.4,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
