import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';

// BoxDecoration decorationBackgroundImage = BoxDecoration(
//     image: DecorationImage(
//         image: AssetImage(AssetConstants.imgAppBg), fit: BoxFit.cover));

decorationBackgroundColor(BuildContext context) {
  return boxDecoration(context, color: context.theme.canvasColor, isGradient: true);
}

boxDecoration( context, {Color? color, bool isGradient = false, double radius = 0}) {
  color = color ?? context.theme.primaryColorDark;
  return BoxDecoration(
    color: isGradient ? null : color,
    gradient: isGradient ? linearGradient(color!) : null,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

getRoundCornerWithShadow({Color color = cMaxExtraLight}) {
  return BoxDecoration(
    color: color,
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    // borderRadius: BorderRadius.only(
    //   topLeft: Radius.circular(dp15),
    //   topRight: Radius.circular(dp15),
    // ),
    //boxShadow: kElevationToShadow[1]
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 0,
          blurRadius: 6,
          offset: const Offset(10, 0) // Shadow position
          //       // color: Colors.grey.withOpacity(0.8),
          //       // spreadRadius: 10,
          //       // blurRadius: 5,
          //       // offset: Offset(0, 7),
          ),
    ],
  );
}

boxDecorationRoundShadow({Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    borderRadius: const BorderRadius.all(Radius.circular(30)),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 15,
          offset: const Offset(4, 4) // Shadow position
          ),
    ],
  );
}

boxDecorationRound({Color color = cLightDark}) {
  return BoxDecoration(
    color: color,
    shape: BoxShape.circle,
    borderRadius: const BorderRadius.all(Radius.circular(30)),
    // boxShadow: [
    //   BoxShadow(
    //       color: Colors.grey.withOpacity(0.3),
    //       spreadRadius: 1,
    //       blurRadius: 15,
    //       offset: const Offset(4, 4) // Shadow position
    //   ),
    // ],
  );
}

boxDecorationRoundShadowLight({Color color = Colors.white,double? borderRadius}) {
  borderRadius = borderRadius ?? 30;
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(4, 4) // Shadow position
          ),
    ],
  );
}

boxDecorationFullCircleShadow({Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    borderRadius: const BorderRadius.all(Radius.circular(100)),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 15,
          offset: const Offset(4, 4) // Shadow position
          ),
    ],
  );
}

boxDecorationRoundBorderTop({Color bgColor = cDark}) {
  return BoxDecoration(
    color: bgColor,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 15,
          offset: const Offset(4, 4) // Shadow position
          ),
    ],
  );
}

boxDecorationRoundBorderBottom({Color bgColor = cDark}) {
  return BoxDecoration(
    color: bgColor,
    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 15,
          offset: const Offset(4, 4) // Shadow position
          ),
    ],
  );
}

boxDecorationRoundOnly(BuildContext context,
    {bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
    Color? bgColor,
    double radius = 7}) {
  bgColor = bgColor ?? context.theme.canvasColor;
  return BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular((left || top) ? radius : 0),
      bottomLeft: Radius.circular((left || bottom) ? radius : 0),
      topRight: Radius.circular((right || top) ? radius : 0),
      bottomRight: Radius.circular((right || bottom) ? radius : 0),
    ),
  );
}

boxDecorationRoundBorder(BuildContext context,
    {Color? bgColor,
    Color? borderColor,
    double radius = 7,
    double borderWidth = 0.50}) {
  bgColor = bgColor ?? context.theme.canvasColor;
  borderColor = borderColor ?? Colors.grey;
  return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(4, 4) // Shadow position
            )
      ]);
}

boxDecorationRoundCorner(BuildContext context, {Color? color, double radius = 7}) {
  color = color ?? context.theme.canvasColor;
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

boxDecorationBottomBorder({Color? borderColor}) {
  borderColor = borderColor ?? Colors.grey;
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: borderColor,
        width: 1,
      ),
    ),
  );
}

// const decorationBackgroundImage = BoxDecoration(
//   image: DecorationImage(
//     image: AssetImage(
//       AssetConstants.bgWelcome,
//     ),
//     fit: BoxFit.cover,
//   ),
// );

// decorationSearchBox({VoidCallback? rightIconAction}) {
//   return InputDecoration(
//     filled: false,
//     hintText: "Search".tr,
//     hintStyle: const TextStyle(color: Colors.grey),
//     isDense: true,
//     suffixIcon: InkWell(
//       onTap: rightIconAction,
//       child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: SvgPicture.asset(AssetConstants.icSearch,
//               color: context.theme.primaryColorDark)),
//     ),
//     border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(7),
//         borderSide: const BorderSide(width: dp1, style: BorderStyle.solid)),
//     focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: context.theme.colorScheme.secondary),
//         borderRadius: BorderRadius.circular(dp7)),
//   );
// }

decorationRoundCornerBox({Color color = Colors.white}) {
  return BoxDecoration(
      color: color, borderRadius: const BorderRadius.all(Radius.circular(7)));
}

getRoundSoftTransparentBox(BuildContext context, ) {
  return BoxDecoration(
      color: context.theme.primaryColor.withOpacity(0.03),
      borderRadius: const BorderRadius.all(Radius.circular(7)));
}

linearGradient(Color color) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [color.withOpacity(0.9), color],
  );
}

// final navDrawerBackgroundDecoration = BoxDecoration(
//   image: DecorationImage(
//     image: AssetImage(
//       AssetConstants.splash_bg,
//     ),
//     fit: BoxFit.cover,
//   ),
// );
//
// getRoundedCornerShape({double borderRadius = dp20}) {
//   return RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//   );
// }
//
// decorationBottomBorder() {
//   return BoxDecoration(
//     border: Border(
//       bottom: BorderSide(
//         //                   <--- left side
//         color: context.theme.disabledColor,
//         width: dp1,
//       ),
//     ),
//   );
// }
//
// getBoxCornerBox({Color color = kAccentColorOrange}) {
//   return BoxDecoration(
//       //color: color, borderRadius: BorderRadius.all(Radius.circular(dp7))
//
//       border: Border.all(color: color, width: 2));
// }
//
// getRoundTransparentBox() {
//   return BoxDecoration(
//       color: white.withOpacity(0.03),
//       borderRadius: BorderRadius.all(Radius.circular(dp7)));
// }
//
// getTransparentBox() {
//   return BoxDecoration(
//       gradient: new LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           const Color(0xFF202942),
//           const Color(0xFF1B243D),
//           // Color.fromARGB(255, 25,178,238),
//           // Color.fromARGB(255, 21,236,229)
//         ],
//       ),
//       //color: white.withOpacity(0.03),
//       borderRadius: BorderRadius.all(Radius.circular(dp0)));
// }
//
// getTransparentBoxWithGradient() {
//   return BoxDecoration(
//       gradient: new LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           const Color(0xFF202942),
//           const Color(0xFF1B243D),
//           // Color.fromARGB(255, 25,178,238),
//           // Color.fromARGB(255, 21,236,229)
//         ],
//       ),
//       //color: white.withOpacity(0.03),
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(dp7), topRight: Radius.circular(dp7)));
// }
//
// getRoundTransparentBoxWithBorder() {
//   return BoxDecoration(
//       color: white.withOpacity(0.03),
//       border: Border.all(color: kBorder),
//       borderRadius: BorderRadius.all(Radius.circular(dp5)));
// }
//
// getRoundTransparentBoxWithBorderRadius20() {
//   return BoxDecoration(
//       color: white.withOpacity(0.03),
//       border: Border.all(color: kBorder),
//       borderRadius: BorderRadius.all(Radius.circular(dp20)));
// }
//
// getGreyBackground() {
//   return BoxDecoration(
//     color: kGreyColor,
//     // border: Border.all(color: kBorder),
//     // borderRadius: BorderRadius.all(Radius.circular(dp5))
//   );
// }
//
// getRoundCornerBoxWhite({Color color = white}) {
//   return BoxDecoration(
//     color: color,
//     borderRadius: BorderRadius.all(Radius.circular(dp15)),
//     boxShadow: [
//       BoxShadow(
//         color: black.withOpacity(0.3),
//         blurRadius: 5,
//         offset: Offset(0, 4), // Shadow position
//       ),
//     ],
//   );
// }
//
// getRoundCornerBoxWithShadow({Color color}) {
//   return BoxDecoration(
//     color: color,
//     borderRadius: BorderRadius.all(Radius.circular(dp15)),
//     boxShadow: [
//       BoxShadow(
//         color: black.withOpacity(0.3),
//         blurRadius: 5,
//         offset: Offset(0, 4), // Shadow position
//       ),
//     ],
//   );
// }
//
// getRoundGradientCornerBoxWithShadow() {
//   return BoxDecoration(
//     borderRadius: BorderRadius.circular(12.0),
//     gradient: LinearGradient(
//       begin: Alignment(-0.96, 0.57),
//       end: Alignment(1.0, 0.08),
//       colors: [const Color(0xff6ee4ff), const Color(0xffb6f5ff)],
//       stops: [0.0, 1.0],
//     ),
//     boxShadow: [
//       BoxShadow(
//         color: const Color(0xff27ccff),
//         offset: Offset(0, 4),
//         //blurRadius: 5,
//       ),
//     ],
//   );
// }
//
// getRoundCornerBoxWhiteWithoutShadow({Color color}) {
//   return BoxDecoration(
//     color: color,
//     borderRadius: BorderRadius.all(Radius.circular(dp15)),
//   );
// }
//
// getRoundCornerBoxBlack({Color color = black}) {
//   return BoxDecoration(
//     color: color,
//     borderRadius: BorderRadius.all(Radius.circular(dp15)),
//     boxShadow: [
//       BoxShadow(
//         color: black.withOpacity(0.3),
//         blurRadius: 5,
//         offset: Offset(0, 4), // Shadow position
//       ),
//     ],
//   );
// }
//
// getRoundCornerBoxWhiteBottomRadius({Color color = white}) {
//   return BoxDecoration(
//     color: color,
//     borderRadius: BorderRadius.only(
//       bottomLeft: Radius.circular(dp15),
//       bottomRight: Radius.circular(dp15),
//     ),
//     // boxShadow: kElevationToShadow[
//     //     1]
//     boxShadow: [
//       BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           spreadRadius: 0,
//           blurRadius: 6,
//           offset: Offset(0, 10) // Shadow position
//           ),
//     ],
//   );
// }
//
// getRoundCornerBoxWhiteTopRadius({Color color = white}) {
//   return BoxDecoration(
//     color: color,
//     borderRadius: BorderRadius.only(
//       topLeft: Radius.circular(dp15),
//       topRight: Radius.circular(dp15),
//     ),
//     // boxShadow: kElevationToShadow[
//     //     1]
//     boxShadow: [
//       BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           spreadRadius: 0,
//           blurRadius: 6,
//           offset: Offset(10, 0) // Shadow position
//           // color: Colors.grey.withOpacity(0.8),
//           // spreadRadius: 10,
//           // blurRadius: 5,
//           // offset: Offset(0, 7),
//           ),
//     ],
//   );
// }
//
// getRoundCornerBorder({Color color = kTabBorder}) {
//   return BoxDecoration(
//       border: Border.all(color: color),
//       borderRadius: BorderRadius.all(Radius.circular(dp7)));
// }
//
// getCircleCornerBorder({Color color = kDivider2}) {
//   return BoxDecoration(
//       border: Border.all(color: color),
//       borderRadius: BorderRadius.circular(dp80));
// }
//
// getRoundCornerBorderWithBgColor({Color bgColor}) {
//   return BoxDecoration(
//       color: bgColor, borderRadius: BorderRadius.all(Radius.circular(dp7)));
// }
//
// getRoundCornerWhite() {
//   return BoxDecoration(
//       color: white, borderRadius: BorderRadius.all(Radius.circular(dp50)));
// }
//
// getRoundCornerBorderOnlyTop(Color color) {
//   return BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.vertical(top: Radius.circular(dp20)));
// }
//
// getRoundCornerBorderOnlyBottom(Color color) {
//   return BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.vertical(bottom: Radius.circular(dp20)));
// }
//
// getRoundCornerBorderOnlyTop2() {
//   RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(dp20)));
// }
//
// getRoundedRectangleBorderTop(Color color) {
//   RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(dp7), topRight: Radius.circular(dp7)),
//       side: BorderSide(color: color));
// }
//
// getRoundedRectangleBorderBottom(Color color) {
//   RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(dp7),
//           bottomRight: Radius.circular(dp7)),
//       side: BorderSide(color: color));
// }
//
// getCircleBoxWithCenterIcon(String iconPath, {Color color = white}) {
//   return Container(
//     alignment: Alignment.center,
//     width: Get.width / 3,
//     height: Get.width / 3,
//     decoration: BoxDecoration(shape: BoxShape.circle, color: bgCircle
//         //border: Border.all(color: context.theme.accentColor.withOpacity(0.9), width: dp4,),
//         ),
//     child: SvgPicture.asset(
//       iconPath,
//       width: dp40,
//       height: dp40,
//     ),
//   );
// }
//
// getRectangleBoxWithText(
//   String text, {
//   Color textColor,
//   Color bgColor,
// }) {
//   return Container(
//     alignment: Alignment.center,
//     height: 30,
//     padding: EdgeInsets.all(4),
//     width: Get.width / 4,
//     decoration: BoxDecoration(
//       color: bgColor,
//       shape: BoxShape.rectangle,
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontFamily: 'Montserrat',
//         fontSize: 22,
//         color: textColor,
//         letterSpacing: 1.3199999999999998,
//         fontWeight: FontWeight.w700,
//         height: 1.2727272727272727,
//       ),
//       textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
//       textAlign: TextAlign.center,
//     ),
//   );
// }
//
// boxDecorationOnlyTop() {
//   return BoxDecoration(
//       color: context.theme.accentColor,
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(dp50), topRight: Radius.circular(dp50)));
// }
