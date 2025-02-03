import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/ui/features/test_screen/test_screen_controller.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/dimens.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _controller = Get.put(TestScreenController());

  String _alias = '';
  String _mnemonic = '';
  String _strongholdPassword = '';
  String _strongholdFilepath = '';
  String _lastAddress = '';

  final NetworkInfo networkInfo = const NetworkInfo(
      nodeUrl: 'https://api.testnet.shimmer.network',
      faucetUrl: 'https://faucet.testnet.shimmer.network/api/enqueue');


  @override
  void initState() {
    super.initState();
    try {
      _getStrongholdFilePath();
    } on FfiException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> _getStrongholdFilePath() async {
    final Directory appSupportDir = await getApplicationSupportDirectory();

    // Create the Stronghold folder and take over the path
    final Directory appSupportDirStrongholdFolder = Directory('${appSupportDir.path}/');

    setState(() {

      _alias = "Rubayet1&";
      _mnemonic = "rally panic spend explain excuse obey sort gadget lion width undo stay frog month cute peanut shine office negative donkey mass lab traffic lobster"; //8
      //_mnemonic = "above lonely suit carbon loan crazy curve pluck favorite cannon exist hat author paddle dress broom disease canal zone record real course judge vivid"; //7
      _strongholdPassword = "Rubayet1&";
      _strongholdFilepath = appSupportDirStrongholdFolder.path+"ipact_wallet/";
      _lastAddress = "rms1qqa5h2taghrl8u24k3g9xr9edwk2jqnrwtm5t4ygdg3mu8e4tpjty6ewwpe"; //8
      //_lastAddress = "rms1qzckvhu7hyxrft2jj4kek5r8muuw8yw9v9emwl08efcd5yv9q6lhkvwf3z0"; //7

      debugPrint('<<<<<Stronghold File Path>>>>> $_strongholdFilepath');


      //_callFfiCreateWalletAccount();            //1. method for creating wallet and IOTA account
      //_callFfiGetAddresses();                 //2. method for getting already generated and saved public address in stronghold
      //_callFfiCheckBalance();                 //3. method for checking balance
      //_callFfiGenerateAddress();              //4. method for generating public address
      //_callFfiCreateTransaction();            //5. method for creating transaction
      //_callFfiCreateAdvancedTransaction();    //6. method for creating advanced transaction including time-lock and deposit-return-lock condition
      //_callFfiGetSentTransactions();          //7. method for getting all sent transactions
      //_callFfiGetReceivedTransactions();      //8. method for getting all received transaction
      //_callFfiGetSingleTransaction();         //9. method for getting a specific transaction
      //_callFfiRequestFunds();                 //10. method for requesting funds from faucet



      var transactionParamsForCollaborationCreation = const TransactionParams(
          transactionTag: "",
          transactionMetadata: "{'1', '1234','rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj','MIIBCgKCAQEA2r52FfmyxeeUyg0o6C97JRO34Lsens1yapYBFQnC3CrDmKDs0ToR2+6q5tVik6tEKFrEo1E4CbGVzD0I+Ur+SnkbaZTQ6KrZZKBmeCy9elacMNocjsZeRJtVIz2E7QlqWM40zHsUMA03BxLTCAM90L1u5e7cz/9oWGPb8MhRFdRES7DxocLFyyVS2Cis/6m1rRCoQM0ewP87v7PKgraqwt0wOO69vk3qoGTcfAVT4MiXB9s6ZU3BhNZRpnsKxC8cnPMl8MyWZ/S8423rnh1Y/++scKZ8iAfPMPb1ORakxe8T2aGtyWNQrO57tw14y4w1FN15aLE93oBYVEy/90WNSQIDAQAB'}",
          receiverAddress: "rms1qr6aygm4nrn3hp7rnztttzd09l5mms4zzt83k5ukj42hq7pzm29a7gehcv7",
          storageDepositReturnAddress: "rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj"
      );

      var transactionParamsForFileHash = const TransactionParams(
          transactionTag: "",
          transactionMetadata: "{'2', 'collaboration_id','document_id','original_file_hash'}",
          receiverAddress: "rms1qzuqx4k29tj8m8agre2emqd4f85ukkwhqtnj6ypyezjmw9q3ce2uyefthfm",
          storageDepositReturnAddress: "rms1qzuqx4k29tj8m8agre2emqd4f85ukkwhqtnj6ypyezjmw9q3ce2uyefthfm"
      );

      //writeCollaborationInTangle(transactionParamsForCollaborationCreation);    //6. method for creating advanced transaction including time-lock and deposit-return-lock condition
      //getIncomingCollaborationsFromTangle();
      //requestFundsFromFaucet(networkInfo);
      //writeFileHashToTangle(transactionParamsForFileHash);
      //getBalance();
      //createIotaAccount(networkInfo);
      //writeSymmetricDecryptionConfirmationToTangle();

    });
  }

  Future<void> createIotaAccount(NetworkInfo networkInfo) async {
    debugPrint('createIotaAccount');
    final receivedText = await api.createIotaAccount(
        networkInfo: networkInfo,
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: _mnemonic,
          strongholdPassword:_strongholdPassword,
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
    print(receivedText);
  }

  Future<void> getBalance() async {
    debugPrint('getBalance');
    final receivedText = await api.getBalance(
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword:'',
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
    print(receivedText);
  }


  Future<void> writeSymmetricDecryptionConfirmationToTangle(TransactionParams transactionParams) async {
    debugPrint('writeSymmetricDecryptionConfirmationToTangle');
    final receivedText = await api.writeAdvancedTransaction(
        transactionParams: transactionParams,
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword:_strongholdPassword,
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
  }

  Future<void> writeFileHashToTangle(TransactionParams transactionParams) async {
    debugPrint('writeFileHashToTangle');
    final receivedText = await api.writeAdvancedTransaction(
        transactionParams: transactionParams,
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword:_strongholdPassword,
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
  }


  Future<void> readFileHashFromTangle() async {
    debugPrint('readFileHashFromTangle');
    final receivedText = await api.readIncomingTransactions(
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword:'',
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
  }

  Future<String> requestFundsFromFaucet(NetworkInfo networkInfo) async {
    debugPrint("writeCollaborationInTangle");
    final receivedText = await api.requestFunds(
        networkInfo: networkInfo,
        walletInfo: WalletInfo(
          alias: '',
          mnemonic: '',
          strongholdPassword:'',
          strongholdFilepath: _strongholdFilepath,
          lastAddress: _lastAddress,
        )
    );
    debugPrint(receivedText);
    return receivedText;
  }

  Future<String> writeCollaborationInTangle(TransactionParams transactionParams) async {
    debugPrint("writeCollaborationInTangle");
    final receivedText = await api.writeAdvancedTransaction(
        transactionParams: transactionParams,
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword:_strongholdPassword,
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
    debugPrint(receivedText);
    return receivedText;
  }


  Future<void> getIncomingCollaborationsFromTangle() async {

    debugPrint('storeCollaborationInTangle');
    final receivedText = await api.readIncomingTransactions(
        walletInfo: WalletInfo(
          alias: _alias,
          mnemonic: '',
          strongholdPassword:'',
          strongholdFilepath: _strongholdFilepath,
          lastAddress: '',
        )
    );
    debugPrint(receivedText);
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
                  Center(
                    child: SizedBox(
                      width: Get.width / 2,
                      child: ButtonFillMain(
                          title: "Continue".tr,
                          bgColor: context.theme.primaryColor,
                          textColor: context.theme.primaryColorDark,
                          onPress: () {
                            _controller.callFfiTestMethod();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}