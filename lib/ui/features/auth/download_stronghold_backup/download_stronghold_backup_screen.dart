import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ui/features/auth/auth_widgets.dart';
import 'package:unify_secret/ui/features/auth/profileSuccessful/profile_successful_screen.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'download_stronghold_backup_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DownloadStrongholdBackupScreen extends StatefulWidget {
  final String mnemonicText;
  final String userName;
  final String password;
  final String pin;

  const DownloadStrongholdBackupScreen({super.key,
    required this.mnemonicText,
    required this.userName,
    required this.password,
    required this.pin});

  @override
  DownloadStrongholdBackupScreenState createState() => DownloadStrongholdBackupScreenState();
}

class DownloadStrongholdBackupScreenState extends State<DownloadStrongholdBackupScreen> {
  final _controller = Get.put(DownloadStrongholdBackupController());
  final _formKey = GlobalKey<FormState>();
  final emailEditController = TextEditingController();
  final passEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    var box = Hive.box<User>('users');
    var name = box.get('userName');
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        // appBar: appBarWithBack(title: "".tr, context: context),
        body: SafeArea(
          child: Column(
            children: [
              vSpacer20(),
              ScreenStepForAccountCreation(isActive11: context.theme.focusColor,isActive12: context.theme.focusColor,isActive13: context.theme.focusColor,isActive14: context.theme.focusColor),
              vSpacer20(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.paddingMid),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        vSpacer30(),
                        AuthTitleView(
                            title: "Download\nStronghold Backup".tr,
                            subTitle:
                                "This phrases can be used to recover your profile, save them securly and don't share with other people."
                                    .tr,
                            subMaxLines: 30),
                        vSpacer30(),
                        LinearPercentIndicator(
                          barRadius: const Radius.circular(10),
                          backgroundColor: context.theme.primaryColor,
                          // width: MediaQuery.of(context).size.width - 50,
                          animation: true,
                          lineHeight: 70.0,
                          animationDuration: 2000,
                          percent: 0.9,
                          center: const Text("90.0%"),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              vSpacer20(),
              Padding(
                padding: const EdgeInsets.all(Dimens.paddingMid),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: Get.width / 2.5,
                    child: Obx(() =>
                        ButtonFillMain(
                            title: "Continue".tr,
                            isLoading: _controller.isLoading.value,
                            onPress: () {
                              Get.to(() =>
                                  ProfileSuccessfulScreen(
                                      mnemonicText: widget.mnemonicText.toString(),
                                      userName: widget.userName.toString(),
                                      password: widget.password.toString(),
                                      pin: _controller.pinCodeEditController.text));
                              // showBottomSheetFullScreen(context, const View());
                              // showModalSheetScreen(context, const View());

                              hideKeyboard();
                            })),
                  ),
                ),
              ),
              vSpacer10(),
            ],
          ),
        ));
  }
}