import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/T3Images.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'AN INITIATIVE BY',
                style: TextStyle(
                    fontFamily: fontTekoBold,
                    color: t3_colorPrimary,
                    fontSize: textSizeLarge),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  splash2_cm_icon,
                  scale: 5,
                ),
                Container(
                  width: size.width * 0.9,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'CHIEF MINISTER BALOCHISTAN',
                      style: TextStyle(
                          fontFamily: fontTekoBold,
                          color: t3_colorPrimary,
                          fontSize: textSizeLarge),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.9,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'MIR ABDUL QUDDUS BIZENJO',
                      style: TextStyle(
                          fontFamily: fontTekoBold,
                          color: t3_colorPrimary,
                          fontSize: textSizeXLarge),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Image.asset(splash2_urdu_icon),
            )
          ],
        ),
      ),
    );
  }
}
