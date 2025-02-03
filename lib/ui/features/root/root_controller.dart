import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/ffi.dart';

class RootController extends GetxController {
  int bottomNavIndex = 1;
  late Function(int) changeBottomNavIndex;


  String _alias = '';
  String _mnemonic = '';
  String _strongholdPassword = '';
  String _strongholdFilepath = '';
  String _lastAddress = '';

  Future<void> _callFfiGetAddresses() async {
    final receivedText = await api.getAddresses(
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword: '',
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        ));
    debugPrint(receivedText);
  }

  //
  // Future<void> _getStrongholdFilePath() async {
  //   final Directory appSupportDir = await getApplicationSupportDirectory();
  //
  //   // Create the Stronghold folder and take over the path
  //   final Directory appSupportDirStrongholdFolder =
  //   Directory('${appSupportDir.path}/');
  //
  //   setState(() {
  //
  //     _alias = "Rubayet1&";
  //     _mnemonic = "combine magnet clock exotic inmate recycle join shove drive dry fit where choose scissors kitchen lift shop jelly way insect actress bomb matter mad";
  //     _strongholdPassword = "Rubayet1&";
  //     _strongholdFilepath = appSupportDirStrongholdFolder.path;
  //     _lastAddress = "rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj";
  //     //_lastAddress = "rms1qp086sft5vasn9psjn62l2yj73weerjmhzf472jk2knepfx8v6eyydzyhm8";
  //
  //     debugPrint('<<<<<Stronghold File Path>>>>> $_strongholdFilepath');
  //
  //
  //     // _callFfiCreateWalletAccount();            //1. method for creating wallet and IOTA account
  //     _callFfiGetAddresses();                 //2. method for getting already generated and saved public address in stronghold
  //     //_callFfiCheckBalance();                 //3. method for checking balance
  //     //_callFfiGenerateAddress();              //4. method for generating public address
  //     //_callFfiCreateTransaction();            //5. method for creating transaction
  //     //_callFfiCreateAdvancedTransaction();    //6. method for creating advanced transaction including time-lock and deposit-return-lock condition
  //     //_callFfiGetSentTransactions();          //7. method for getting all sent transactions
  //     //_callFfiGetReceivedTransactions();      //8. method for getting all received transaction
  //     //_callFfiGetSingleTransaction();         //9. method for requesting funds from faucet
  //     //_callFfiRequestFunds();                 //10. method for requesting funds from faucet
  //
  //   });
  // }


}
