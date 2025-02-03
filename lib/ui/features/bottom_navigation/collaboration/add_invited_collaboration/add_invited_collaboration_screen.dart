import 'dart:async';
import 'dart:convert';
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
import 'package:unify_secret/utils/common_widgets.dart';
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
  late User user;

  late Box<Collaborations> collaborationBox;
  late Collaborations collaborations;

  late String iPactWalletFilePathValue;
  late String iOTATransactionId;

  final NetworkInfo networkInfo = const NetworkInfo(
      nodeUrl: 'https://api.testnet.shimmer.network',
      faucetUrl: 'https://faucet.testnet.shimmer.network/api/enqueue');


  @override
  void initState() {
    super.initState();
    sentCollaborationBox = Hive.box('collaborations');
    userBox = Hive.box<User>('users');

    if (userBox.isNotEmpty) {
      user = userBox.values.first;
      print('--------------userPublicAddress');
      print(user.userPublicAddress.toString());
      _controller.userPublicAddress.value = user.userPublicAddress.toString();
      _controller.userPublicKey.value = user.userPublicKey.toString();
    } else {
      // empty state
    }


    collaborationBox = Hive.box('collaborations');
    if (collaborationBox.isNotEmpty) {
      //collaborations = collaborationBox.values.first;

      _controller.userPublicAddress.value = user.userPublicAddress.toString();
      _controller.userPublicKey.value = user.userPublicKey.toString();

    } else {
      // empty state
    }

    _getIpactWalletFilePath();

    // _handleInitialUri();
  }


/*  _addCollaborationLink() async {

    if (_controller.collaborationNameTextController.value.text.isEmpty) {
      CustomSnackBar.show(context, "Collaboration name can not be empty.");
    } else if (_controller.collaborationInvitationLinkTextController.value.text.isEmpty) {
      CustomSnackBar.show(
          context, "Invited Collaboration Link can not be empty.");
    } else {

      iOTATransactionId = await _writeCollaborationInIota();


          if(iOTATransactionId.isNotEmpty){
        _encryptionControllerFinal.generateRsaKeyPemFileFromReceivedPublicKey(
            collaborationId: prm1.toString(),
            iotaAddress: prm3.toString(),
            receivedPublicKey:prm2.toString());

        //var iOTATransactionId = '2354326545';
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
      }

    }
  }*/

  _addCollaborationLink() async {
    if (_controller.collaborationNameTextController.value.text.isEmpty) {
      CustomSnackBar.show(context, "Collaboration name can not be empty.");
    } else if (_controller.collaborationInvitationLinkTextController.value.text.isEmpty) {
      CustomSnackBar.show(context, "Invited Collaboration Link can not be empty.");
    } else {
      // handleAcceptCollaborationInvitation(context,_controller.isLoading2,message: 'Please wait while we process your request...');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(message: 'Please wait while we process your request.\nDo not close the app.\nThank you for your patience.',context: context);
        },
      );

      try {
        iOTATransactionId = await _writeCollaborationInIota();

        if (iOTATransactionId.isNotEmpty) {
          _encryptionControllerFinal.generateRsaKeyPemFileFromReceivedPublicKey(
            collaborationId: prm1.toString(),
            iotaAddress: prm3.toString(),
            receivedPublicKey: prm2.toString(),
          );

          if (_controller.pastedLink.isNotEmpty) {
            /// Saving data to local DB
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
            Navigator.pop(context); // Close the dialog
            Navigator.pop(context); // Go back to the previous screen
          }
        }
      } catch (e) {
        Navigator.pop(context); // Close the dialog
        Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  _onAcceptNewCollaborationPressed() {
    _controller.pastedLink.value = _controller.collaborationInvitationLinkTextController.value.text.toString();
    extractParameters(_controller.pastedLink.toString());
    _addCollaborationLink();
  }


  void _getIpactWalletFilePath() async {
    iPactWalletFilePathValue = await iPactWalletFilePath();
  }

  Future<String> _writeCollaborationInIota() async {

    var transactionMetadataForCollaborationCreation =
    {
      "a": 1,
      "b": prm1,
      "c": user.userPublicAddress.toString(),
      "d": user.userPublicKey.toString(),
    };

    var transactionParamsForCollaborationCreation = TransactionParams(
        transactionTag: "",
        transactionMetadata: jsonEncode(transactionMetadataForCollaborationCreation),
        receiverAddress: '$prm3',
        storageDepositReturnAddress: '$prm3'
    );
    print(transactionParamsForCollaborationCreation.transactionMetadata);
    print(user.userName.toString());
    print(_controller.strongholdPasswordController.text.toString());
    print(iPactWalletFilePathValue.toString());

    var transactionId = await writeCollaborationInTangle(transactionParamsForCollaborationCreation);    //6. method for creating advanced transaction including time-lock and deposit-return-lock condition

    print('collaborationtransactionId');
    print(transactionId);

    return transactionId;
  }

  Future<String> writeCollaborationInTangle(TransactionParams transactionParams) async {
    debugPrint("writeCollaborationInTangle");
    final receivedText = await api.writeAdvancedTransaction(
        transactionParams: transactionParams,
        walletInfo: WalletInfo(
          alias: user.userName.toString(),
          mnemonic: '',
          strongholdPassword: _controller.strongholdPasswordController.text.toString(),
          strongholdFilepath: iPactWalletFilePathValue.toString(),
          lastAddress: '',
        )
    );
    debugPrint(receivedText);
    return receivedText;
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
                                  isObscure: !_controller.isShowPassword.value,
                                  suffix: ShowHideIconView(
                                      isShow: _controller.isShowPassword.value,
                                      onTap: () => _controller.isShowPassword.value =
                                      !_controller.isShowPassword.value),
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
                                      onPress: _onAcceptNewCollaborationPressed,
                                      // onPress: () {
                                      //
                                      //   _controller.pastedLink.value = _controller.collaborationInvitationLinkTextController.value.text.toString();
                                      //
                                      //   extractParameters(_controller.pastedLink.toString());
                                      //
                                      //   _addCollaborationLink();
                                      // }
                                      )),
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
