import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_share/components/general_textfield.dart';
import 'package:ride_share/components/progress_dialog.dart';
import 'package:ride_share/components/rounded_button.dart';
import 'package:ride_share/screens/home_screen.dart';
import 'package:ride_share/screens/login_screen.dart';

import '../constants.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration_screen';

  // snackbar deprecated to be replaced
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  // to be checked for best use case
  var fullNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //to be refactored into services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void registerUser(BuildContext context) async {
    //show dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(status: 'Logging you in'),
    );

    final User user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((e) {
      Navigator.pop(context);
      PlatformException exception = e;
      showSnackBar(exception.message);
    }))
        .user;

    if (user != null) {
      Navigator.pop(context);
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');

      //save data on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
      };
      newUserRef.set(userMap);

      Navigator.pushNamed(context, HomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 70.0),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 40.0),
                Text(
                  "Create a Rider's Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: BoldFont,
                  ),
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  hintText: 'Full Name',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  hintText: 'Email Address',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  hintText: 'Phone Number',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 40.0),
                RoundedButton(
                  onPressed: () async {
                    // to be refactored later
                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      showSnackBar('No internet connection');
                    }
                    if (fullNameController.text.length < 3) {
                      showSnackBar('Please provide a valid full name');
                      return;
                    }
                    if (phoneNumberController.text.length < 10) {
                      showSnackBar('Please provide a valid phone number');
                      return;
                    }
                    if (!emailController.text.contains('@')) {
                      showSnackBar('Please provide a valid email address');
                      return;
                    }
                    if (passwordController.text.length < 8) {
                      showSnackBar('Please provide a valid password');
                      return;
                    }
                    registerUser(context);
                  },
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40.0,
                  fillColor: colorGreen,
                  title: 'Register',
                  titleColor: Colors.black,
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.id, (route) => false);
                  },
                  child: Text("Already have an account? Sign in here."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
