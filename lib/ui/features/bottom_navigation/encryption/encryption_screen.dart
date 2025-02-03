import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_controller_final.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'encryption_controller.dart';


class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({Key? key}) : super(key: key);

  @override
  EncryptionScreenState createState() => EncryptionScreenState();
}

class EncryptionScreenState extends State<EncryptionScreen> {
  final _controller = Get.put(EncryptionController());
  final _encryptionControllerFinal = Get.put(EncryptionControllerFinal());

  @override
  void initState() {
    /// For creating public key and private key
   // _encryptionControllerFinal.generateKeyPemFile();
    /// For public key
    _encryptionControllerFinal.getPublicKeyAsString();

    // _encryptionControllerFinal.generateKeyFileForSymmetricCryptography();
   // _encryptionControllerFinal.symmetricEncryptFile();
   // _encryptionControllerFinal.asymmetricEncryptFile();
   // _encryptionControllerFinal.asymmetricDecryptFile();
   // _encryptionControllerFinal.symmetricDecryptFile();
   //_encryptionControllerFinal.compareHashedFiles('asymmetric_key_pairs/asymmetric_key_pair_1/public_key.pem','received_cryptographic_keys/1234/rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj/public_key.pem');
   //_encryptionControllerFinal.compareHashedFiles('original_files/original_file_1.txt', 'level_1_decrypted_files/level_1_decrypted_file_1.txt');
   /*_encryptionControllerFinal.generateRsaKeyPemFileFromReceivedPublicKey(
       '1234',
       'rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj',
       'MIIBCgKCAQEA2r52FfmyxeeUyg0o6C97JRO34Lsens1yapYBFQnC3CrDmKDs0ToR2+6q5tVik6tEKFrEo1E4CbGVzD0I+Ur+SnkbaZTQ6KrZZKBmeCy9elacMNocjsZeRJtVIz2E7QlqWM40zHsUMA03BxLTCAM90L1u5e7cz/9oWGPb8MhRFdRES7DxocLFyyVS2Cis/6m1rRCoQM0ewP87v7PKgraqwt0wOO69vk3qoGTcfAVT4MiXB9s6ZU3BhNZRpnsKxC8cnPMl8MyWZ/S8423rnh1Y/++scKZ8iAfPMPb1ORakxe8T2aGtyWNQrO57tw14y4w1FN15aLE93oBYVEy/90WNSQIDAQAB'
   );*/
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarMain(title: "Encryption".tr,context:context),
      body: SafeArea(
        child: Column(
          children: [
            vSpacer20(), 
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //       child: Column(
            //         children: [
            //           Container(
            //             height: 300,
            //             width: Get.width,
            //             color: context.theme.dividerColor,
            //             child: const Column(
            //               children: [
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //               ],
            //             ),
            //           ),
            //           vSpacer30(),
            //           Container(
            //             height: 300,
            //             width: Get.width,
            //             color: context.theme.dividerColor,
            //             child: const Column(
            //               children: [
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //                 TextAutoPoppins("Demo Text"),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),

      // SafeArea(
      //   child: Column(
      //     children: [
      //       AppBarMain(contextMain: context, title: "FileShare".tr),
      //       const Spacer(),
      //       Column(children: [Icon(Icons.rocket, size: context.width / 4), TextAutoMetropolis("Coming Soon".tr)]),
      //       const Spacer(),
      //       // Container(
      //       //     margin: const EdgeInsets.only(bottom: Dimens.paddingLargeDouble),
      //       //     width: context.width - 50,
      //       //     height: Dimens.btnHeightLarge,
      //       //     child: ButtonFillMain(title: "Back To Menu".tr, onPress: () => Get.back())
      //       // )
      //     ],
      //   ),
      // ),
    );
  }
}