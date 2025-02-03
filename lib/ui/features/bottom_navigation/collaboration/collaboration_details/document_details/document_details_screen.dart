import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'dart:typed_data';
import 'package:archive/archive.dart';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/collaboration/documents.dart';
import 'package:unify_secret/data/models/transaction.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/document_details/document_details_controller.dart';
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

class DocumentDetailsScreen extends StatefulWidget {
  final String? collaborationId;
  final String? documentName;
  final bool? documentShareStatus;
  final String? filePath;
  final String? fileId;
  final String? fileOriginalName;
  final String? generateKeyFileForSymmetricCryptography;
  final String? symmetricEncryptFile;
  final String? asymmetricEncryptFile;
  final String? asymmetricDecryptFile;
  final String? symmetricDecryptFile;
  final String? originalFileHash;
  final String? symmetricEncryptFileHash;
  final bool? ownDocument;
  final String? originalFileHashTransactionId;
  final String? symmetricEncryptFileHashTransactionId;
  final String? asymmetricDecryptFileHash;
  final String? asymmetricDecryptFileHashTransactionId;
  final bool? isCryptographicKeyShared;
  final bool? isFileEncrypted;
  final String? cryptographicKeyTransactionId;

  const DocumentDetailsScreen({
    super.key,
    this.collaborationId,
    this.documentName,
    this.documentShareStatus,
    this.filePath,
    this.fileId,
    this.fileOriginalName,
    this.generateKeyFileForSymmetricCryptography,
    this.symmetricEncryptFile,
    this.asymmetricEncryptFile,
    this.asymmetricDecryptFile,
    this.symmetricDecryptFile,
    this.originalFileHash,
    this.symmetricEncryptFileHash,
    this.ownDocument,
    this.originalFileHashTransactionId,
    this.symmetricEncryptFileHashTransactionId,
    this.asymmetricDecryptFileHash,
    this.asymmetricDecryptFileHashTransactionId,
    this.isCryptographicKeyShared,
    this.isFileEncrypted,
    this.cryptographicKeyTransactionId,
  });

  @override
  DocumentDetailsScreenState createState() => DocumentDetailsScreenState();
}

class DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  final _controller = Get.put(DocumentDetailsController());
  final _controllerEncryptionControllerFinal =
      Get.put(EncryptionControllerFinal());

  final _encryptionControllerFinal = Get.put(EncryptionControllerFinal());

  bool _isChecked = false;

  EncryptionUtils objectInstance = EncryptionUtils();

  late Box<Documents> documentsBox;

  late Box<Collaborations> collaborationBox;
  late Collaborations collaborations;

  late Box<User> userBox;
  late User user;

  late String iPactWalletFilePathValue;

  @override
  void initState() {
    super.initState();
    _getIpactWalletFilePath();

    documentsBox = Hive.box('documents');

    userBox = Hive.box<User>('users');
    if (userBox.isNotEmpty) {
      user = userBox.values.first;
    } else {
      // empty state
    }

    collaborationBox = Hive.box('collaborations');
    if (collaborationBox.isNotEmpty) {
// Find the specific collaboration by filtering the box values
      collaborations = collaborationBox.values.firstWhere(
            (collab) => collab.collaborationId == widget.collaborationId,
      );

      //print('collaborations');
      //print(collaborations.collaborationId);
      //print(collaborations.senderIOTAAddress);
      //print(collaborations.receiverIOTAAddress);

    } else {
      // empty state
    }

    //print('here');
    _receiveAsymmetricDecryptionConfirmation();
    _receiveCryptographicKey();
  }

  Future<dynamic> _readCryptographicKeyFromTangle(
      String collaborationId, String fileId) async {
    // Read incoming transactions
    final receivedText = await api.readIncomingTransactions(
        walletInfo: WalletInfo(
      alias: user.userName.toString(),
      mnemonic: '',
      strongholdPassword: '',
      strongholdFilepath: iPactWalletFilePathValue.toString(),
      lastAddress: '',
    ));

    //print('receivedText');
    //print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);

    List<Transaction> transactions =
        jsonList.map((json) => Transaction.fromJson(json)).toList();

    List<Map<String, dynamic>?> transactionList = transactions
        .map((transaction) {
          try {
            if (transaction.metadata != null &&
                transaction.metadata.isNotEmpty) {
              var transactionMetadata = jsonDecode(transaction.metadata);
              if (transactionMetadata['a'] == 5 &&
                  transactionMetadata['b'] == collaborationId &&
                  transactionMetadata['c'] == fileId) {
                return {
                  'transactionType': transactionMetadata['a'].toString(),
                  'transactionId': transaction.transactionId,
                  'collaborationId': transactionMetadata['b'],
                  'fileId': transactionMetadata['c'],
                  'cryptographicKey': transactionMetadata['d'],
                };
              }
            }
          } catch (e) {
            print(e.toString());
          }
          return null; // Return null for transactions that don't meet the criteria
        })
        .where((item) => item != null)
        .toList(); // Remove null entries from the list

    if (transactionList.isNotEmpty) {
      return transactionList.first;
    } else {
      return null;
    }
  }

  _receiveCryptographicKey() async {
    if (widget.ownDocument == false &&
        widget.documentShareStatus == true &&
        (widget.cryptographicKeyTransactionId == null ||
            widget.cryptographicKeyTransactionId == '')) {
      /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
              message:
                  'Please wait while we process your request.\nDo not close the app.\nThank you for your patience.',
              context: context);
        },
      );*/

      try {
        iPactWalletFilePathValue = await iPactWalletFilePath();
        var transactionValue = await _readCryptographicKeyFromTangle(
            widget.collaborationId.toString(), widget.fileId.toString());
        //print("_receiveCryptographicKey");
        //print(transactionValue);

        if (transactionValue != null) {
          var cryptographicKey = transactionValue['cryptographicKey'];
          var cryptographicKeyTransactionId = transactionValue['transactionId'];

          if (cryptographicKey != null || cryptographicKey != '') {
            await _controllerEncryptionControllerFinal
                .generateFileForReceivedSymmetricKey(
                    collaborationId: widget.collaborationId.toString(),
                    fileId: widget.fileId,
                    cryptographicKey: cryptographicKey);

            var asymmetricDecryptFiles = widget.asymmetricDecryptFile;
            if (asymmetricDecryptFiles != null ||
                asymmetricDecryptFiles != '') {
              var asymmetricDecryptFilesList = asymmetricDecryptFiles
                  ?.substring(1, asymmetricDecryptFiles.length - 1)
                  .split(', ')
                  .map((s) => s.trim())
                  .toList();
              print('asymmetricDecryptFilesList');
              print(asymmetricDecryptFilesList);

              int fileCount = 1;
              List<String> symmetricDecryptedFilesPath = [];
              for (var asymmetricDecryptFileSingle
                  in asymmetricDecryptFilesList!) {
                var symmetricDecryptedFilePath =
                    await _controllerEncryptionControllerFinal
                        .symmetricDecryptFile(
                            collaborationId: widget.collaborationId.toString(),
                            fileId: widget.fileId,
                            fileExtension: 'txt',
                            fileCount: fileCount);

                symmetricDecryptedFilesPath.add(symmetricDecryptedFilePath);
                fileCount = fileCount + 1;
              }

              print('symmetricDecryptedFilesPath');
              print(symmetricDecryptedFilesPath);


              if (cryptographicKeyTransactionId != '' ||
                  cryptographicKeyTransactionId != null) {
                List<Documents> documents = documentsBox.values.toList();

                var filteredDocumentsList = documents
                    .where((documents) => documents.fileId == widget.fileId)
                    .toList();

                if (filteredDocumentsList.isNotEmpty) {
                  var firstDocument = filteredDocumentsList.first;

                  var updatedDocuments = Documents(
                    collaborationId: firstDocument.collaborationId,
                    documentName: firstDocument.documentName,
                    documentShareStatus: firstDocument.documentShareStatus,
                    filePath: firstDocument.filePath,
                    fileId: firstDocument.fileId,
                    fileOriginalName: firstDocument.fileOriginalName,
                    generateKeyFileForSymmetricCryptography:
                    firstDocument.generateKeyFileForSymmetricCryptography,
                    symmetricEncryptFile: firstDocument.symmetricEncryptFile,
                    asymmetricEncryptFile: firstDocument.asymmetricEncryptFile,
                    asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
                    symmetricDecryptFile: symmetricDecryptedFilesPath.toString(),
                    originalFileHash: firstDocument.originalFileHash,
                    symmetricEncryptFileHash:
                    firstDocument.symmetricEncryptFileHash,
                    ownDocument: firstDocument.ownDocument,
                    originalFileHashTransactionId:
                    firstDocument.originalFileHashTransactionId,
                    symmetricEncryptFileHashTransactionId:
                    firstDocument.symmetricEncryptFileHashTransactionId,
                    symmetricDecryptFileHash:
                    firstDocument.symmetricDecryptFileHash,
                    asymmetricDecryptFileHash:
                    firstDocument.asymmetricDecryptFileHash,
                    symmetricDecryptFileHashTransactionId:
                    firstDocument.symmetricDecryptFileHashTransactionId,
                    asymmetricDecryptFileHashTransactionId:
                    firstDocument.asymmetricDecryptFileHashTransactionId,
                    isCryptographicKeyShared: true,
                    isFileEncrypted: firstDocument.isFileEncrypted,
                    cryptographicKeyTransactionId: cryptographicKeyTransactionId,
                  );
                  await documentsBox.put(firstDocument.key, updatedDocuments);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'The Final decryption is completed.',
                      snackPosition: SnackPosition.BOTTOM);
                }
              }
            }

          }
        }
        // Navigator.pop(context); // Close the dialog
        // Go back to the previous screen
      } catch (e) {
        //Navigator.pop(context); // Close the dialog
        Get.snackbar('Error', e.toString(),
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  bool compareLists(List<dynamic> listA, List<String> listB) {
    // Convert metaDataD to List<String>
    List<String> metaDataDAsString = listA.map((e) => e.toString()).toList();
    if (metaDataDAsString.length == listB.length) {
      for (int i = 0; i < metaDataDAsString.length; i++) {
        if (metaDataDAsString[i] != listB[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  _readAsymmetricDecryptionConfirmationFromTangle(
      List<String> symmetricEncryptFilesHash) async {
    // Read incoming transactions
    final receivedText = await api.readIncomingTransactions(
      walletInfo: WalletInfo(
        alias: user.userName.toString(),
        mnemonic: '',
        strongholdPassword: '',
        strongholdFilepath: iPactWalletFilePathValue.toString(),
        lastAddress: '',
      ),
    );

    print('receivedText');
    print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);
    List<Transaction> transactions =
        jsonList.map((json) => Transaction.fromJson(json)).toList();

    // Filter and convert the List<Transaction> to List<Map<String, String>>
    List<Map<String, String>> filteredTransactions =
        transactions.fold([], (acc, transaction) {
      try {
        Map<String, dynamic> metadata = jsonDecode(transaction.metadata);
        if (metadata['a'] == 4) {
          var metaDataD = metadata['d'] as List<dynamic>;
          var symmetricEncryptFilesHashToMatch = symmetricEncryptFilesHash;
          print('metaDataD');
          print(metaDataD);
          print('symmetricEncryptFilesHashToMatch');
          print(symmetricEncryptFilesHashToMatch);

          var isMatched =
              compareLists(metaDataD, symmetricEncryptFilesHashToMatch);

          if (isMatched) {
            acc.add({
              'transactionId': transaction.transactionId,
              'collaborationId': metadata['b'].toString(),
              'fileId': metadata['c'].toString(),
              'fileHash': symmetricEncryptFilesHashToMatch.toString(),
            });
          }
        }
      } catch (e) {
        print('Error parsing metadata: $e');
      }
      return acc;
    });

    print('filteredTransactions');
    print(filteredTransactions);

    // Check if any filtered transaction exists
    if (filteredTransactions.isNotEmpty) {
      print('Found transaction: ${filteredTransactions.first}');
      return filteredTransactions.first;
    } else {
      print('Transaction with file hash $symmetricEncryptFilesHash not found.');
      return null;
    }
  }

  Future<void> _receiveAsymmetricDecryptionConfirmation() async {
    // following code only will be executed if the initial decryption of file is done by the receiver

    if (widget.ownDocument == true &&
        widget.documentShareStatus == true &&
        (widget.asymmetricDecryptFileHash == null ||
            widget.asymmetricDecryptFileHash == '')) {
      var symmetricEncryptFilesHash = List<String>.from(
          jsonDecode(widget.symmetricEncryptFileHash.toString()));

      print('symmetricEncryptFilesHash');
      print(symmetricEncryptFilesHash);

      if (symmetricEncryptFilesHash.isNotEmpty) {
        iPactWalletFilePathValue = await iPactWalletFilePath();

        var transactionValue =
            await _readAsymmetricDecryptionConfirmationFromTangle(
                symmetricEncryptFilesHash);

        print("transactionValue");
        print(transactionValue);

        List<Documents> documents = documentsBox.values.toList();
        var filteredDocumentsList = documents
            .where((documents) => documents.fileId == widget.fileId)
            .toList();

        if (filteredDocumentsList.isNotEmpty) {
          print('hereweare');

          var firstDocument = filteredDocumentsList.first;

          var updatedDocuments = Documents(
            collaborationId: firstDocument.collaborationId,
            documentName: firstDocument.documentName,
            documentShareStatus: firstDocument.documentShareStatus,
            filePath: firstDocument.filePath,
            fileId: firstDocument.fileId,
            fileOriginalName: firstDocument.fileOriginalName,
            generateKeyFileForSymmetricCryptography:
                firstDocument.generateKeyFileForSymmetricCryptography,
            symmetricEncryptFile: firstDocument.symmetricEncryptFile,
            asymmetricEncryptFile: firstDocument.asymmetricEncryptFile,
            asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
            symmetricDecryptFile: firstDocument.symmetricDecryptFile,
            originalFileHash: firstDocument.originalFileHash,
            symmetricEncryptFileHash: firstDocument.symmetricEncryptFileHash,
            ownDocument: firstDocument.ownDocument,
            originalFileHashTransactionId:
                firstDocument.originalFileHashTransactionId,
            symmetricEncryptFileHashTransactionId:
                firstDocument.symmetricEncryptFileHashTransactionId,
            symmetricDecryptFileHash: firstDocument.symmetricDecryptFileHash,
            asymmetricDecryptFileHash: transactionValue['fileHash'].toString(),
            symmetricDecryptFileHashTransactionId:
                firstDocument.symmetricDecryptFileHashTransactionId,
            asymmetricDecryptFileHashTransactionId:
                transactionValue['transactionId'].toString(),
            isCryptographicKeyShared: firstDocument.isCryptographicKeyShared,
            isFileEncrypted: firstDocument.isFileEncrypted,
            cryptographicKeyTransactionId:
                firstDocument.cryptographicKeyTransactionId,
          );
          await documentsBox.put(firstDocument.key, updatedDocuments);
        }
      }
    }
  }

  Future<Map<String, String>?> _readFileHashFromTangle(
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
      ),
    );

    print('receivedText');
    print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);
    List<Transaction> transactions =
        jsonList.map((json) => Transaction.fromJson(json)).toList();

    // Filter and convert the List<Transaction> to List<Map<String, String>>
    List<Map<String, String>> filteredTransactions =
        transactions.fold([], (acc, transaction) {
      /*try {
        var metadata = jsonDecode(transaction.metadata);

        // Ensure the metadata is a Map
        if (metadata is Map<String, dynamic>) {
          // Parse 'd' to a list
          List<dynamic> dList = jsonDecode(metadata['d']);

          // Check if 'd' contains the asymmetricDecryptedFileHash
          if (metadata['a'] == 4 && dList.contains(asymmetricDecryptedFileHash)) {
            acc.add({
              'transactionId': transaction.transactionId,
              'collaborationId': metadata['b'].toString(),
              'fileId': metadata['c'].toString(),
              'fileHash': asymmetricDecryptedFileHash,
            });
          }
        }
      }*/

      try {
        Map<String, dynamic> metadata = jsonDecode(transaction.metadata);

        // Filter transactions during the mapping
        if (metadata['a'] == 4 &&
            (metadata['d'] as List<dynamic>)
                .contains(asymmetricDecryptedFileHash) &&
            metadata['d'].contains(asymmetricDecryptedFileHash)) {
          print('metadata d');
          print(metadata['d']);
          acc.add({
            'transactionId': transaction.transactionId,
            'collaborationId': metadata['b'].toString(),
            'fileId': metadata['c'].toString(),
            'fileHash': asymmetricDecryptedFileHash,
          });
        }
      } catch (e) {
        print('Error parsing metadata: $e');
      }
      return acc;
    });

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

  Future<Map<String, String>> _readFileHashFromTangleOld(
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
                .substring(4, transaction.metadata.length - 1)
                .split(', ');
          } else if (transaction.metadata.startsWith('[') &&
              transaction.metadata.endsWith(']')) {
            data = jsonDecode(transaction.metadata).cast<String>();
          }
        }
        print("data--");
        print(data);
      } catch (e) {
        print('Error parsing metadata: $e');
      }

      print("data--");
      print(data);

      return {
        // 'transactionType': data.isNotEmpty ? data[0] : '',
        'transactionId': transaction.transactionId,
        'collaborationId': data.isNotEmpty ? data[0] : '',
        'fileId': data.length > 1 ? data[1] : '',
        'fileHash': data.length > 2 ? data[2] : '',
      };
    }).toList();

    // Debug print the resulting list of maps
    for (var _transaction_test in transactionList) {
      print("transaction0");
      print(_transaction_test);
    }

    // return transactionList;

    print(asymmetricDecryptedFileHash);
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
    print(foundTransaction);
    return foundTransaction;
  }

  @override
  void dispose() {
    hideKeyboard();
    super.dispose();
  }

  void _getIpactWalletFilePath() async {
    iPactWalletFilePathValue = await iPactWalletFilePath();
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

  /*Future<void> handleEncryptionProcess() async {
    if (_controller.strongholdPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Password field can not be empty');
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
        String collaborationPartnerAddress;
        if (user.userPublicAddress == collaborations.senderIOTAAddress) {
          collaborationPartnerAddress =
              collaborations.receiverIOTAAddress.toString();
        } else {
          collaborationPartnerAddress =
              collaborations.senderIOTAAddress.toString();
        }

        final keyFilePath = await _controllerEncryptionControllerFinal
            .generateKeyFileForSymmetricCryptography(
          collaborationId: widget.collaborationId.toString(),
          fileId: widget.fileId.toString(),
        );

        final symmetricEncryptedFilePath =
        await _controllerEncryptionControllerFinal.symmetricEncryptFile(
          collaborationId: widget.collaborationId.toString(),
          fileId: widget.fileId.toString(),
          fileToEncryptPath: widget.filePath.toString(),
        );

        final appSupportDir = await getApplicationSupportDirectory();

        final asymmetricEncryptedFilePath =
        await _controllerEncryptionControllerFinal.asymmetricEncryptFile(
          collaborationId: widget.collaborationId.toString(),
          fileId: widget.fileId.toString(),
          publicKeyPemFilePath:
          '${appSupportDir.path}/cryptographic_documents/received_cryptographic_keys/${widget.collaborationId}/$collaborationPartnerAddress/public_key.pem',
        );

        var originalFileHash =
        await objectInstance.createHashFromFile(widget.filePath.toString());
        print('originalFileHash');
        print(originalFileHash);
        var symmetricEncryptFileHash = await objectInstance
            .createHashFromFile(symmetricEncryptedFilePath.toString());
        print('symmetricEncryptFileHash');
        print(symmetricEncryptFileHash);

        var transactionParamsForOriginalFileHash = TransactionParams(
            transactionTag: "",
            transactionMetadata:
            "{2, ${widget.collaborationId.toString()}, ${widget.fileId.toString()}, $originalFileHash}",
            receiverAddress: '$collaborationPartnerAddress',
            storageDepositReturnAddress: '$collaborationPartnerAddress');

        var transactionParamsSymmetricEncryptedFileHash = TransactionParams(
            transactionTag: "",
            transactionMetadata:
            "{3, ${widget.collaborationId.toString()}, ${widget.fileId.toString()}, $symmetricEncryptFileHash}",
            receiverAddress: '$collaborationPartnerAddress',
            storageDepositReturnAddress: '$collaborationPartnerAddress');

        var originalFileHashTransactionId =
        await writeFileHashToTangle(transactionParamsForOriginalFileHash);
        var symmetricEncryptFileHashTransactionId = await writeFileHashToTangle(
            transactionParamsSymmetricEncryptedFileHash);

        final documentKey = widget.fileId.toString().trim();
        final existingDocument = documentsBox.get(documentKey);

        List<Documents> documents = documentsBox.values.toList();

        var filteredDocumentsList = documents
            .where((documents) => documents.fileId == widget.fileId)
            .toList();

        if (filteredDocumentsList.isNotEmpty) {
          var firstDocument = filteredDocumentsList.first;

          var updatedDocuments = Documents(
            collaborationId: firstDocument.collaborationId,
            documentName: firstDocument.documentName,
            documentShareStatus: firstDocument.documentShareStatus,
            filePath: firstDocument.filePath,
            fileId: firstDocument.fileId,
            fileOriginalName: firstDocument.fileOriginalName,
            generateKeyFileForSymmetricCryptography: keyFilePath,
            symmetricEncryptFile: symmetricEncryptedFilePath,
            asymmetricEncryptFile: asymmetricEncryptedFilePath,
            asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
            symmetricDecryptFile: firstDocument.symmetricDecryptFile,
            originalFileHash: originalFileHash.toString(),
            symmetricEncryptFileHash: symmetricEncryptFileHash.toString(),
            ownDocument: firstDocument.ownDocument,
            originalFileHashTransactionId:
            originalFileHashTransactionId.toString(),
            symmetricEncryptFileHashTransactionId:
            symmetricEncryptFileHashTransactionId.toString(),
            symmetricDecryptFileHash: firstDocument.symmetricDecryptFileHash,
            asymmetricDecryptFileHash: firstDocument.asymmetricDecryptFileHash,
            symmetricDecryptFileHashTransactionId:
            firstDocument.symmetricDecryptFileHashTransactionId,
            asymmetricDecryptFileHashTransactionId:
            firstDocument.asymmetricDecryptFileHashTransactionId,
            isCryptographicKeyShared: firstDocument.isCryptographicKeyShared,
            cryptographicKeyTransactionId:
            firstDocument.cryptographicKeyTransactionId,
          );

          await documentsBox.put(firstDocument.key, updatedDocuments);

          Get.snackbar('Success', 'Files encrypted and saved successfully!',
              snackPosition: SnackPosition.BOTTOM);

          setState(() {
            isFileEncrypted = true;
          });

          Navigator.pop(context);
          Navigator.pop(context);
        }
        Get.back();
      } catch (e) {
        print(e.toString());
        Get.snackbar('Error', e.toString());
        Get.back();
      }
    }
  }*/

  Future<void> handleEncryptionProcess() async {
    if (_controller.strongholdPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Password field cannot be empty');
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
        String collaborationPartnerAddress;

        print('user.userPublicAddress');
        print(user.userPublicAddress);
        if (user.userPublicAddress == collaborations.senderIOTAAddress) {
          collaborationPartnerAddress =
              collaborations.receiverIOTAAddress.toString();
          print('here01');
          print('collaborationPartnerAddress: $collaborationPartnerAddress');
        } else {
          collaborationPartnerAddress =
              collaborations.senderIOTAAddress.toString();
          print('here02');
          print('collaborationPartnerAddress: $collaborationPartnerAddress');
        }

        List<String> filePaths =
            List<String>.from(json.decode(widget.filePath!));
        List<String> symmetricEncryptedFilePaths = [];
        List<String> asymmetricEncryptedFilePaths = [];
        List<String> originalFileHashes = [];
        List<String> symmetricEncryptFileHashes = [];

        final keyFilePath = await _controllerEncryptionControllerFinal
            .generateKeyFileForSymmetricCryptography(
          collaborationId: widget.collaborationId.toString(),
          fileId: widget.fileId.toString(),
        );

        final appSupportDir = await getApplicationSupportDirectory();

        var fileCount = 1;
        for (String filePath in filePaths) {
          final symmetricEncryptedFilePath =
              await _controllerEncryptionControllerFinal.symmetricEncryptFile(
                  collaborationId: widget.collaborationId.toString(),
                  fileId: widget.fileId.toString(),
                  fileToEncryptPath: filePath,
                  fileCount: fileCount);
          symmetricEncryptedFilePaths.add(symmetricEncryptedFilePath);

          final asymmetricEncryptedFilePath =
              await _controllerEncryptionControllerFinal.asymmetricEncryptFile(
                  collaborationId: widget.collaborationId.toString(),
                  fileId: widget.fileId.toString(),
                  publicKeyPemFilePath:
                      '${appSupportDir.path}/cryptographic_documents/received_cryptographic_keys/${widget.collaborationId}/$collaborationPartnerAddress/public_key.pem',
                  fileCount: fileCount);
          asymmetricEncryptedFilePaths.add(asymmetricEncryptedFilePath);

          var originalFileHash =
              await objectInstance.createHashFromFile(filePath);
          print('originalFileHash');
          print(originalFileHash);

          originalFileHashes.add(originalFileHash.toString());

          var symmetricEncryptFileHash = await objectInstance
              .createHashFromFile(symmetricEncryptedFilePath);
          print('symmetricEncryptFileHash');
          print(symmetricEncryptFileHash);

          symmetricEncryptFileHashes.add(symmetricEncryptFileHash.toString());

          fileCount = fileCount + 1;
          print('fileCount');
          print(fileCount);
        }

        print('originalFileHashes');
        print(originalFileHashes);
        var transactionMetadataForOriginalFileHashes = {
          "a": 2,
          "b": widget.collaborationId.toString(),
          "c": widget.fileId.toString(),
          "d": originalFileHashes
        };

        var transactionParamsForOriginalFileHashes = TransactionParams(
            transactionTag: "",
            transactionMetadata:
                jsonEncode(transactionMetadataForOriginalFileHashes),
            //transactionMetadata: transactionMetadataForOriginalFileHashes,
            receiverAddress: '$collaborationPartnerAddress',
            storageDepositReturnAddress: '$collaborationPartnerAddress');

        var originalFileHashTransactionId =
            await writeFileHashToTangle(transactionParamsForOriginalFileHashes);

        print('originalFileHashTransactionId');
        print(originalFileHashTransactionId);

        print('symmetricEncryptFileHashes');
        print(symmetricEncryptFileHashes);
        var transactionMetadataForSymmetricEncryptedFileHashes = {
          "a": 3,
          "b": widget.collaborationId.toString(),
          "c": widget.fileId.toString(),
          "d": symmetricEncryptFileHashes
        };

        var transactionParamsSymmetricEncryptedFileHashes = TransactionParams(
            transactionTag: "",
            transactionMetadata:
                jsonEncode(transactionMetadataForSymmetricEncryptedFileHashes),
            receiverAddress: '$collaborationPartnerAddress',
            storageDepositReturnAddress: '$collaborationPartnerAddress');

        var symmetricEncryptFileHashTransactionId = await writeFileHashToTangle(
            transactionParamsSymmetricEncryptedFileHashes);

        print('symmetricEncryptFileHashTransactionId');
        print(symmetricEncryptFileHashTransactionId);

        //originalFileHashTransactionIds.add(originalFileHashTransactionId);
        //symmetricEncryptFileHashTransactionIds.add(symmetricEncryptFileHashTransactionId);

        final documentKey = widget.fileId.toString().trim();
        final existingDocument = documentsBox.get(documentKey);

        List<Documents> documents = documentsBox.values.toList();

        var filteredDocumentsList = documents
            .where((documents) => documents.fileId == widget.fileId)
            .toList();

        if (filteredDocumentsList.isNotEmpty) {
          var firstDocument = filteredDocumentsList.first;

          var updatedDocuments = Documents(
            collaborationId: firstDocument.collaborationId,
            documentName: firstDocument.documentName,
            documentShareStatus: firstDocument.documentShareStatus,
            filePath: firstDocument.filePath,
            fileId: firstDocument.fileId,
            fileOriginalName: firstDocument.fileOriginalName,
            generateKeyFileForSymmetricCryptography:
                firstDocument.generateKeyFileForSymmetricCryptography,
            symmetricEncryptFile: json.encode(symmetricEncryptedFilePaths),
            asymmetricEncryptFile: json.encode(asymmetricEncryptedFilePaths),
            asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
            symmetricDecryptFile: firstDocument.symmetricDecryptFile,
            originalFileHash: json.encode(originalFileHashes),
            symmetricEncryptFileHash: json.encode(symmetricEncryptFileHashes),
            ownDocument: firstDocument.ownDocument,
            originalFileHashTransactionId: originalFileHashTransactionId,
            symmetricEncryptFileHashTransactionId:
                symmetricEncryptFileHashTransactionId,
            symmetricDecryptFileHash: firstDocument.symmetricDecryptFileHash,
            asymmetricDecryptFileHash: firstDocument.asymmetricDecryptFileHash,
            symmetricDecryptFileHashTransactionId:
                firstDocument.symmetricDecryptFileHashTransactionId,
            asymmetricDecryptFileHashTransactionId:
                firstDocument.asymmetricDecryptFileHashTransactionId,
            isCryptographicKeyShared: firstDocument.isCryptographicKeyShared,
            isFileEncrypted: true,
            cryptographicKeyTransactionId:
                firstDocument.cryptographicKeyTransactionId,
          );

          await documentsBox.put(firstDocument.key, updatedDocuments);

          Get.snackbar('Success', 'Files encrypted and saved successfully!',
              snackPosition: SnackPosition.BOTTOM);

          Navigator.pop(context);
          Navigator.pop(context);
        }
        Get.back();
      } catch (e) {
        print(e.toString());
        Get.snackbar('Error', e.toString());
        Get.back();
      }
    }
  }

  Future<void> handleShareCryptographicKeyProcess() async {
    if (_controller.strongholdPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Password field can not be empty');
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
        String collaborationPartnerAddress;
        if (user.userPublicAddress == collaborations.senderIOTAAddress) {
          collaborationPartnerAddress =
              collaborations.receiverIOTAAddress.toString();
        } else {
          collaborationPartnerAddress =
              collaborations.senderIOTAAddress.toString();
        }

        var symmetricKey = await _encryptionControllerFinal.readSymmetricKey(
            collaborationId: widget.collaborationId.toString(),
            fileId: widget.fileId.toString());

        var metadata = {
          "a": 5,
          "b": widget.collaborationId.toString(),
          "c": widget.fileId.toString(),
          "d": symmetricKey
        };

        var transactionParamsCryptographicKey = TransactionParams(
            transactionTag: "",
            transactionMetadata: jsonEncode(metadata),
            receiverAddress: '$collaborationPartnerAddress',
            storageDepositReturnAddress: '$collaborationPartnerAddress');

        var cryptographicKeyTransactionId =
            await writeFileHashToTangle(transactionParamsCryptographicKey);

        final documentKey = widget.fileId.toString().trim();
        final existingDocument = documentsBox.get(documentKey);

        List<Documents> documents = documentsBox.values.toList();

        var filteredDocumentsList = documents
            .where((documents) => documents.fileId == widget.fileId)
            .toList();

        if (filteredDocumentsList.isNotEmpty) {
          var firstDocument = filteredDocumentsList.first;

          var updatedDocuments = Documents(
            collaborationId: firstDocument.collaborationId,
            documentName: firstDocument.documentName,
            documentShareStatus: firstDocument.documentShareStatus,
            filePath: firstDocument.filePath,
            fileId: firstDocument.fileId,
            fileOriginalName: firstDocument.fileOriginalName,
            generateKeyFileForSymmetricCryptography:
                firstDocument.generateKeyFileForSymmetricCryptography,
            symmetricEncryptFile: firstDocument.documentShareStatus.toString(),
            asymmetricEncryptFile: firstDocument.asymmetricEncryptFile,
            asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
            symmetricDecryptFile: firstDocument.symmetricDecryptFile,
            originalFileHash: firstDocument.originalFileHash,
            symmetricEncryptFileHash: firstDocument.symmetricEncryptFileHash,
            ownDocument: firstDocument.ownDocument,
            originalFileHashTransactionId:
                firstDocument.originalFileHashTransactionId,
            symmetricEncryptFileHashTransactionId:
                firstDocument.symmetricEncryptFileHashTransactionId,
            symmetricDecryptFileHash: firstDocument.symmetricDecryptFileHash,
            asymmetricDecryptFileHash: firstDocument.asymmetricDecryptFileHash,
            symmetricDecryptFileHashTransactionId:
                firstDocument.symmetricDecryptFileHashTransactionId,
            asymmetricDecryptFileHashTransactionId:
                firstDocument.asymmetricDecryptFileHashTransactionId,
            isCryptographicKeyShared: true,
            isFileEncrypted: firstDocument.isFileEncrypted,
            cryptographicKeyTransactionId:
                cryptographicKeyTransactionId.toString(),
          );

          await documentsBox.put(firstDocument.key, updatedDocuments);

          Get.snackbar('Success', 'Files encrypted and saved successfully!',
              snackPosition: SnackPosition.BOTTOM);

          Navigator.pop(context);
          Navigator.pop(context);
          hideKeyboard();
        }
      } catch (e) {
        print(e.toString());
        Get.snackbar('Error', e.toString());
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarWithBack(
          title: widget.documentName.toString(), context: context),
      body: SafeArea(
        child: Column(
          children: [
            getTabView(
              titles: [
                widget.ownDocument == true
                    ? (widget.documentShareStatus == true
                        ? "Share Key"
                        : "Encrypt & Share".tr)
                    : "Decrypt File Stack".tr,
                "File Stack Details".tr
              ],
              controller: _controller.tabController,
              onTap: (selected) {
                _controller.tabSelectedIndex.value = selected;
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _controller.tabController,
                children: [
                  widget.ownDocument == true
                      ? (widget.documentShareStatus == true
                          ? _shareCryptographicKeyTab()
                          : _encryptAndShareTab())
                      : _decryptFileFinalTab(),
                  _documentDetailsTab()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encryptAndShareTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildFileViews(widget.filePath, 'Original'),
            widget.isFileEncrypted == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      vSpacer10(),
                      TextAutoMetropolis(
                        "Stronghold Password".tr,
                        fontSize: Dimens.fontSizeRegular,
                        textAlign: TextAlign.start,
                      ),
                      vSpacer5(),
                      Obx(
                        () => TextFieldView(
                          controller: _controller.strongholdPasswordController,
                          hint: "Enter your Stronghold Password".tr,
                          isObscure: !_controller.isShowPassword.value,
                          inputType: TextInputType.visiblePassword,
                          validator: TextFieldValidator.emptyValidator,
                          suffix: ShowHideIconView(
                              isShow: _controller.isShowPassword.value,
                              onTap: () => _controller.isShowPassword.value =
                                  !_controller.isShowPassword.value),
                        ),
                      ),
                      vSpacer20(),
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
                            child: SizedBox(
                              width: Get.width / 1.3,
                              child: const TextAutoPoppins(
                                'I agree to encrypt the document and share the document hash with my collaboration partner via the IOTA Tangle.',
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      vSpacer20(),
                    ],
                  )
                : const SizedBox(),
            _isChecked == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.isFileEncrypted == true
                          ? const Expanded(
                              child: TextAutoMetropolis(
                                'File is encrypted. Now you can share the encrypted file.',
                                maxLines: 5,
                                fontSize: 16,
                              ),
                            )
                          : Obx(() => SizedBox(
                                width: Get.width / 2.1,
                                child: ButtonFillMainWhiteBg(
                                  title: "Encrypt for Sending".tr,
                                  isLoading: _controller.isLoading.value,
                                  onPress: handleEncryptionProcess,
                                ),
                              )),
                    ],
                  )
                : const SizedBox(),
            ValueListenableBuilder(
              valueListenable: documentsBox.listenable(),
              builder: (context, Box<Documents> box, _) {
                List<Documents> documents = box.values.toList();
                var filteredDocumentsList = documents
                    .where((documents) => documents.fileId == widget.fileId)
                    .toList();

                if (filteredDocumentsList.isNotEmpty) {
                  var firstDocument = filteredDocumentsList.first;
                  return firstDocument.isFileEncrypted == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vSpacer20(),
                            ..._buildFileViews(widget.symmetricEncryptFile,
                                'Symmetric Encrypt'),
                            vSpacer20(),
                            ..._buildFileViews(widget.asymmetricEncryptFile,
                                'Asymmetric Encrypt'),
                            vSpacer30(),
                            const Center(
                              child: TextAutoMetropolis(
                                'You successfully done the encryption.\n The hash of original file and symmetric encrypt file are stored in IOTA. \n Now the asymmetric encrypted files are  ready to share with your collaboration partner',
                                maxLines: 5,
                                fontSize: 16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            vSpacer30(),
                            Center(
                              child: SizedBox(
                                width: Get.width / 2.5,
                                child: Obx(() => ButtonFillMain(
                                      title: "Share File".tr,
                                      isLoading: _controller.isLoading.value,
                                      onPress: () async {
                                        //await shareFile(
                                        await shareFilesAsZip(
                                            context,
                                            firstDocument.asymmetricEncryptFile
                                                .toString(),
                                            widget.collaborationId.toString(),
                                            widget.fileId.toString());
                                      },
                                    )),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox();
                } else {
                  return const Center(child: Text('No document found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFileViews(String? filePaths, String? label) {
    debugPrint('filePaths');

    debugPrint(filePaths);

    if (filePaths == null || filePaths.isEmpty) {
      return [const SizedBox()];
    }

    // Parse the JSON string
    List<String> fileList;

    try {
      fileList = List<String>.from(json.decode(filePaths));
      print('fileList');
      print(fileList);
    } catch (e) {
      print("Error parsing JSON string: $e");
      return [const SizedBox()];
    }

    return List<Widget>.generate(fileList.length, (index) {
      String filePath = fileList[index];
      return DocumentsItemDetailsView(
        context: context,
        fileTitle: "$label File ${index + 1}", // Include the file count here
        documentRealName: filePath.trim().split('/').last,
        //assetName: AssetConstants.icLocked,
        onTap: () {
          OpenFile.open(filePath.trim());
        },
        onTapDownload: () {
          OpenFile.open(filePath.trim());
        },
      );
    });
  }

  Widget _shareCryptographicKeyTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildFileViews(widget.filePath, 'Original'),
            vSpacer20(),
            ValueListenableBuilder(
              valueListenable: documentsBox.listenable(),
              builder: (context, Box<Documents> box, _) {
                List<Documents> documents = box.values.toList();
                var filteredDocumentsList = documents
                    .where((documents) => documents.fileId == widget.fileId)
                    .toList();

                if (filteredDocumentsList.isNotEmpty) {
                  var firstDocument = filteredDocumentsList.first;

                  return firstDocument.isFileEncrypted == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vSpacer20(),
                            ..._buildFileViews(widget.symmetricEncryptFile,
                                'Symmetric Encrypt'),
                            vSpacer20(),
                            ..._buildFileViews(widget.asymmetricEncryptFile,
                                'Asymmetric Encrypt'),
                          ],
                        )
                      : const SizedBox();
                } else {
                  return const Center(child: Text('No document found'));
                }
              },
            ),
            (widget.asymmetricDecryptFileHash == null ||
                    widget.asymmetricDecryptFileHash == '')
                ? Column(children: [
                    vSpacer30(),
                    const Center(
                        child: TextAutoMetropolis(
                      'You have successfully encrypted and share the file with your collaboration partner. Please wait until your collaboration partner perform the initial decryption.',
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                    )),
                    vSpacer5(),
                  ])
                : widget.isCryptographicKeyShared != true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          vSpacer30(),
                          const Center(
                              child: TextAutoMetropolis(
                            'Your collaboration partner successfully performed the initial decryption. Share the Cryptographic key to your collaboration partner to perform the final decryption to obtain the original document',
                            maxLines: 10,
                            fontSize: 16,
                            textAlign: TextAlign.center,
                          )),
                          vSpacer5(),
                          vSpacer30(),
                          TextAutoMetropolis("Stronghold Password".tr,
                              fontSize: Dimens.fontSizeRegular),
                          vSpacer5(),
                          Obx(
                            () => TextFieldView(
                              controller:
                                  _controller.strongholdPasswordController,
                              hint: "Enter your Stronghold Password".tr,
                              isObscure: !_controller.isShowPassword.value,
                              inputType: TextInputType.visiblePassword,
                              validator: TextFieldValidator.emptyValidator,
                              suffix: ShowHideIconView(
                                  isShow: _controller.isShowPassword.value,
                                  onTap: () =>
                                      _controller.isShowPassword.value =
                                          !_controller.isShowPassword.value),
                            ),
                          ),
                          vSpacer20(),
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
                                child: SizedBox(
                                  width: Get.width / 1.3,
                                  child: const TextAutoPoppins(
                                    'I agree to share cryptographic key with my collaboration partner via the IOTA Tangle.',
                                    maxLines: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          vSpacer20(),
                        ],
                      )
                    : Column(
                        children: [
                          vSpacer30(),
                          const Center(
                              child: TextAutoMetropolis(
                            'You have successfully shared the Cryptographic Secret to your collaboration partner which can be used to perform the final decryption to obtain the original document',
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            maxLines: 10,
                          )),
                          vSpacer5(),
                        ],
                      ),
            _isChecked == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.isCryptographicKeyShared == true
                          ? const Expanded(
                              child: TextAutoMetropolis(
                                'The Cryptographic Key is Shared to the collaboration partner through IOTA',
                                maxLines: 5,
                                fontSize: 16,
                              ),
                            )
                          : Obx(() => SizedBox(
                                width: Get.width / 1.8,
                                child: ButtonFillMainWhiteBg(
                                  title: "Share Cryptographic Key".tr,
                                  isLoading: _controller.isLoading.value,
                                  onPress: handleShareCryptographicKeyProcess,
                                ),
                              )),
                    ],
                  )
                : const SizedBox(),
            vSpacer30(),
          ],
        ),
      ),
    );
  }

  List<String> convertStringToList(String input) {
    return input
        .substring(1, input.length - 1)
        .split(', ')
        .map((s) => s.trim())
        .toList();
  }

  Widget _decryptFileFinalTab() {
    // Ensure that asymmetricDecryptFile and symmetricDecryptFile are lists
    List<String> asymmetricDecryptFiles =
        widget.asymmetricDecryptFile != null &&
                widget.asymmetricDecryptFile is String
            ? convertStringToList(widget.asymmetricDecryptFile.toString())
            : widget.asymmetricDecryptFile as List<String>? ?? [];

    List<String> symmetricDecryptFiles = widget.symmetricDecryptFile != null &&
            widget.symmetricDecryptFile is String
        ? convertStringToList(widget.symmetricDecryptFile.toString())
        : widget.symmetricDecryptFile as List<String>? ?? [];

    List<String> filePaths =
        widget.filePath != null && widget.filePath is String
            ? convertStringToList(widget.filePath.toString())
            : widget.filePath as List<String>? ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (asymmetricDecryptFiles.isNotEmpty) ...[
              Text(
                  'Asymmetric Decrypt Files (${asymmetricDecryptFiles.length})'),
              ...asymmetricDecryptFiles.asMap().entries.map((entry) {
                int index = entry.key;
                String file = entry.value;
                return DocumentsLockedItemDetailsView(
                  context: context,
                  fileTitle: "Asymmetric Decrypt File ${index + 1}",
                  documentRealName: file.trim().split('/').last,
                  assetName: AssetConstants.icLocked,
                  onTap: () {
                    OpenFile.open(file);
                  },
                );
              }).toList(),
              vSpacer30(),
            ],
            if (symmetricDecryptFiles.isNotEmpty) ...[
              Text('Symmetric Decrypt Files (${symmetricDecryptFiles.length})'),
              Column(
                children: [
                  ...symmetricDecryptFiles.asMap().entries.map((entry) {
                    int index = entry.key;
                    String file = entry.value;
                    return DocumentsItemDetailsView(
                      context: context,
                      fileTitle:
                          "Symmetric Decrypt File/ Original File ${index + 1}",
                      documentRealName: file.trim().split('/').last,
                      onTap: () {
                        OpenFile.open(file);
                      },
                      onTapDownload: () {
                        OpenFile.open(file);
                      },
                    );
                  }).toList(),
                  vSpacer30(),
                  Center(
                    child: SizedBox(
                      width: Get.width / 1.3,
                      child: const TextAutoMetropolis(
                        'You have successfully completed the final decryption of received file.',
                        maxLines: 10,
                        fontSize: 16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (asymmetricDecryptFiles.isNotEmpty)
              Center(
                child: SizedBox(
                  width: Get.width / 1.3,
                  child: const TextAutoMetropolis(
                    'You have successfully completed the initial decryption of received file.\nPlease wait until your collaboration partner allows you to perform the final decryption.',
                    maxLines: 10,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _decryptFileFinalTabOld() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentsLockedItemDetailsView(
              context: context,
              fileTitle: "Asymmetric Decrypt File",
              documentRealName:
                  widget.asymmetricDecryptFile!.trim().split('/').last,
              assetName: AssetConstants.icLocked,
              onTap: () {
                OpenFile.open(widget.filePath.toString());
                OpenFile.open(widget.asymmetricDecryptFile.toString());
              },
            ),
            vSpacer30(),
            (widget.symmetricDecryptFile != null)
                ? Column(
                    children: [
                      DocumentsItemDetailsView(
                        context: context,
                        fileTitle: "Symmetric Decrypt File/ Original File",
                        documentRealName:
                            widget.symmetricDecryptFile!.trim().split('/').last,
                        onTap: () {
                          OpenFile.open(widget.symmetricDecryptFile.toString());
                        },
                        onTapDownload: () {
                          OpenFile.open(widget.symmetricDecryptFile.toString());
                        },
                      ),
                      vSpacer30(),
                      Center(
                        child: SizedBox(
                          width: Get.width / 1.3,
                          child: const TextAutoMetropolis(
                            'You have successfully completed the final decryption of received file.',
                            maxLines: 10,
                            fontSize: 16,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: SizedBox(
                      width: Get.width / 1.3,
                      child: const TextAutoMetropolis(
                        'You have successfully completed the initial decryption of received file.\nPlease wait until your collaboration partner allow to perform the final decryption.',
                        maxLines: 10,
                        fontSize: 16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _documentDetailsTab() {
    return RefreshIndicator(
      onRefresh: _controller.getData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            vSpacer20(),
            SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                radius: 0,
                backgroundColor: context.theme.dividerColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset(
                    AssetConstants.icDocument,
                    color: context.theme.primaryColorDark,
                  ),
                ),
              ),
            ),
            Center(
              child: DocumentCard(
                collaborationId: widget.collaborationId?.toString() ?? '',
                documentName: widget.documentName?.toString() ?? '',
                documentShareStatus: widget.documentShareStatus?.toString() ?? '',
                filePath: widget.filePath?.toString() ?? '',
                fileId: widget.fileId?.toString() ?? '',
                fileOriginalName: widget.fileOriginalName?.toString() ?? '',
                generateKeyFileForSymmetricCryptography:
                widget.generateKeyFileForSymmetricCryptography?.toString() ?? '',
                symmetricEncryptFile: widget.symmetricEncryptFile?.toString() ?? '',
                asymmetricEncryptFile: widget.asymmetricEncryptFile?.toString() ?? '',
                asymmetricDecryptFile: widget.asymmetricDecryptFile?.toString() ?? '',
                symmetricDecryptFile: widget.symmetricDecryptFile?.toString() ?? '',
                originalFileHash: widget.originalFileHash?.toString() ?? '',
                symmetricEncryptFileHash: widget.symmetricEncryptFileHash?.toString() ?? '',
                ownDocument: widget.ownDocument?.toString() ?? '',
                originalFileHashTransactionId: widget.originalFileHashTransactionId?.toString() ?? '',
                symmetricEncryptFileHashTransactionId: widget.symmetricEncryptFileHashTransactionId?.toString() ?? '',
                asymmetricDecryptFileHash: widget.asymmetricDecryptFileHash?.toString() ?? '',
                asymmetricDecryptFileHashTransactionId: widget.asymmetricDecryptFileHashTransactionId?.toString() ?? '',
                isCryptographicKeyShared: widget.isCryptographicKeyShared?.toString() ?? '',
                isFileEncrypted: widget.isFileEncrypted?.toString() ?? '',
                cryptographicKeyTransactionId: widget.cryptographicKeyTransactionId?.toString() ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> shareFile(BuildContext context, String filePath) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Encrypted Document',
      text:
          'Import this encrypted document in iPact Application Receive document section to decrypt',
    );

    Get.snackbar('Success', 'File shared successfully!',
        snackPosition: SnackPosition.BOTTOM);
    //updateDocumentShareStatus();
  }

  Future<void> shareFiles(BuildContext context, String filePaths) async {
    debugPrint('filePaths');
    debugPrint(filePaths);
    List<dynamic> dynamicList = jsonDecode(filePaths);
    // Convert the List<dynamic> to List<String>
    var filePathList = List<String>.from(dynamicList);

    print('SHARE FILES');
    print(filePathList);

    List<XFile> xFiles =
        filePathList.map((filePath) => XFile(filePath)).toList();

    await Share.shareXFiles(
      xFiles,
      subject: 'Encrypted Documents',
      text:
          'Import these encrypted documents in iPact Application Receive document section to decrypt',
    );

    Get.snackbar('Success', 'Files shared successfully!',
        snackPosition: SnackPosition.BOTTOM);

    //updateDocumentShareStatus();
  }

  zipFilesInMemory(List<String> filePaths) {
    // Create the encoder
    final archive = Archive();

    // Add the files to the archive
    for (var filePath in filePaths) {
      final file = File(filePath);
      final fileBytes = file.readAsBytesSync();
      final fileName = file.path.split('/').last;
      archive.addFile(ArchiveFile(fileName, fileBytes.length, fileBytes));
    }

    // Encode the archive to a Zip file in memory
    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(archive)!;
    return Uint8List.fromList(zipData);
  }

  Future<String> createZipFile(
      List<String> filePaths, String zipFileName) async {
    final archive = Archive();

    for (var filePath in filePaths) {
      final file = File(filePath);
      final fileBytes = file.readAsBytesSync();
      final fileName = file.path.split('/').last;
      archive.addFile(ArchiveFile(fileName, fileBytes.length, fileBytes));
    }

    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(archive)!;

    final tempDir = await getTemporaryDirectory();
    final zipFilePath = '${tempDir.path}/$zipFileName';

    final zipFile = File(zipFilePath);
    await zipFile.writeAsBytes(zipData);

    return zipFilePath;
  }

  Future<void> shareFilesAsZip(BuildContext context, String filePaths,
      String collaborationId, String fileId) async {
    debugPrint('filePaths');
    debugPrint(filePaths);
    List<dynamic> dynamicList = jsonDecode(filePaths);
    var filePathList = List<String>.from(dynamicList);

    print('SHARE FILES');
    print(filePathList);

    String zipFileName = '${collaborationId}_$fileId.zip';
    String zipFilePath = await createZipFile(filePathList, zipFileName);

    final zipXFile =
        XFile(zipFilePath, mimeType: 'application/zip', name: zipFileName);

    print('zipXFile');
    print(zipXFile.name);

    await Share.shareXFiles(
      [zipXFile],
      subject: 'Encrypted Documents',
      text:
          'Import these encrypted documents in iPact Application Receive document section to decrypt',
    );
    Get.snackbar('Success', 'Files shared successfully!',
        snackPosition: SnackPosition.BOTTOM);
    updateDocumentShareStatus();
  }

/*
  Future<void> shareFilesAsZip(BuildContext context, String filePaths, String collaborationId, String fileId) async {
    debugPrint('filePaths');
    debugPrint(filePaths);
    List<dynamic> dynamicList = jsonDecode(filePaths);
    var filePathList = List<String>.from(dynamicList);

    print('SHARE FILES');
    print(filePathList);

    Uint8List zipData = zipFilesInMemory(filePathList);

    final zipXFile = XFile.fromData(
      zipData,
      mimeType: 'application/zip',
      //name: '${collaborationId}_$fileId.zip',
      name: 'final.zip',
    );

    print('zipXFile');
    print(zipXFile.name);

    await Share.shareXFiles(
      [zipXFile],
      subject: 'Encrypted Documents',
      text: 'Import these encrypted documents in iPact Application Receive document section to decrypt',
    );

    Get.snackbar('Success', 'Files shared successfully!',
        snackPosition: SnackPosition.BOTTOM);
  }
*/

  void updateDocumentShareStatus() async {
    try {
      List<Documents> documents = documentsBox.values.toList();

      var filteredDocumentsList = documents
          .where((documents) => documents.fileId == widget.fileId)
          .toList();

      if (filteredDocumentsList.isNotEmpty) {
        var firstDocument = filteredDocumentsList.first;

        var updatedDocuments = Documents(
          collaborationId: firstDocument.collaborationId,
          documentName: firstDocument.documentName,
          documentShareStatus: true,
          filePath: firstDocument.filePath,
          fileId: firstDocument.fileId,
          fileOriginalName: firstDocument.fileOriginalName,
          generateKeyFileForSymmetricCryptography:
              firstDocument.generateKeyFileForSymmetricCryptography,
          symmetricEncryptFile: firstDocument.symmetricEncryptFile,
          asymmetricEncryptFile: firstDocument.asymmetricEncryptFile,
          asymmetricDecryptFile: firstDocument.asymmetricDecryptFile,
          symmetricDecryptFile: firstDocument.symmetricDecryptFile,
          originalFileHash: firstDocument.originalFileHash.toString(),
          symmetricEncryptFileHash: firstDocument.symmetricEncryptFileHash,
          ownDocument: firstDocument.ownDocument,
          originalFileHashTransactionId:
              firstDocument.originalFileHashTransactionId,
          symmetricEncryptFileHashTransactionId:
              firstDocument.symmetricEncryptFileHashTransactionId,
          symmetricDecryptFileHash: firstDocument.symmetricDecryptFileHash,
          asymmetricDecryptFileHash: firstDocument.asymmetricDecryptFileHash,
          symmetricDecryptFileHashTransactionId:
              firstDocument.symmetricDecryptFileHashTransactionId,
          asymmetricDecryptFileHashTransactionId:
              firstDocument.asymmetricDecryptFileHashTransactionId,
          isCryptographicKeyShared: firstDocument.isCryptographicKeyShared,
          isFileEncrypted: firstDocument.isFileEncrypted,
          cryptographicKeyTransactionId:
              firstDocument.cryptographicKeyTransactionId,
        );

        await documentsBox.put(firstDocument.key, updatedDocuments);

        Navigator.pop(context);
        hideKeyboard();
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString());
      Navigator.pop(context);
    }
  }
}
