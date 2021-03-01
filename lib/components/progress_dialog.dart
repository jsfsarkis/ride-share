import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/constants.dart';

class ProgressDialog extends StatelessWidget {
  final String status;

  ProgressDialog({@required this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(width: 5.0),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorAccent),
              ),
              SizedBox(width: 25.0),
              Text(
                status,
                style: TextStyle(fontSize: 15.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
