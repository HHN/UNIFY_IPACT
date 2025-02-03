import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/features/auth/set_up_pin/set_up_pin_screen.dart';
import 'package:unify_secret/utils/common_utils.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  // final nameEditController = TextEditingController();
  final usernameEditController = TextEditingController();
  // final emailEditController = TextEditingController();
  final passEditController = TextEditingController();
  final confirmPassEditController = TextEditingController();
  RxBool isShowPassword = false.obs;


  void clearInputData() {
    usernameEditController.text = "";
    passEditController.text = "";
    confirmPassEditController.text = "";
    isShowPassword = false.obs;
  }

  void isInPutDataValid({String? mnemonicText, BuildContext? context}) {
    if (usernameEditController.text.isNotEmpty &&
        passEditController.text.isNotEmpty &&
        confirmPassEditController.text.isNotEmpty) {

      //hideKeyboard(context);
      Get.to(() => SetUpPinScreen(
          mnemonicText: mnemonicText.toString().trim(),
          userName: usernameEditController.text,
          password: passEditController.text));
    } else {
      CustomSnackBar.show(context!,"Fields can not be empty.");
    }
  }


}
