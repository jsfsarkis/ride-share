import 'package:ride_share/models/nearby_driver_model.dart';

class GeofireHelper {
  static List<NearbyDriverModel> nearbyDriversList = [];

  static void removeDriverFromList(String key) {
    int index = nearbyDriversList.indexWhere((element) => element.key == key);
    nearbyDriversList.removeAt(index);
  }

  static void updateDriverLocation(NearbyDriverModel driver) {
    int index =
        nearbyDriversList.indexWhere((element) => element.key == driver.key);
    nearbyDriversList[index].longitude = driver.longitude;
    nearbyDriversList[index].latitude = driver.latitude;
  }
}
