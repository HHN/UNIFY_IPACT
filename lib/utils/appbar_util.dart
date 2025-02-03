import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'button_util.dart';
import 'dimens.dart';

class AppBarMainOld extends StatelessWidget {
  const AppBarMainOld(
      {super.key, required this.contextMain, required this.title});

  final BuildContext contextMain;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: ButtonOnlyIcon(
          iconData: Icons.menu,
          iconSize: Dimens.iconSizeMid,
          onTap: () => Scaffold.of(contextMain).openDrawer()),
      title: TextAutoMetropolis(title, fontSize: Dimens.fontSizeMid),
      actions: [
        // ButtonOnlyIcon(iconData: Icons.category, iconSize: Dimens.iconSizeMin, onTap: (){}),
        // hSpacer10(),
      ],
    );
  }
}

AppBar appBarMain({String? title, BuildContext? context}) {
  return AppBar(
    backgroundColor: context!.theme.scaffoldBackgroundColor,
    elevation: 0,
    centerTitle: true,
    leading: ButtonOnlyIcon(
        iconData: Icons.menu,
        iconSize: Dimens.iconSizeMid,
        onTap: () => Scaffold.of(context!).openDrawer()),
    title: TextAutoMetropolis(title ?? '', fontSize: Dimens.fontSizeMid),
    actions: [
      // ButtonOnlyIcon(iconData: Icons.category, iconSize: Dimens.iconSizeMin, onTap: (){}),
      // hSpacer10(),
    ],
  );
}

AppBar appBarMainWithRefresh(
    {String? title, BuildContext? context, VoidCallback? onTap}) {
  return AppBar(
    backgroundColor: context!.theme.scaffoldBackgroundColor,
    elevation: 0,
    centerTitle: true,
    leading: ButtonOnlyIcon(
        iconData: Icons.menu,
        iconSize: Dimens.iconSizeMid,
        onTap: () => Scaffold.of(context!).openDrawer()),
    title: TextAutoMetropolis(title ?? '', fontSize: Dimens.fontSizeMid),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ButtonOnlyIcon(
            iconData: Icons.refresh,
            iconSize: Dimens.iconSizeMid,
            onTap: onTap),
      ),
    ],
  );
}

class AppBarWithBack extends StatelessWidget {
  const AppBarWithBack({super.key, required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: ButtonOnlyIcon(
          iconData: Icons.arrow_back,
          iconSize: Dimens.iconSizeMid,
          onTap: () => Get.back()),
      title: TextAutoMetropolis(title ?? '', fontSize: Dimens.fontSizeMid),
    );
  }
}

AppBar appBarWithBack({String? title, BuildContext? context}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: context!.theme.scaffoldBackgroundColor,
    leading: ButtonOnlyIcon(
        iconData: Icons.arrow_back,
        iconSize: Dimens.iconSizeMid,
        onTap: () => Get.back()),
    title: TextAutoMetropolis(title ?? '', fontSize: Dimens.fontSizeMid),
  );
}

class AppBarOnlyTitle extends StatelessWidget {
  const AppBarOnlyTitle({super.key, required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: const SizedBox(),
      title: TextAutoMetropolis(title ?? '', fontSize: Dimens.fontSizeMid),
    );
  }
}
