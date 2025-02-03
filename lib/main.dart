import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/collaboration/documents.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ui/features/splash/splash_page.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/language_util.dart';
import 'package:unify_secret/utils/theme.dart';
import 'data/local/constants.dart';
import 'data/local/strings.dart';
import 'data/remote/api_provider.dart';

void main() async {
  await GetStorage.init();
  await _setDefaultValues();
  WidgetsFlutterBinding.ensureInitialized();

  //Directory directory = await getApplicationDocumentsDirectory();
  Directory? directory = await getExternalStorageDirectory();
  Hive.init(directory?.path);
  Hive.initFlutter('hive_db'); // sub directory

  ///  Register the adapter for user
  // Hive.registerAdapter<UsersCollection>(UsersCollectionAdapter());
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox<User>('users');
  Hive.registerAdapter<Collaborations>(CollaborationsAdapter());
  await Hive.openBox<Collaborations>('collaborations');
  Hive.registerAdapter<Documents>(DocumentsAdapter());
  await Hive.openBox<Documents>('documents');

  GlobalVariables.gIsDarkMode = ThemeService().loadThemeFromBox();
  Get.put(APIProvider());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, statusBarIconBrightness: GlobalVariables.gIsDarkMode ? Brightness.light : Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(const MyApp()));
}

Future<void> _setDefaultValues() async {
  GetStorage().writeIfNull(PreferenceKey.isDark, systemThemIsDark());
  GetStorage().writeIfNull(PreferenceKey.isLoggedIn, false);
  GetStorage().writeIfNull(PreferenceKey.languageKey, LanguageUtil.defaultLangKey);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LanguageUtil.getTextDirection(),
      child: GetMaterialApp(
        title: "UnifySecret".tr,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeftWithFade,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        translations: Strings(),
        locale: LanguageUtil.getCurrentLocal(),
        fallbackLocale: Locale(LanguageUtil.defaultLangKey),
        localizationsDelegates: const [],
        initialRoute: "/",
        builder: (context, child) {
          // final scale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3);
          // return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: scale), child: child!);
          final scale = MediaQuery.of(context).textScaler.clamp();
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: scale), child: child!);
        },
        home: const SplashScreen(),
      ),
    );
  }
}
