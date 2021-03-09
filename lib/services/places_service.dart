import 'package:flutter/cupertino.dart';
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
  }

  void searchPlace(String placeName) async {
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
        addressPredictionList = predictionsList;
        notifyListeners();
      }
    }
  }
}
