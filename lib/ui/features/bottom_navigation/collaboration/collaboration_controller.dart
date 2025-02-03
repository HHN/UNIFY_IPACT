import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollaborationController extends GetxController
    with GetSingleTickerProviderStateMixin {

  // Future<void> getData() async {
  //   Future.delayed(const Duration(seconds: 1), () {
  //     _refreshCollaboration();
  //   });
  // }
  TabController? tabController;
  final tabSelectedIndex = 0.obs;
  final strongholdPasswordController = TextEditingController();

  RxString userName= ''.obs;
  RxString iPactWalletFilePathValue = ''.obs;


  List<dynamic> notificationItemList = [
    {'name': 'John', 'group': 'April 27, 2021'},
    // {'name': 'Will', 'group': 'April 27, 2021'},
    // {'name': 'Beth', 'group': 'April 27, 2021'},
    // {'name': 'Miranda', 'group': 'April 26, 2021'},
    // {'name': 'Mike', 'group': 'April 26, 2021'},
    // {'name': 'Danny', 'group': 'April 26, 2021'},
    // {'name': 'Simul', 'group': 'April 2, 2021'},
    // {'name': 'Danny2', 'group': 'April 2, 2021'},
    // {'name': 'Danny3', 'group': 'April 2, 2021'},
    // {'name': 'Danny4', 'group': 'April 2, 2021'},
  ].obs;
  List<dynamic> notificationItemList0 = [].obs;

  bool isDataLoaded = false;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(vsync: this, length: 2);

    // collaborationBox = Hive.box('collaborations');
    // userBox = Hive.box<User>('users');
  }
  RxBool isLoading = false.obs;

  RxList filteredReceivedCollaborationList = [].obs;
  RxList filteredSentCollaborationList = [].obs;

  //
  //
  // late Box<User> userBox;
  // late User data;
  //
  // late String iPactWalletFilePathValue;
  //
  // late Box<Collaborations> collaborationBox;
  //
  //
  // List<Collaborations> filteredAllPendingCollaborationsList = [];
  //
  // void _refreshCollaboration() async {
  //
  //   var transactionList = await _callFfiGetReceivedTransactions();
  //
  //
  //   List<Collaborations> allCollaborations = collaborationBox.values.toList();
  //
  //   filteredAllPendingCollaborationsList = allCollaborations
  //       .where((collaboration) => collaboration.collaborationAccepted == false && collaboration.collaborationSent == true)
  //       .toList();
  //
  //   for (var pendingCollaboration in filteredAllPendingCollaborationsList) {
  //
  //     var filteredTransactions = transactionList.where((transaction) {
  //       return transaction['transaction_type'] == "1" && transaction['collaboration_id'] == pendingCollaboration.collaborationId;
  //     }).toList();
  //
  //     if (filteredTransactions.isNotEmpty) {
  //
  //       var firstTransaction = filteredTransactions.first;
  //       // Do something with firstTransaction
  //       print('First Transaction: $firstTransaction');
  //
  //
  //       // Create a new instance with updated values
  //       var updatedCollaboration = Collaborations(
  //         collaborationId: pendingCollaboration.collaborationId,
  //         collaborationName: pendingCollaboration.collaborationName,
  //         collaborationAccepted: true,
  //         collaborationSent: pendingCollaboration.collaborationSent,
  //         transactionId: firstTransaction['transaction_id'].toString(),
  //         senderIOTAAddress: pendingCollaboration.senderIOTAAddress,
  //         senderPublicKey: pendingCollaboration.senderPublicKey,
  //         receiverIOTAAddress: firstTransaction['iota_address'].toString(),
  //         receiverPublicKey: firstTransaction['public_key'].toString(),
  //       );
  //
  //       // Replace the old object with the new one
  //       await collaborationBox.put(pendingCollaboration.key, updatedCollaboration);
  //
  //       print('Updated Collaboration: ${pendingCollaboration.collaborationId}');
  //
  //       // Save the updated collaboration back to the Hive box
  //       // pendingCollaboration.save();
  //
  //     } else {
  //       print('No transactions found matching the criteria.');
  //     }
  //
  //   }
  // }
  //
  //
  //
  // void _getIpactWalletFilePath() async {
  //   iPactWalletFilePathValue = await iPactWalletFilePath();
  // }
  //
  // Future<List<Map<String, String>>> _callFfiGetReceivedTransactions() async{
  //   // final receivedText = await api.getReceivedTransactions(
  //   //     walletInfo: WalletInfo(
  //   //       alias: data.userName.toString(),
  //   //       mnemonic: '',
  //   //       strongholdPassword: '',
  //   //       strongholdFilepath: iPactWalletFilePathValue.toString(),
  //   //       lastAddress: '',
  //   //     ));
  //   // debugPrint("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<here>>>>>>>>>>>>>>>>>>>>>>");
  //
  //   final transactions = [
  //     {
  //       "transaction_type": "1",
  //       "transaction_id": "0xa2dba66bcc3416ca746dae740375d83a79c8038184923328e93d47404a537bca",
  //       "collaboration_id": "1718703594588703",
  //       "iota_address": "rms1qr37h7mup8dmc6flavc3wyzk4p8a35s700qfs4vgntsqlr5fn0tsjegx89j",
  //       "public_key": "MIIBCgKCAQEAqJhtThIOnj5mOWDmLqE/m9HD5oqNnbC9E4E5cySH1EpAmkjROdpjincY9f1yOd/57633HWptvQBOxBoWoKO1j5u/6EdvYs5UvhP3OQ5eYZZHqkVDe6l0kIMA9Uz1d1yHP34f6omFpFM9NXSpLjTLy8Q6zlGYb7qFBJu9g9eRHAgMPzpb92lkTxp5/Y7vToGHznfs/UmH0pt484soezYddXH0Ar2jJSaF3lMywclB2ss7qT50I2QZRr2umPRN0FNr3FJTilmu7nsU3rGpC1Tgv7XCXRbvKqjcfmLbnXHxXhxluy9AByY2zjw7EyBaRAKYJTCKQa4Ce6UgrrV8NmSwqwIDAQAB&prm3"
  //     },
  //     {
  //       "transaction_type": "1",
  //       "transaction_id": "0xa2dba66bcc3416ca746dae740375d83a79c8038184923328e93d47404a537bca",
  //       "collaboration_id": "1718665524858738",
  //       "iota_address": "rms1qr37h7mup8dmc6flavc3wyzk4p8a35s700qfs4vgntsqlr5fn0tsjegx89j",
  //       "public_key": "MIIBCgKCAQEAqJhtThIOnj5mOWDmLqE/m9HD5oqNnbC9E4E5cySH1EpAmkjROdpjincY9f1yOd/57633HWptvQBOxBoWoKO1j5u/6EdvYs5UvhP3OQ5eYZZHqkVDe6l0kIMA9Uz1d1yHP34f6omFpFM9NXSpLjTLy8Q6zlGYb7qFBJu9g9eRHAgMPzpb92lkTxp5/Y7vToGHznfs/UmH0pt484soezYddXH0Ar2jJSaF3lMywclB2ss7qT50I2QZRr2umPRN0FNr3FJTilmu7nsU3rGpC1Tgv7XCXRbvKqjcfmLbnXHxXhxluy9AByY2zjw7EyBaRAKYJTCKQa4Ce6UgrrV8NmSwqwIDAQAB&prm3"
  //     },
  //     {
  //       "transaction_type": "2",
  //       "transaction_id": "0xa2dba66bcc3416ca746dae740375d83a79c8038184923328e93d47404a537bca",
  //       "collaboration_id": "1418655109581599",
  //       "iota_address": "rms1qr37h7mup8dmc6flavc3wyzk4p8a35s700qfs4vgntsqlr5fn0tsjegx89j",
  //       "public_key": "MIIBCgKCAQEAqJhtThIOnj5mOWDmLqE/m9HD5oqNnbC9E4E5cySH1EpAmkjROdpjincY9f1yOd/57633HWptvQBOxBoWoKO1j5u/6EdvYs5UvhP3OQ5eYZZHqkVDe6l0kIMA9Uz1d1yHP34f6omFpFM9NXSpLjTLy8Q6zlGYb7qFBJu9g9eRHAgMPzpb92lkTxp5/Y7vToGHznfs/UmH0pt484soezYddXH0Ar2jJSaF3lMywclB2ss7qT50I2QZRr2umPRN0FNr3FJTilmu7nsU3rGpC1Tgv7XCXRbvKqjcfmLbnXHxXhxluy9AByY2zjw7EyBaRAKYJTCKQa4Ce6UgrrV8NmSwqwIDAQAB&prm3"
  //     }
  //   ];
  //
  //   print(transactions);
  //
  //   return transactions;
  // }

}
