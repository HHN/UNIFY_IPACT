import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/ui/features/auth/auth_widgets.dart';
import 'package:unify_secret/ui/features/auth/set_up_pin/set_up_pin_screen.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  final String mnemonicText;

  const SignUpScreen({super.key, required this.mnemonicText});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  final _controller = Get.put(SignUpController());

  @override
  void dispose() {
    _controller.clearInputData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingMid),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpacer10(),
                  ScreenStepForAccountCreation(isActive11: context.theme.focusColor,isActive12: context.theme.focusColor),
                  vSpacer20(),
                  vSpacer30(),
                  const AppLogo(),
                  vSpacer30(),
                  // TextAutoMetropolis(widget.mnemonicText.toString(),maxLines: 30,),
                  // const TextAutoMetropolis('Create Profile',maxLines: 2,fontSize: 12,),
                  AuthTitleView(
                      title: "Create Profile".tr,
                      subTitle: "Your data is encrypted and stored locally on your device using IOTA Stronghold.".tr,
                      subMaxLines: 2),
                  vSpacer30(),
                  Form(
                    key: _controller.formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextAutoMetropolis("Full Name".tr,
                          //     fontSize: Dimens.fontSizeRegular),
                          // vSpacer5(),
                          // TextFieldView(
                          //     controller: nameEditController,
                          //     hint: "Enter full name".tr,
                          //     helperMaxLines: 2,
                          //     inputType: TextInputType.name,
                          //     helperText:
                          //         "Make sure matches the government ID".tr,
                          //     validator: (text) =>
                          //         TextFieldValidator.emptyValidator(text,
                          //             message: "Full name is required".tr)),
                          // vSpacer15(),
                          TextAutoMetropolis("Username".tr,
                              fontSize: Dimens.fontSizeRegular),
                          vSpacer5(),
                          TextFieldView(
                              controller: _controller.usernameEditController,
                              hint: "Enter unique username".tr,
                              inputType: TextInputType.name,
                              validator: TextFieldValidator.usernameValidator),
                          vSpacer15(),
                          // TextAutoMetropolis("Email".tr,
                          //     fontSize: Dimens.fontSizeRegular),
                          // vSpacer5(),
                          // TextFieldView(
                          //     controller: emailEditController,
                          //     hint: "Enter email".tr,
                          //     inputType: TextInputType.emailAddress,
                          //     validator: TextFieldValidator.emailValidator),
                          // vSpacer15(),
                          TextAutoMetropolis("Password".tr,
                              fontSize: Dimens.fontSizeRegular),
                          vSpacer5(),
                          Obx(() => TextFieldView(
                              controller: _controller.passEditController,
                              hint: "Enter password".tr,
                              isObscure: !_controller.isShowPassword.value,
                              inputType: TextInputType.visiblePassword,
                              errorMaxLines: 3,
                              helperMaxLines: 3,
                              helperText: "Password_invalid_message".trParams({
                                "count": LimitConst.passwordLength.toString()
                              }),
                              suffix: ShowHideIconView(
                                  isShow: _controller.isShowPassword.value,
                                  onTap: () => _controller.isShowPassword.value =
                                      !_controller.isShowPassword.value),
                              validator: TextFieldValidator.passwordValidator
                              // validator: (text) => (TextFieldValidator.passwordValidator) && (TextFieldValidator.emptyValidator(text, message: "Full name is required".tr))
                          )),
                          vSpacer15(),
                          TextAutoMetropolis("Confirm Password".tr,
                              fontSize: Dimens.fontSizeRegular),
                          vSpacer5(),
                          Obx(() => TextFieldView(
                              controller: _controller.confirmPassEditController,
                              hint: "Enter confirm password".tr,
                              isObscure: !_controller.isShowPassword.value,
                              inputType: TextInputType.visiblePassword,
                              suffix: ShowHideIconView(
                                  isShow: _controller.isShowPassword.value,
                                  onTap: () => _controller.isShowPassword.value =
                                      !_controller.isShowPassword.value),
                              validator: (text) =>
                                  TextFieldValidator.confirmPasswordValidator(
                                      text,
                                      password: _controller.passEditController.text))),
                          vSpacer30(),
                          // TextAutoSpan(
                          //     text: 'By selecting Agree and continue'.tr,
                          //     subText: "Privacy Policy".tr,
                          //     onTap: () => () {
                          //           Get.to(() => const SignInScreen());
                          //         }),
                          // vSpacer5(),

                          vSpacer30(),
                          Container(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: Get.width / 2.5,
                              child: ButtonFillMain(
                                  title: "Continue".tr,
                                  onPress: () {                                    final isValid = _controller.formKey.currentState?.validate();
                                  hideKeyboard();

                                    if (_controller.usernameEditController.text.isNotEmpty &&
                                        _controller.passEditController.text.isNotEmpty &&
                                        _controller.confirmPassEditController.text.isNotEmpty) {

                                      if (isValid != null && isValid) {
                                        _controller.formKey.currentState?.save();
                                        Get.to(() => SetUpPinScreen(
                                            mnemonicText: widget.mnemonicText.toString(),
                                            userName: _controller.usernameEditController.text.trim(),
                                            password: _controller.passEditController.text));
                                      }
                                    } else {
                                      CustomSnackBar.show(context,"Fields can not be empty.");
                                      // showToast("Fields can not be empty".tr, isError: true);
                                    }
                                  }),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
