import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/collaboration/documents.dart';
import 'package:unify_secret/data/models/transaction.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/receive_document/receive_document_controller.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_controller_final.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_utils.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_field_util.dart';
import 'package:unify_secret/utils/text_util.dart';

class ReceiveDocumentScreen extends StatefulWidget {
  const ReceiveDocumentScreen({super.key});

  @override
  ReceiveDocumentScreenState createState() => ReceiveDocumentScreenState();
}

class ReceiveDocumentScreenState extends State<ReceiveDocumentScreen> {
  final _controllerEncryptionControllerFinal =
      Get.put(EncryptionControllerFinal());
  bool _isChecked = false;
  final _controller = Get.put(ReceiveDocumentController());

  File? selectedFile;
  String? fileNameSplit;
  String? documentName;

  late Box<Documents> documentsBox;
  late Box<Collaborations> collaborationBox;

  late String iPactWalletFilePathValue;
  late Box<User> userBox;
  late User user;
  late Collaborations collaborations;
  EncryptionUtils objectInstance = EncryptionUtils();

  @override
  void initState() {
    super.initState();
    documentsBox = Hive.box('documents');
    _getIpactWalletFilePath();
    userBox = Hive.box<User>('users');

    if (userBox.isNotEmpty) {
      user = userBox.values.first;
    } else {
      // empty state
    }

    collaborationBox = Hive.box('collaborations');
  }

  @override
  void dispose() {
    hideKeyboard();
    super.dispose();
  }

  void _getIpactWalletFilePath() async {
    iPactWalletFilePathValue = await iPactWalletFilePath();
  }

  Future<List<File>> _unzipFile(String zipFilePath) async {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Read the Zip file from the provided path
    final bytes = File(zipFilePath).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents to the temporary directory
    List<File> extractedFiles = [];
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final filePath = '$tempPath/$filename';
        final extractedFile = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        extractedFiles.add(extractedFile);
      }
    }
    return extractedFiles;
  }

  Future<void> _handleDecryptionProcess(String filePath) async {
    if (selectedFile.toString().isEmpty) {
      Get.snackbar('Error', 'You have not selected any encrypted file');
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
              message:
                  'Please wait while we process your request.\nDo not close the app.\nThank you for your patience.',
              context: context);
        },
      );

      try {
        //print(filePath);
        int startIndex = filePath.indexOf('/data');
        filePath = filePath.substring(startIndex);
        // Remove trailing single quote if present
        if (filePath.endsWith("'")) {
          filePath = filePath.substring(0, filePath.length - 1);
        }

        //print('filePath');
        //print(filePath);

        var receivedEncryptedFiles = await _unzipFile(filePath);

        if (receivedEncryptedFiles.isNotEmpty) {
          Collaborations? exactCollaboration;
          // Iterate over all items in the box to find the matching collaborationId
          for (var collaboration in collaborationBox.values) {
            if (collaboration.collaborationId ==
                _controller.collaborationId.toString()) {
              //print('Found collaboration: ${collaboration.collaborationId}');
              exactCollaboration = collaboration;
              break;
            }
          }
          //print("exactCollaboration");
          //print(exactCollaboration);

          String collaborationPartnerAddress;
          if (user.userPublicAddress == exactCollaboration!.senderIOTAAddress) {
            collaborationPartnerAddress =
                exactCollaboration.receiverIOTAAddress.toString();
          } else {
            collaborationPartnerAddress =
                exactCollaboration.senderIOTAAddress.toString();
          }

          var fileCount = 1;
          var asymmetricDecryptedFilesPath = [];
          var asymmetricDecryptedFilesHash = [];

          for (var receivedEncryptedFile in receivedEncryptedFiles) {
            //print('receivedEncryptedFile.path');
            //print(receivedEncryptedFile.path);
            var receivedEncryptedFilePath = receivedEncryptedFile.path;

            var asymmetricDecryptedFilePath =
                await _controllerEncryptionControllerFinal
                    .asymmetricDecryptFile(
                        collaborationId: _controller.collaborationId.toString(),
                        fileId: _controller.fileId.toString(),
                        filePath: receivedEncryptedFilePath.toString(),
                        fileCount: fileCount.toString());

            //print("_controller.collaborationId.toString()");
            //print(_controller.collaborationId.toString());
            //print("_controller.fileId.toString()");
            //print(_controller.fileId.toString());

            var asymmetricDecryptedFileHash = await objectInstance
                .createHashFromFile(asymmetricDecryptedFilePath.toString());
            //print("asymmetricDecryptedFileHash");
            //print(asymmetricDecryptedFileHash);

            var readFileHashFromTangleValue = await readFileHashFromTangle(
                asymmetricDecryptedFileHash.toString());
            //print("readFileHashFromTangleValue");
            //print(readFileHashFromTangleValue);

            if (readFileHashFromTangleValue!.isNotEmpty) {
              asymmetricDecryptedFilesPath
                  .add(asymmetricDecryptedFilePath.toString());
              asymmetricDecryptedFilesHash
                  .add(asymmetricDecryptedFileHash.toString());
            }
            fileCount = fileCount + 1;
          }

          var transactionMetadataForAsymmetricDecryptionConfirmationTransaction =
              {
            "a": 4,
            "b": _controller.collaborationId.toString(),
            "c": _controller.fileId.toString(),
            "d": asymmetricDecryptedFilesHash
          };

          var asymmetricDecryptionConfirmationTransactionParams =
              TransactionParams(
                  transactionTag: "",
                  //transactionMetadata: "{2, 'collaboration_id', 'document_id', '${originalFileHash.toString()}'}",
                  transactionMetadata: jsonEncode(
                      transactionMetadataForAsymmetricDecryptionConfirmationTransaction),
                  receiverAddress: '$collaborationPartnerAddress',
                  storageDepositReturnAddress: '$collaborationPartnerAddress');

          var asymmetricDecryptFileHashTransactionId =
              await writeFileHashToTangle(
                  asymmetricDecryptionConfirmationTransactionParams);

          //print(asymmetricDecryptFileHashTransactionId);
          //print("asymmetricDecryptFileHashTransactionId");


          addDocumentAndSaveToHive(
            collaborationId: _controller.collaborationId.toString(),
            documentName:
                _controller.documentNameTextController.text.toString(),
            documentShareStatus: true,
            fileId: _controller.fileId.toString(),
            asymmetricDecryptFile: asymmetricDecryptedFilesPath.toString(),
            ownDocument: false,
            asymmetricDecryptFileHash: asymmetricDecryptedFilesHash.toString(),
            asymmetricDecryptFileHashTransactionId:
            asymmetricDecryptFileHashTransactionId.toString(),
            isCryptographicKeyShared: false,
          );

          // Navigator.pop(context);
          Get.snackbar('Succeeded', 'Received Document Decrypted Successfully.',
              snackPosition: SnackPosition.BOTTOM);
          Navigator.pop(context); // Close the dialog
          Navigator.pop(context); // Go back to the previous screen
        }
      } catch (e) {
        //print(e.toString());
        Get.snackbar('Error', e.toString());
        Get.back(); // Close the dialog
      }
    }
  }

  Future<String> writeFileHashToTangle(
      TransactionParams transactionParams) async {
    print('writeFileHashToTangle');
    print(user.userName.toString());
    print(iPactWalletFilePathValue.toString());
    final receivedText = await api.writeAdvancedTransaction(
        transactionParams: transactionParams,
        walletInfo: WalletInfo(
          alias: user.userName.toString(),
          mnemonic: '',
          strongholdPassword:
              _controller.strongholdPasswordController.text.toString(),
          // strongholdPassword: 'Rasel1#',
          strongholdFilepath: iPactWalletFilePathValue.toString(),
          lastAddress: '',
        ));
    print(receivedText);
    return receivedText;
  }

  Future<Map<String, String>?> readFileHashFromTangle(
      String asymmetricDecryptedFileHash) async {
    print('getIncomingCollaborationsFromTangle');
    print(user.userName.toString());

    // Read incoming transactions
    final receivedText = await api.readIncomingTransactions(
        walletInfo: WalletInfo(
      alias: user.userName.toString(),
      mnemonic: '',
      strongholdPassword: '',
      strongholdFilepath: iPactWalletFilePathValue.toString(),
      lastAddress: '',
    ));

    print('receivedText');
    print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);
    List<Transaction> transactions =
        jsonList.map((json) => Transaction.fromJson(json)).toList();

    // Filter and convert the List<Transaction> to List<Map<String, String>>
    List<Map<String, String>> filteredTransactions = transactions
        .map((transaction) {
          try {
            Map<String, dynamic> metadata = jsonDecode(transaction.metadata);

            // Filter transactions during the mapping
            if (metadata['a'] == 3 &&
                (metadata['d'] as List<dynamic>)
                    .contains(asymmetricDecryptedFileHash) &&
                metadata['d'].contains(asymmetricDecryptedFileHash)) {
              print('metadata d');
              print(metadata['d']);
              return {
                'transactionId': transaction.transactionId,
                'collaborationId': metadata['b'].toString(),
                'fileId': metadata['c'].toString(),
                'fileHash': metadata['d'].toString(),
              };
            }
          } catch (e) {
            print('Error parsing metadata: $e');
          }
          return null;
        })
        .where((transaction) => transaction != null)
        .cast<Map<String, String>>()
        .toList();

    // Check if any filtered transaction exists
    if (filteredTransactions.isNotEmpty) {
      print('Found transaction: ${filteredTransactions.first}');
      return filteredTransactions.first;
    } else {
      print(
          'Transaction with file hash $asymmetricDecryptedFileHash not found.');
      return null;
    }
  }

  Future<Map<String, String>> readFileHashFromTangleOld(
      String asymmetricDecryptedFileHash) async {
    print('getIncomingCollaborationsFromTangle');
    print(user.userName.toString());

    // Read incoming transactions
    final receivedText = await api.readIncomingTransactions(
        walletInfo: WalletInfo(
      alias: user.userName.toString(),
      mnemonic: '',
      strongholdPassword: '',
      strongholdFilepath: iPactWalletFilePathValue.toString(),
      lastAddress: '',
    ));

    print('receivedText');
    print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);
    List<Transaction> transactions =
        jsonList.map((json) => Transaction.fromJson(json)).toList();

    // Convert List<Transaction> to List<Map<String, String>>
    List<Map<String, String>> transactionList = transactions.map((transaction) {
      // Handle the metadata correctly
      List<String> data = [];
      try {
        if (transaction.metadata != null && transaction.metadata.isNotEmpty) {
          if (transaction.metadata.startsWith('{') &&
              transaction.metadata.endsWith('}')) {
            data = transaction.metadata
                .substring(3, transaction.metadata.length - 1)
                .split(', ');
          } else if (transaction.metadata.startsWith('[') &&
              transaction.metadata.endsWith(']')) {
            data = jsonDecode(transaction.metadata).cast<String>();
          }
        }
        print("data");
        print(data);
      } catch (e) {
        print('Error parsing metadata: $e');
      }

      return {
        // 'transactionType': data.isNotEmpty ? data[0] : '',
        'transactionId': transaction.transactionId,
        'collaborationId': data.isNotEmpty ? data[0] : '',
        'fileId': data.length > 1 ? data[1] : '',
        'fileHash': data.length > 2 ? data[2] : '',
      };
    }).toList();

    // Debug print the resulting list of maps
    for (var transaction in transactionList) {
      print(transaction);
    }

    // return transactionList;

    // Find the specific file hash in the transaction list
    var foundTransaction = transactionList.firstWhere(
      (transaction) => transaction['fileHash'] == asymmetricDecryptedFileHash,
      // orElse: () => null,
    );

    // Check if the transaction was found and print the result
    if (foundTransaction.isNotEmpty) {
      print('Found transaction: $foundTransaction');
      print('foundTransaction');
    } else {
      print(
          'Transaction with file hash $asymmetricDecryptedFileHash not found.');
    }
    print('foundTransaction');
    return foundTransaction;
  }

  Map<String, String> extractTwoNumbers(String text) {
    RegExp regExp = RegExp(r'\d+');
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    List<String> numbers =
        matches.map((match) => match.group(0)!).take(2).toList();

    String collaborationId = numbers.isNotEmpty ? numbers[0] : '';
    String fileId = numbers.length > 1 ? numbers[1] : '';

    return {
      'collaborationId': collaborationId,
      'fileId': fileId,
    };
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      //appBar: appBarWithBack(title: "ReceiveDocument".tr, context: context),
      appBar: appBarWithBack(title: "ReceiveFileStack".tr, context: context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSpacer30(),
                    const AppLogo(),
                    vSpacer30(),
                    Padding(
                      padding: const EdgeInsets.all(Dimens.paddingLarge),
                      child: Form(
                        key: _controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextAutoMetropolis("File Stack Name".tr,
                                fontSize: Dimens.fontSizeRegular),
                            vSpacer5(),
                            TextFieldView(
                              controller:
                                  _controller.documentNameTextController,
                              hint: "Write a File Stack Name".tr,
                              inputType: TextInputType.name,
                              validator: TextFieldValidator.emptyValidator,
                              onSaved: (value) {
                                documentName = value.toString();
                              },
                            ),
                            vSpacer15(),
                            TextAutoMetropolis("Stronghold Password".tr,
                                fontSize: Dimens.fontSizeRegular),
                            vSpacer5(),
                            TextFieldView(
                              controller:
                                  _controller.strongholdPasswordController,
                              hint: "Enter your Stronghold Password".tr,
                              inputType: TextInputType.visiblePassword,
                              validator: TextFieldValidator.emptyValidator,
                              isObscure: !_controller.isShowPassword.value,
                              suffix: ShowHideIconView(
                                  isShow: _controller.isShowPassword.value,
                                  onTap: () =>
                                      _controller.isShowPassword.value =
                                          !_controller.isShowPassword.value),
                              // onSaved: (value) {
                              //   collabName = value.toString();
                              // },
                            ),
                            vSpacer15(),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 2.5,
                                      child: Obx(() => ButtonFillMainWhiteBg(
                                            title: "Select File Stack".tr,
                                            isLoading:
                                                _controller.isLoading.value,
                                            onPress: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();

                                              if (result != null) {
                                                setState(() {
                                                  selectedFile = File(result
                                                      .files.single.path!);
                                                  print('selectedFile');
                                                  print(selectedFile);
                                                  fileNameSplit = selectedFile!
                                                      .path
                                                      .split('/')
                                                      .last;

                                                  Map<String, String> ids =
                                                      extractTwoNumbers(
                                                          fileNameSplit!);
                                                  _controller.collaborationId
                                                          .value =
                                                      ids['collaborationId']!;
                                                  _controller.fileId.value =
                                                      ids['fileId']!;
                                                  print(
                                                      "_controller.collaborationId.value");
                                                  print(_controller
                                                      .collaborationId.value
                                                      .toString());
                                                  print(
                                                      "_controller.fileId.value");
                                                  print(_controller.fileId.value
                                                      .toString());
                                                });
                                              } else {
                                                // User canceled the picker
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                                selectedFile != null
                                    ? Obx(() {
                                        return InkWell(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const TextAutoMetropolis(
                                                  'Selected File Stack: ',
                                                  fontSize: 14,
                                                  maxLines: 3),
                                              TextAutoPoppins('$fileNameSplit',
                                                  maxLines: 3),
                                              TextAutoPoppins(
                                                  _controller.collaborationId
                                                      .toString(),
                                                  maxLines: 3),
                                              TextAutoPoppins(
                                                  _controller.fileId.toString(),
                                                  maxLines: 3),
                                            ],
                                          ),
                                          onTap: () {
                                            OpenFile.open(selectedFile!.path);
                                          },
                                        );
                                      })
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          focusColor: context.theme.primaryColorDark,
                          activeColor: context.theme.primaryColorDark,
                          checkColor: context.theme.primaryColorLight,
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked = !_isChecked;
                            });
                          },
                          child: const TextAutoPoppins(
                            'I want to decrypt the received File Stack.',
                          ),
                        ),
                      ],
                    ),
                    vSpacer20(),
                    _isChecked == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: Get.width / 2.5,
                                child: Obx(() => ButtonFillMain(
                                      title: "Decrypt Files".tr,
                                      isLoading: _controller.isLoading.value,
                                      onPress: () {
                                        if (selectedFile.toString().isEmpty ||
                                            selectedFile == null) {
                                          Get.snackbar('Error',
                                              'You have not selected any File Stack');
                                        } else {
                                          _handleDecryptionProcess(
                                              selectedFile.toString());
                                        }
                                        // Get.back();
                                      },
                                    )),
                              ),
                            ],
                          )
                        : const SizedBox(height: 0),
                    vSpacer30(),
                  ],
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
    required String documentName,
    required bool documentShareStatus,
    required String? fileId,
    required String? asymmetricDecryptFile,
    required bool? ownDocument,
    required String? asymmetricDecryptFileHash,
    required String? asymmetricDecryptFileHashTransactionId,
    required bool? isCryptographicKeyShared,
  }) {
    // final isValid = _controller.formKey.currentState?.validate();
    //
    // if (isValid != null && isValid) {
    //   _controller.formKey.currentState?.save();
    if (fileId != null) {
      documentsBox.add(Documents(
        collaborationId: collaborationId,
        documentName: documentName.toString(),
        documentShareStatus: documentShareStatus,
        fileId: fileId,
        // fileOriginalName: '',
        // generateKeyFileForSymmetricCryptography: '',
        // symmetricEncryptFile: '',
        // asymmetricEncryptFile: '',
        asymmetricDecryptFile: asymmetricDecryptFile,
        // symmetricDecryptFile: '',
        // originalFileHash: '',
        // symmetricEncryptFileHash: '',
        ownDocument: ownDocument,
        // originalFileHashTransactionId: '',
        // symmetricEncryptFileHashTransactionId: '',
        // symmetricDecryptFileHash: '',
        asymmetricDecryptFileHash: asymmetricDecryptFileHash.toString(),
        asymmetricDecryptFileHashTransactionId:
            asymmetricDecryptFileHashTransactionId.toString(),
        isCryptographicKeyShared: isCryptographicKeyShared,

        // filePath: filePath,
        // fileOriginalName: firstDocument.fileOriginalName,
        // generateKeyFileForSymmetricCryptography: firstDocument.generateKeyFileForSymmetricCryptography,
        // symmetricEncryptFile: firstDocument.symmetricEncryptFile,
        // asymmetricEncryptFile: firstDocument.asymmetricEncryptFile,
        // asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
        // symmetricDecryptFile: firstDocument.symmetricDecryptFile,
        // originalFileHash: firstDocument.originalFileHash.toString(),
        // symmetricEncryptFileHash: firstDocument.symmetricEncryptFileHash,
        // ownDocument: firstDocument.ownDocument,
        // originalFileHashTransactionId: firstDocument.originalFileHashTransactionId,
        // symmetricEncryptFileHashTransactionId: firstDocument.symmetricEncryptFileHashTransactionId,
        // symmetricDecryptFileHash: firstDocument.symmetricDecryptFileHash,
        // asymmetricDecryptFileHash: firstDocument.asymmetricDecryptFileHash,
        // symmetricDecryptFileHashTransactionId: firstDocument.symmetricDecryptFileHashTransactionId,
        // asymmetricDecryptFileHashTransactionId: firstDocument.asymmetricDecryptFileHashTransactionId,
        // isCryptographicKeyShared: firstDocument.isCryptographicKeyShared,
        // cryptographicKeyTransactionId: firstDocument.cryptographicKeyTransactionId,
      ));
    }
    // }
  }

// void invitePartnerAndSaveToHive({
//   String? collaborationId,
//   String? collaborationName,
//   bool? collaborationAccepted,
//   bool? collaborationSent,
//   String? transactionId,
//   String? senderIOTAAddress,
//   String? senderPublicKey,
//   String? receiverIOTAAddress,
//   String? receiverPublicKey,
// }) {
//   final isValid = _controller.formKey.currentState?.validate();
//
//   if (isValid != null && isValid) {
//     _controller.formKey.currentState?.save();
//     collaborationBox.add(Collaborations(
//       collaborationId: collaborationId!,
//       collaborationName: collaborationName!,
//       collaborationAccepted: collaborationAccepted!,
//       collaborationSent: collaborationSent!,
//       transactionId: transactionId!,
//       senderIOTAAddress: senderIOTAAddress!,
//       senderPublicKey: senderPublicKey!,
//       receiverIOTAAddress: receiverIOTAAddress!,
//       receiverPublicKey: receiverPublicKey!,
//     ));
//   }
// }
}
