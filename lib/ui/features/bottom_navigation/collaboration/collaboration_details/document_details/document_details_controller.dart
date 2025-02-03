import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/models/collaboration/documents.dart';

class DocumentDetailsController extends GetxController with GetSingleTickerProviderStateMixin{
  RxBool isLoading = false.obs;
  RxString pastedLink = ''.obs;
  RxBool isShowPassword = false.obs;

  final collaborationNameTextController = TextEditingController();
  final collaborationInvitationListTextController = TextEditingController();
  final strongholdPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString userPublicKey = ''.obs;
  RxString userPublicAddress= ''.obs;
  // RxString keyFilePath= ''.obs;
  // RxString prm1= ''.obs;
  // RxString prm2= ''.obs;
  // RxString prm3= ''.obs;

  var documentsBox = Hive.box<Documents>('documents');
  var documentsList = <Documents>[].obs;



  TabController? tabController;
  final tabSelectedIndex = 0.obs;



  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    loadDocuments();
    documentsBox.listenable().addListener(loadDocuments);
    super.onInit();
  }

  Future<void> getData() async {
    // getList();
    Future.delayed(const Duration(seconds: 1), () {
      //Duration.zero
      // getItemList();
    });
  }

  void loadDocuments() {
    documentsList.value = documentsBox.values.toList();
  }

  Future<void> updateDocument(String key, Documents document) async {
    await documentsBox.put(key, document);
    loadDocuments(); // Refresh the documents list
  }


  // Documents firstDocument = firstDocument.obs;


}
