import 'package:flutter/material.dart';
import 'package:ride_share/components/general_textfield.dart';
import 'package:ride_share/components/rounded_button.dart';

import '../constants.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration_screen';
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
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  hintText: 'Full Name',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  hintText: 'Email Address',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  hintText: 'Phone Number',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 40.0),
                RoundedButton(
                  onPressed: () {},
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40.0,
                  fillColor: colorGreen,
                  title: 'Register',
                  titleColor: Colors.black,
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {},
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
