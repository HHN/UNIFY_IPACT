import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;


  // RxString publicAddress = ''.obs;
  // RxString ffiGetAddressesJsonResponse = ''.obs;

  RxString userPublicKey = ''.obs;
  RxString userPublicAddress= ''.obs;
  RxString userName= ''.obs;

}
