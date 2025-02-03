import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDocumentsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString pastedLink = ''.obs;

  final collaborationNameTextController = TextEditingController();
  final collaborationInvitationListTextController = TextEditingController();
  final strongholdPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString userPublicKey = ''.obs;
  RxString userPublicAddress= ''.obs;
  // RxString prm1= ''.obs;
  // RxString prm2= ''.obs;
  // RxString prm3= ''.obs;



}
