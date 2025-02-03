import 'package:get/get.dart';
import 'api_provider.dart';

class APIRepository {
  final provider = Get.find<APIProvider>();

  // Map<String, String> authHeader() {
  //   String? token = GetStorage().read(PreferenceKey.accessToken);
  //   var mapObj = <String, String>{};
  //   mapObj[APIKeyConstants.accept] = APIKeyConstants.vAccept;
  //   mapObj[APIKeyConstants.apiSecretKey] = APIKeyConstants.vApiKey;
  //   if (token != null && token.isNotEmpty) {
  //     mapObj[APIKeyConstants.authorization] = "${APIKeyConstants.vBearer} $token";
  //   }
  //   //printFunction("authHeader", mapObj[APIKeyConstants.authorization]);
  //   return mapObj;
  // }

  /// *** ------------ *** ///
  /// *** POST requests *** ///
  /// *** ------------ *** ///


  /// *** ------------ *** ///
  /// *** GET requests *** ///
  /// *** ------------ *** ///


  /// *** ---------------- *** ///
  /// *** SOCKET requests *** ///
  /// *** -------------- *** ///


  /// *** ---------------- *** ///
  /// *** Others requests *** ///
  /// *** -------------- *** ///

}
