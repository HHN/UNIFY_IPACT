import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/collaboration/documents.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/add_documents/add_documents_controller.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';

class AddDocumentsScreen extends StatefulWidget {
  final String? collaborationId;
  const AddDocumentsScreen({super.key, this.collaborationId});

  @override
  AddDocumentsScreenState createState() => AddDocumentsScreenState();
}

class AddDocumentsScreenState extends State<AddDocumentsScreen> {
  final _controller = Get.put(AddDocumentsController());

  String? documentName;
  File? selectedFile;
  String? fileNameSplit;

  late Box<Collaborations> collaborationBox;
  late Box<Documents> documentsBox;

  @override
  void initState() {
    super.initState();
    collaborationBox = Hive.box('collaborations');
    documentsBox = Hive.box('documents');
  }

  @override
  void dispose() {
    hideKeyboard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: appBarWithBack(title: "Add Document".tr, context: context),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vSpacer30(),
                        const AppLogo(),
                        vSpacer100(),
                        Form(
                          key: _controller.formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextAutoMetropolis("Folder Name".tr,
                                    fontSize: Dimens.fontSizeRegular),
                                vSpacer5(),
                                TextFieldView(
                                  controller: _controller
                                      .collaborationNameTextController,
                                  hint: "Add a name for Folder".tr,
                                  inputType: TextInputType.name,
                                  validator: TextFieldValidator.emptyValidator,
                                  onSaved: (value) {
                                    documentName = value.toString();
                                  },
                                ),
                                vSpacer15(),
                              ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: Get.width / 2.5,
                              child: Obx(() => ButtonFillMainWhiteBg(
                                  title: "Select File".tr,
                                  isLoading: _controller.isLoading.value,
                                  onPress: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles();

                                    if (result != null) {
                                      setState(() {
                                        // selectedFile = File(result.files.single.path!);
                                        // fileNameSplit = selectedFile.toString().split('/').last;
                                        selectedFile =
                                            File(result.files.single.path!);
                                        fileNameSplit =
                                            selectedFile!.path.split('/').last;
                                      });
                                    } else {
                                      // User canceled the picker
                                    }
                                  })),
                            ),
                          ],
                        ),
                        selectedFile != null
                            ? InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const TextAutoMetropolis(
                                      'Selected document name: ',
                                      fontSize: 14,
                                    ),
                                    TextAutoPoppins(
                                      '$fileNameSplit',
                                      maxLines: 10,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  OpenFile.open(selectedFile.toString());
                                },
                              )
                            : const SizedBox(),
                        vSpacer100(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: Get.width / 1.5,
                              child: Obx(() => ButtonFillMain(
                                  title: "Add Document".tr,
                                  isLoading: _controller.isLoading.value,
                                  onPress: () {
                                    if (selectedFile != null &&
                                        _controller
                                            .collaborationNameTextController
                                            .text
                                            .isNotEmpty) {
                                      var dateAndTimeNowForFileId =
                                          DateTime.now().microsecondsSinceEpoch;

                                      var dateAndTimeNow =
                                          DateTime.now().microsecondsSinceEpoch;
                                      print(dateAndTimeNow);
                                      addDocumentAndSaveToHive(
                                        collaborationId: widget.collaborationId
                                            .toString(), // Replace with actual collaboration ID
                                        filePath: selectedFile,
                                        fileId:
                                            dateAndTimeNowForFileId.toString(),
                                        fileOriginalName:
                                            fileNameSplit.toString(),
                                        ownDocument: true,
                                        isCryptographicKeyShared: false,
                                      );
                                      Navigator.pop(context);
                                    } else if (_controller
                                        .collaborationNameTextController
                                        .text
                                        .isEmpty) {
                                      CustomSnackBar.show(context,
                                          "Collaboration Name can not be empty.");
                                    } else if (selectedFile == null) {
                                      CustomSnackBar.show(context,
                                          "Select file can not be empty.");
                                    }
                                  })),
                            ),
                          ],
                        ),
                        vSpacer30(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void addDocumentAndSaveToHive({
    required String collaborationId,
    required File? filePath,
    required String? fileId,
    required String? fileOriginalName,
    required bool? ownDocument,
    required bool? isCryptographicKeyShared,
  }) {
    final isValid = _controller.formKey.currentState?.validate();

    if (isValid != null && isValid) {
      _controller.formKey.currentState?.save();
      if (filePath != null) {
        documentsBox.add(Documents(
            collaborationId: collaborationId,
            documentName: documentName.toString(),
            documentShareStatus: false,
            isFileEncrypted: false,
            filePath: filePath.path,
            fileId: fileId.toString(),
            fileOriginalName: fileOriginalName!,
            generateKeyFileForSymmetricCryptography: '',
            symmetricEncryptFile: '',
            asymmetricEncryptFile: '',
            asymmetricDecryptFile: '',
            symmetricDecryptFile: '',
            originalFileHash: '',
            symmetricEncryptFileHash: '',
            ownDocument: ownDocument,
            originalFileHashTransactionId: '',
            symmetricEncryptFileHashTransactionId: '',
            isCryptographicKeyShared: isCryptographicKeyShared,
            ));
      }
    }
  }
}
