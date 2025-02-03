import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/ffi.dart';

class TestScreenController extends GetxController {


  RxString mnemonicText = ''.obs;
  // RxList mnemonicList = [].obs;
  RxList rxSplitItems = [].obs;

  bool isLoading = true;



  RxString userName= ''.obs;
  RxString iPactWalletFilePathValue = ''.obs;


  static const NetworkInfo networkInfo = NetworkInfo(
      nodeUrl: 'https://api.testnet.shimmer.network',
      faucetUrl: 'https://faucet.testnet.shimmer.network/api/enqueue'
  );


  Future<String> getStrongholdFilePath() async {
    final Directory appSupportDir = await getApplicationSupportDirectory();
    final Directory appSupportDirStrongholdFolder =
    Directory('${appSupportDir.path}/');
    final strongholdFilePath = appSupportDirStrongholdFolder.path;
    return strongholdFilePath;
  }

  Future<void> callFfiTestMethod() async {
    //callFfiGetNodeInfo();
    //callFfiGenerateMnemonic();
  }

  Future<void> callFfiGenerateMnemonic() async {
    final receivedText = await api.generateMnemonic();
    debugPrint(receivedText);
  }

  Future<void> callFfiGetNodeInfo() async {
    final receivedText = await api.getNodeInfo(networkInfo:networkInfo);
    debugPrint(receivedText);
  }

}
