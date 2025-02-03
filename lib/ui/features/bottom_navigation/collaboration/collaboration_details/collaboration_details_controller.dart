import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollaborationDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  final collaborationNameTextController = TextEditingController();

  TabController? tabController;
  final tabSelectedIndex = 0.obs;



  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    super.onInit();
  }

  Future<void> getData() async {
    // getList();
    Future.delayed(const Duration(seconds: 1), () {
      //Duration.zero
      // getItemList();
    });
  }


  List<dynamic> documentsDemoItemList = [
    {'name': 'John', 'group': 'April 27, 2021'},
    {'name': 'Will', 'group': 'April 27, 2021'},
    {'name': 'Beth', 'group': 'April 27, 2021'},
  ].obs;
}
