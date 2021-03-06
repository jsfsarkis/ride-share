import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/components/divider_line.dart';
import 'package:ride_share/components/prediction_tile.dart';
import 'package:ride_share/services/geocoding_service.dart';
import 'package:ride_share/services/places_service.dart';

import '../constants.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'search_page';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupFieldController = TextEditingController();
  TextEditingController destinationFieldController = TextEditingController();

  FocusNode destinationFieldFocus = FocusNode();

  bool focused = false;
  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(destinationFieldFocus);
      focused = true;
    }
  }

  String searchValue;

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<PlacesService>(context, listen: false)
        .addressPredictionList
        .clear();
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    var placesService = Provider.of<PlacesService>(context);
    var geocodingService = Provider.of<GeocodingService>(context);
    String pickupAddress = geocodingService.pickupAddress.placeName;
    pickupFieldController.text = pickupAddress;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'Set Destination',
            style: TextStyle(
              color: Colors.black,
              fontFamily: BoldFont,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  top: 10.0,
                  right: 24.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 18.0),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/pickicon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(width: 18.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorLightGrayFair,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              controller: pickupFieldController,
                              decoration: InputDecoration(
                                hintText: 'Pickup Location',
                                fillColor: colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/desticon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(width: 18.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorLightGrayFair,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                placesService.searchPlace(value);
                              },
                              focusNode: destinationFieldFocus,
                              controller: destinationFieldController,
                              decoration: InputDecoration(
                                hintText: 'Where to?',
                                fillColor: colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            (placesService.addressPredictionList.isEmpty == true)
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          addressPrediction:
                              placesService.addressPredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerLine(),
                      itemCount: placesService.addressPredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
