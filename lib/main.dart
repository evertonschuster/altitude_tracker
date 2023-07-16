import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    const MyApp({
    super.key
  });



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altitude Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AltitudePage(),
    );
  }
}

class AltitudePage extends StatefulWidget {
  @override
  _AltitudePageState createState() => _AltitudePageState();
}

class _AltitudePageState extends State<AltitudePage> {
  LocationData? _locationData;
  double? _altitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final currentLocation = await location.getLocation();
    setState(() {
      _locationData = currentLocation;
      _altitude = currentLocation.altitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Altitude App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Altitude:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _altitude != null ? '$_altitude meters' : 'Loading...',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
