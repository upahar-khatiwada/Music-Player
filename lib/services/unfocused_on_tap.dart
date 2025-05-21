import 'package:flutter/material.dart';

// general function to unfocus the search bar when tapped outside
void unfocusOnTap() {
  FocusManager.instance.primaryFocus?.unfocus();
}

class UnfocusOnTap extends StatelessWidget {
  const UnfocusOnTap({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: unfocusOnTap, child: child);
  }
}
