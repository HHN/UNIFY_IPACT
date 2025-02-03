import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/utils/colors.dart';
import 'common_utils.dart';
import 'dimens.dart';

class ButtonFillMain extends StatelessWidget {
  const ButtonFillMain(
      {super.key,
      this.title,
      this.onPress,
      this.textColor,
      this.bgColor,
      this.borderColor,
      this.borderRadius,
      this.isLoading,
      this.isTransparentBg,
      this.icon,
      this.fontSize,
      this.height = 42,
      this.iconSize});

  final String? title;
  final VoidCallback? onPress;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? fontSize;
  final bool? isLoading;
  final bool? isTransparentBg;
  final IconData? icon;
  final double? iconSize;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var isTransparentBg = false;
    final isLoadingL = isLoading ?? false;
    final textColorL = textColor ?? context.theme.primaryColorLight;

    // final bgColorL = bgColor ?? context.theme.focusColor;
    final bgColorL = isTransparentBg == false ? bgColor ?? cDark : bgColor ?? Colors.transparent;
    final borderColorL = borderColor ?? cDark ;
    return ElevatedButton.icon(
        icon: isLoadingL
            ? Container(width: height, height: height, padding: const EdgeInsets.all(10), child: CircularProgressIndicator(color: textColorL, strokeWidth: 3))
            : icon != null
                ? Icon(icon, color: textColorL, size: iconSize ?? Dimens.iconSizeMid)
                :  SizedBox(height: height),
        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(bgColorL),
            backgroundColor: WidgetStateProperty.all<Color>(bgColorL),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 30)), side: BorderSide(color: borderColorL)))),
        onPressed: isLoadingL ? null : onPress,
        label:
            AutoSizeText(title ?? "", style: context.theme.textTheme.labelSmall!.copyWith(color: textColorL, fontSize: fontSize ?? Dimens.fontSizeRegular)));
  }
}

class ButtonOnlyCircleIcon extends StatelessWidget {
  const ButtonOnlyCircleIcon(
      {super.key,
        this.visualDensity,
        this.padding,
        this.onTap,
        this.iconData,
        this.iconColor,
        this.iconSize});

  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.theme.dividerColor,
      minRadius: 15,
      maxRadius: 18,
      child: IconButton(
        iconSize: iconSize ?? Dimens.iconSizeMid,
        padding: padding ?? EdgeInsets.zero,
        visualDensity: visualDensity ?? minimumVisualDensity,
        onPressed: onTap,
        icon: iconData != null
            ? Icon(
          iconData,
          color: iconColor ?? context.theme.primaryColorDark,
          size: Dimens.iconSizeMin,
        )
            : const SizedBox(),
      ),
    );
  }
}
class SvgCircleIcon extends StatelessWidget {
  const SvgCircleIcon(
      {super.key,
        this.visualDensity,
        this.padding,
        this.onTap,
        this.iconName,
        this.iconColor,
        this.iconSize});

  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final String? iconName;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.theme.dividerColor,
      minRadius: 15,
      maxRadius: 18,
      child: SvgPicture.asset(iconName!,color: context.theme.primaryColorDark, height: 22, width: 22),
    );
  }
}

class CircleIconSvg extends StatelessWidget {
  const CircleIconSvg(
      {super.key,
        this.iconData,
        this.iconColor,
        this.iconSize});

  final String? iconData;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.theme.dividerColor,
      minRadius: 15,
      maxRadius: 18,
      child: SvgPicture.asset(iconData!,
        color: iconColor ?? context.theme.primaryColorDark,
        height: iconSize,
      ),
    );
  }
}


class OnlyIcon extends StatelessWidget {
  const OnlyIcon(
      {super.key,
        this.visualDensity,
        this.padding,
        this.onTap,
        this.iconData,
        this.iconColor,
        this.iconSize});

  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize ?? Dimens.iconSizeMid,
      padding: padding ?? EdgeInsets.zero,
      visualDensity: visualDensity ?? minimumVisualDensity,
      onPressed: onTap,
      icon: iconData != null
          ? Icon(
        iconData,
        color: iconColor ?? context.theme.focusColor,
        size: Dimens.iconSizeMin,
      )
          : const SizedBox(),
    );
  }
}
class ButtonFillMainWhiteBg extends StatelessWidget {
  const ButtonFillMainWhiteBg(
      {super.key,
      this.title,
      this.onPress,
      this.textColor,
      this.bgColor,
      this.borderColor,
      this.borderRadius,
      this.isLoading,
      this.isTransparentBg,
      this.icon,
      this.fontSize,
      this.height = 45,
      this.iconSize});

  final String? title;
  final VoidCallback? onPress;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? fontSize;
  final bool? isLoading;
  final bool? isTransparentBg;
  final IconData? icon;
  final double? iconSize;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var isTransparentBg = false;
    final isLoadingL = isLoading ?? false;
    final textColorL = textColor ?? context.theme.secondaryHeaderColor;

    // final bgColorL = bgColor ?? context.theme.focusColor;
    final bgColorL = bgColor ?? context.theme.scaffoldBackgroundColor;
    final borderColorL = borderColor ?? cDark ;
    return ElevatedButton.icon(
        icon: isLoadingL
            ? Container(color: Colors.transparent,width: height, height: height, padding: const EdgeInsets.all(10), child: CircularProgressIndicator(color: textColorL, strokeWidth: 3))
            : icon != null
                ? Icon(icon, color: textColorL, size: iconSize ?? Dimens.iconSizeMid)
                :  SizedBox(height: height),

        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(bgColorL),
            backgroundColor: WidgetStateProperty.all<Color>(bgColorL),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 50)), side: BorderSide(color: borderColorL)))),
        onPressed: isLoadingL ? null : onPress,
        label:
            AutoSizeText(title ?? "", style: context.theme.textTheme.labelSmall!.copyWith(color: textColorL, fontSize: fontSize ?? Dimens.fontSizeRegular)));
  }
}

class ButtonOnlyIcon extends StatelessWidget {
  const ButtonOnlyIcon({super.key, this.visualDensity, this.padding, this.onTap, this.iconData, this.iconColor, this.iconSize});

  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize ?? Dimens.iconSizeMid,
      padding: padding ?? EdgeInsets.zero,
      visualDensity: visualDensity ?? minimumVisualDensity,
      onPressed: onTap,
      icon: iconData != null ? Icon(iconData, color: iconColor ?? context.theme.primaryColorDark) : const SizedBox(),
    );
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText(this.text,
      {Key? key,
        this.onPress,
        this.textColor,
        this.bgColor,
        this.radius = 30,
        this.isEnable = true,
        this.borderColor,
        this.fontSize,
        this.visualDensity})
      : super(key: key);

  final String text;
  final VoidCallback? onPress;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final double radius;
  final double? fontSize;
  final bool isEnable;
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    final bgColorL = bgColor ?? Theme.of(context).focusColor;
    return ElevatedButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all<double>(0),
            overlayColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor.withOpacity(0.1)),
            foregroundColor: WidgetStateProperty.all<Color>(bgColorL),
            backgroundColor: WidgetStateProperty.all<Color>(bgColorL),
            visualDensity: visualDensity,
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: borderColor ?? bgColorL, width: 2)))),
        onPressed: isEnable ? onPress : null,
        child:
        AutoSizeText(text, style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: fontSize ?? 14, color: textColor), minFontSize: 8));
  }
}
