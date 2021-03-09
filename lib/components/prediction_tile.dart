import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:ride_share/models/address_prediction_model.dart';

import '../constants.dart';

class PredictionTile extends StatelessWidget {
  final AddressPredictionModel addressPrediction;
  PredictionTile({this.addressPrediction});

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        addressPrediction.mainText != null
                            ? addressPrediction.mainText
                            : '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18.0, fontFamily: BoldFont),
                      ),
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
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
