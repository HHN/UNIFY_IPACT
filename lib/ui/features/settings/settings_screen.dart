import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'package:unify_secret/utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWithBack(title: "Settings".tr),
            vSpacer20(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.paddingLarge),
                child: Card(
                  elevation: 1.0,
                  color: context.theme.scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoFormRow(
                      padding: EdgeInsets.zero,
                      prefix: Row(
                        children: <Widget>[
                          hSpacer10(),
                          Icon(GlobalVariables.gIsDarkMode ? Icons.dark_mode : Icons.light_mode, size: Dimens.iconSizeMid,color: context.theme.primaryColorDark,),
                          hSpacer10(),
                          TextAutoMetropolis(GlobalVariables.gIsDarkMode ? 'Dark Mode'.tr : "Light Mode".tr, fontSize: Dimens.fontSizeMid)
                        ],
                      ),
                      child: CupertinoSwitch(
                        value: GlobalVariables.gIsDarkMode,
                        activeColor: context.theme.focusColor,
                        onChanged: (value) => ThemeService().switchTheme(),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
