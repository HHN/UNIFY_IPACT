import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button_util.dart';
import 'common_utils.dart';
import 'dimens.dart';

class TextAutoMetropolis extends StatelessWidget {
  const TextAutoMetropolis(this.text, {super.key, this.maxLines, this.textAlign, this.color, this.fontSize});

  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        maxLines: maxLines,
        minFontSize: 10,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: context.theme.textTheme.titleMedium!.copyWith(color:  color ??context.theme.secondaryHeaderColor, fontSize: fontSize));
  }
}

class TextAutoPoppins extends StatelessWidget {
  const TextAutoPoppins(this.text, {super.key, this.maxLines, this.textAlign, this.color, this.fontSize, this.decoration, this.height});

  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final double? height;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        maxLines: maxLines,
        minFontSize: 10,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: context.theme.textTheme.bodyMedium!.copyWith(color: color ?? context.theme.primaryColor, fontSize: fontSize, decoration: decoration, height: height));
  }
}

class TextAutoSpan extends StatelessWidget {
  const TextAutoSpan({super.key, required this.text, required this.subText, this.onTap, this.maxLines});

  final String text;
  final String subText;
  final VoidCallback? onTap;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
        TextSpan(
          text: text,
          style: context.textTheme.bodyMedium!.copyWith(color: context.theme.primaryColor),
          children: <TextSpan>[
            TextSpan(
                text: subText,
                style: context.textTheme.titleMedium!.copyWith(fontSize: Dimens.fontSizeRegular,decoration: TextDecoration.underline,color: context.theme.primaryColorDark),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ],
        ),
        maxLines: maxLines);
  }
}

class TextWithCopyIcon extends StatelessWidget {
  const TextWithCopyIcon(this.text, {Key? key, this.maxLines = 2, this.iconSize, this.textAlign, this.padding}) : super(key: key);
  final String text;
  final int maxLines;
  final double? iconSize;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(Dimens.paddingMid),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: TextAutoPoppins(text, maxLines: maxLines, textAlign: textAlign)),
            ButtonOnlyIcon(
                iconData: Icons.copy_outlined, iconColor: context.theme.primaryColor, iconSize: iconSize, onTap: () => copyToClipboard(text))
          ],
        ));
  }
}


class RichTextCustom extends StatelessWidget {
  const RichTextCustom(
      {super.key,
        required this.context,
        required this.leftText,
        required this.rightText});

  final BuildContext? context;
  final String? leftText;
  final String? rightText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: leftText,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: rightText,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}