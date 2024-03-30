import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:myweather/widgets/weatherData.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _currentAddress = "";
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "my",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "Weather",
              style: TextStyle(
                  color: Color.fromARGB(215, 119, 171, 243),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    if (_currentAddress == null || _currentPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return WeatherData(city: _currentAddress!, pos: _currentPosition!);
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() => _currentPosition = position);
      await _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      debugPrint("in getCurrentPosition ${e}");
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      var output = 'no result found';
      if (placemarks.isNotEmpty) {
        output = '${placemarks[0].locality}, ${placemarks[0].subLocality}';
      }
      setState(() {
        _currentAddress = output;
      });
    } catch (e) {
      debugPrint("int _getAddressFromLatLng ${e}");
    }
  }
}
