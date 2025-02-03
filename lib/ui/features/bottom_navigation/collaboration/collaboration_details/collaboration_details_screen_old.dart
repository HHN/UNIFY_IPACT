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
import 'package:printing/printing.dart';

class CollaborationDetailsScreen extends StatefulWidget {

  final String? collaborationName;
  final String? timeOrCollaborationId;
  final String? collaborationStatus;
  final String? transactionId;
  final String? senderPublicKey;
  final String? receiverPublicKey;
  final String? senderIotaPublicAddress;
  final String? receiverIotaPublicAddress;

  const CollaborationDetailsScreen({super.key, this.collaborationName, this.timeOrCollaborationId, this.collaborationStatus, this.transactionId, this.senderPublicKey, this.receiverPublicKey, this.senderIotaPublicAddress, this.receiverIotaPublicAddress});

  @override
  CollaborationDetailsScreenState createState() =>
      CollaborationDetailsScreenState();
}

class CollaborationDetailsScreenState extends State<CollaborationDetailsScreen> {

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

  final _controller = Get.put(CollaborationDetailsController());

  late Box<Documents> documentsBox;

  @override
  void initState() {
    super.initState();
    documentsBox = Hive.box('documents');
  }
  // Future<void> getData() async {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     // _refreshCollaboration();
  //   });
  // }

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
        appBar: appBarWithBack(title: widget.collaborationName.toString(), context: context),
        body: SafeArea(
          child: Column(
            children: [
              getTabView(
                titles: ["Documents".tr, "Collaboration Details".tr],
                controller: _controller.tabController,
                onTap: (selected) {
                  _controller.tabSelectedIndex.value = selected;
                  // print(widget.collaborationStatus.toString());
                },
              ),
              Expanded(
                child: TabBarView(
                    controller: _controller.tabController,
                    children: [ _documentsTab(), _collaborationDetailsTab()]),
              ),
            ],
          ),
        ));
  }

  Widget _documentsTab() {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: Hive.box<Documents>('documents').listenable(),
          builder: (context, Box<Documents> box, _) {
            List<Documents> documents = box.values.toList();
            print('documents-');
            print(documents);

            var filteredDocumentsList = documents.where((doc) =>
            doc.collaborationId == widget.timeOrCollaborationId).toList();
            print("filteredDocumentsList");
            print(filteredDocumentsList);

            if (filteredDocumentsList.isEmpty) {
              return EmptyViewWithLoading(
                isLoading: false,
                message: "Documents not uploaded yet.".tr,
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
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                        child: DocumentsItemView(
                          context: context,
                          bgColor: context.theme.primaryColorLight,
                          iconColor: document.documentShareStatus == true ? context.theme.primaryColorDark : context.theme.disabledColor,
                          titleText: document.documentName.toString() ?? 'Unknown',
                          onTap: () =>
                            Get.to(DocumentDetailsScreen(
                              collaborationId: document.collaborationId,
                              documentName: document.documentName.toString(),
                              documentShareStatus: document.documentShareStatus,
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        Positioned(
          bottom: 60.0,
          right: 16.0,
          child: _customFloatingSpeedDialForDocuments(),
        )

      /*   // widget.collaborationStatus.toString() == 'accepted'?

            // :const SizedBox(),*/
      ],
    );
  }


  Widget _collaborationDetailsTab()  {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: RefreshIndicator(
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
                      backgroundColor:
                      context.theme.dividerColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          AssetConstants.icStartNewCollaboration,
                          color: context.theme.primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: CollaborationCard(
                      id: widget.timeOrCollaborationId.toString(),
                      collaborationName: widget.collaborationName.toString(),
                      collaborationId: widget.timeOrCollaborationId.toString(),
                      collaborationStatus: widget.collaborationStatus.toString(),
                      transactionId: widget.transactionId.toString(),
                      senderIotaAddress: widget.senderIotaPublicAddress.toString(),
                      receiverIotaAddress: widget.receiverIotaPublicAddress.toString(),
                      senderPublicKey: widget.senderPublicKey.toString(),
                      receiverPublicKey: widget.receiverPublicKey.toString(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
        bottom: 60.0,
        right: 16.0,
        child: _customFloatingSpeedDialForDetails(),
    )
      ],
    );
  }


  _customFloatingSpeedDialForDocuments() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: mini,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize: buttonSize,
      label: extend ? const Text("Open") : null,
      activeLabel: extend ? const Text("Close") : null,
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: speedDialDirection,
      switchLabelPosition: switchLabelPosition,
      closeManually: closeManually,
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
      children: [
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
          onTap: () => Get.to(() => AddDocumentsScreen(collaborationId: widget.timeOrCollaborationId.toString())),
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
          label: "Add Multiple Document".tr,
          onTap: () => Get.to(() => AddMultipleDocumentsScreen(collaborationId: widget.timeOrCollaborationId.toString())),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
      ],
    );
  }


  Future<void> _generatePdfAndPrint() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Collaboration Details',
                    style: const pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Name: ${widget.collaborationName}'),
                pw.Text('ID: ${widget.timeOrCollaborationId}'),
                pw.Text('Status: ${widget.collaborationStatus}'),
                pw.Text('Transaction ID: ${widget.transactionId}'),
                pw.Text('Sender Public Key: ${widget.senderPublicKey}'),
                pw.Text('Receiver Public Key: ${widget.receiverPublicKey}'),
                pw.Text('Sender IOTA Address: ${widget.senderIotaPublicAddress}'),
                pw.Text('Receiver IOTA Address: ${widget.receiverIotaPublicAddress}'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _generatePdfAndDownload() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Collaboration Details',
                    style: const pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Name: ${widget.collaborationName}'),
                pw.Text('ID: ${widget.timeOrCollaborationId}'),
                pw.Text('Status: ${widget.collaborationStatus}'),
                pw.Text('Transaction ID: ${widget.transactionId}'),
                pw.Text('Sender Public Key: ${widget.senderPublicKey}'),
                pw.Text('Receiver Public Key: ${widget.receiverPublicKey}'),
                pw.Text('Sender IOTA Address: ${widget.senderIotaPublicAddress}'),
                pw.Text('Receiver IOTA Address: ${widget.receiverIotaPublicAddress}'),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${widget.collaborationName}_collaboration_details.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }


  _customFloatingSpeedDialForDetails() {
    return SpeedDial(
      icon: Icons.file_copy_outlined,
      activeIcon: Icons.close,
      spacing: 3,
      mini: mini,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize: buttonSize,
      label: extend ? const Text("Open") : null,
      activeLabel: extend ? const Text("Close") : null,
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: speedDialDirection,
      switchLabelPosition: switchLabelPosition,
      closeManually: closeManually,
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
      children: [
        SpeedDialChild(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.file_copy),
          ),
          backgroundColor: context.theme.primaryColorDark,
          foregroundColor: context.theme.primaryColorLight,
          labelBackgroundColor: context.theme.primaryColorLight,
          label: "Print".tr,
          onTap: () => _generatePdfAndPrint(),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
        SpeedDialChild(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.file_download),
          ),
          backgroundColor: context.theme.primaryColorDark,
          foregroundColor: context.theme.primaryColorLight,
          labelBackgroundColor: context.theme.primaryColorLight,
          label: "Download".tr,
          onTap: () => _generatePdfAndDownload(),
          onLongPress: () => debugPrint('StartNewCollaboration LONG PRESS'),
        ),
      ],
    );
  }

}
