import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/ui/features/auth/login/login_screen.dart';
import 'package:unify_secret/ui/features/auth/profileSuccessful/profile_successful_controller.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_controller_final.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';

class ProfileSuccessfulScreen extends StatefulWidget {
  final String mnemonicText;
  final String userName;
  final String password;
  final String pin;

  const ProfileSuccessfulScreen(
      {super.key,
      required this.mnemonicText,
      required this.userName,
      required this.password,
      required this.pin});

  @override
  State<ProfileSuccessfulScreen> createState() =>
      _ProfileSuccessfulScreenState();
}

class _ProfileSuccessfulScreenState extends State<ProfileSuccessfulScreen> {
  final _controller = Get.put(ProfileSuccessfulController());
  final codeEditController = TextEditingController();

  late String _mnemonicText;
  String _strongholdFilePath = '';
  String alias = '';
  String strongholdPassword = '';

  // late String publicAddress = '';

  late Box<User> userBox;

  final _encryptionControllerFinal = Get.put(EncryptionControllerFinal());


  @override
  void initState() {
    super.initState();


    /// Generating public-private key pair for asymmetric encryption and decryption
    _encryptionControllerFinal.generateKeyPemFile();

    _mnemonicText = widget.mnemonicText.toString();
    alias = widget.userName.toString();
    strongholdPassword = widget.password.toString();
    _getStrongholdFilePath("stronghold", "walletdb");

    userBox = Hive.box('users');




  }

  Future<void> _ownPublicKey() async {

    _controller.ownPublicKey.value = await _encryptionControllerFinal.getPublicKeyAsString();
    //print('-------_ownPublicKey');
    //print(_controller.ownPublicKey.value.toString());
  }


  Future<void> requestFundsFromFaucet() async {
    String nodeUrl = 'https://api.testnet.shimmer.network';
    String faucetUrl = 'https://faucet.testnet.shimmer.network/api/enqueue';
    final NetworkInfo networkInfo =
    NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);

    final receivedText = await api.requestFunds(
        networkInfo: networkInfo,
        walletInfo: WalletInfo(
          alias: '',
          mnemonic: '',
          strongholdPassword:'',
          strongholdFilepath: _strongholdFilePath,
          lastAddress: _controller.publicAddress.value,
        )
    );
    //debugPrint(receivedText);
  }

  Future<void> createIotaAccount() async {
    String nodeUrl = 'https://api.testnet.shimmer.network';
    String faucetUrl = 'https://faucet.testnet.shimmer.network/api/enqueue';

    final NetworkInfo networkInfo =
    NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);
    final WalletInfo walletInfo = WalletInfo(
      alias: alias,
      mnemonic: _mnemonicText,
      strongholdPassword: strongholdPassword,
      strongholdFilepath: _strongholdFilePath,
      lastAddress: "",
    );

    try {
      //debugPrint('<<<<<Call Rust API To Create Wallet Account>>>>>');
      //debugPrint(networkInfo.nodeUrl);
      //debugPrint(networkInfo.faucetUrl);
      //debugPrint(walletInfo.alias);
      //debugPrint(walletInfo.mnemonic);
      //debugPrint(walletInfo.strongholdPassword);
      //debugPrint(walletInfo.strongholdFilepath);
      //debugPrint(walletInfo.lastAddress);

      // _controller.publicAddress.value = ' ';

      final createWalletResponseText = await api.createIotaAccount(
          networkInfo: networkInfo, walletInfo: walletInfo);

      if (mounted) {
        _controller.publicAddress.value = createWalletResponseText;
        //debugPrint('<<<<<Account Creation Successful. Public Address: >>>>>');
        //debugPrint(_controller.publicAddress.value);
/*
        /// For adding data in local hive db
        _controller.publicAddress.value.isNotEmpty ? submitData() : null;*/

        /// Generating user public key encryption and decryption
        _ownPublicKey();
        requestFundsFromFaucet();


      }
    } on FfiException catch (e) {
      debugPrint('<<<<<Account Creation Error>>>>>');
    }
  }


  /*Future<void> _callFfiCreateWalletAccount() async {
    String nodeUrl = 'https://api.testnet.shimmer.network';
    String faucetUrl = 'https://faucet.testnet.shimmer.network/api/enqueue';

    final NetworkInfo networkInfo =
        NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);
    final WalletInfo walletInfo = WalletInfo(
      alias: alias,
      mnemonic: _mnemonicText,
      strongholdPassword: strongholdPassword,
      strongholdFilepath: _strongholdFilePath,
      lastAddress: "",
    );

    try {
      debugPrint('<<<<<Call Rust API To Create Wallet Account>>>>>');
      debugPrint(networkInfo.nodeUrl);
      debugPrint(networkInfo.faucetUrl);
      debugPrint(walletInfo.alias);
      debugPrint(walletInfo.mnemonic);
      debugPrint(walletInfo.strongholdPassword);
      debugPrint(walletInfo.strongholdFilepath);
      debugPrint(walletInfo.lastAddress);

      // _controller.publicAddress.value = ' ';

      final createWalletResponseText = await api.createWalletAccount(
          networkInfo: networkInfo, walletInfo: walletInfo);

      if (mounted) {
        _controller.publicAddress.value = createWalletResponseText;
        debugPrint('<<<<<Account Creation Successful. Public Address: >>>>>');
        debugPrint(_controller.publicAddress.value);
*//*
        /// For adding data in local hive db
        _controller.publicAddress.value.isNotEmpty ? submitData() : null;*//*

        /// Generating user public key encryption and decryption
        _ownPublicKey();

      }
    } on FfiException catch (e) {
      debugPrint('<<<<<Account Creation Error>>>>>');
    }
  }*/

  Future<void> _getStrongholdFilePath(
      String strongholdFolder, String rocksdbFolder) async {
    final Directory appSupportDir = await getApplicationSupportDirectory();

    // Create the Stronghold folder and take over the path
    final Directory appSupportDirStrongholdFolder =
        Directory('${appSupportDir.path}/');
    setState(() {
      _strongholdFilePath = appSupportDirStrongholdFolder.path + "ipact_wallet/" ;
      //debugPrint('<<<<<Stronghold File Path>>>>> $_strongholdFilePath');
      //_callFfiCreateWalletAccount();
      createIotaAccount();
    });
    //print("_strongholdFilePath is $_strongholdFilePath");
  }

  // @override
  // void dispose() {
  //   _controller.publicAddress.value == '';
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final subTitle = "${'Enter verification code which sent email'.tr} ${widget.registrationId}";
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(Dimens.paddingMid),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vSpacer10(),
                      ScreenStepForAccountCreation(
                          isActive11: context.theme.focusColor,
                          isActive12: context.theme.focusColor,
                          isActive13: context.theme.focusColor,
                          isActive14: context.theme.focusColor),
                      vSpacer20(),
                      vSpacer100(),
                      _controller.publicAddress.value.isEmpty
                          ? handleEmptyViewWithLoadingForProfileCreation(
                              context, _controller.isLoading)
                          : Column(
                              children: [
                                SvgPicture.asset(
                                  AssetConstants.icCheckLarge,
                                  color: context.theme.focusColor,
                                  width: Get.width / 3,
                                  height: Get.width / 3,
                                ),
                                vSpacer30(),
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextAutoMetropolis(
                                        "Profile Successfully Created".tr,
                                        fontSize: Dimens.fontSizeLarge,
                                        color:
                                            context.theme.secondaryHeaderColor,
                                        textAlign: TextAlign.center,
                                      ),
                                      vSpacer10(),
                                      TextAutoPoppins(
                                        "Your profile creation is successful.\nYou can Login now"
                                            .tr,
                                        maxLines: 10,
                                        color:
                                            context.theme.secondaryHeaderColor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                vSpacer30(),
                                // vSpacer30(),
                                // Center(
                                //   child: TextAutoMetropolis(
                                //     "Profile Address:\n${_controller.publicAddress.value.toString()}",fontSize: Dimens.fontSizeMid,textAlign: TextAlign.center,
                                //     maxLines: 30,
                                //   ),
                                // ),
                                // vSpacer30(),
                                vSpacer100(),
                                Center(
                                  child: SizedBox(
                                    width: Get.width / 3.5,
                                    child: Obx(() => ButtonFillMain(
                                        title: "Login".tr,
                                        isLoading: _controller.isLoading2.value,
                                        onPress: () async {

                                          // /// For adding data in local hive db
                                          // _controller.publicAddress.value.isNotEmpty ? submitData() : null;
                                          userBox.add(User(
                                              userName: widget.userName.toString(),
                                              userPin: widget.pin,
                                              userPublicAddress: _controller.publicAddress.value.toString(),
                                              userPublicKey: _controller.ownPublicKey.value.toString())
                                          );

                                          //debugPrint(widget.userName);
                                          //debugPrint('------------------============== userPublicAddress');
                                          //debugPrint(userBox.name);
                                          //debugPrint(userBox.get('userPublicAddress').toString());
                                          //debugPrint(userBox.get('userPin').toString());
                                          //debugPrint(userBox.get('userName').toString());


                                          // GlobalVariables.globalCurrentUser = widget.userName.toString();
                                          Get.offAll(() => const LogInScreen());
                                        })),
                                  ),
                                ),
                              ],
                            ),
                      vSpacer30(),
                    ],
                  ),
                )),
          ),
        ));
  }
}
