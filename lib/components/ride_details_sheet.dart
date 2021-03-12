import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ride_share/components/rounded_button.dart';

import '../constants.dart';

class RideDetailsSheet extends StatelessWidget {
  double height;
  RideDetailsSheet({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: colorAccent1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/taxi.png',
                      height: 70.0,
                      width: 70.0,
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Taxi',
                          style:
                              TextStyle(fontSize: 18.0, fontFamily: BoldFont),
                        ),
                        Text(
                          '14km',
                          style:
                              TextStyle(fontSize: 16.0, color: colorTextLight),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: Text(
                        '\$13',
                        style: TextStyle(fontSize: 18.0, fontFamily: BoldFont),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 22.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.moneyBillAlt,
                    size: 18.0,
                    color: colorTextLight,
                  ),
                  SizedBox(width: 16.0),
                  Text('Cash'),
                  SizedBox(width: 5.0),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: colorTextLight,
                    size: 16.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: RoundedButton(
                onPressed: () {},
                width: MediaQuery.of(context).size.width / 0.1,
                height: 50.0,
                fillColor: colorGreen,
                title: 'REQUEST CAB',
                titleColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
