import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/extentions.dart';
import 'package:unify_secret/utils/image_util.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';


class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final sizeL = size ?? Get.width / 3;
    final sizeT = size ?? Get.width / 3;
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(AssetConstants.icLogo, height: sizeL, width: sizeL),
          // vSpacer15(),
          ImageAsset(imagePath: AssetConstants.icOnlyLogoText, width: sizeT)
        ],
      ),
    );
  }
}

class AppLogoWithTitle extends StatelessWidget {
  const AppLogoWithTitle({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final sizeL = size ?? Get.width / 4;
    final sizeT = size ?? Get.width / 3;
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(AssetConstants.ic_logo_horizontal, height: sizeL, width: sizeL),
          // SvgPicture.asset(AssetConstants.icLogo, height: sizeL, width: sizeL),
          // // vSpacer15(),
          // ImageAsset(imagePath: AssetConstants.icLogoWithText, width: sizeT)
        ],
      ),
    );
  }
}

class ShowHideIconView extends StatelessWidget {
  const ShowHideIconView({super.key, required this.isShow, required this.onTap});

  final bool isShow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: isShow
            ? Icon(Icons.visibility_outlined, color: context.theme.primaryColor)
            : Icon(Icons.visibility_off_outlined, color: context.theme.primaryColor));
  }
}

class RoundTextWithBG extends StatelessWidget {
  const RoundTextWithBG({super.key, this.text, this.size, this.iconData});

  final String? text;
  final double? size;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    final sizeL = size ?? Dimens.iconSizeLarge2x;
    return ClipOval(
      child: Container(
          alignment: Alignment.center,
          width: sizeL,
          height: sizeL,
          padding: const EdgeInsets.all(5),
          color: context.theme.focusColor,
          child: text!.isValid
              ? TextAutoMetropolis(text!, color: Colors.white, fontSize: sizeL / 3)
              : iconData != null
                  ? Icon(iconData, color: Colors.white)
                  : const SizedBox()),
    );
  }
}


class TwoTextSpaceFixed extends StatelessWidget {
  const TwoTextSpaceFixed(this.text, this.subText,
      {Key? key, this.subColor, this.color, this.maxLine = 1, this.subMaxLine = 1, this.fontSize, this.crossAxisAlignment, this.flex = 3})
      : super(key: key);

  final String text;
  final String subText;
  final Color? subColor;
  final Color? color;
  final int maxLine;
  final int subMaxLine;
  final double? fontSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: flex,
            child: TextAutoPoppins(text, fontSize: fontSize ?? Dimens.fontSizeRegular, color: color, textAlign: TextAlign.start, maxLines: maxLine)),
        Expanded(
            flex: 7,
            child: TextAutoPoppins(subText,
                fontSize: fontSize ?? Dimens.fontSizeRegular, color: subColor, textAlign: TextAlign.end, maxLines: subMaxLine)),
      ],
    );
  }
}
