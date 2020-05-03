import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class FidgetSpinner extends StatefulWidget {
  @override
  _FidgetSpinnerState createState() => _FidgetSpinnerState();
}

class _FidgetSpinnerState extends State<FidgetSpinner>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.elasticOut,
    );

    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String img = (!isDarkMode)
        ? 'images/fidget-spinner.jpg'
        : 'images/fidget-spinner1.jpg';

    return Container(
      child: Transform.rotate(
        angle: animation.value,
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            img,
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
