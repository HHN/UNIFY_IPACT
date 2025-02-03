import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/start_new_collaboration/start_new_collaboration_controller.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_controller_final.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'package:app_links/app_links.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_screen.dart';

class StartNewCollaborationScreen extends StatefulWidget {
  const StartNewCollaborationScreen({super.key});

  @override
  StartNewCollaborationScreenState createState() =>
      StartNewCollaborationScreenState();
}

class StartNewCollaborationScreenState
    extends State<StartNewCollaborationScreen> {
  final _controller = Get.put(AcceptNewCollaborationController());
  final _formKey = GlobalKey<FormState>();
  final emailEditController = TextEditingController();
  final passEditController = TextEditingController();

  String? collabName;
  late Box<Collaborations> collaborationBox;

  final _encryptionControllerFinal = Get.put(EncryptionControllerFinal());

  late Box<User> userBox;

  @override
  void initState() {
    super.initState();
    collaborationBox = Hive.box('collaborations');
    userBox = Hive.box<User>('users');

    if (userBox.isNotEmpty) {
      final data = userBox.values.first;
      print('--------------userPublicAddress');
      print(data.userPublicAddress.toString());
      _controller.userPublicAddress.value = data.userPublicAddress.toString();
      _controller.userPublicKey.value = data.userPublicKey.toString();
    } else {
      // empty state
    }
  }




  void _shareLink() async {
    if (_controller.collaborationNameTextController.value.text.isEmpty) {
      CustomSnackBar.show(context, "Collaboration name can not be empty.");
    } else {
      var dateAndTimeNow = DateTime.now().microsecondsSinceEpoch;
      print(dateAndTimeNow);


      var varOwnPublicKey = _controller.userPublicKey.value;
      var varUserPublicAddress = _controller.userPublicAddress.value;

      final String url =
          'https://play.google.com/store/apps/details?id=de.hsheilbronn.ipact&prm1=$dateAndTimeNow&prm2=$varOwnPublicKey&prm3=$varUserPublicAddress';

      final String emailBody = 'Hi! You have a new invitation to collaborate. Step 1: Click the link to install the application. Step 2: Copy the link and open the iPact Application to collaborate. $url';

      final result = await Share.shareWithResult(emailBody,
          subject: 'Invitation to Collaborate');

      if (result.status == ShareResultStatus.success) {
        // CustomSnackBar.show(context, "Link shared.");
        Get.snackbar('Succeeded', 'Link shared Successfully.',snackPosition: SnackPosition.BOTTOM);
        print('Link shared!');
        Navigator.pop(context);

        ///Saving data to local DB
        invitePartnerAndSaveToHive(
          collaborationId: dateAndTimeNow.toString(),
          collaborationName: _controller.collaborationNameTextController.text.trim().toString(),
          collaborationAccepted: false,
          collaborationSent: true,
          transactionId: '',
          senderIOTAAddress: _controller.userPublicAddress.toString(),
          senderPublicKey: _controller.userPublicKey.toString(),
          receiverIOTAAddress: '',
          receiverPublicKey: '',
        );
      }
    }
  }

/*  void _shareLink2() async {
    if (_controller.collaborationNameTextController.value.text.isEmpty) {
      CustomSnackBar.show(context, "Collaboration name can not be empty.");
    } else {
      var dateAndTimeNow = DateTime.now().microsecondsSinceEpoch;
      print(dateAndTimeNow);

      var ownPublicKey =
          await _encryptionControllerFinal.getPublicKeyAsString();

      const String url = 'https://play.google.com/store/apps/details?id=de.hsheilbronn.ipact';

      var varOwnPublicKey = _controller.ownPublicKey.value;
      var varUserPublicAddress = _controller.userPublicAddress.value;

      final String url2 =
          'https://play.google.com/store/apps/details?id=de.hsheilbronn.ipact&prm1=$dateAndTimeNow&prm2=$varOwnPublicKey&prm3=$varUserPublicAddress';

      final String emailBody =
          'Hi! Someone invites you to collaborate. First install the app from Google Play Store $url \n\n After installing the app click the below link to collaborate $url2';


      final result = await Share.shareWithResult(emailBody,
          subject: 'Invitation to Collaborate');

      if (result.status == ShareResultStatus.success) {
        Get.snackbar('Succeeded', 'Link shared Successfully.');
        print('Link shared!');
        Navigator.pop(context);

        ///Saving data to local DB
        invitePartnerAndSaveToHive(
          collaborationId: dateAndTimeNow.toString(),
          collaborationName: _controller.collaborationNameTextController.text
              .trim()
              .toString(),
          collaborationAccepted: false,
          collaborationSent: true,
          transactionId: '',
          senderIOTAAddress: _controller.userPublicAddress.value.toString(),
          senderPublicKey: _controller.ownPublicKey.value.toString(),
          receiverIOTAAddress: '',
          receiverPublicKey: '',
        );
      }
    }
  }*/

  @override
  void dispose() {
    hideKeyboard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: appBarWithBack(title: "StartNewCollaboration".tr, context: context),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vSpacer30(),
                        const AppLogo(),
                        vSpacer100(),
                        Form(
                          key: _controller.formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextAutoMetropolis("Collaboration Name".tr,
                                    fontSize: Dimens.fontSizeRegular),
                                vSpacer5(),
                                TextFieldView(
                                  controller: _controller
                                      .collaborationNameTextController,
                                  hint: "Add a name for Collaboration".tr,
                                  inputType: TextInputType.name,
                                  validator: TextFieldValidator.emptyValidator,
                                  onSaved: (value) {
                                    collabName = value.toString();
                                  },
                                ),
                                vSpacer15(),
                              ]),
                        ),
                        vSpacer20(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: Get.width / 2.2,
                              child: Obx(() => ButtonFillMain(
                                  title: "Invite Partner".tr,
                                  isLoading: _controller.isLoading.value,
                                  onPress: () async {
                                    _shareLink();
                                    // _shareLink2();
                                  })),
                            ),
                          ],
                        ),
                        vSpacer30(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void invitePartnerAndSaveToHive({
    String? collaborationId,
    String? collaborationName,
    bool? collaborationAccepted,
    bool? collaborationSent,
    String? transactionId,
    String? senderIOTAAddress,
    String? senderPublicKey,
    String? receiverIOTAAddress,
    String? receiverPublicKey,
  }) {
    final isValid = _controller.formKey.currentState?.validate();

    if (isValid != null && isValid) {
      _controller.formKey.currentState?.save();
      collaborationBox.add(Collaborations(
        collaborationId: collaborationId!,
        collaborationName: collaborationName!,
        collaborationAccepted: collaborationAccepted!,
        collaborationSent: collaborationSent!,
        transactionId: transactionId!,
        senderIOTAAddress: senderIOTAAddress!,
        senderPublicKey: senderPublicKey!,
        receiverIOTAAddress: receiverIOTAAddress!,
        receiverPublicKey: receiverPublicKey!,
      ));
    }
  }
}
