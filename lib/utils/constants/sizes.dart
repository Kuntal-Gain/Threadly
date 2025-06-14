import 'package:flutter/material.dart';

Widget sizeVar(double height) {
  return SizedBox(height: height);
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}

Widget sizeZ() {
  return const Spacer();
}

Widget sizeBox(double height, double width) {
  return SizedBox(height: height, width: width);
}
