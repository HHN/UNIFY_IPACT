import 'dart:convert';
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
import 'package:unify_secret/utils/extentions.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';

class AddMultipleDocumentsScreen extends StatefulWidget {
  final String? collaborationId;
  const AddMultipleDocumentsScreen({super.key, this.collaborationId});

  @override
  AddMultipleDocumentsScreenState createState() => AddMultipleDocumentsScreenState();
}

class AddMultipleDocumentsScreenState extends State<AddMultipleDocumentsScreen> {
  final _controller = Get.put(AddDocumentsController());

  String? documentName;
  List<File> selectedFiles = [];
  List<String> fileNames = [];
  Set<String> filePathsSet = {}; // Set to track file paths

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

  void _showFileAlreadySelectedAlert(String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File Already Selected', style: TextStyle(color:context.theme.secondaryHeaderColor)),
          content: Text('The file "$fileName" has already been selected.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      for (var file in result.files) {
        File newFile = File(file.path!);
        String fileName = file.name;
        String filePath = newFile.path;

        // if (filePathsSet.contains(filePath))
        if (selectedFiles.any((f) => f.name == newFile.name)) {
          _showFileAlreadySelectedAlert(fileName);
        } else {
          setState(() {
            selectedFiles.add(newFile);
            fileNames.add(fileName);
            filePathsSet.add(filePath);
          });
        }
      }
    } else {
      print("File picker was canceled.");
    }
  }

  void _removeFile(int index) {
    setState(() {
      filePathsSet.remove(selectedFiles[index].path); // Remove the path from the set
      selectedFiles.removeAt(index);
      fileNames.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarWithBack(title: "Add File Stack".tr, context: context),
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
                            TextAutoMetropolis("File Stack Name".tr, fontSize: Dimens.fontSizeRegular),
                            vSpacer5(),
                            TextFieldView(
                              controller: _controller.collaborationNameTextController,
                              hint: "Write a File Stack Name".tr,
                              inputType: TextInputType.name,
                              validator: TextFieldValidator.emptyValidator,
                              onSaved: (value) {
                                documentName = value.toString();
                              },
                            ),
                            vSpacer15(),
                          ],
                        ),
                      ),
                      selectedFiles.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(selectedFiles.length, (index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Selected File: ', style: TextStyle(fontSize: 14)),
                                      Text(fileNames[index], maxLines: 10),
                                    ],
                                  ),
                                  onTap: () {
                                    OpenFile.open(selectedFiles[index].path);
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _removeFile(index);
                                },
                              ),
                            ],
                          );
                        }),
                      )
                          : const SizedBox(),
                      vSpacer30(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: Get.width / 2.5,
                            child: Obx(() => ButtonFillMainWhiteBg(
                              title: "Select File".tr,
                              isLoading: _controller.isLoading.value,
                              onPress: _selectFiles,
                            )),
                          ),
                        ],
                      ),
                      vSpacer100(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: Get.width / 1.5,
                            child: Obx(() => ButtonFillMain(
                                title: "Add File Stack".tr,
                                isLoading: _controller.isLoading.value,
                                onPress: () {
                                  if (selectedFiles.isNotEmpty && _controller.collaborationNameTextController.text.isNotEmpty) {
                                    var dateAndTimeNowForFileId = DateTime.now().microsecondsSinceEpoch;

                                    var files = [];
                                    var fileNamesList = [];
                                    for (var file in selectedFiles) {
                                      files.add(file.path);
                                      fileNamesList.add(fileNames[selectedFiles.indexOf(file)]);
                                    }

                                    var dateAndTimeNow = DateTime.now().microsecondsSinceEpoch;
                                    addDocumentAndSaveToHive(
                                      collaborationId: widget.collaborationId.toString(),
                                      filePath: jsonEncode(files), // Convert files list to JSON string
                                      fileId: dateAndTimeNowForFileId.toString(),
                                      fileOriginalName: jsonEncode(fileNamesList), // Convert file names list to JSON string
                                      ownDocument: true,
                                      isCryptographicKeyShared: false,
                                    );

                                    Navigator.pop(context);
                                  } else if (_controller.collaborationNameTextController.text.isEmpty) {
                                    CustomSnackBar.show(context, "Collaboration Name can not be empty.");
                                  } else if (selectedFiles.isEmpty) {
                                    CustomSnackBar.show(context, "Select file can not be empty.");
                                  }
                                }
                            )),
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
      ),
    );
  }

  void addDocumentAndSaveToHive({
    required String collaborationId,
    required String? filePath,
    required String? fileId,
    required String? fileOriginalName,
    required bool? ownDocument,
    required bool? isCryptographicKeyShared,
  }) {
    final isValid = _controller.formKey.currentState?.validate();

    if (isValid != null && isValid) {
      _controller.formKey.currentState?.save();
      documentsBox.add(Documents(
        collaborationId: collaborationId,
        documentName: documentName.toString(),
        documentShareStatus: false,
        isFileEncrypted: false,
        filePath: filePath,
        fileOriginalName: fileOriginalName,
        fileId: fileId,
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
        symmetricDecryptFileHash: '',
        asymmetricDecryptFileHash: '',
        symmetricDecryptFileHashTransactionId: '',
        asymmetricDecryptFileHashTransactionId: '',
        isCryptographicKeyShared: isCryptographicKeyShared,
        cryptographicKeyTransactionId: '',
      ));
    }
  }
}
