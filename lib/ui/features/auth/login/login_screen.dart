import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ui/features/auth/auth_widgets.dart';
import 'package:unify_secret/ui/features/privacy_policy/privacy_policy_screen.dart';
import 'package:unify_secret/ui/features/root/root_screen.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'logIn_controller.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  LogInScreenState createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  final _controller = Get.put(LogInController());
  final _formKey = GlobalKey<FormState>();

  String _globalUserName = '';

  //Box userBox = Hive.box<UsersCollection>('users');
  // var userBox = Hive.box<UsersCollection>('users');

  // Box userBox = Hive.box<User>('users');

  late Box<User> userBox;
  // User? userPAddress;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('users');

    // userPAddress = userBox.get('userPublicAddress');
    //
    // print('--------------userPublicAddress');
    //
    // print(userPAddress?.userPublicAddress);



  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    // var box = Hive.box<UsersCollection>('user');
    // var name = box.get('userName');
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: appBarWithBack(title: "Login".tr, context: context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpacer30(),
                  AuthTitleView(
                      title: "Login with\nyour Profile".tr,
                      subTitle: "".tr,
                      subMaxLines: 30),
                  vSpacer30(),
                  // Create a fresh software profile running on Shimmer. This provides a Stronghold file and recovery phrase
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: ValueListenableBuilder(
                        valueListenable: userBox.listenable(),
                        builder: (context,box, child) {
                          return box.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: userBox.length,
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final user = userBox.getAt(index) as User;
                                    // final users = box.getAt(index);
                                    _controller.userNameATIndex.value = user.toString();
                                    // final image.isSynchronized == false;
                                    return GestureDetector(
                                      onTap: (() {
                                        // GlobalVariables.globalCurrentUser = user.userName.toString();
                                        // _globalUserName = GlobalVariables.globalCurrentUser.toString();
                                        //
                                        // debugPrint('<<<<<_globalUserName>>>>> $_globalUserName');

                                        //debugPrint('------------------============== userPublicAddress');
                                        //debugPrint(userBox.name);
                                        //debugPrint(user.userName.toString());
                                        //debugPrint(user.userPin.toString());
                                        //debugPrint(user.userPublicAddress.toString());

                                        Get.offAll(() => LoginWithPin(user: user));
                                        // Get.offAll(() => LoginWithPin(userName: user.userName.toString(), user: user));
                                        // Get.to(() => LoginWithPin(userName:_globalUserName));
                                      }),
                                      child: SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: CircleAvatar(
                                          radius: 0,
                                          backgroundColor:
                                              context.theme.dividerColor,
                                          child: TextAutoMetropolis(
                                              user.userName.toString()),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Column(
                                  children: [
                                    vSpacer100(),
                                    Center(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: TextAutoSpan(
                                              text:
                                                  'You do not have any IOTA profile.\n\n'
                                                      .tr,
                                              subText:
                                                  'Please create a new IOTA profile'
                                                      .tr,
                                              onTap: () => Get.off(() =>
                                                  const PrivacyPolicyScreen()))),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class LoginWithPin extends StatefulWidget {
  final User user;
  // final String userName;

  const LoginWithPin({super.key, required this.user});

  @override
  State<LoginWithPin> createState() => _LoginWithPinState();
}

// Box userBox = Hive.box<User>('users');

class _LoginWithPinState extends State<LoginWithPin> {
  final _controller = Get.put(LogInController());

  // late Box<User> userBox;

  @override
  void initState() {
    super.initState();

    // userBox = Hive.box('users');
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user.userName.toString();
    final pin = widget.user.userPin.toString();
    // final pin = userBox.get('userPin').toString();
    //debugPrint('----------------- userName -----------------  ');
    //debugPrint(name);
    //debugPrint('----------------- userPin -----------------  ');
    //debugPrint(pin);
    // debugPrint('-----------------userPublicAddress');
    // debugPrint(userBox.get('userPublicAddress').toString());
    // debugPrint(userBox.get('userPin').toString());
    // debugPrint(userBox.get('userName').toString());
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: appBarWithBack(title: "Login".tr, context: context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingMid),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  vSpacer30(),
                  SizedBox(
                    height: 200,
                    width: 200,
                    // color: context.theme.canvasColor,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: context.theme.dividerColor,
                      // child: TextAutoMetropolis(widget.userName.toString()),
                      child: TextAutoMetropolis(widget.user.userName.toString()),
                    ),
                  ),
                  vSpacer30(),
                  Form(
                    key: _controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoMetropolis("Input PIN".tr,
                            fontSize: Dimens.fontSizeRegular),
                        vSpacer5(),
                        TextFieldPinCode(
                          controller: _controller.pinCodeEditController,
                        ),
                        vSpacer30(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Container()),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: Get.width / 3.5,
                          child: Obx(() => ButtonFillMain(
                              title: "Continue".tr,
                              isLoading:
                                  _controller.isLoadingForContinueBtn.value,
                              onPress: () {

                                final isValid = _controller.formKey.currentState?.validate();


                                if (_controller.pinCodeEditController.value.text.isNotEmpty) {

                                  if (isValid != null && isValid) {
                                    _controller.formKey.currentState?.save();

                                    if (_controller.pinCodeEditController.value.text.toString() == pin && widget.user.userName == name
                                    ) {
                                      Get.offAll(() => const RootScreen());
                                    } else {
                                      CustomSnackBar.show(context,"Wrong pin inserted.");
                                    }
                                  }
                                } else {
                                  CustomSnackBar.show(
                                      context, "Pin can not be empty.");
                                }
                              })),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
