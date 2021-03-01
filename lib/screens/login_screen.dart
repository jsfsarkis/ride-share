import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ride_share/components/general_textfield.dart';
import 'package:ride_share/components/progress_dialog.dart';
import 'package:ride_share/components/rounded_button.dart';
import 'package:ride_share/constants.dart';
import 'package:ride_share/screens/home_screen.dart';
import 'package:ride_share/screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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

  void login(BuildContext context) async {

    //show dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in'),
    );

    final User user = (await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((e) {
      // navigator to pop the progress dialog in case of error
      Navigator.pop(context);
      PlatformException exception = e;
      showSnackBar(exception.message);
    }))
        .user;

    if (user != null) {
      // verify login check if info is on database
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');
      userRef.once().then((DataSnapshot snapshot) => {
            if (snapshot.value != null)
              {
                 Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.id, (route) => false)
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Sign in as a Rider',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: BoldFont,
                  ),
                ),
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
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 40.0),
                RoundedButton(
                  onPressed: () async {
                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      showSnackBar('No internet connection');
                    }

                    if (!emailController.text.contains('@')) {
                      showSnackBar('Please enter valid email address');
                    }
                    if (passwordController.text.length < 8) {
                      showSnackBar('Please enter lengthy password');
                    }

                    login(context);
                  },
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40.0,
                  fillColor: colorGreen,
                  title: 'LOGIN',
                  titleColor: Colors.black,
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.id, (route) => false);
                  },
                  child: Text("Don't have an account? Sign up here."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
