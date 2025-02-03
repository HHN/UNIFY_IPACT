import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:get/get.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/ui/features/test_screen/ffi/ffi_utils.dart';
import 'package:unify_secret/ui/features/test_screen/test_screen_controller.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/dimens.dart';

class TestScreen2 extends StatefulWidget {
  const TestScreen2({super.key});

  @override
  State<TestScreen2> createState() => _TestScreen2State();
}

class _TestScreen2State extends State<TestScreen2> {
  // final _controller = Get.put(TestScreenController());

  String _alias = '';
  String _mnemonic = '';
  String _strongholdPassword = '';
  String _strongholdFilepath = '';
  String _lastAddress = '';

  final NetworkInfo networkInfo = const NetworkInfo(
      nodeUrl: 'https://api.testnet.shimmer.network',
      faucetUrl: 'https://faucet.testnet.shimmer.network/api/enqueue');

  final TransactionParams transactionParams = const TransactionParams(
      transactionTag: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia",
      transactionMetadata: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquy",
      receiverAddress: "rms1qr6aygm4nrn3hp7rnztttzd09l5mms4zzt83k5ukj42hq7pzm29a7gehcv7",
      storageDepositReturnAddress: "rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj"
  );

  @override
  void initState() {
    super.initState();
    try {
      _initializeStrongholdFilePath();
    } on FfiException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> _initializeStrongholdFilePath() async {
    _strongholdFilepath = await FFIUtils.getStrongholdFilePath();
    setState(() {
      _alias = "Rubayet1&";
      _mnemonic = "combine magnet clock exotic inmate recycle join shove drive dry fit where choose scissors kitchen lift shop jelly way insect actress bomb matter mad";
      _strongholdPassword = "Rubayet1&";
      _lastAddress = "rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj";
      debugPrint('<<<<<Stronghold File Path>>>>> $_strongholdFilepath');
      _callFfiGetAddresses();
    });
  }

  Future<void> _callFfiGetAddresses() async {
    await FFIUtils.callFfiGetAddresses(
      WalletInfo(
        alias: _alias,
        mnemonic: '',
        strongholdPassword: '',
        strongholdFilepath: _strongholdFilepath,
        lastAddress: '',
      ),
    );
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
                            // _controller.callFfiTestMethod();
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
