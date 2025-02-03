import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/transaction.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_utils.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'immutability_check_controller.dart';

class ImmutabilityCheckScreen extends StatefulWidget {
  const ImmutabilityCheckScreen({super.key});

  @override
  ImmutabilityCheckScreenState createState() => ImmutabilityCheckScreenState();
}

class ImmutabilityCheckScreenState extends State<ImmutabilityCheckScreen> {
  final _controller = Get.put(ImmutabilityCheckController());

  File? selectedFile;
  String? fileNameSplit;
  bool? immutabilityStatus;

  late Box<User> userBox;
  late User user;

  late String iPactWalletFilePathValue;

  late Box<Collaborations> collaborationBox;
  late Collaborations collaborations;



  @override
  void initState() {
    super.initState();

    userBox = Hive.box<User>('users');
    if (userBox.isNotEmpty) {
      user = userBox.values.first;
    }

    collaborationBox = Hive.box('collaborations');
    if (collaborationBox.isNotEmpty) {
      collaborations = collaborationBox.values.first;
    } else {
      // empty state
    }

  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<Map<String, String>?> _readFileHashFromTangle(
      String fileHash) async {

    final receivedText;
    if (user.userPublicAddress == collaborations.senderIOTAAddress) {
      receivedText = await api.readOutgoingTransactions(
          walletInfo: WalletInfo(
            alias: user.userName.toString(),
            mnemonic: '',
            strongholdPassword: '',
            strongholdFilepath: iPactWalletFilePathValue.toString(),
            lastAddress: '',
          ));
    } else {

      receivedText = await api.readIncomingTransactions(
          walletInfo: WalletInfo(
            alias: user.userName.toString(),
            mnemonic: '',
            strongholdPassword: '',
            strongholdFilepath: iPactWalletFilePathValue.toString(),
            lastAddress: '',
          ));

    }
    //print('receivedText');
    //print(receivedText);

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
        if (metadata['a'] == 2 &&
            (metadata['d'] as List<dynamic>)
                .contains(fileHash) &&
            metadata['d'].contains(fileHash)) {
          print('metadata');
          print(metadata);
          //print('metadata d');
          //print(metadata['d']);
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
          'Transaction with file hash $fileHash not found.');
      return null;
    }
  }


  Future<Map<String, String>> _readFileHashFromTangleOld(
      String fileHash) async {

    print('user.userPublicAddress');
    print(user.userPublicAddress);
    print('collaborations.senderIOTAAddress');
    print(collaborations.senderIOTAAddress);

    final receivedText;
    if (user.userPublicAddress == collaborations.senderIOTAAddress) {
       receivedText = await api.readOutgoingTransactions(
          walletInfo: WalletInfo(
            alias: user.userName.toString(),
            mnemonic: '',
            strongholdPassword: '',
            strongholdFilepath: iPactWalletFilePathValue.toString(),
            lastAddress: '',
          ));
    } else {

      receivedText = await api.readIncomingTransactions(
          walletInfo: WalletInfo(
            alias: user.userName.toString(),
            mnemonic: '',
            strongholdPassword: '',
            strongholdFilepath: iPactWalletFilePathValue.toString(),
            lastAddress: '',
          ));

    }


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
                .substring(2, transaction.metadata.length - 1)
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
        'transactionType': data.isNotEmpty ? data[0] : '',
        'transactionId': transaction.transactionId,
        'collaborationId': data.length > 1 ? data[1] : '',
        'fileId': data.length > 2 ? data[2] : '',
        'fileHash': data.length > 3 ? data[3] : '',
      };
    }).toList();

    // Debug print the resulting list of maps
    for (var _transaction_test in transactionList) {
      print("transaction0");
      print(_transaction_test);
    }

    // return transactionList;

    // Find the specific file hash in the transaction list
    var foundTransaction = transactionList.firstWhere(
          (transaction) =>
      transaction['fileHash'] == fileHash,
      // orElse: () => null,
    );

    print('foundTransaction');
    print(foundTransaction);
    return foundTransaction;
  }


  Future<bool> checkFileImmutability(File file) async {

    try{
      EncryptionUtils encryptionUtils = EncryptionUtils();
      var fileHash = await encryptionUtils.getHashFromFile(file);

      iPactWalletFilePathValue = await iPactWalletFilePath();
      var fileHashTransaction = await _readFileHashFromTangle(fileHash.toString());

      if (fileHashTransaction!.isNotEmpty && fileHashTransaction['fileHash'] != null){
        var savedFilesHash= fileHashTransaction['fileHash'];
        print('fileHash.toString()');
        print(fileHash.toString());

        print('savedFilesHash');
        print(savedFilesHash);
        if (savedFilesHash!.contains(fileHash.toString())) {
          return true;
        }

      }
    }catch(e){
      print('something went wrong');
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarMain(title: "Immutability Check".tr, context: context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                vSpacer20(),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        selectedFile = File(result.files.single.path!);
                        fileNameSplit = selectedFile!.path.split('/').last;
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: SizedBox(
                    height: 110,
                    width: 110,
                    child: CircleAvatar(
                      radius: 0,
                      backgroundColor: context.theme.dividerColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AssetConstants.icFileUpload,
                              color: context.theme.primaryColorDark,
                              height: 38,
                            ),
                            const TextAutoMetropolis(
                              'Upload File',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add space between the elements
                const TextAutoMetropolis(
                  'Upload file here to check file immutability',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  fontSize: 14,
                ),
                vSpacer20(),
                selectedFile != null
                    ? Column(
                  children: [
                    InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextAutoMetropolis(
                            'Selected decrypted document name: ',
                            fontSize: 14,
                            maxLines: 3,
                          ),
                          TextAutoPoppins(
                            '$fileNameSplit',
                            maxLines: 3,
                          ),
                        ],
                      ),
                      onTap: () {
                        OpenFile.open(selectedFile!.path);
                      },
                    ),
                    vSpacer20(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width / 2.2,
                          child: Obx(
                                () => ButtonFillMain(
                              title: "Check Immutability".tr,
                              isLoading: _controller.isLoading.value,
                              onPress: () async {
                                _controller.isLoading.value = true;
                                immutabilityStatus = await checkFileImmutability(selectedFile!);
                                setState(() {});
                                _controller.isLoading.value = false;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : const SizedBox(),
                vSpacer30(),
                if (immutabilityStatus != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                    child: ImmutabilityCheckItemView(
                      context: context,
                      bgColor: context.theme.primaryColorLight,
                      titleText: immutabilityStatus!
                          ? 'Immutability Ensured'
                          : 'Immutability Compromised or Wrong File',
                      iconData: immutabilityStatus!
                          ? AssetConstants.icFileChecked2
                          : AssetConstants.icFileCross,
                      status: immutabilityStatus!
                          ? 'accepted'
                          : 'declined',
                      onTap: () {},
                    ),
                  ),
                vSpacer10(),
                vSpacer30(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
