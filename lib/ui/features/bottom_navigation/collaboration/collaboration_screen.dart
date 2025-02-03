import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/data/models/transaction.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ffi.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_controller.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/collaboration_details_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/receive_document/receive_document_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/start_new_collaboration/start_new_collaboration_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_controller_final.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/text_util.dart';

import 'add_invited_collaboration/add_invited_collaboration_screen.dart';

class CollaborationScreen extends StatefulWidget {
  // final String? dateAndTimeNow;
  // final String? ownPublicKey;
  // final String? userPublicAddress;
  const CollaborationScreen({Key? key}) : super(key: key);

  @override
  CollaborationScreenState createState() => CollaborationScreenState();
}

class CollaborationScreenState extends State<CollaborationScreen> {
  /// Start of floating button variables
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endFloat;

  /// End of floating button variables

  final _controller = Get.put(CollaborationController());
  final _encryptionControllerFinal = Get.put(EncryptionControllerFinal());


  final _searchController = TextEditingController();
  Timer? _searchTimer;

  late Box<User> userBox;
  late User user;


  List<Collaborations> filteredAllPendingCollaborationsList = [];

  late Box<Collaborations> collaborationBox;

  @override
  void initState() {
    super.initState();

    collaborationBox = Hive.box('collaborations');
    userBox = Hive.box<User>('users');

    if (userBox.isNotEmpty) {
      user = userBox.values.first;
      print('--------------userPublicAddress');
      _controller.userName.value = user.userName.toString();
    } else {
      // empty state
    }

    _getIpactWalletFilePath();

    _initializeData();
  }
  void _initializeData() async {
    await _refreshCollaboration();
  }

  Future<void> getData() async {
    Future.delayed(const Duration(seconds: 3), () async {
      await _refreshCollaboration();
    });
  }

  void _getIpactWalletFilePath() async {
    _controller.iPactWalletFilePathValue.value = await iPactWalletFilePath();
  }


  Future<List<Map<String, String>>> getIncomingCollaborationsFromTangle() async {
    print('getIncomingCollaborationsFromTangle');
    print(_controller.userName.value.toString());

    // Read incoming transactions
    final receivedText = await api.readIncomingTransactions(
      walletInfo: WalletInfo(
        alias: _controller.userName.value.toString(),
        mnemonic: '',
        strongholdPassword: '',
        strongholdFilepath: _controller.iPactWalletFilePathValue.value.toString(),
        lastAddress: '',
      ),
    );

    print('receivedText');
    print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);
    List<Transaction> transactions = jsonList.map((json) => Transaction.fromJson(json)).toList();

    // Convert List<Transaction> to List<Map<String, String>>
    List<Map<String, String>> transactionList = transactions.fold([], (acc, transaction) {
      Map<String, dynamic> metadata = {};
      try {
        if (transaction.metadata != null && transaction.metadata.isNotEmpty) {
          var parsedMetadata = jsonDecode(transaction.metadata);

          // Ensure the metadata is a Map
          if (parsedMetadata is Map<String, dynamic>) {
            metadata = parsedMetadata;
            // Filter only transactions where "a": 1
            if (metadata['a'] == 1) {
              acc.add({
                'transactionType': metadata['a'].toString(),
                'transactionId': transaction.transactionId,
                'collaborationId': metadata['b']?.toString() ?? '',
                'iotaAddress': metadata['c']?.toString() ?? '',
                'publicKey': metadata['d']?.toString() ?? '',
              });
            }
          }
        }
      } catch (e) {
        print('Error parsing metadata: $e');
      }
      return acc;
    });

    return transactionList;
  }


  Future<List<Map<String, String>>> getIncomingCollaborationsFromTangleOld() async {
    print('getIncomingCollaborationsFromTangle');
    print(_controller.userName.value.toString());

    // Read incoming transactions
    final receivedText = await api.readIncomingTransactions(
        walletInfo: WalletInfo(
          alias: _controller.userName.value.toString(),
          mnemonic: '',
          strongholdPassword: '',
          strongholdFilepath: _controller.iPactWalletFilePathValue.value.toString(),
          lastAddress: '',
        )
    );

    print('receivedText');
    print(receivedText);

    // Parse the JSON string
    List<dynamic> jsonList = jsonDecode(receivedText);
    List<Transaction> transactions = jsonList.map((json) => Transaction.fromJson(json)).toList();

    // Convert List<Transaction> to List<Map<String, String>>
    List<Map<String, String>> transactionList = transactions.map((transaction) {
      // Handle the metadata correctly
      List<String> data = [];
      try {
        if (transaction.metadata != null && transaction.metadata.isNotEmpty) {
          if (transaction.metadata.startsWith('{') && transaction.metadata.endsWith('}')) {
            data = transaction.metadata.substring(1, transaction.metadata.length - 1).split(', ');
          } else if (transaction.metadata.startsWith('[') && transaction.metadata.endsWith(']')) {
            data = jsonDecode(transaction.metadata).cast<String>();
          }
        }
      } catch (e) {
        print('Error parsing metadata: $e');
      }

      return {
        'transactionType': data.isNotEmpty ? data[0] : '',
        'transactionId': transaction.transactionId,
        'collaborationId': data.length > 1 ? data[1] : '',
        'iotaAddress': data.length > 2 ? data[2] : '',
        'publicKey': data.length > 3 ? data[3] : '',
      };
    }).toList();

    // Debug print the resulting list of maps
    /*for (var transaction in transactionList) {
      print(transaction);
    }*/

    return transactionList;
  }

  List<String> convertStringToList(String input) {
    // Remove the curly braces
    String trimmed = input.substring(1, input.length - 1);
    // Split the string by comma and trim spaces
    List<String> result = trimmed.split(', ').map((e) => e.trim()).toList();
    return result;
  }

  _refreshCollaboration() async {
    var transactionList = await getIncomingCollaborationsFromTangle();

    List<Collaborations> allCollaborations = collaborationBox.values.toList();
    print('transactionList');
    print(transactionList);

    filteredAllPendingCollaborationsList = allCollaborations.where((collaboration) =>
    collaboration.collaborationAccepted == false && collaboration.collaborationSent == true).toList();

    for (var pendingCollaboration in filteredAllPendingCollaborationsList) {
      var filteredTransactions = transactionList.where((transaction) {
        return transaction['transactionType'] == "1" && transaction['collaborationId'] == pendingCollaboration.collaborationId;
      }).toList();

      if (filteredTransactions.isNotEmpty) {
        var firstTransaction = filteredTransactions.first;
        // Do something with firstTransaction
        print('First Transaction: $firstTransaction');

        // Create a new instance with updated values
        var updatedCollaboration = Collaborations(
          collaborationId: pendingCollaboration.collaborationId,
          collaborationName: pendingCollaboration.collaborationName,
          collaborationAccepted: true,
          collaborationSent: pendingCollaboration.collaborationSent,
          transactionId: firstTransaction['transactionId'].toString(),
          senderIOTAAddress: pendingCollaboration.senderIOTAAddress,
          senderPublicKey: pendingCollaboration.senderPublicKey,
          receiverIOTAAddress: firstTransaction['iotaAddress'].toString(),
          receiverPublicKey: firstTransaction['publicKey'].toString(),
        );

        if (firstTransaction['publicKey'].toString().isNotEmpty) {
          _encryptionControllerFinal.generateRsaKeyPemFileFromReceivedPublicKey(
            collaborationId: pendingCollaboration.collaborationId,
            iotaAddress: firstTransaction['iotaAddress'].toString(),
            receivedPublicKey: firstTransaction['publicKey'].toString(),
          );
        }


        // Replace the old object with the new one
        await collaborationBox.put(pendingCollaboration.key, updatedCollaboration);

        print('Updated Collaboration: ${pendingCollaboration.collaborationId}');
      } else {
        print('No transactions found matching the criteria.');
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarMain(
        title: "Collaboration".tr, context: context,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: getData,
              child: _collaborationAllList(),
            ),
          ),
          Positioned(
            bottom: 110.0,
            right: 16.0,
            child: _customFloatingSpeedDial(),
          ),
        ],
      ),
    );
  }

  Widget _collaborationAllList() {
    return ValueListenableBuilder(
      valueListenable: collaborationBox.listenable(),
      builder: (context, box, child) {
        List<Collaborations> allSentCollaboration = collaborationBox.values.toList();

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextAutoMetropolis("Pull Down To Refresh", color: Colors.grey, fontSize: 8,textAlign: TextAlign.center),
              ),
            ),
            if (allSentCollaboration.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: EmptyViewWithLoading(
                    isLoading: _controller.isLoading.value,
                    message: "You do not have any collaboration yet.".tr,
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final Collaborations collaboration = allSentCollaboration[index];
                    String status = collaboration.collaborationAccepted.toString();
                    String finalStatus = status == 'true' ? 'accepted' : 'pending';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                      child: CollaborationItemView2(
                        context: context,
                        bgColor: context.theme.primaryColorLight,
                        titleText: collaboration.collaborationName.toString(),
                        status: finalStatus,
                        onTap: () {
                          debugPrint('------------------============== collaborationBox Item');
                          debugPrint(collaborationBox.name);
                          debugPrint(collaboration.collaborationId.toString());

                          Get.to(CollaborationDetailsScreen(
                            collaborationName: collaboration.collaborationName.toString(),
                            timeOrCollaborationId: collaboration.collaborationId.toString(),
                            collaborationStatus: finalStatus.toString(),
                            transactionId: collaboration.transactionId.toString(),
                            senderPublicKey: collaboration.senderPublicKey.toString(),
                            receiverPublicKey: collaboration.receiverPublicKey.toString(),
                            senderIotaPublicAddress: collaboration.senderIOTAAddress.toString(),
                            receiverIotaPublicAddress: collaboration.receiverIOTAAddress.toString(),
                          ));
                        },
                      ),
                    );
                  },
                  childCount: allSentCollaboration.length,
                ),
              ),
          ],
        );
      },
    );
  }

/*  Widget _collaborationAllList() {
    return ValueListenableBuilder(
      valueListenable: collaborationBox.listenable(),
      builder: (context, box, child) {
        List<Collaborations> allSentCollaboration = collaborationBox.values.toList();
        return allSentCollaboration.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextAutoMetropolis("Pull Down To Refresh", color: Colors.grey, fontSize: 8),
              EmptyViewWithLoading(
                isLoading: _controller.isLoading.value,
                message: "You do not have any collaboration yet.".tr,
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
          itemCount: allSentCollaboration.length,
          itemBuilder: (context, index) {
            final Collaborations collaboration = allSentCollaboration[index];
            String status = collaboration.collaborationAccepted.toString();
            String finalStatus = status == 'true' ? 'accepted' : 'pending';

            return CollaborationItemView2(
              context: context,
              bgColor: context.theme.primaryColorLight,
              titleText: collaboration.collaborationName.toString(),
              status: finalStatus,
              onTap: () {
                debugPrint('------------------============== collaborationBox Item');
                debugPrint(collaborationBox.name);
                debugPrint(collaboration.collaborationId.toString());

                Get.to(CollaborationDetailsScreen(
                  collaborationName: collaboration.collaborationName.toString(),
                  timeOrCollaborationId: collaboration.collaborationId.toString(),
                  collaborationStatus: finalStatus.toString(),
                  transactionId: collaboration.transactionId.toString(),
                  senderPublicKey: collaboration.senderPublicKey.toString(),
                  receiverPublicKey: collaboration.receiverPublicKey.toString(),
                  senderIotaPublicAddress: collaboration.senderIOTAAddress.toString(),
                  receiverIotaPublicAddress: collaboration.receiverIOTAAddress.toString(),
                ));
              },
            );
          },
        );
      },
    );
  }*/

  _customFloatingSpeedDial() {
    return SpeedDial(
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      // / This is ignored if animatedIcon is non null
      // child: Text("open"),
      // activeChild: Text("close"),
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: mini,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      // dialRoot: customDialRoot
      //     ? (ctx, open, toggleChildren) {
      //         return ElevatedButton(
      //           onPressed: toggleChildren,
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.blue[900],
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      //           ),
      //           child: const Text(
      //             "Custom Dial Root",
      //             style: TextStyle(fontSize: 17),
      //           ),
      //         );
      //       }
      //     : null,
      buttonSize: buttonSize,
      // it's the SpeedDial size which defaults to 56 itself
      // iconTheme: IconThemeData(size: 22),
      label: extend ? const Text("Open") : null,
      // The label of the main button.
      /// The active label of the main button, Defaults to label if not specified.
      activeLabel: extend ? const Text("Close") : null,

      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: speedDialDirection,
      switchLabelPosition: switchLabelPosition,

      /// If true user is forced to close dial manually
      closeManually: closeManually,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: renderOverlay,
      // overlayColor: Colors.black,
      // overlayOpacity: 0.5,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      useRotationAnimation: useRAnimation,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      foregroundColor: context.theme.primaryColorLight,
      backgroundColor: context.theme.primaryColorDark,
      // activeForegroundColor: Colors.red,
      // activeBackgroundColor: Colors.blue,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: customDialRoot
          ? const RoundedRectangleBorder()
          : const StadiumBorder(),
      // childMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: [
        SpeedDialChild(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              AssetConstants.icStartNewCollaboration,
              color: context.theme.primaryColorLight,
            ),
          ),
          backgroundColor: context.theme.primaryColorDark,
          foregroundColor: context.theme.primaryColorLight,
          labelBackgroundColor: context.theme.primaryColorLight,
          label: "StartNewCollaboration".tr,
          onTap: () => Get.to(() => const StartNewCollaborationScreen()),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
        SpeedDialChild(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              AssetConstants.icStartNewCollaboration,
              color: context.theme.primaryColorLight,
            ),
          ),
          backgroundColor: context.theme.primaryColorDark,
          foregroundColor: context.theme.primaryColorLight,
          labelBackgroundColor: context.theme.primaryColorLight,
          label: "AcceptNewCollaboration".tr,
          onTap: () => Get.to(() => const AddInvitedCollaborationScreen()),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
        SpeedDialChild(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              AssetConstants.icDocument,
              color: context.theme.primaryColorLight,
            ),
          ),
          backgroundColor: context.theme.primaryColorDark,
          foregroundColor: context.theme.primaryColorLight,
          labelBackgroundColor: context.theme.primaryColorLight,
          label: "ReceiveFileStack".tr,
          //label: "ReceiveDocument".tr,
          onTap: () => Get.to(() => const ReceiveDocumentScreen()),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
      ],
    );
  }
}
