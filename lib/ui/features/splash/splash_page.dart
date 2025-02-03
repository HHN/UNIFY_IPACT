import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  late Box<Collaborations> collaborationBox;

  @override
  void initState() {
    // TODO: implement initState

    //print('---------PRM-----PRM');
    _handleInitialUri();

  }


  void _handleInitialUri() async {
    final initialUri = await getInitialUri();
    //print(initialUri);
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
    //print('Received deep link: ${uri.toString()}');
    final queryParams = uri.queryParameters;
    //print('Custom parameters: $queryParams');
    String? prm1 = queryParams['prm1'];
    String? prm2 = queryParams['prm2'];
    String? prm3 = queryParams['prm3'];
    //print('PRM');
    //print(prm1.toString());
    //print(prm2.toString());
    //print(prm3.toString());
    if (prm1 != null && prm2 != null && prm3 != null) {
      // Save the values to Hive DB
      invitePartnerAndSaveToHive(
        collaborationId: prm1,
        // collaborationName: collabName ?? '',
        collaborationName: 'collab Name',
        collaborationAccepted: false,
        collaborationSent: false,
        transactionId: '',
        senderIOTAAddress: prm3,
        senderPublicKey: prm2,
        receiverIOTAAddress: '',
        receiverPublicKey: '',
      );

      // Show the values in your app
      Get.snackbar('Deep Link Data', 'prm1: $prm1, prm2: $prm2, prm3: $prm3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: GetBuilder<SplashController>(
          init: SplashController(),
          builder: (splashController) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogoWithTitle(),
                // vSpacer15(),
                // TextAutoMetropolis("UnifySecret".tr,
                //     fontSize: Dimens.fontSizeLarge)
              ],
            );
          }),
    );
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
