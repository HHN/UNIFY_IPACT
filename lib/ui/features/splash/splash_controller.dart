import 'package:get/get.dart';
import 'package:unify_secret/ui/features/auth/welcome_screen/welcome_screen.dart';
import 'package:unify_secret/utils/network_util.dart';

class SplashController extends GetxController {
  RxBool hasLocalAuth = false.obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    NetworkCheck.isOnline().then((value) {
      if (value) {
        Future.delayed(const Duration(seconds: 3), () async {
          Get.to(() => const WelcomeScreen());
          // var loggedIn = GetStorage().read(PreferenceKey.isLoggedIn);
          // if (loggedIn) {
          //   Get.offAll(() => const RootScreen());
          // } else {
          //   Get.off(() => const RootScreen());
          // }
        });
      }
    });
  }
}
