import 'package:flutter/material.dart';
import 'package:ride_share/constants.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final double width, height;
  final Color fillColor;
  final String title;
  final Color titleColor;

  RoundedButton({
    @required this.onPressed,
    @required this.width,
    @required this.height,
    @required this.fillColor,
    @required this.title,
    @required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: RawMaterialButton(
        elevation: 0,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        fillColor: fillColor,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: BoldFont,
            color: titleColor,
          ),
        ),
      ),
    );
  }
}