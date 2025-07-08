import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../mih_components/mih_pop_up_messages/mih_error_message.dart';

class MIHLocationAPI {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  ///This function is to get the current location of the signed in user.
  ///First checks the permission, if permission is denied (new user), request permission from user.
  ///if user has blocked permission (denied or denied forver), user will get error pop up.
  ///if user has granted permission (while in use), function will return Position object.
  Future<Position?> getGPSPosition(BuildContext context) async {
    print("Before checkPermission"); // Debug
    LocationPermission permission = await Geolocator.checkPermission();
    print("After checkPermission: $permission"); // Debug
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showPermissionError(context);
        return null;
      } else if (permission == LocationPermission.deniedForever) {
        showPermissionError(context);
        return null;
      } else {
        Position location = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);
        return location;
      }
    } else if (permission == LocationPermission.deniedForever) {
      showPermissionError(context);
      return null;
    } else {
      Position location = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      return location;
    }
  }

  double getDistanceInMeaters(Position startPosition, Position endPosition) {
    return Geolocator.distanceBetween(startPosition.latitude,
        startPosition.longitude, endPosition.latitude, endPosition.longitude);
  }

  void showPermissionError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Location Denied");
      },
    );
  }
}
