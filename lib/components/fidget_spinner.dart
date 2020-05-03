import 'package:flutter/material.dart';

class FidgetSpinner extends StatefulWidget {
  @override
  _FidgetSpinnerState createState() => _FidgetSpinnerState();
}

class _FidgetSpinnerState extends State<FidgetSpinner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: 0.8,
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'images/fidget-spinner.jpg',
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}
