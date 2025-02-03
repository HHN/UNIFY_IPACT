import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/ffi.dart';

class ProfileSuccessfulController extends GetxController {

  // RxBool isLoading = false.obs;

  bool isLoading = true;

  RxBool isLoading2 = false.obs;


  RxString publicAddress = ''.obs;
  RxString ownPublicKey = ''.obs;


  //
  // String _strongholdFilePath = '';
  //
  // late String publicAddress = '';
  //
  // //
  // Future<void> getStrongholdFilePath(
  //     String strongholdFolder, String rocksdbFolder) async {
  //   final Directory appSupportDir = await getApplicationSupportDirectory();
  //
  //   // Create the Stronghold folder and take over the path
  //   final Directory appSupportDirStrongholdFolder = Directory('${appSupportDir.path}/');
  //
  //   _strongholdFilePath = appSupportDirStrongholdFolder.path;
  //   debugPrint('<<<<<Stronghold File Path>>>>> $_strongholdFilePath');
  //   callFfiCreateWalletAccount();
  //   // setState(() {
  //   //
  //   // });
  //   //print("_strongholdFilePath is $_strongholdFilePath");
  // }
  //
  //
  //
  // Future<void> callFfiCreateWalletAccount() async {
  //   String nodeUrl = 'https://api.testnet.shimmer.network';
  //   String faucetUrl = 'https://faucet.testnet.shimmer.network/api/enqueue';
  //
  //   final NetworkInfo networkInfo =
  //   NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);
  //   final WalletInfo walletInfo = WalletInfo(
  //     alias: alias,
  //     mnemonic: _mnemonicText,
  //     strongholdPassword: strongholdPassword,
  //     strongholdFilepath: _strongholdFilePath,
  //     lastAddress: "",
  //   );
  //
  //   try {
  //     debugPrint('<<<<<Call Rust API To Create Wallet Account>>>>>');
  //     debugPrint(networkInfo.nodeUrl);
  //     debugPrint(networkInfo.faucetUrl);
  //     debugPrint(walletInfo.alias);
  //     debugPrint(walletInfo.mnemonic);
  //     debugPrint(walletInfo.strongholdPassword);
  //     debugPrint(walletInfo.strongholdFilepath);
  //     debugPrint(walletInfo.lastAddress);
  //
  //     final createWalletResponseText = await api.createWalletAccount(
  //         networkInfo: networkInfo, walletInfo: walletInfo);
  //
  //     if (mounted) {
  //       publicAddress = createWalletResponseText;
  //       debugPrint(
  //           '<<<<<Account Creation Successful. Public Address: >>>>> $publicAddress');
  //     }
  //   } on FfiException catch (e) {
  //     debugPrint('<<<<<Account Creation Error>>>>>');
  //   }
  // }



// Future<void> _callFfiCreateWalletAccount() async {
  //   String nodeUrl = 'https://api.testnet.shimmer.network';
  //   String faucetUrl = 'https://faucet.testnet.shimmer.network/api/enqueue';
  //   String alias = 'Rubayet_1';
  //   String strongholdPassword = 'Rubayet_1';
  //   final NetworkInfo networkInfo = NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);
  //   final WalletInfo walletInfo = WalletInfo(
  //     alias:  alias,
  //     mnemonic: _mnemonicText,
  //     strongholdPassword: strongholdPassword,
  //     strongholdFilepath: _strongholdFilePath,
  //     lastAddress: "",
  //   );
  //   try {
  //     debugPrint('<<<<<Call Rust API To Create Wallet Account>>>>>');
  //     final createWalletResponseText = await api.createWalletAccount(
  //         networkInfo: networkInfo, walletInfo: walletInfo);
  //     if (mounted) {
  //       debugPrint('<<<<<Account Creation Successful. Public Address>>>>> $createWalletResponseText');
  //     }
  //   } on FfiException catch (e) {
  //     debugPrint('<<<<<Account Creation Error>>>>>');
  //   }
  // }
  //
  // Future<void> _getStrongholdFilePath(
  //     String strongholdFolder, String rocksdbFolder) async {
  //   final Directory appSupportDir = await getApplicationSupportDirectory();
  //
  //   // Create the Stronghold folder and take over the path
  //   final Directory appSupportDirStrongholdFolder =
  //   Directory('${appSupportDir.path}/');
  //   setState(() {
  //     _strongholdFilePath = appSupportDirStrongholdFolder.path;
  //     debugPrint('<<<<<Stronghold File Path>>>>> $_strongholdFilePath');
  //   });
  //   //print("_strongholdFilePath is $_strongholdFilePath");
  // }


}