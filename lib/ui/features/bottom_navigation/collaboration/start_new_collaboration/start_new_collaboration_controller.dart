import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcceptNewCollaborationController extends GetxController {
  RxBool isLoading = false.obs;

  final collaborationNameTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  RxString userPublicKey = ''.obs;
  RxString userPublicAddress= ''.obs;

}
