import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/features/auth/sign_up/sign_up_screen.dart';
import 'package:unify_secret/utils/extentions.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';

import 'button_util.dart';
import 'dimens.dart';

void alertForAction(BuildContext context,
    {String? title,
    String? subTitle,
    int? maxLinesSub,
    String? buttonYesTitle,
    VoidCallback? onYesAction,
    String? buttonNoTitle,
    VoidCallback? onNoAction,
    Color? noButtonColor,
    Color? yesButtonColor}) {
  final view = Column(
    children: [
      vSpacer10(),
      if (title.isValid)
        TextAutoMetropolis(title!,
            maxLines: 2,
            fontSize: Dimens.fontSizeMid,
            textAlign: TextAlign.center),
      vSpacer30(),
      if (subTitle.isValid)
        TextAutoPoppins(subTitle!,
            maxLines: maxLinesSub ?? 5, textAlign: TextAlign.center),
      vSpacer30(),
      vSpacer30(),
      if (buttonYesTitle.isValid)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: Get.width / 3,
              child: ButtonFillMain(
                  title: buttonNoTitle,
                  onPress: onNoAction,
                  borderColor: Colors.transparent,
                  bgColor: noButtonColor),
            ),
            SizedBox(
              width: Get.width / 3,
              child: ButtonFillMain(
                  title: buttonYesTitle,
                  onPress: onYesAction,
                  borderColor: Colors.transparent,
                  bgColor: yesButtonColor),
            ),
          ],
        ),
      vSpacer10(),
    ],
  );
  showModalSheetScreen(context, view);
}

void alertForAction2(BuildContext context,
    {String? title,
    String? subTitle,
    int? maxLinesSub,
    String? buttonYesTitle,
    VoidCallback? onYesAction,
    String? buttonNoTitle,
    VoidCallback? onNoAction,
    Color? noButtonColor,
    bool? isChecked,
    Color? yesButtonColor}) {
  final view = Column(
    children: [
      vSpacer10(),
      if (title.isValid)
        TextAutoMetropolis(title!,
            maxLines: 2,
            fontSize: Dimens.fontSizeMid,
            textAlign: TextAlign.center),
      vSpacer10(),
      if (subTitle.isValid)
        TextAutoPoppins(subTitle!,
            maxLines: maxLinesSub ?? 5, textAlign: TextAlign.center),
      vSpacer15(),
      if (buttonYesTitle.isValid)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonFillMain(
                title: buttonNoTitle,
                onPress: onNoAction,
                bgColor: noButtonColor),
            ButtonFillMain(
                title: buttonYesTitle,
                onPress: onYesAction,
                bgColor: yesButtonColor),
          ],
        ),
    ],
  );
  showModalSheetScreen(context, view);
}

showModalSheetScreen(BuildContext context, Widget customView,
    {Function? onClose, bool? isDismissible}) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: isDismissible ?? true,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonOnlyIcon(
                    iconData: Icons.cancel_outlined,
                    iconSize: Dimens.iconSizeMid,
                    iconColor: Colors.white,
                    onTap: () {
                      Get.back();
                      if (onClose != null) onClose();
                    }),
                hSpacer10(),
              ],
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(Dimens.paddingMid),
                margin: const EdgeInsets.symmetric(
                    vertical: Dimens.paddingLarge,
                    horizontal: Dimens.paddingMid),
                decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    border:
                        Border.all(color: context.theme.primaryColor, width: 1),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Dimens.cornerRadiusMid))),
                child: customView)
          ],
        );
      });
}

void showBottomSheetFullScreen(BuildContext context, Widget customView,
    {Function? onClose,
    String? title,
    bool isScrollControlled = true,
    double? titleFontSize}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) =>
        BottomSheetView(customView, title: title, titleFontSize: titleFontSize),
  ).whenComplete(() => onClose != null ? onClose() : {});
}

class BottomSheetView extends StatelessWidget {
  const BottomSheetView(this.customView,
      {Key? key, this.title, this.titleFontSize})
      : super(key: key);

  final Widget customView;
  final String? title;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.height - 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimens.cornerRadiusLarge),
                topRight: Radius.circular(Dimens.cornerRadiusLarge))),
        padding: const EdgeInsets.all(Dimens.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isValid)
                  Expanded(
                      child: TextAutoMetropolis(title!,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          fontSize: titleFontSize ?? Dimens.fontSizeMid))
                else
                  hSpacer30(),
                InkResponse(
                    child: Icon(Icons.cancel_outlined,
                        size: Dimens.iconSizeLarge,
                        color: Theme.of(context).primaryColorLight),
                    onTap: () => Navigator.of(context).pop())
              ],
            ),
            customView,
          ],
        ));
  }
}
