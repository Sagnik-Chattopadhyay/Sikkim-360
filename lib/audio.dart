import 'package:flutter/material.dart';
import 'geo_audio_service.dart';

class audio extends StatefulWidget {
  const audio({super.key});

  @override
  State<audio> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<audio> {
  final GeoAudioService _geoAudioService = GeoAudioService();

  @override
  void initState() {
    super.initState();
    _geoAudioService.startTracking(); // start tracking on load
  }

  @override
  void dispose() {
    _geoAudioService.stopTracking(); // stop tracking when screen closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Move  from one place to another",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
