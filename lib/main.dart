import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/constants.dart';
import 'package:ride_share/screens/home_screen.dart';
import 'package:ride_share/screens/login_screen.dart';
import 'package:ride_share/screens/registration_screen.dart';
import 'package:ride_share/screens/search_screen.dart';
import 'package:ride_share/screens/splash_screen.dart';
import 'package:ride_share/services/geocoding_service.dart';
import 'package:ride_share/services/places_service.dart';

import 'helpers/map_methods.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:808635764507:ios:9b49254f833ef7dbc70dbe',
            apiKey: 'AIzaSyDh8hy76eR38E9Qr7i4s23_W6pdKm8c5Gs',
            projectId: 'ride-sharing-90212',
            messagingSenderId: '808635764507',
            databaseURL:
                'https://ride-sharing-90212-default-rtdb.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:808635764507:android:22a3316263f88284c70dbe',
            apiKey: 'AIzaSyBMWlvNTB8F5PWPoEK-7yvX4g5GuZaSiE0',
            messagingSenderId: '808635764507',
            projectId: 'ride-sharing-90212',
            databaseURL:
                'https://ride-sharing-90212-default-rtdb.firebaseio.com',
          ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (context) => GeocodingService()),
        ListenableProvider(create: (context) => PlacesService()),
        Provider<MapMethods>(create: (context) => MapMethods()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: RegularFont,
          primarySwatch: Colors.blue,
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          SearchScreen.id: (context) => SearchScreen(),
        },
      ),
    );
  }
}
