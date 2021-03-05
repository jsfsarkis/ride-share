class AddressModel {
  String id;
  String placeName;
  double latitude;
  double longitude;
  String placeFormattedAddress;
  bool isPlaceName;

  AddressModel({
    this.id,
    this.placeName,
    this.latitude,
    this.longitude,
    this.placeFormattedAddress,
    this.isPlaceName,
  });
}
