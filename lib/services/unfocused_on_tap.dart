import 'package:flutter/material.dart';

// general function to unfocus the search bar when tapped outside
void unfocusedOnTap() {
  FocusManager.instance.primaryFocus?.unfocus();
}

class UnfocusedOnTap extends StatelessWidget {
  const UnfocusedOnTap({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: unfocusedOnTap, child: child);
  }
}
