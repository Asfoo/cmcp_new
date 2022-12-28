import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/colors.dart';

Widget gradientAppBarTop(double height) {
  return Container(
    height: height * 0.14,
    decoration: BoxDecoration(
      gradient:
          LinearGradient(colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]),
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0)),
    ),
  );
}
