import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/components/progress_dialog.dart';
import 'package:ride_share/models/address_model.dart';
import 'package:ride_share/models/address_prediction_model.dart';

import '../constants.dart';
import 'network_service.dart';

class PlacesService extends ChangeNotifier {
  AddressModel destinationAddress = AddressModel();
  List<AddressPredictionModel> addressPredictionList = [];

  void setDestinationAddress({
    String id,
    String placeName,
    double latitude,
    double longitude,
    String placeFormattedAddress,
    bool isPlaceName,
  }) {
    this.destinationAddress.id = id;
    this.destinationAddress.placeName = placeName;
    this.destinationAddress.latitude = latitude;
    this.destinationAddress.longitude = longitude;
    this.destinationAddress.placeFormattedAddress = placeFormattedAddress;
    this.destinationAddress.isPlaceName = isPlaceName;
    notifyListeners();
  }

  Future<dynamic> searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=123254251&components=country:lb';
      var response = await NetworkService.httpGetRequest(url);

      if (response == 'failed') {
        return;
      }

      if (response['status'] == 'OK') {
        var predictionsJson = response['predictions'];

        var predictionsList = (predictionsJson as List)
            .map((e) => AddressPredictionModel.fromJson(e))
            .toList();
        if (placeName.length > 2) {
          addressPredictionList = predictionsList;
          notifyListeners();
        } else {
          addressPredictionList.clear();
          notifyListeners();
        }
      }
    }
  }

  void getPlaceDetails(String placeId, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(status: 'Please wait...'),
    );

    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';

    var response = await NetworkService.httpGetRequest(url);

    Navigator.pop(context);

    if (response == 'failed') {
      return;
    }

    if (response['status'] == 'OK') {
      setDestinationAddress(
        id: placeId,
        placeName: response['result']['name'],
        latitude: response['result']['geometry']['location']['lat'],
        longitude: response['result']['geometry']['location']['lng'],
      );

      Navigator.pop(context, 'getDirections');
    }
  }
}
