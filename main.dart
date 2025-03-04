import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
List<Map<String, dynamic>> dummyBluetoothDevices = [
  {"name": "JBL Speaker", "address": "00:1A:7D:DA:71:13", "rssi": -45},
  {"name": "AirPods Pro", "address": "1F:2B:3C:4D:5E:6F", "rssi": -50},
  {"name": "Fitbit Charge 5", "address": "A0:B1:C2:D3:E4:F5", "rssi": -60},
  {"name": "Logitech Mouse", "address": "12:34:56:78:9A:BC", "rssi": -55},
  {"name": "Samsung Watch", "address": "AB:CD:EF:12:34:56", "rssi": -48},
  {"name": "Car Bluetooth", "address": "98:76:54:32:10:FE", "rssi": -70},
];

void main() {
  runApp(BMIGaugeApp());
}

class BMIGaugeApp extends StatefulWidget {
  @override
  State<BMIGaugeApp> createState() => _BMIGaugeAppState();
}

class _BMIGaugeAppState extends State<BMIGaugeApp> {
  bool isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: BMIScreen(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
    );
  }
}


class BMIScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final double bmi;


  BMIScreen({required this.toggleTheme, required this.isDarkMode,})
      : bmi = double.parse((72 / (1.75 * 1.75)).toStringAsFixed(1));

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final double weight = 72;
 // kg
  final double height = 1.75;
  var isBluetoothOrWifi = false;
  bool isBluetoothOn = false;
  List<BluetoothDevice> devicesList = [];
  String? connectedDevice;

  void _scanForBluetoothDevices() {
    setState(() {
      devicesList.clear();
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devicesList = results.map((result) => result.device).toList();
      });
    });
  }

  // void _showBluetoothDevices() {
  //   // _scanForBluetoothDevices();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.all(16.0),
  //         height: 300,
  //         child: Column(
  //           children: [
  //             Text("Nearby Bluetooth Devices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             SizedBox(height: 10),
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: devicesList.length,
  //                 itemBuilder: (context, index) {
  //                   return ListTile(
  //                     title: Text(devicesList[index].platformName.isEmpty ? "Unknown Device" : devicesList[index].name),
  //                     subtitle: Text(devicesList[index].remoteId.toString()),
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


  void _showBluetoothDevices() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nearby Bluetooth Devices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyBluetoothDevices.length,
                      itemBuilder: (context, index) {
                        final device = dummyBluetoothDevices[index];
                        final isConnected = device["name"] == connectedDevice;

                        return ListTile(
                          leading: Icon(Icons.bluetooth, color: isConnected ? Colors.blue :widget.isDarkMode? Colors.white:Colors.black),
                          title: Text(device["name"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                          subtitle: Text("Address: ${device["address"]}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isBluetoothOn = true;
                                // Disconnect all devices first
                                for (var dev in dummyBluetoothDevices) {
                                  dev["isConnected"] = false;
                                }
                                // Connect the selected device
                                device["isConnected"] = true;
                                connectedDevice = device["name"];

                              });

                              Navigator.pop(context); // Close BottomSheet
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${device["name"]} connected!")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isConnected ? Colors.green : Colors.blue,
                            ),
                            child: Text(isConnected ? "Connected" : "Connect"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Gauges"),
        actions: [
          IconButton(
            icon: Icon(isBluetoothOrWifi?Icons.wifi_off:Icons.wifi, color:!isBluetoothOrWifi?Colors.blue: widget.isDarkMode ? Colors.white : Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(isBluetoothOn==true?Icons.bluetooth_connected:Icons.bluetooth, color: isBluetoothOn==true  ? Colors.blue : (widget.isDarkMode ? Colors.white : Colors.black)),
            onPressed: _showBluetoothDevices,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top: Weight Gauge (Full Width)
            // _buildGauge("Weight", weight, 40, 150, "kg", Colors.blue, isDarkMode, null,null),
            _buildBMIGauge(widget.isDarkMode, null,null),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),

            // Bottom: BMI (Left, Large) & Height (Right, Small)
            Row(
              children: [
                // BMI Gauge (Larger)
                Expanded(
                  flex: 1, // Takes 2/3 of the space
                  // child: _buildBMIGauge(isDarkMode, screenHeight * 0.3, screenWidth * 0.6),
                  child: _buildGauge("Weight", weight, 40, 150, "kg", Colors.blue, widget.isDarkMode,screenHeight * 0.28, screenWidth * 0.6) ,
                ),

                SizedBox(width: 10),

                // Height Gauge (Smaller)
                Expanded(
                  flex: 1, // Takes 1/3 of the space
                  child: _buildGauge("Height", height * 100, 100, 250, "cm", Colors.purple, widget.isDarkMode, screenHeight * 0.28, screenWidth * 0.6),

                  // child: _buildGauge("Height", height, 1, 2.5, "m", Colors.purple, widget.isDarkMode,screenHeight * 0.28, screenWidth * 0.6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGauge(String title, double value, double min, double max, String unit, Color color, bool isDarkMode, double? screenHeight, double? screenWidth) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        SizedBox(
          height: screenHeight,
          width: screenWidth,
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    angle: 90,
                    positionFactor: 0.8,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBMIGauge(bool isDarkMode, double? screenHeight, double? screenWidth) {
    return Column(
      children: [
        Text("BMI", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        SizedBox(height: 20,),
        SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 10,
                maximum: 40,
                ranges: <GaugeRange>[
                  GaugeRange(startValue: 10, endValue: 18.5, color: Colors.yellow, label: 'Underweight', startWidth: 20, endWidth: 20),
                  GaugeRange(startValue: 18.5, endValue: 24.9, color: Colors.green, label: 'Normal', startWidth: 20, endWidth: 20),
                  GaugeRange(startValue: 25, endValue: 29.9, color: Colors.orange, label: 'Overweight', startWidth: 20, endWidth: 20),
                  GaugeRange(startValue: 30, endValue: 40, color: Colors.red, label: 'Obese', startWidth: 20, endWidth: 20),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(value: widget.bmi, enableAnimation: true, needleColor: isDarkMode ? Colors.white : Colors.black),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      "${widget.bmi}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    angle: 90,
                    positionFactor: 0.8,
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
