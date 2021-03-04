import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_share/constants.dart';
import 'package:ride_share/services/network_service.dart';

class HelperMethods {
  // geocoding method to be refactored into a geocoding service
  static Future<String> findCoordinateAddress(Position position) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await NetworkService.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }

    return placeAddress;
  }
}
