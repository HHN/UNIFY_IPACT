import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SetUpPinScreenController extends GetxController {

  RxBool isLoading = false.obs;

  final pinCodeEditController = TextEditingController();
  final pinConfirmCodeEditController = TextEditingController();


  final formKey = GlobalKey<FormState>();

}
