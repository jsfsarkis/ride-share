import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:ride_share/models/address_model.dart';
import 'package:ride_share/models/address_prediction_model.dart';
import 'package:ride_share/services/network_service.dart';

import '../constants.dart';

class PredictionTile extends StatelessWidget {
  final AddressPredictionModel addressPrediction;
  PredictionTile({this.addressPrediction});

  void getPlaceDetails(String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';

    var response = await NetworkService.httpGetRequest(url);

    if (response == 'failed') {
      return;
    }

    if (response['status'] == 'OK') {
      AddressModel thisPlace = AddressModel();
      thisPlace.placeName = response['result']['name'];
      thisPlace.id = placeId;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.latitude = response['result']['geometry']['location']['lng'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(OMIcons.locationOn, color: colorDimText),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addressPrediction.mainText != null
                            ? addressPrediction.mainText
                            : '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 18.0, fontFamily: BoldFont),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        addressPrediction.secondaryText != null
                            ? addressPrediction.secondaryText
                            : '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: colorDimText,
                          fontFamily: BoldFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
