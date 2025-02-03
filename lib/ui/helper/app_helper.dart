import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unify_secret/ui/features/auth/welcome_screen/welcome_screen.dart';

import '../../data/local/constants.dart';
import '../../data/models/settings.dart';
import '../../utils/common_utils.dart';


void logOutActions() {
  var storage = GetStorage();
  storage.write(PreferenceKey.accessToken, "");
  storage.write(PreferenceKey.isLoggedIn, false);
  storage.write(PreferenceKey.userObject, {});
  Get.offAll(() => const WelcomeScreen());
}

CommonSettings? getCommonSettingsLocal() {
  try {
    final dataMap = GetStorage().read(PreferenceKey.settingsObject);
    if (dataMap != null) {
      return CommonSettings.fromJson(dataMap);
    }
  } catch (error) {
    printFunction("getSettingLocal error", error);
  }
  return null;
}
