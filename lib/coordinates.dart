import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sikkim_app/location.dart';

/// The main screen of the app (StatefulWidget to handle state changes)
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

/// State class for `LocationScreen`
class _LocationScreenState extends State<LocationScreen> {
  final Location locationHelper =
  Location();
  String userLocation = 'No data';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  /// Fetches the user's location and updates the UI
  Future<void> getLocation() async {
    setState(() => _isLoading = true);

    final locationData =
    await locationHelper.getUserlocation();

    if (locationData != null) {
      setState(() {

        userLocation =
        'Latitude: ${locationData['latitude']}, Longitude: ${locationData['longitude']}';

        _isLoading = false;
      });
    } else {
      setState(() {
        userLocation = 'Location not found';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'),
      ),
      body: Center(
        child: _isLoading
            ? const CupertinoActivityIndicator()
            : Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(userLocation,
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
              getLocation,
              child: const Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}
