import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/add_invited_collaboration/add_invited_collaboration_controller.dart';
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
class AddInvitedCollaborationScreen extends StatefulWidget {
  const AddInvitedCollaborationScreen({super.key});

  @override
  AddInvitedCollaborationScreenState createState() =>
      AddInvitedCollaborationScreenState();
}

class AddInvitedCollaborationScreenState
    extends State<AddInvitedCollaborationScreen> {
  bool _isChecked = false;
  final _controller = Get.put(AddInvitedCollaborationController());
  final _formKey = GlobalKey<FormState>();
  final emailEditController = TextEditingController();
  final passEditController = TextEditingController();

  String? collabName;
  late Box<Collaborations> sentCollaborationBox;

  final _encryptionControllerFinal = Get.put(EncryptionControllerFinal());

  late Box<User> userBox;
  late User data;

  late String iPactWalletFilePathValue;


  @override
  void initState() {
    super.initState();
    sentCollaborationBox = Hive.box('collaborations');
    userBox = Hive.box<User>('users');

    if (userBox.isNotEmpty) {
      data = userBox.values.first;
      print('--------------userPublicAddress');
      print(data.userPublicAddress.toString());
      _controller.userPublicAddress.value = data.userPublicAddress.toString();
      _controller.userPublicKey.value = data.userPublicKey.toString();
    } else {
      // empty state
    }

    _getIpactWalletFilePath();

    // _handleInitialUri();
  }

/*  void _handleInitialUri() async {
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

  Future<Uri?> getInitialUri() async {
    // Fetch the initial URI (deep link)
    final Uri? uri = await AppLinks().getInitialLink();
    return uri;
  }

  void _handleDeepLink(Uri uri) {
    print('Received deep link: ${uri.toString()}');
    final queryParams = uri.queryParameters;
    print('Custom parameters: $queryParams');
    String? prm1 = queryParams['prm1'];
    String? prm2 = queryParams['prm2'];
    String? prm3 = queryParams['prm3'];
    if (prm1 != null && prm2 != null && prm3 != null) {
      // Navigate to CollaborationScreen and pass parameters
      Get.to(() => const CollaborationScreen(), arguments: {
        'prm1': prm1,
        'prm2': prm2,
        'prm3': prm3,
      });
    }
  }*/

  void _addCollaborationLink() async {
    if (_controller.collaborationNameTextController.value.text.isEmpty) {
      CustomSnackBar.show(context, "Collaboration name can not be empty.");
    } else if (_controller
        .collaborationInvitationLinkTextController.value.text.isEmpty) {
      CustomSnackBar.show(
          context, "Invited Collaboration Link can not be empty.");
    } else {
      // var pastedLink = _controller.collaborationInvitationListTextController.value.text.toString();

      var dateAndTimeNow = DateTime.now().microsecondsSinceEpoch;
      print(dateAndTimeNow);

      var invitedUserPublicAddress;
      var varOwnPublicKey = _controller.userPublicKey.value;
      var varUserPublicAddress = _controller.userPublicAddress.value;

      final String url =
          'https://play.google.com/store/apps/details?id=de.hsheilbronn.ipact&prm1=$dateAndTimeNow&prm2=$varOwnPublicKey&prm3=$varUserPublicAddress';

      _encryptionControllerFinal.generateRsaKeyPemFileFromReceivedPublicKey(
          collaborationId: prm1.toString(),
          iotaAddress: prm3.toString(),
          receivedPublicKey:prm2.toString());

      var iOTATransactionId = _writeCollaborationInIota();
      if (_controller.pastedLink.isNotEmpty) {
        ///Saving data to local DB
        invitePartnerAndSaveToHive(
          collaborationId: prm1.toString(),
          collaborationName: _controller.collaborationNameTextController.text.trim().toString(),
          collaborationAccepted: true,
          collaborationSent: false,
          transactionId: iOTATransactionId.toString(),
          senderIOTAAddress: prm3.toString(),
          senderPublicKey: prm2.toString(),
          receiverIOTAAddress: _controller.userPublicAddress.toString(),
          receiverPublicKey: _controller.userPublicKey.value.toString(),
        );

        Get.snackbar('Succeeded', 'Invited Collaboration Accepted Successfully.', snackPosition: SnackPosition.BOTTOM);
        print('Link Accepted!');
        Navigator.pop(context);
      }

      // if (result.status == ShareResultStatus.success) {
      //   // CustomSnackBar.show(context, "Link shared.");
      //   Get.snackbar('Succeeded', 'Collaboration Added Successfully.',snackPosition: SnackPosition.BOTTOM);
      //   print('Link shared!');
      //   Navigator.pop(context);
      //
      //   ///Saving data to local DB
      //   invitePartnerAndSaveToHive(
      //     collaborationId: dateAndTimeNow.toString(),
      //     collaborationName: _controller.collaborationNameTextController.text
      //         .trim()
      //         .toString(),
      //     collaborationAccepted: true,
      //     collaborationSent: false,
      //     transactionId: '',
      //     senderIOTAAddress: userPublicAddress.toString(),
      //     senderPublicKey: ownPublicKey.toString(),
      //     receiverIOTAAddress: '',
      //     receiverPublicKey: '',
      //   );
      // }
    }
  }

  void _getIpactWalletFilePath() async {
    iPactWalletFilePathValue = await iPactWalletFilePath();
  }

  String _writeCollaborationInIota() {
      var transactionParamsForCollaborationCreation = TransactionParams(
          // transactionTag: "{'1', '$prm1'}",
          transactionTag: "a",
          transactionMetadata: "{'1', '$prm1', '${data.userPublicAddress.toString()}','${data.userPublicKey.toString()}'}",
          receiverAddress: "rms1qr6aygm4nrn3hp7rnztttzd09l5mms4zzt83k5ukj42hq7pzm29a7gehcv7",
          storageDepositReturnAddress: "rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj"
      );
      print(transactionParamsForCollaborationCreation.transactionTag);
      print(transactionParamsForCollaborationCreation.transactionMetadata);
      print(data.userName.toString());
      print(_controller.strongholdPasswordController.text.toString());
      print(iPactWalletFilePathValue.toString());

      // _callFfiCreateAdvancedTransaction(transactionParamsForCollaborationCreation);


      return '0xa2dba66bcc3416ca746dae740375d83a79c8038184923328e93d47404a537bca';


  }

  Future<void> _callFfiCreateAdvancedTransaction(TransactionParams transactionParams, ) async {

    final receivedText = await api.createAdvancedTransaction(
        transactionParams: transactionParams,
        walletInfo: WalletInfo(
          alias: data.userName.toString(),
          mnemonic: '',
          strongholdPassword: _controller.strongholdPasswordController.text.toString(),
          strongholdFilepath: iPactWalletFilePathValue.toString(),
          lastAddress: '',
        )
    );
    debugPrint(receivedText);
  }

  /// For extracting the value from link

  String prm1 = '';
  String prm2 = '';
  String prm3 = '';

  void extractParameters(String url) {
    RegExp regExp = RegExp(r'prm1=([^&]+)&prm2=([^&]+)&prm3=([^&]+)');
    RegExpMatch? match = regExp.firstMatch(url);

    if (match != null) {
      setState(() {
        prm1 = match.group(1) ?? '';
        prm2 = match.group(2) ?? '';
        prm3 = match.group(3) ?? '';
      });
    } else {
      setState(() {
        prm1 = 'Not found';
        prm2 = 'Not found';
        prm3 = 'Not found';
      });
    }
  }

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
        appBar:
            appBarWithBack(title: "AcceptNewCollaboration".tr, context: context),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vSpacer30(),
                      const AppLogo(),
                      vSpacer100(),
                      Padding(
                        padding: const EdgeInsets.all(Dimens.paddingLarge),
                        child: Form(
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
                                  hint: "Add a name for Collaboration.".tr,
                                  inputType: TextInputType.name,
                                  validator: TextFieldValidator.emptyValidator,
                                  onSaved: (value) {
                                    return collabName = value.toString();
                                  },
                                ),
                                vSpacer15(),
                                TextAutoMetropolis("Invited Link".tr,
                                    fontSize: Dimens.fontSizeRegular),
                                vSpacer5(),
                                TextFieldView(
                                  controller: _controller.collaborationInvitationLinkTextController,
                                  hint: "Copy and paste the link that you got from invitation.".tr,
                                  inputType: TextInputType.name,
                                  validator: TextFieldValidator.emptyValidator,
                                  // onSaved: (value) {
                                  //   collabName = value.toString();
                                  // },
                                ),
                                vSpacer15(),
                                TextAutoMetropolis("Stronghold Password".tr,
                                    fontSize: Dimens.fontSizeRegular),
                                vSpacer5(),
                                TextFieldView(
                                  controller: _controller.strongholdPasswordController,
                                  hint: "Enter your Stronghold Password".tr,
                                  inputType: TextInputType.visiblePassword,
                                  validator: TextFieldValidator.emptyValidator,
                                  // onSaved: (value) {
                                  //   collabName = value.toString();
                                  // },
                                ),
                              ]),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            focusColor: context.theme.primaryColorDark,
                            activeColor: context.theme.primaryColorDark,
                            checkColor: context.theme.primaryColorLight,
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: const TextAutoPoppins(
                              'I accept the invitation.',
                            ),
                          ),
                        ],
                      ),
                      vSpacer20(),
                      _isChecked == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: Get.width / 1.5,
                                  child: Obx(() => ButtonFillMain(
                                      title: "AcceptNewCollaboration".tr,
                                      isLoading: _controller.isLoading.value,
                                      onPress: () {

                                        _controller.pastedLink.value = _controller.collaborationInvitationLinkTextController.value.text.toString();

                                        extractParameters(_controller.pastedLink.toString());

                                        _writeCollaborationInIota();
                                        _addCollaborationLink();
                                      })),
                                ),
                              ],
                            )
                          : const SizedBox(height: 0),
                      vSpacer30(),

                      ///For testing the pram value
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment:MainAxisAlignment.center,
                      //   children: [
                      //     const SizedBox(height: 20),
                      //     Center(
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           pastedLink = _controller.collaborationInvitationListTextController.value.text.toString();
                      //           extractParameters(pastedLink!);
                      //         },
                      //         child: const Text('Extract Parameters'),
                      //       ),
                      //     ),
                      //     const SizedBox(height: 20),
                      //     Text('prm1: $prm1'),
                      //     Text('prm2: $prm2'),
                      //     Text('prm3: $prm3'),
                      //     const SizedBox(height: 20),
                      //   ],
                      // ),
                    ],
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
      sentCollaborationBox.add(Collaborations(
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
