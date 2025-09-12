import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';

class GeoAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Position>? _positionStream;

  String? _lastPlayed; // prevent replaying same audio

  // Predefined coordinates and audio file names
  final List<Map<String, dynamic>> _geoPoints = [
    {
<
      'latitude': 22.5905452,
      'longitude': 88.466225,
      'audio': 'sculpture1.mp3',
    },
    {
      'latitude': 22.5784,
      'longitude': 88.4756,
      'audio': 'sculpture2.mp3',
    },
    {
      'latitude': 22.59054,
      'longitude': 88.466266,
      'audio': 'sculpture3.mp3',
    },
    {
      'latitude': 22.5905721,
      'longitude': 88.4662491,
      'audio': 'sculpture4.mp3',

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
        accuracy: LocationAccuracy.best, // high accuracy
        distanceFilter: 10, // update every 10+ meters
      ),
    ).listen((Position position) {
      _checkGeoPoints(position);
    });
  }

  // Check if user is near any target coordinate
  Future<void> _checkGeoPoints(Position position) async {
    double minDistance = double.infinity;
    Map<String, dynamic>? nearestPoint;

    for (var point in _geoPoints) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        point['latitude'],
        point['longitude'],
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestPoint = point;
      }
    }

    // Play audio only if within 50 meters of the nearest point
    if (nearestPoint != null && minDistance < 50) {
      if (_lastPlayed != nearestPoint['audio']) {
        _lastPlayed = nearestPoint['audio'];
        await _playAudio(nearestPoint['audio']);
      }
    }
  }

  // Play audio from assets
  Future<void> _playAudio(String fileName) async {
    await _audioPlayer.stop();

    // ✅ only use "audio/" here (no "assets/")
    await _audioPlayer.play(AssetSource('audio/$fileName'));
  }

  // Stop tracking
  void stopTracking() {
    _positionStream?.cancel();
    _audioPlayer.stop();
  }
}
