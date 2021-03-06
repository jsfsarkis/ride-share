import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_share/constants.dart';
import 'package:ride_share/models/directions_model.dart';
import 'package:ride_share/services/network_service.dart';

class MapMethods {
  static Position position;

  // get current location of user through GPS
  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    MapMethods.position = position;
    return position;
  }

  // animate the map camera to a new location

  static Future<DirectionsModel> getDirections(
      LatLng startingPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startingPosition.latitude},${startingPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await NetworkService.httpGetRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionsModel directions = DirectionsModel();
    directions.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directions.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directions.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directions.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directions.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directions;
  }

  static int estimateFares(DirectionsModel directions) {
    // km = $0.7
    // minute = $0.2
    // base fare = $3

    double baseFare = 3;
    double distanceFare = (directions.distanceValue / 1000) * 0.3;
    double timeFare = (directions.durationValue / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }
}
