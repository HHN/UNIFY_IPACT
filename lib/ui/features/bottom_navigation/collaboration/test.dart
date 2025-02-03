import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:unify_secret/data/models/collaboration/collaborations.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_controller.dart';
import 'dart:async';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/collaboration_details_screen.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import '../../../../utils/spacers.dart';

/*class CollaborationScreen extends StatefulWidget {
  const CollaborationScreen({Key? key}) : super(key: key);

  @override
  CollaborationScreenState createState() => CollaborationScreenState();
}

class CollaborationScreenState extends State<CollaborationScreen> {
  final _controller = Get.put(CollaborationController());

  late Box<Collaborations> collaborationBox;
  List<Collaborations> filteredReceivedCollaborationList = [];
  List<Collaborations> filteredSentCollaborationList = [];
  StreamSubscription<AppLinks>? _sub;

  @override
  void initState() {
    super.initState();
    collaborationBox = Hive.box('collaborations');
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() async {
    final AppLinks appLinks = AppLinks();

    // Listen for incoming links
    _sub = appLinks.uriLinkStream.listen((Uri uri) {
      _processLink(uri);
    }) as StreamSubscription<AppLinks>?;

    // Handle initial link
    final Uri? initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      _processLink(initialUri);
    }
  }

  void _processLink(Uri uri) {
    final dateAndTimeNow = uri.queryParameters['prm1'];
    final ownPublicKey = uri.queryParameters['prm2'];
    final userPublicAddress = uri.queryParameters['prm3'];

    if (dateAndTimeNow != null && ownPublicKey != null && userPublicAddress != null) {
      invitePartnerAndSaveToHive(
        collaborationId: dateAndTimeNow,
        collaborationName: 'Received Collaboration', // Provide a meaningful name
        collaborationAccepted: false,
        collaborationSent: false, // As per your request
        transactionId: '',
        senderIOTAAddress: userPublicAddress,
        senderPublicKey: ownPublicKey,
        receiverIOTAAddress: '',
        receiverPublicKey: '',
      );
    }
  }

  void invitePartnerAndSaveToHive({
    required String collaborationId,
    required String collaborationName,
    required bool collaborationAccepted,
    required bool collaborationSent,
    required String transactionId,
    required String senderIOTAAddress,
    required String senderPublicKey,
    required String receiverIOTAAddress,
    required String receiverPublicKey,
  }) {
    collaborationBox.add(Collaborations(
      collaborationId: collaborationId,
      collaborationName: collaborationName,
      collaborationAccepted: collaborationAccepted,
      collaborationSent: collaborationSent,
      transactionId: transactionId,
      senderIOTAAddress: senderIOTAAddress,
      senderPublicKey: senderPublicKey,
      receiverIOTAAddress: receiverIOTAAddress,
      receiverPublicKey: receiverPublicKey,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarMain(title: "Test".tr),
      body: SafeArea(
        child: Column(
          children: [
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
                children: [_sentTab(), _receivedTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receivedTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: collaborationBox.listenable(),
          builder: (context, box, child) {
            List<Collaborations> allReceivedCollaboration =
            collaborationBox.values.toList();
            filteredReceivedCollaborationList = allReceivedCollaboration
                .where((collaboration) =>
            !collaboration.collaborationSent)
                .toList();

            return filteredReceivedCollaborationList.isEmpty
                ? EmptyViewWithLoading(
              isLoading: _controller.isLoading.value,
              message:
              "You do not have any Received collaboration yet.".tr,
            )
                : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: filteredReceivedCollaborationList.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final Collaborations receivedCollaboration =
                filteredReceivedCollaborationList[index];
                String status =
                receivedCollaboration.collaborationAccepted ? 'accepted' : 'pending';
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.paddingLarge),
                  child: CollaborationItemView2(
                    context: context,
                    bgColor: context.theme.primaryColorLight,
                    titleText:
                    receivedCollaboration.collaborationName,
                    status: status,
                    onTap: () {
                      debugPrint(
                          '------------------============== receivedCollaborationBox Item');
                      debugPrint(collaborationBox.name);
                      debugPrint(
                          receivedCollaboration.collaborationId);

                      Get.to(const CollaborationDetailsScreen());
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: collaborationBox.listenable(),
          builder: (context, box, child) {
            List<Collaborations> allSentCollaboration =
            collaborationBox.values.toList();
            filteredSentCollaborationList = allSentCollaboration
                .where((collaboration) =>
            collaboration.collaborationSent)
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
                var filteredSentCollaborationList;
                final Collaborations sentCollaboration =
                filteredSentCollaborationList[index];
                String status =
                sentCollaboration.collaborationAccepted ? 'accepted' : 'pending';
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.paddingLarge),
                  child: CollaborationItemView2(
                    context: context,
                    bgColor: context.theme.primaryColorLight,
                    titleText:
                    sentCollaboration.collaborationName,
                    status: status,
                    onTap: () {
                      debugPrint(
                          '------------------============== sentCollaborationBox Item');
                      debugPrint(collaborationBox.name);
                      debugPrint(
                          sentCollaboration.collaborationId);

                      Get.to(const CollaborationDetailsScreen());
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
}*/

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Extract Parameters from URL'),
        ),
        body: UrlParser(),
      ),
    );
  }
}

class UrlParser extends StatefulWidget {
  @override
  _UrlParserState createState() => _UrlParserState();
}

class _UrlParserState extends State<UrlParser> {
  final TextEditingController collaborationInvitationListTextController = TextEditingController();
  String prm1 = '';
  String prm2 = '';
  String prm3 = '';

  void extractParameters(String url) {
    RegExp regExp = RegExp(r'prm1=([^&]+)&prm2=([^&]+)&prm3=([^&]+)');
    RegExpMatch? match = regExp.firstMatch(url);

    if (match != null) {
      setState(() {
        prm1 = match.group(1) ?? '';
        prm2 = match.group(2) ?? '';
        prm3 = match.group(3) ?? '';
      });
    } else {
      setState(() {
        prm1 = 'Not found';
        prm2 = 'Not found';
        prm3 = 'Not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: collaborationInvitationListTextController,
            decoration: const InputDecoration(
              labelText: 'Paste your URL here',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String pastedLink = collaborationInvitationListTextController.value.text.toString();
              extractParameters(pastedLink);
            },
            child: const Text('Extract Parameters'),
          ),
          const SizedBox(height: 20),
          Text('prm1: $prm1'),
          Text('prm2: $prm2'),
          Text('prm3: $prm3'),
        ],
      ),
    );
  }
}

