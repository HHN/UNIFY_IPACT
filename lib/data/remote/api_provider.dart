import 'package:get/get.dart';
import '../local/api_constants.dart';

class APIProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = APIURLConstants.baseUrl;
    httpClient.maxAuthRetries = 3;
    httpClient.timeout = const Duration(seconds: 60);
    super.onInit();
  }

  /// *** Common Server Request *** ///

}
