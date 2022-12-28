import 'dart:ui';

import 'package:flutter/material.dart';

const t3_colorPrimary = Color(0xFF098821);
const t3_colorPrimaryDark = Color(0xFF2ccd63);
const t3_colorAccent = Color(0xFFf7b733);

const t3_app_background = Color(0xFFf8f8f8);
const t3_view_color = Color(0xFFDADADA);
const t3_gray = Color(0xFFF4F4F4);

const t3_red = Color(0xFFF12727);
const t3_green = Color(0xFF8BC34A);
const t3_edit_background = Color(0xFFF5F4F4);
const t3_light_gray = Color(0xFFCECACA);
const t3_tint = Color(0xFFF4704C);
const t3_colorPrimary_light = Color(0xFFe2e0f9);
const t3_orange = Color(0xFFF13E0A);

const t3_white = Color(0xFFffffff);
const t3_black = Color(0xFF000000);
const t3_icon_color = Color(0xFF747474);

const t3_shadow = Color(0x70E2E2E5);
var t3White = materialColor(0xFFFFFFFF);
const shadow_color = Color(0x95E9EBF0);

const Banking_app_Background = Color(0xFFf3f5f9);
const complain_app_Background = Color(0xFFf9f9f9);
// const complain_app_Background_2 = Color(0xFFfefefe);

const Banking_blackColor = Color(0xFF070706);
const Banking_TextColorPrimary = Color(0xFF070706);
const Banking_TextColorSecondary = Color(0xFF747474);
const Banking_whitePureColor = Color(0xFFffffff);
const Banking_palColor = Color(0xFF4a536b);
const Banking_RedColor = Color(0xFFD80027);
const Banking_blueColor = Color(0xFF041887);
const Banking_blueLightColor = Color(0xFF41479B);
const Banking_BalanceColor = Color(0xFF8ed16f);

const quiz_app_background = Color(0xFFf3f5f9);
const quiz_view_color = Color(0xFFDADADA);
const quiz_colorPrimary = Color(0xFF5362FB);
const quiz_white = Color(0xFFffffff);
const t8_view_color = Color(0xFFDADADA);
const t8_white = Color(0xFFffffff);
const quiz_textColorSecondary = Color(0xFF918F8F);
const quiz_colorPrimaryDark = Color(0xFF3D50FC);
const quiz_textColorPrimary = Color(0xFF333333);

const opPrimaryColor = Color(0xFF343EDB);

const grocery_view_color = Color(0xFFB4BBC2);
const grocery_color_yellow = Color(0xFFFFC107);
const grocery_app_background = Color(0xFFE7EFF6);
const grocery_ShadowColor = Color(0X95E9EBF0);
const grocery_icon_color = Color(0xFF747474);
const grocery_color_red = Color(0xFFC00404);
const grocery_textColorSecondary = Color(0xFFAAB3AC);

const t5ViewColor = Color(0XFFB4BBC2);

const sky_blue_color = Color(0xFF00CFE8);
const green_color = Color(0xFF28C76F);

const t11_edit_text_color = Color(0xFFDEE4FF);
const gray_text_color = Colors.grey;

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor materialColor(colorHax) {
  return MaterialColor(colorHax, color);
}

MaterialColor colorCustom = MaterialColor(0XFF5959fc, color);

// bootsrap colors
const webPrimary = Color(0xFF007bff);
const webSecondary = Color(0xFF6c757d);
const webSuccess = Color(0xFF28a745);
const webDanger = Color(0xFFdc3545);
const webWarning = Color(0xFFffc107);
const webInfo = Color(0xFF17a2b8);
