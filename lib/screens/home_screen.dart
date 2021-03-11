import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/components/divider_line.dart';
import 'package:ride_share/components/progress_dialog.dart';
import 'package:ride_share/helpers/map_methods.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
        color: Colors.red,
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
  }

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    var geocodingService = Provider.of<GeocodingService>(context);
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
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              MapMethods.animateMapCamera(MapMethods.position, mapController);
            },
            polylines: _polylines,
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 7,
            left: MediaQuery.of(context).size.width / 20,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
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
                    Icons.menu,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.9,
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
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
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
                        var response =
                            await Navigator.pushNamed(context, SearchScreen.id);
                        if (response == 'getDirections') {
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
        ],
      ),
    );
  }
}
