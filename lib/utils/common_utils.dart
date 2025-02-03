import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/utils/extentions.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../data/local/constants.dart';
import '../ui/helper/global_variables.dart';

// void showToast(String? text,
//     {bool isError = true, bool isLong = false, BuildContext? context}) {
//   if (text!.isValid) return;
//   context = context ?? GlobalVariables.currentContext;
//   final bgColor = isError ? Colors.red : Get.theme.primaryColor;
//   final textColor = isError ? Colors.white : Get.theme.primaryColorDark;
//   if (context != null && context.mounted && isError) {
//     Widget toast = Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: const BorderRadius.all(Radius.circular(15))),
//         child: TextAutoPoppins(text, color: textColor, maxLines: 10));
//     FToast().init(context).showToast(
//         child: toast,
//         gravity: ToastGravity.BOTTOM,
//         toastDuration: Duration(seconds: isLong ? 5 : 2));
//   } else {
//     Fluttertoast.showToast(
//         msg: text,
//         toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: bgColor,
//         textColor: textColor);
//   }
// }

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.theme.primaryColorDark,
        content: TextAutoPoppins(
          message,
          color: context.theme.primaryColorLight,
        ),
      ),
    );
  }
}

/*class ToastScaffoldMessenger extends StatelessWidget {
  const ToastScaffoldMessenger(
      {super.key, this.message, this.context});

  final String? message;
  final BuildContext? context;

  @override
  Widget build(BuildContext context) {
    final messageL = message ?? "No data available".tr;
     ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      backgroundColor: context.theme.primaryColorDark,
      content: TextAutoPoppins(
        message!,
        color: context.theme.primaryColorLight,
      ),
    ));
  }
}*/

// Widget scaffoldMessenger(
//     {BuildContext? context,String? message}) {
//    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
//     backgroundColor: context.theme.primaryColorDark,
//     content: TextAutoPoppins(
//       message!,
//       color: context.theme.primaryColorLight,
//     ),
//   ));
// }

void showLoadingDialog(BuildContext context, {bool isDismissible = false}) {
  if (Get.isDialogOpen == null || !Get.isDialogOpen!) {
    Get.dialog(
        Center(
            child: CircularProgressIndicator(color: context.theme.focusColor)),
        barrierDismissible: isDismissible);
  }
}


Future<String> iPactWalletFilePath() async {

  final Directory appSupportDir = await getApplicationSupportDirectory();

  // Create the Stronghold folder and take over the path
  final Directory appSupportDirStrongholdFolder = Directory('${appSupportDir.path}/');
  return "${appSupportDirStrongholdFolder.path}ipact_wallet/";

}

VisualDensity get minimumVisualDensity =>
    const VisualDensity(horizontal: -4, vertical: -4);

void hideLoadingDialog() {
  if (Get.isDialogOpen != null && Get.isDialogOpen!) Get.back();
}

void hideKeyboard({BuildContext? context}) {
  if (context == null) {
    FocusManager.instance.primaryFocus?.unfocus();
  } else if (FocusScope.of(context).canRequestFocus) {
    FocusScope.of(context).unfocus();
  }
}

void printFunction(String tag, dynamic data) {
  if (kDebugMode) GetUtils.printFunction("$tag => ", data, "");
}

void clearStorage() {
  var storage = GetStorage();
  storage.write(PreferenceKey.accessToken, "");
  storage.write(PreferenceKey.isLoggedIn, false);
  storage.write(PreferenceKey.userObject, {});
}

void editTextFocusDisable(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

bool systemThemIsDark() =>
    SchedulerBinding.instance.platformDispatcher.platformBrightness ==
    Brightness.dark;

void copyToClipboard(String string) {
  Clipboard.setData(ClipboardData(text: string)).then((_) {
    // showToast("Text copied to clipboard".tr, isError: false);
  });
}

String removeSpecialChar(String? text) {
  if (text != null && text.isNotEmpty) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), '');
  }
  return "";
}

Future<String> htmlStringFromLocal(String path) async {
  String fileText = await rootBundle.loadString(path);
  String htmlStr = Uri.dataFromString(fileText,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
      .toString();
  return htmlStr;
}

bool isValidPassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{6,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String getNameCharacter(String? name) {
  if (name.isValid) {
    final list = name!.trim().split(' ').toList();
    if (list.length > 1) {
      return list.map((l) => l[0]).take(2).join().toUpperCase();
    } else {
      return (list.first.length > 2 ? list.first.substring(0, 2) : list.first)
          .toUpperCase();
    }
  }
  return '';
}

//package_info_plus:
Future<String> getAppId() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.packageName;
}

void navBackToRoot(BuildContext context) =>
    Navigator.popUntil(context, (route) => route.isFirst);

void openUrlInLauncher(String url,
    {LaunchMode launchMode = LaunchMode.platformDefault,
    BuildContext? context}) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: launchMode);
  } else {
    CustomSnackBar.show(context!, "The URL is invalid.");
  }
}



void showToast(String text, {bool isError = true, bool isLong = false}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    // backgroundColor: isError ? Colors.red : Colors.greenAccent,
    textColor: Colors.white,
    // webBgColor: linear-gradient(to right, #00b09b, #96c93d)
    //fontSize: 16.0
  );
}