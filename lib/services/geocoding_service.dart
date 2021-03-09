import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_share/models/address_model.dart';

import '../constants.dart';
import 'network_service.dart';

class GeocodingService extends ChangeNotifier {
  AddressModel pickupAddress = AddressModel(isPlaceName: false);

  // set the pickup address field values
  void setPickupAddress({
    String id,
    String placeName,
    double latitude,
    double longitude,
    String placeFormattedAddress,
    bool isPlaceName,
  }) {
    this.pickupAddress.id = id;
    this.pickupAddress.placeName = placeName;
    this.pickupAddress.latitude = latitude;
    this.pickupAddress.longitude = longitude;
    this.pickupAddress.placeFormattedAddress = placeFormattedAddress;
    this.pickupAddress.isPlaceName = isPlaceName;
    notifyListeners();
  }

  Future<dynamic> reverseGeocoding(
      Position position, BuildContext context) async {
    // check if the device is connected to the internet
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return 'Check your internet connection';
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await NetworkService.httpGetRequest(url);
    if (response != 'failed') {
      String placeAddress = response['results'][0]['formatted_address'];
      setPickupAddress(
        latitude: position.latitude,
        longitude: position.longitude,
        placeName: placeAddress,
        isPlaceName: true,
      );
    }
  }
}
