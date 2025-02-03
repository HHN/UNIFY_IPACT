

import 'package:flutter/material.dart';

const Color cSnow = Color(0xffFAFAFA);
// const Color cUfoGreen = Color(0xff32D777);
// const Color cDeepCarminePink = Color(0xffFF2E2E);
const Color cSecondaryTextColor = Color(0xff121946);
const Color cCharleston = Color(0xff23262F);
const Color cRedPigment = Color(0xffF31629);
// const Color cSlateGray = Color(0xff8d8d93);
const Color cSlateGray = Color(0xffd3d3d3);
const Color cBrightRed = Color(0xFFFC0939);
const Color cLightGreen = Color(0xffFD930B);

/// New Blue color scheme

const Color cDark = Color(0xFF0C62A8);
const Color cLightDark = Color(0xFF15A6D3);
const Color cLight = Color(0xFF4EBEDE);
const Color cExtraLight = Color(0xFF7ED6E8);
const Color cExtraLight2 = Color(0xFFAEE5F6);
const Color cMaxExtraLight = Color(0xFFFFFFFF);
// const Color cDark = Color(0xFF0077b6);
// const Color cLightDark = Color(0xFF00b4d8);
// const Color cLight = Color(0xFF90e0ef);
// const Color cExtraLight = Color(0xFFcaf0f8);
// const Color cExtraLight2 = Color(0xffe0f5fd);
// const Color cMaxExtraLight = Color(0xfff3fbff);

/*/// New Orange color scheme

const Color cDark = Color(0xFFff6700);
const Color cLightDark = Color(0xFFFD930B);
const Color cLight = Color(0xFFffb38a);
const Color cExtraLight = Color(0xffffe3d1);
const Color cExtraLight2 = Color(0xfffff9f5);
const Color cMaxExtraLight = Color(0xfffff9f2);*/

// /// New Orange color scheme
//
// const Color cOrangeDark = Color(0xFFff6700);
// const Color cLightDarkOrange = Color(0xFFff9248);
// const Color cLightOrange = Color(0xFFffb38a);
// const Color cExtraLightOrange = Color(0xFFffd7b5);



int getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return int.parse(hexColor, radix: 16);
}



/*
import 'package:flutter/material.dart';

const Color cMaxExtraLight = Color(0xffffffff);
const Color cSnow = Color(0xffFAFAFA);
const Color cAccent = Colors.blueAccent;
const Color cUfoGreen = Color(0xff32D777);
const Color cCharleston = Color(0xff23262F);
const Color cOnyx = Color(0xff353945);
const Color cMintCream = Color(0xffF5FFF9);
const Color cCultured = Color(0xffF7F7F8);
const Color cSlateGray = Color(0xff777E90);
const Color cSonicSilver = Color(0xffBBBBBC);
const Color cDeepCarminePink = Color(0xffFF2E2E);
const Color cGainsboro = Color(0xffDDDDDD);
const Color cBlack = Color(0xff000000);
const Color cRedPigment = Color(0xffF31629);
const Color cSunGlow = Color(0xfffcd535);
const Color cSunGlowDark = Color(0xff655515);
const Color cBoldYellow = Color(0xFFEAC41C);
const Color cOrange = Color(0xFFFFA400);
const Color cBlue = Color(0xFF182458);
const Color cLightBlue = Color(0xFF6675ae);
const Color cLightGreen = Color(0xFF78c295);
const Color cLightYellow = Color(0xFFdacd56);

int getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return int.parse(hexColor, radix: 16);
}
*/



