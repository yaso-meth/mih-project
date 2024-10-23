import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';

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
    //Check the type of permission granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //First time user (auto denied pernission) request permission from user
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //User denied permission
        showPermissionError(context);
        return null;
      } else if (permission == LocationPermission.deniedForever) {
        //User denied permission Forever
        showPermissionError(context);
        return null;
      }
    } else if (permission == LocationPermission.deniedForever) {
      showPermissionError(context);
      return null;
    } else {
      Position location = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      //print(location);
      return location;
    }
    return null;
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
