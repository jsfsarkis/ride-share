import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/components/general_textfield.dart';
import 'package:ride_share/components/rounded_button.dart';
import 'package:ride_share/constants.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';
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
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  hintText: 'Email Address',
                ),
                SizedBox(height: 10.0),
                GeneralTextField(
                  onChanged: (value) {},
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 40.0),
                RoundedButton(
                  onPressed: () {},
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40.0,
                  fillColor: colorGreen,
                  title: 'LOGIN',
                  titleColor: Colors.black,
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {},
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
