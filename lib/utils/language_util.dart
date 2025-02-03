import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/local/constants.dart';

class LanguageUtil {
  static List<String> allRtlKey = ["ar", "az", "dv", "he", "ku", "fa", "ur"];
  static String defaultLangKey = "en";
  static final List<LanguageObj> locales = [
    LanguageObj(code: defaultLangKey, name: "English", local: Locale(defaultLangKey)),
    LanguageObj(code: 'es', name: "Español", local: const Locale('es')),

    ///Language(code: 'bn', name: "বাংলা", local: const Locale('bn', "BD")),
  ];

  // void dialogForLanguageChange(Function(String) onChange) {
  //   showModalSheetFullScreen(
  //     Get.context!,
  //     Column(
  //       children: [
  //         Text("Choose Your Language".tr, style: Get.textTheme.bodyLarge),
  //         const SizedBox(height: 10),
  //         ConstrainedBox(
  //           constraints: BoxConstraints(maxHeight: Get.width),
  //           child: ListView.separated(
  //               shrinkWrap: true,
  //               itemBuilder: (context, index) {
  //                 return InkWell(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8),
  //                     child: Text(locales[index].name, style: Get.textTheme.labelSmall),
  //                   ),
  //                   onTap: () async {
  //                     final localObj = locales[index];
  //                     Get.back();
  //                     Get.updateLocale(localObj.local);
  //                     GetStorage().write(PreferenceKey.languageKey, localObj.code);
  //                     onChange(localObj.name);
  //                   },
  //                 );
  //               },
  //               separatorBuilder: (context, index) => Divider(color: context.theme.primaryColor),
  //               itemCount: locales.length),
  //         )
  //       ],
  //     ),
  //   );
  // }

  static Locale getCurrentLocal() {
    String currentKey = GetStorage().read(PreferenceKey.languageKey) ?? defaultLangKey;
    return Locale(currentKey);
  }

  static LanguageObj getCurrentLanguageObj() {
    String currentKey = getCurrentKey();
    LanguageObj language = LanguageUtil.locales.singleWhere((element) => element.code == currentKey);
    return language;
  }

  static void updateLanguage(String key) {
    Get.updateLocale(Locale(key));
    GetStorage().write(PreferenceKey.languageKey, key);
  }

  static String getCurrentKey() {
    return GetStorage().read(PreferenceKey.languageKey);
  }

  static TextDirection getTextDirection() {
    return LanguageUtil.allRtlKey.contains(getCurrentKey()) ? TextDirection.rtl : TextDirection.ltr;
  }

  static bool isDirectionRTL() {
    return LanguageUtil.allRtlKey.contains(getCurrentKey());
  }
}

class LanguageObj {
  String code;
  String name;
  Locale local;

  LanguageObj({required this.code, required this.name, required this.local});

  factory LanguageObj.fromJson(Map<String, dynamic> json) => LanguageObj(
        code: json["code"],
        name: json["name"],
        local: json["local"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "local": local,
      };
}
