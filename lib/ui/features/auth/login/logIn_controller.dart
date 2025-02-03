import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:unify_secret/data/models/user.dart';

class LogInController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingForContinueBtn = false.obs;

  RxString userNameATIndex = ''.obs;


  // var box = Hive.box<UsersCollection>('users');
  // var name = box.get('userName');

  final pinCodeEditController = TextEditingController();


  final formKey = GlobalKey<FormState>();


}
