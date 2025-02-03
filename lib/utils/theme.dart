import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/local/constants.dart';
import '../ui/helper/global_variables.dart';
import 'colors.dart';
import 'dimens.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    textTheme: lightTextTheme,
    primaryColor: cCharleston,
    primaryColorLight: cMaxExtraLight,
    primaryColorDark: cDark,
    scaffoldBackgroundColor: cMaxExtraLight,
    secondaryHeaderColor: cSecondaryTextColor,
    dividerColor: cExtraLight2,
    cardColor: cLight,
    canvasColor: cExtraLight,
    focusColor: cLightDark,
    disabledColor: cSlateGray,
    iconTheme: const IconThemeData(color: cLightDark, size: Dimens.iconSizeMid),
    buttonTheme: const ButtonThemeData(buttonColor: cExtraLight, disabledColor: cSlateGray),
  );

  static final lightTextTheme = TextTheme(
    titleMedium: GoogleFonts.metrophobic(fontWeight: FontWeight.bold, color: cCharleston, fontSize: Dimens.fontSizeLarge),
    bodyMedium: GoogleFonts.metrophobic(fontWeight: FontWeight.normal, color: cCharleston, fontSize: Dimens.fontSizeRegular),

    /// For Button
    labelMedium: GoogleFonts.metrophobic(fontWeight: FontWeight.bold, color: cCharleston, fontSize: Dimens.fontSizeLarge),
  );

  static final dark = ThemeData.dark().copyWith(
    textTheme: lightTextTheme,
    primaryColor: cCharleston,
    primaryColorLight: cMaxExtraLight,
    primaryColorDark: cDark,
    scaffoldBackgroundColor: cMaxExtraLight,
    secondaryHeaderColor: cSecondaryTextColor,
    dividerColor: cExtraLight2,
    cardColor: cLight,
    canvasColor: cExtraLight,
    focusColor: cLightDark,
    disabledColor: cSlateGray,
    iconTheme: const IconThemeData(color: cLightDark, size: Dimens.iconSizeMid),
    buttonTheme: const ButtonThemeData(buttonColor: cExtraLight, disabledColor: cSlateGray),
  );

  static final darkTextTheme = TextTheme(
    titleMedium: GoogleFonts.metrophobic(fontWeight: FontWeight.bold, color: cMaxExtraLight, fontSize: Dimens.fontSizeLarge),
    bodyMedium: GoogleFonts.metrophobic(fontWeight: FontWeight.normal, color: cMaxExtraLight, fontSize: Dimens.fontSizeRegular),

    /// For Button
    labelMedium: GoogleFonts.metrophobic(fontWeight: FontWeight.bold, color: cMaxExtraLight, fontSize: Dimens.fontSizeLarge),
  );
}

/// *** NOTE: get the view main colors by context (like background) *** ///
class ThemeService {
  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool loadThemeFromBox() => GetStorage().read(PreferenceKey.isDark) ?? false;

  _saveThemeToBox(bool isDarkMode) => GetStorage().write(PreferenceKey.isDark, isDarkMode);

  void switchTheme() {
    var isDark = loadThemeFromBox();
    GlobalVariables.gIsDarkMode = !GlobalVariables.gIsDarkMode;
    Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!isDark);
  }
}
