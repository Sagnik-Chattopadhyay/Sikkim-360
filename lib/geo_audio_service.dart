import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';

class GeoAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Position>? _positionStream;

  // Predefined coordinates and audio paths
  final List<Map<String, dynamic>> _geoPoints = [
    {
      'latitude': 22.5783131,
      'longitude': 88.4758096,
      // 'audio': 'audio/sculpture1.mp3',
    },
    {
      'latitude': 22.6784,
      'longitude': 88.5754,
      // 'audio': 'audio/sculpture2.mp3',
    },
  ];

  // Start tracking location
  Future<void> startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    // Subscribe to location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // check every 20+ meters
      ),
    ).listen((Position position) {
      _checkGeoPoints(position);
    });
  }

  // Check if the user is near any target coordinate
  Future<void> _checkGeoPoints(Position position) async {
    for (var point in _geoPoints) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        point['latitude'],
        point['longitude'],
      );

      if (distance < 10) { // within 50 meters radius
        await _playAudio(point['audio']);
        break;
      }
    }
  }


  Future<void> _playAudio(String filePath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(filePath));
  }

  // Stop tracking
  void stopTracking() {
    _positionStream?.cancel();
    _audioPlayer.stop();
  }
}
