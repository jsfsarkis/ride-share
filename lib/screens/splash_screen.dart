import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/helpers/map_methods.dart';
import 'package:ride_share/services/geocoding_service.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getGeocodingData();
  }

  void getGeocodingData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var geocodingService =
          Provider.of<GeocodingService>(context, listen: false);
      var mapMethods = Provider.of<MapMethods>(context, listen: false);

      // get current position to be used in geocoding service
      Position position = await mapMethods.getCurrentPosition();

      // reverse geocode current position into an address
      await geocodingService.reverseGeocoding(position, context);

      if (geocodingService.pickupAddress != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var geocodingService = Provider.of<GeocodingService>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
