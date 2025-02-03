import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/collaboration/documents.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/add_documents/add_documents_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/add_documents/add_multiple_documents_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/collaboration_details_controller.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_details/document_details/document_details_screen.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';
import 'package:unify_secret/utils/text_util.dart';

class CollaborationDetailsScreen extends StatefulWidget {
  final String? collaborationName;
  final String? timeOrCollaborationId;
  final String? collaborationStatus;
  final String? transactionId;
  final String? senderPublicKey;
  final String? receiverPublicKey;
  final String? senderIotaPublicAddress;
  final String? receiverIotaPublicAddress;

  const CollaborationDetailsScreen(
      {super.key,
        this.collaborationName,
        this.timeOrCollaborationId,
        this.collaborationStatus,
        this.transactionId,
        this.senderPublicKey,
        this.receiverPublicKey,
        this.senderIotaPublicAddress,
        this.receiverIotaPublicAddress});

  @override
  CollaborationDetailsScreenState createState() =>
      CollaborationDetailsScreenState();
}

class CollaborationDetailsScreenState extends State<CollaborationDetailsScreen> {
  final _controller = Get.put(CollaborationDetailsController());

  var isDialOpen = ValueNotifier<bool>(false);

  late Box<Documents> documentsBox;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: Text(widget.collaborationName.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showCollaborationInfo,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            getTabView(
              titles: ["Outgoing File Stack".tr, "Incoming File Stack".tr],
              controller: _controller.tabController,
              onTap: (selected) {
                _controller.tabSelectedIndex.value = selected;
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _controller.tabController,
                children: [_outgoingDocumentsTab(), _incomingDocumentsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outgoingDocumentsTab() {
    return _documentsTab(true);
  }

  Widget _incomingDocumentsTab() {
    return _documentsTab(false);
  }

  Widget _documentsTab(bool isOutgoing) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: Hive.box<Documents>('documents').listenable(),
          builder: (context, Box<Documents> box, _) {
            List<Documents> documents = box.values.toList();
            var filteredDocumentsList = documents.where((doc) {
              return doc.collaborationId == widget.timeOrCollaborationId &&
                  doc.ownDocument == isOutgoing;
            }).toList();

            if (filteredDocumentsList.isEmpty) {
              return EmptyViewWithLoading(
                isLoading: false,
                message: isOutgoing
                    ? "No Outgoing File Stack.".tr
                    : "No Incoming File Stack.".tr,
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemCount: filteredDocumentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = filteredDocumentsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.paddingLarge),
                        child: Column(
                          children: [
                            // Text('${document.documentName}'),

                            DocumentsItemView1(
                              context: context,
                              bgColor: context.theme.primaryColorLight,
                              iconColor: document.documentShareStatus == true
                                  ? context.theme.primaryColorDark
                                  : context.theme.disabledColor,
                              titleText: document.documentName ?? 'Unknown',
                              onTap: () => Get.to(DocumentDetailsScreen(
                                collaborationId: document.collaborationId,
                                documentName: document.documentName,
                                documentShareStatus: document.documentShareStatus,
                                isFileEncrypted: document.isFileEncrypted,
                                filePath: document.filePath,
                                fileId: document.fileId,
                                fileOriginalName: document.fileOriginalName,
                                generateKeyFileForSymmetricCryptography: document.generateKeyFileForSymmetricCryptography,
                                symmetricEncryptFile: document.symmetricEncryptFile,
                                asymmetricEncryptFile: document.asymmetricEncryptFile,
                                asymmetricDecryptFile: document.asymmetricDecryptFile,
                                symmetricDecryptFile: document.symmetricDecryptFile,
                                originalFileHash: document.originalFileHash,
                                symmetricEncryptFileHash: document.symmetricEncryptFileHash,
                                ownDocument: document.ownDocument,
                                originalFileHashTransactionId: document.originalFileHashTransactionId,
                                symmetricEncryptFileHashTransactionId: document.symmetricEncryptFileHashTransactionId,
                                asymmetricDecryptFileHash: document.asymmetricDecryptFileHash,
                                asymmetricDecryptFileHashTransactionId: document.asymmetricDecryptFileHashTransactionId,
                                isCryptographicKeyShared: document.isCryptographicKeyShared,
                                cryptographicKeyTransactionId: document.cryptographicKeyTransactionId,
                              )),
                              fileOriginalName: document.fileOriginalName, // Pass the fileOriginalName here
                            )


                            // DocumentsItemView(
                            //   context: context,
                            //   bgColor: context.theme.primaryColorLight,
                            //   iconColor: document.documentShareStatus == true
                            //       ? context.theme.primaryColorDark
                            //       : context.theme.disabledColor,
                            //   titleText: document.documentName ?? 'Unknown',
                            //   onTap: () => Get.to(DocumentDetailsScreen(
                            //     collaborationId: document.collaborationId,
                            //     documentName: document.documentName,
                            //     documentShareStatus: document.documentShareStatus,
                            //     isFileEncrypted: document.isFileEncrypted,
                            //     filePath: document.filePath,
                            //     fileId: document.fileId,
                            //     fileOriginalName: document.fileOriginalName,
                            //     generateKeyFileForSymmetricCryptography: document
                            //         .generateKeyFileForSymmetricCryptography,
                            //     symmetricEncryptFile:
                            //     document.symmetricEncryptFile,
                            //     asymmetricEncryptFile:
                            //     document.asymmetricEncryptFile,
                            //     asymmetricDecryptFile:
                            //     document.asymmetricDecryptFile,
                            //     symmetricDecryptFile:
                            //     document.symmetricDecryptFile,
                            //     originalFileHash: document.originalFileHash,
                            //     symmetricEncryptFileHash:
                            //     document.symmetricEncryptFileHash,
                            //     ownDocument: document.ownDocument,
                            //     originalFileHashTransactionId:
                            //     document.originalFileHashTransactionId,
                            //     symmetricEncryptFileHashTransactionId:
                            //     document.symmetricEncryptFileHashTransactionId,
                            //     asymmetricDecryptFileHash:
                            //     document.asymmetricDecryptFileHash,
                            //     asymmetricDecryptFileHashTransactionId:
                            //     document.asymmetricDecryptFileHashTransactionId,
                            //     isCryptographicKeyShared:
                            //     document.isCryptographicKeyShared,
                            //     cryptographicKeyTransactionId:
                            //     document.cryptographicKeyTransactionId,
                            //   )),
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),

        (widget.collaborationStatus.toString() == "accepted" && isOutgoing) ?

        Positioned(
          bottom: 60.0,
          right: 16.0,
          //child: Text(widget.collaborationStatus.toString()),
          child: _customFloatingSpeedDialForDocuments(),
        )

            : const SizedBox()

      ],
    );
  }

  void _showCollaborationInfo() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Collaboration Details',
          style: TextStyle(color: context.theme.secondaryHeaderColor),
        ),
        content: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7, // Limit dialog height to 70% of screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichTextCustom(context: context, leftText: 'Name: ', rightText: '${widget.collaborationName}'),
                RichTextCustom(context: context, leftText: 'ID: ', rightText: '${widget.timeOrCollaborationId}'),
                RichTextCustom(context: context, leftText: 'Status: ', rightText: '${widget.collaborationStatus}'),
                RichTextCustom(context: context, leftText: 'Transaction ID: ', rightText: '${widget.transactionId}'),
                RichTextCustom(context: context, leftText: 'Sender Public Key: ', rightText: '${widget.senderPublicKey}'),
                RichTextCustom(context: context, leftText: 'Receiver Public Key: ', rightText: '${widget.receiverPublicKey}'),
                RichTextCustom(context: context, leftText: 'Sender IOTA Address: ', rightText: '${widget.senderIotaPublicAddress}'),
                RichTextCustom(context: context, leftText: 'Receiver IOTA Address: ', rightText: '${widget.receiverIotaPublicAddress}'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }



  SpeedDial _customFloatingSpeedDialForDocuments() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(56.0, 56.0),
      visible: true,
      direction: SpeedDialDirection.up,
      closeManually: false,
      renderOverlay: true,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      useRotationAnimation: true,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      foregroundColor: context.theme.primaryColorLight,
      backgroundColor: context.theme.primaryColorDark,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: const StadiumBorder(),
      children: [
/*
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
          label: "Add Single Document".tr,
          onTap: () => Get.to(() => AddDocumentsScreen(
              collaborationId: widget.timeOrCollaborationId.toString())),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
*/
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
          label: "Add File Stack".tr,
          onTap: () => Get.to(() => AddMultipleDocumentsScreen(
              collaborationId: widget.timeOrCollaborationId.toString())),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
      ],
    );
  }
}
