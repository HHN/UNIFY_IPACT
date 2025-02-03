import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/features/auth/auth_widgets.dart';
import 'package:unify_secret/ui/features/auth/profileSuccessful/profile_successful_screen.dart';
import 'package:unify_secret/ui/features/auth/set_up_pin/set_up_pin_controller.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';

class SetUpPinScreen extends StatefulWidget {
  final String mnemonicText;
  final String userName;
  final String password;

  const SetUpPinScreen(
      {super.key,
      required this.mnemonicText,
      required this.userName,
      required this.password});

  @override
  State<SetUpPinScreen> createState() => _SetUpPinScreenState();
}

class _SetUpPinScreenState extends State<SetUpPinScreen> {
  final _controller = Get.put(SetUpPinScreenController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final subTitle = "${'Enter verification code which sent email'.tr} ${widget.registrationId}";
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
                  ScreenStepForAccountCreation(
                      isActive11: context.theme.focusColor,
                      isActive12: context.theme.focusColor,
                      isActive13: context.theme.focusColor),
                  vSpacer20(),
                  vSpacer30(),
                  const AppLogo(),
                  vSpacer30(),
                  //
                  // TextAutoMetropolis(widget.mnemonicText.toString(),maxLines: 30,),
                  // TextAutoMetropolis(widget.userName.toString(),maxLines: 30,),
                  // TextAutoMetropolis(widget.password.toString(),maxLines: 30,),
                  AuthTitleView(
                      title: "Set iPact Pin".tr,
                      subTitle: "Please record this PIN and store it in a secure location, such as a trusted password manager. Losing this PIN will result in losing access to iPact!",
                      subMaxLines: 3),
                  vSpacer30(),
                  Form(
                    key: _controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoMetropolis("Input PIN".tr,
                            fontSize: Dimens.fontSizeRegular,color: context.theme.primaryColor),
                        vSpacer5(),
                        TextFieldPinCode(
                          controller: _controller.pinCodeEditController,
                        ),
                        vSpacer30(),
                        TextAutoMetropolis("Confirm PIN".tr,
                            fontSize: Dimens.fontSizeRegular,color: context.theme.primaryColor),
                        vSpacer5(),
                        TextFieldPinCode(
                            controller: _controller.pinConfirmCodeEditController,
                            validator: (text) =>
                                TextFieldValidator.confirmPinValidator(text,
                                    pin: _controller.pinCodeEditController.text)),

                        vSpacer20(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimens.paddingMid),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: Get.width / 2.5,
                        child: Obx(() => ButtonFillMain(
                            title: "Set Pin".tr,
                            isLoading: _controller.isLoading.value,
                            onPress: () {

                              final isValid = _controller.formKey.currentState?.validate();



                              if(_controller.pinCodeEditController.text.isNotEmpty && _controller.pinConfirmCodeEditController.text.isNotEmpty){

                                if (isValid != null && isValid) {
                                  _controller.formKey.currentState?.save();

                                  Get.offAll(() => ProfileSuccessfulScreen(
                                      mnemonicText: widget.mnemonicText.toString(),
                                      userName: widget.userName.toString(),
                                      password: widget.password.toString(),
                                      pin: _controller.pinCodeEditController.text));
                                }
                                // showBottomSheetFullScreen(context, const View());
                                // showModalSheetScreen(context, const View());
                              }else if(_controller.pinCodeEditController.text.isEmpty || _controller.pinConfirmCodeEditController.text.isEmpty){
                               if(_controller.pinCodeEditController.text.isEmpty){
                                CustomSnackBar.show(context,"Input Pin can not be empty.");
                              }else if(_controller.pinConfirmCodeEditController.text.isEmpty){
                                CustomSnackBar.show(context,"Confirm Pin can not be empty.");
                              }else {
                                  CustomSnackBar.show(context, "Pin can not be empty.");
                                }
                              }

                              hideKeyboard();
                            })),
                      ),
                    ),
                  ),
                  /*Container(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: Get.width / 2.5,
                      child: Obx(() => ButtonFillMain(
                          title: "Set Pin".tr,
                          isLoading: _controller.isLoading.value,
                          onPress: () {
                            Get.to(() => DownloadStrongholdBackupScreen(
                                mnemonicText: widget.mnemonicText.toString(),
                                userName: widget.userName.toString(),
                                password: widget.password.toString(),
                                pin: _controller.pinCodeEditController.text));
                            // Get.to(() =>
                            //     ProfileSuccessfulScreen(
                            //         mnemonicText: widget.mnemonicText.toString(),
                            //         userName: widget.userName.toString(),
                            //         password: widget.password.toString(),
                            //         pin: _controller.pinCodeEditController.text));
                            // // showBottomSheetFullScreen(context, const View());
                            // showModalSheetScreen(context, const View());

                            hideKeyboard();
                          })),
                    ),
                  ),*/
                  vSpacer10(),
                  // Align(
                  //     alignment: Alignment.centerRight,
                  //     child: TextAutoSpan(
                  //         text: 'Back to'.tr,
                  //         subText: "Sign In".tr,
                  //         onTap: () => Get.off(() => const SignInScreen()))),
                  // vSpacer10()
                ],
              ),
            ),
          ),
        ));
  }
}

class View extends StatelessWidget {
  const View({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      vSpacer10(),
      TextAutoMetropolis("profile Successfully Created".tr,
          fontSize: Dimens.fontSizeMid),
      vSpacer5(),
      vSpacer10(),
    ]);
  }
}
