import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_controller.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/collaboration_details_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/start_new_collaboration/start_new_collaboration_screen.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';

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
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];

  /// End of floating button variables

  final _controller = Get.put(CollaborationController());

  final _searchController = TextEditingController();
  Timer? _searchTimer;

  late Box<Collaborations> collaborationBox;
  List<Collaborations> filteredReceivedCollaborationList = [];
  List<Collaborations> filteredSentCollaborationList = [];

  /// Testing
  // late AppLinks _appLinks;
  // StreamSubscription<Uri>? _sub;

  // String? dateAndTimeNow2;
  //  String? ownPublicKey2;
  //  String? userPublicAddress2;

  @override
  void initState() {
    super.initState();

    collaborationBox = Hive.box('collaborations');

    // _appLinks = AppLinks();
    // _handleIncomingLinks();
  }

  // void _handleIncomingLinks() {
  //   _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       // Extract parameters
  //       dateAndTimeNow2 = uri.queryParameters['prm1='];
  //       ownPublicKey2 = uri.queryParameters['prm2='];
  //       userPublicAddress2 = uri.queryParameters['prm3='];
  //
  //       // Navigate to the desired screen with parameters
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => CollaborationScreen(
  //       //       dateAndTimeNow: dateAndTimeNow,
  //       //       ownPublicKey: ownPublicKey,
  //       //       userPublicAddress: userPublicAddress,
  //       //     ),
  //       //   ),
  //       // );
  //     }
  //   }, onError: (err) {
  //     // Handle error
  //   });
  // }

  @override
  void dispose() {
    // _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: appBarMain(title: "Collaboration".tr, context: context),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // dateAndTimeNow2!.isNotEmpty ?
                  // Column(
                  //   children: [
                  //     const Text('Date and Time: '),
                  //     TextAutoMetropolis(dateAndTimeNow2.toString(),),
                  //     const Text('Own Public Key: '),
                  //     TextAutoMetropolis(ownPublicKey2.toString(),),
                  //     const Text('User Public Address: '),
                  //     TextAutoMetropolis(userPublicAddress2.toString(),),
                  //   ],
                  // ): const SizedBox(),
                  getTabView(
                    titles: ["Sent".tr, "Received".tr],
                    controller: _controller.tabController,
                    onTap: (selected) {
                      _controller.tabSelectedIndex.value = selected;
                    },
                  ),
                  vSpacer15(),
                  Expanded(
                    child: TabBarView(
                        controller: _controller.tabController,
                        children: [_sentTab(), _receivedTab()]),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 110.0,
              right: 16.0,
              child: _customFloatingSpeedDial(),
            )
          ],
        ));
  }

  Widget _receivedTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: collaborationBox.listenable(),
          builder: (context, box, child) {
            List<Collaborations> allReceivedCollaboration = collaborationBox.values.toList();
            filteredReceivedCollaborationList = allReceivedCollaboration
                .where((collaborationBox) => collaborationBox.collaborationAccepted == false)
                .toList();
            return filteredReceivedCollaborationList.isEmpty
                ? EmptyViewWithLoading(isLoading: _controller.isLoading.value,
                    message: "You do not have any Received collaboration yet.".tr,
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: filteredReceivedCollaborationList.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final Collaborations collaboration = filteredReceivedCollaborationList[index];
                      String status = collaboration.collaborationAccepted.toString();
                      String finalStatus;
                      if (status == 'true') {
                        finalStatus = 'accepted';
                      } else {
                        finalStatus = 'pending';
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                        child: CollaborationItemView2(
                          context: context,
                          bgColor: context.theme.primaryColorLight,
                          titleText: collaboration.collaborationName.toString(),
                          status: finalStatus,
                          onTap: () {
                            debugPrint('------------------============== sentCollaborationBox Item');
                            debugPrint(collaborationBox.name);
                            debugPrint(collaboration.collaborationId.toString());

                            // Get.to(const CollaborationDetailsScreen());
                            Get.to( CollaborationDetailsScreen(
                                collaborationName:collaboration.collaborationName.toString(),
                                timeOrCollaborationId: collaboration.collaborationId.toString(),
                                collaborationStatus: finalStatus.toString(),
                                transactionId:collaboration.transactionId.toString(),
                                senderPublicKey: collaboration.senderPublicKey.toString(),
                                receiverPublicKey: collaboration.receiverPublicKey.toString(),
                                senderIotaPublicAddress: collaboration.senderIOTAAddress.toString(),
                                receiverIotaPublicAddress: collaboration.receiverIOTAAddress.toString()));

                          },
                        ),
                      );
                    },
                  );
          },
        ),
      ],
    );
  }

  Widget _sentTab() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: collaborationBox.listenable(),
          builder: (context, box, child) {
            // Example filter: users older than 18
            List<Collaborations> allSentCollaboration = collaborationBox.values.toList();
            filteredSentCollaborationList = allSentCollaboration
                .where((collaborationBox) => collaborationBox.collaborationSent == true)
                .toList();

            return filteredSentCollaborationList.isEmpty
                ? EmptyViewWithLoading(
                    isLoading: _controller.isLoading.value,
                    message: "You do not have any Sent collaboration yet.".tr,
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: filteredSentCollaborationList.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final Collaborations collaboration = filteredSentCollaborationList[index];
                      String status = collaboration.collaborationAccepted.toString();
                      String finalStatus;
                      if (status == 'true') {
                        finalStatus = 'accepted';
                      } else {
                        finalStatus = 'pending';
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                        child: CollaborationItemView2(
                          context: context,
                          bgColor: context.theme.primaryColorLight,
                          titleText: collaboration.collaborationName.toString(),
                          status: finalStatus,
                          onTap: () {
                            debugPrint('------------------============== sentCollaborationBox Item');
                            debugPrint(collaborationBox.name);
                            debugPrint(collaboration.collaborationId.toString());

                            Get.to( CollaborationDetailsScreen(
                                collaborationName:collaboration.collaborationName.toString(),
                                timeOrCollaborationId: collaboration.collaborationId.toString(),
                                collaborationStatus: finalStatus.toString(),
                                transactionId:collaboration.transactionId.toString(),
                                senderPublicKey: collaboration.senderPublicKey.toString(),
                                receiverPublicKey: collaboration.receiverPublicKey.toString(),
                                senderIotaPublicAddress: collaboration.senderIOTAAddress.toString(),
                                receiverIotaPublicAddress: collaboration.receiverIOTAAddress.toString()));
                          },
                        ),
                      );
                    },
                  );
          },
        ),
      ],
    );
  }

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
      ],
    );
  }
}
//
// class DetailScreen extends StatelessWidget {
//   final String? dateAndTimeNow;
//   final String? ownPublicKey;
//   final String? userPublicAddress;
//
//   DetailScreen(
//       {this.dateAndTimeNow, this.ownPublicKey, this.userPublicAddress});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Date and Time: $dateAndTimeNow'),
//             Text('Own Public Key: $ownPublicKey'),
//             Text('User Public Address: $userPublicAddress'),
//           ],
//         ),
//       ),
//     );
//   }
// }
