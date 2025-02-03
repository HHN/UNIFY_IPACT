import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadStrongholdBackupController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingForContinueBtn = false.obs;

  RxString userNameATIndex = ''.obs;


  // var box = Hive.box<UsersCollection>('users');
  // var name = box.get('userName');

  final pinCodeEditController = TextEditingController();
  final pinConfirmCodeEditController = TextEditingController();


}
