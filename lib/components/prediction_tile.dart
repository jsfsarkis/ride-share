import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:ride_share/models/address_prediction_model.dart';

import '../constants.dart';

class PredictionTile extends StatelessWidget {
  final AddressPredictionModel addressPrediction;
  PredictionTile({this.addressPrediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(OMIcons.locationOn, color: colorDimText),
          SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addressPrediction.mainText != null
                    ? addressPrediction.mainText
                    : '',
                style: TextStyle(fontSize: 18.0, fontFamily: BoldFont),
              ),
              SizedBox(height: 2.0),
              Text(
                addressPrediction.secondaryText != null
                    ? addressPrediction.secondaryText
                    : '',
                style: TextStyle(
                  fontSize: 12.0,
                  color: colorDimText,
                  fontFamily: BoldFont,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
