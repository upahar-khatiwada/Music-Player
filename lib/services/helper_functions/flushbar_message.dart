import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void displayFlushbar(
  BuildContext context,
  String message,
  Color color,
  IconData icon,
) {
  Flushbar(
    message: message,
    margin: EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: color,
    duration: Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.BOTTOM, // Shows at the bottom
    flushbarStyle: FlushbarStyle.FLOATING, // Floats over the UI
    forwardAnimationCurve: Curves.easeOut,
    reverseAnimationCurve: Curves.easeIn,
    icon: Icon(icon, color: Colors.white),
  ).show(context);
}
