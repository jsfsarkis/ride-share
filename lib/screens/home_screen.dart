import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/components/divider_line.dart';
import 'package:ride_share/components/progress_dialog.dart';
import 'package:ride_share/components/ride_details_sheet.dart';
import 'package:ride_share/global_variables.dart';
import 'package:ride_share/helpers/firebase_methods.dart';
import 'package:ride_share/helpers/map_methods.dart';
import 'package:ride_share/models/directions_model.dart';
import 'package:ride_share/screens/search_screen.dart';
import 'package:ride_share/services/geocoding_service.dart';
import 'package:ride_share/services/places_service.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double rideDetailsSheetHeight = 0;

  double requestRideSheetHeight = 0;

  DirectionsModel tripDirectionDetails;

  bool drawerCanOpen = true;

  DatabaseReference rideRef;

  Future<void> getRouteDetails() async {
    var pickupAddress =
        Provider.of<GeocodingService>(context, listen: false).pickupAddress;
    var destinationAddress =
        Provider.of<PlacesService>(context, listen: false).destinationAddress;

    var pickupLatLng = LatLng(
      pickupAddress.latitude,
      pickupAddress.longitude,
    );

    var destinationLatLng = LatLng(
      destinationAddress.latitude,
      destinationAddress.longitude,
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Getting ready...',
      ),
    );

    var details =
        await MapMethods.getDirections(pickupLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(details.encodedPoints);

    polylineCoordinates.clear();

    if (results.isNotEmpty) {
      results.forEach((element) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Colors.deepPurple,
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: destinationLatLng,
        northeast: pickupLatLng,
      );
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
      );
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickupLatLng,
        northeast: destinationLatLng,
      );
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: pickupAddress.placeName,
        snippet: 'My Location',
      ),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: destinationAddress.placeName,
        snippet: 'My destination',
      ),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  void createRideRequest() {
    rideRef =
        FirebaseDatabase.instance.reference().child('ride-requests').push();
    var pickupAddress =
        Provider.of<GeocodingService>(context, listen: false).pickupAddress;
    var destinationAddress =
        Provider.of<PlacesService>(context, listen: false).destinationAddress;

    Map pickupMap = {
      'latitude': pickupAddress.latitude.toString(),
      'longitude': pickupAddress.longitude.toString(),
    };

    Map destinationMap = {
      'latitude': destinationAddress.latitude.toString(),
      'longitude': destinationAddress.longitude.toString(),
    };

    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': currentUserInfo.fullName,
      'rider_phone': currentUserInfo.phoneNumber,
      'pickup_address_name': pickupAddress.placeName,
      'pickup_info': pickupMap,
      'destination_address_name': destinationAddress.placeName,
      'destination_info': destinationMap,
      'payment_method': 'card',
      'driver_id': 'waiting',
    };

    rideRef.set(rideMap);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    var geocodingService = Provider.of<GeocodingService>(context);
    double searchSheetHeight = MediaQuery.of(context).size.height / 2.9;
    void showDetailsSheet() async {
      setState(() {
        searchSheetHeight = 0;
        rideDetailsSheetHeight = MediaQuery.of(context).size.height / 2.9;
        drawerCanOpen = false;
      });
    }

    var mapMethods = Provider.of<MapMethods>(context);

    resetApp() async {
      Position position = await mapMethods.getCurrentPosition();
      setState(() {
        polylineCoordinates.clear();
        _polylines.clear();
        _markers.clear();
        _circles.clear();
        rideDetailsSheetHeight = 0;
        searchSheetHeight = MediaQuery.of(context).size.height / 2.9;
        drawerCanOpen = true;
        MapMethods.animateMapCamera(position, mapController);
      });
    }

    void showRequestRideSheet(BuildContext context) {
      setState(() {
        rideDetailsSheetHeight = 0;
        requestRideSheetHeight = MediaQuery.of(context).size.height / 2.9;
        drawerCanOpen = true;
      });

      createRideRequest();
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: [
              Container(
                height: 160,
                color: Colors.white,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/user_icon.png',
                        height: 60.0,
                        width: 60.0,
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Joseph Sarkis',
                            style:
                                TextStyle(fontSize: 20, fontFamily: BoldFont),
                          ),
                          SizedBox(height: 5.0),
                          Text('View Profile'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              DividerLine(),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text(
                  'Free Rides',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text(
                  'Payments',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(OMIcons.history),
                title: Text(
                  'Ride History',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: Text(
                  'Support',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(OMIcons.info),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 2.85,
              top: MediaQuery.of(context).size.height / 1.7,
            ),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: HomeScreen._kGooglePlex,
            polylines: _polylines,
            markers: _markers,
            circles: _circles,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              MapMethods.animateMapCamera(MapMethods.position, mapController);
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 7,
            left: MediaQuery.of(context).size.width / 20,
            child: GestureDetector(
              onTap: () {
                (drawerCanOpen == true)
                    ? scaffoldKey.currentState.openDrawer()
                    : resetApp();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    (drawerCanOpen == true) ? Icons.menu : Icons.arrow_back,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          // search sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: searchSheetHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          ))
                    ]),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0),
                      Text(
                        'Nice to see you!',
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        'Where are you going?',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: BoldFont,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async {
                          var response = await Navigator.pushNamed(
                              context, SearchScreen.id);
                          if (response == 'getDirections') {
                            showDetailsSheet();
                            await getRouteDetails();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                                offset: Offset(
                                  0.7,
                                  0.7,
                                ),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.blueAccent),
                                SizedBox(width: 10.0),
                                Text('Search Destination')
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 22.0),
                      Row(
                        children: [
                          Icon(
                            OMIcons.home,
                            color: colorDimText,
                          ),
                          SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add Home'),
                              SizedBox(height: 3),
                              Text(
                                'Your residential address',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorDimText,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      DividerLine(),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Icon(
                            OMIcons.workOutline,
                            color: colorDimText,
                          ),
                          SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add Work'),
                              SizedBox(height: 3),
                              Text(
                                'Your office address',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorDimText,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ride details sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 150),
              child: RideDetailsSheet(
                onPressed: () {
                  showRequestRideSheet(context);
                },
                height: rideDetailsSheetHeight,
                tripDistance: (tripDirectionDetails != null)
                    ? tripDirectionDetails.distanceText
                    : '',
                tripFare: (tripDirectionDetails != null)
                    ? MapMethods.estimateFares(tripDirectionDetails).toString()
                    : '',
              ),
            ),
          ),

          // requesting ride sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                height: requestRideSheetHeight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        minHeight: 5,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Requesting a ride...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: BoldFont,
                          color: colorText,
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            width: 1.0,
                            color: colorLightGrayFair,
                          ),
                        ),
                        child: Icon(Icons.close, size: 25),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel Ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
