import 'package:get/get.dart';
import 'package:unify_secret/ffi.dart';

class CreateNewProfileController extends GetxController {



  bool isCheck = false;

  RxString mnemonicText = ''.obs;
  // RxList mnemonicList = [].obs;
  RxList rxSplitItems = [].obs;

  bool isLoading = true;

  Future<void> callFfiGenerateMnemonic() async {
    final receivedText = await api.generateMnemonic();
    mnemonicText.value = receivedText;

    List<String> splitItems = mnemonicText.value.split(" ");
    rxSplitItems.value = splitItems;
    // gpsHelper(mnemonicText.value);
  }

  // void gpsHelper(String text) {
  // LineSplitter ls = const LineSplitter();
  // // List<String> _masForUsing = ls.convert(text);
  // mnemonicList.value = ls.convert(text);
  //
  // //print(_masForUsing[2]); // gps coordinates: 55.376538; 037.431973;
  // }

}
