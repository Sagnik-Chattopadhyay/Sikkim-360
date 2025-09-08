import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Location{
  //Request location permission and return with only coordinates
  Future<Map<String,dynamic>?>getUserlocation()async{
    bool serviceEnabled;
    LocationPermission permission;
    //Check is location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled)
    {
      return null;
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
    {
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied)
      {
        return null;
      }

    }
    if(permission == LocationPermission.deniedForever)
    {
      return null;
    }
    try
    {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      return {
        'latitude': position.latitude, // User's latitude
        'longitude': position.longitude, // User's longitude
      };

    } catch(e){
      print("Error on getting location: $e");
      return null;
    }
  }
}
