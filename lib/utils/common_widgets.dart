import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'package:url_launcher/url_launcher.dart';


import 'dimens.dart';

class EmptyViewWithLoading extends StatelessWidget {
  const EmptyViewWithLoading(
      {super.key, this.message, required this.isLoading, this.height});

  final bool isLoading;
  final String? message;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final messageL = message ?? "No data available".tr;
    return SizedBox(
      height: height ?? 50,
      child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: context.theme.focusColor)
              : TextAutoPoppins(messageL, maxLines: 3)),
    );
  }
}

class ScreenStepForAccountCreation extends StatelessWidget {
  const ScreenStepForAccountCreation({
    super.key,
    this.isActive11,
    this.isActive12,
    this.isActive13,
    this.isActive14,
    // this.isActive15
  });

  final Color? isActive11;
  final Color? isActive12;
  final Color? isActive13;
  final Color? isActive14;

  // final Color? isActive15;

  @override
  Widget build(BuildContext context) {
    final isActive1 = isActive11 ?? context.theme.disabledColor;
    final isActive2 = isActive12 ?? context.theme.disabledColor;
    final isActive3 = isActive13 ?? context.theme.disabledColor;
    final isActive4 = isActive14 ?? context.theme.disabledColor;
    // final isActive5 = isActive15 ?? context.theme.disabledColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 35.0, // Width of the circle
          height: 35.0, // Height of the circle
          decoration: BoxDecoration(
            color: isActive1, // Background color of the circle
            shape: BoxShape.circle, // Shape of the container
          ),
          child: Center(
            child: TextAutoMetropolis(
              "1",
              color: context.theme.primaryColorLight, // Text color
              fontSize: 20.0, // Font size of
            ),
          ),
        ),
        TextAutoPoppins(
          '-----',
          color: context.theme.primaryColorDark,
        ),
        Container(
          width: 35.0, // Width of the circle
          height: 35.0, // Height of the circle
          decoration: BoxDecoration(
            color: isActive2, // Background color of the circle
            shape: BoxShape.circle, // Shape of the container
          ),
          child: Center(
            child: TextAutoMetropolis(
              "2",
              color: context.theme.primaryColorLight,
              fontSize: 20.0, // Font size of
            ),
          ),
        ),
        TextAutoPoppins(
          '-----',
          color: context.theme.primaryColorDark,
        ),
        Container(
          width: 35.0, // Width of the circle
          height: 35.0, // Height of the circle
          decoration: BoxDecoration(
            color: isActive3, // Background color of the circle
            shape: BoxShape.circle, // Shape of the container
          ),
          child: Center(
            child: TextAutoMetropolis(
              "3",
              color: context.theme.primaryColorLight,
              fontSize: 20.0, // Font size of
            ),
          ),
        ),
        TextAutoPoppins(
          '-----',
          color: context.theme.primaryColorDark,
        ),
        Container(
          width: 35.0, // Width of the circle
          height: 35.0, // Height of the circle
          decoration: BoxDecoration(
            color: isActive4, // Background color of the circle
            shape: BoxShape.circle, // Shape of the container
          ),
          child: Center(
            child: TextAutoMetropolis(
              "4",
              color: context.theme.primaryColorLight,
              fontSize: 20.0, // Font size of
            ),
          ),
        ),
/*        const Text('-----'),
        Container(
          width: 35.0, // Width of the circle
          height: 35.0, // Height of the circle
          decoration: BoxDecoration(
            color: isActive5, // Background color of the circle
            shape: BoxShape.circle, // Shape of the container
          ),
          child: const Center(
            child: Text(
              "5",
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 20.0, // Font size of the number
                fontWeight: FontWeight.bold, // Font weight of the number
              ),
            ),
          ),
        ),*/
      ],
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key, this.padding, this.size}) : super(key: key);
  final double? padding;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 15),
      child: Center(
          child: SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                  color: Theme.of(context).focusColor))),
    );
  }
}

class SegmentedControlView extends StatelessWidget {
  const SegmentedControlView(this.list, this.selected,
      {Key? key, this.onChange})
      : super(key: key);
  final int selected;
  final Function(int)? onChange;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).textScaleFactor > 1
        ? Dimens.fontSizeSmall
        : Dimens.fontSizeRegular;
    final Map<int, Widget> segmentValues = <int, Widget>{};

    for (int i = 0; i < list.length; i++) {
      segmentValues[i] = Text(list[i],
          style: context.theme.textTheme.titleSmall!.copyWith(
              fontSize: fontSize,
              color: selected == i ? Colors.white : context.theme.primaryColor),
          textAlign: TextAlign.center);
    }

    return CupertinoSlidingSegmentedControl(
        groupValue: selected,
        children: segmentValues,
        thumbColor: context.theme.focusColor,
        backgroundColor: Colors.grey.withOpacity(0.25),
        padding: const EdgeInsets.all(Dimens.paddingMin),
        onValueChanged: (i) {
          if (onChange != null) onChange!(i as int);
        });
  }
}

// class DividerVertical extends StatelessWidget {
//   const DividerVertical({Key? key, this.color, this.width = 10, this.height, this.indent}) : super(key: key);
//   final Color? color;
//   final double width;
//   final double? height;
//   final double? indent;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(height: height, child: VerticalDivider(width: width, color: color, thickness: 2, endIndent: indent, indent: indent));
//   }
// }

class DividerHorizontal extends StatelessWidget {
  const DividerHorizontal(
      {Key? key,
      this.color,
      this.width,
      this.height = 10,
      this.indent,
      this.thickness = 0.5})
      : super(key: key);
  final Color? color;
  final double? width;
  final double height;
  final double? indent;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: Divider(
            height: height,
            color: color,
            thickness: thickness,
            endIndent: indent,
            indent: indent));
  }
}

boxDecorationRound(BuildContext context) => BoxDecoration(
    color: Theme.of(context).focusColor.withOpacity(0.1),
    borderRadius:
        const BorderRadius.all(Radius.circular(Dimens.cornerRadiusMid)));

Widget handleEmptyViewWithLoading(bool isLoading,
    {double height = 50, String? message}) {
  String message0 = message ?? "Sorry! Data not found".tr;
  return Container(
      margin: const EdgeInsets.all(20),
      height: height,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : TextAutoMetropolis(
                message0,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
      ));
}

class LoadingDialog extends StatelessWidget {
  final String message;
  final BuildContext context;

  const LoadingDialog(
      {super.key, required this.message, required this.context});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: context.theme.primaryColorDark),
            const SizedBox(height: 20),
            TextAutoPoppins(
              message,
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

Widget handleEmptyViewWithLoadingForProfileCreation(
    BuildContext context, bool isLoading,
    {double height = 50, String? message}) {
  String message0 = message ?? "Sorry! Data not found".tr;
  return Container(
      margin: const EdgeInsets.all(16),
      height: Get.height,
      width: Get.width,
      child: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: context.theme.focusColor),
                vSpacer10(),
                const TextAutoMetropolis(
                  "Please wait !\nProfile is creating . . . .",
                  maxLines: 10,
                  fontSize: Dimens.fontSizeMid,
                  textAlign: TextAlign.center,
                )
              ],
            )
          : TextAutoMetropolis(
              message0,
              maxLines: 2,
              textAlign: TextAlign.center,
            ));
}
Widget handleEmptyViewWithLoadingForStatusUpdate(
    BuildContext context, bool isLoading,
    {double height = 50, String? message}) {
  String message0 = message ?? "Sorry! There is no data to update".tr;
  return Container(
      margin: const EdgeInsets.all(16),
      height: Get.height,
      width: Get.width,
      child: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: context.theme.focusColor),
                vSpacer10(),
                const TextAutoMetropolis(
                  "Please wait !. . . .",
                  maxLines: 10,
                  fontSize: Dimens.fontSizeMid,
                  textAlign: TextAlign.center,
                )
              ],
            )
          : TextAutoMetropolis(
              message0,
              maxLines: 2,
              textAlign: TextAlign.center,
            ));
}

Widget handleAcceptCollaborationInvitation(BuildContext context, bool isLoading,
    {double height = 50, String? message}) {
  String message0 = message ?? "Sorry! Data not found".tr;
  return Container(
      margin: const EdgeInsets.all(16),
      height: Get.height,
      width: Get.width,
      child: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: context.theme.focusColor),
                vSpacer10(),
                const TextAutoMetropolis(
                  "Please wait !.",
                  maxLines: 10,
                  fontSize: Dimens.fontSizeMid,
                  textAlign: TextAlign.center,
                )
              ],
            )
          : TextAutoMetropolis(
              message0,
              maxLines: 2,
              textAlign: TextAlign.center,
            ));
}

class DocumentsLockedItemDetailsView extends StatelessWidget {
  const DocumentsLockedItemDetailsView({
    super.key,
    required this.context,
    required this.documentRealName,
    this.fileTitle,
    this.assetName,
    this.bgColor,
    this.trailingIcon,
    this.onTap,
    this.onTapDownload,
  });

  final BuildContext? context;
  final String? documentRealName;
  final String? fileTitle;
  final String? assetName;
  final Color? bgColor;
  final Icon? trailingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onTapDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      // onTap: onTap,
      onTap: onTapDownload,
      child: Card(
        elevation: 10.0,
        color: bgColor ?? context.theme.primaryColorLight,
        child: Container(
          //decoration: getRoundCornerBox(color: white),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // height: 190,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAutoMetropolis(fileTitle!,
                      fontSize: Dimens.fontSizeRegular),
                  vSpacer10(),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: SizedBox(
                      width: 25,
                      child: SvgPicture.asset(
                        assetName ?? AssetConstants.icDocuments,
                        color: context.theme.focusColor,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoMetropolis(
                          documentRealName!,
                          fontSize: Dimens.fontSizeRegular,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    // trailing: iconView(icon: Icons.download,iconSize:20,onPressCallback: onTapDownload),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentsItemDetailsView extends StatelessWidget {
  const DocumentsItemDetailsView({
    super.key,
    required this.context,
    required this.documentRealName,
    this.fileTitle,
    this.assetName,
    this.bgColor,
    this.trailingIcon,
    this.onTap,
    this.onTapDownload,
  });

  final BuildContext? context;
  final String? documentRealName;
  final String? fileTitle;
  final String? assetName;
  final Color? bgColor;
  final Icon? trailingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onTapDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      // onTap: onTap,
      onTap: onTapDownload,
      child: Card(
        elevation: 10.0,
        color: bgColor ?? context.theme.primaryColorLight,
        child: Container(
          //decoration: getRoundCornerBox(color: white),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // height: 190,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAutoMetropolis(fileTitle!,
                      fontSize: Dimens.fontSizeRegular),
                  vSpacer10(),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: SizedBox(
                      width: 25,
                      child: SvgPicture.asset(
                        assetName ?? AssetConstants.icDocuments,
                        color: context.theme.focusColor,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoMetropolis(
                          documentRealName!,
                          fontSize: Dimens.fontSizeRegular,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    trailing: iconView(
                        icon: Icons.download,
                        iconSize: 20,
                        onPressCallback: onTapDownload),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentsItemView extends StatelessWidget {
  const DocumentsItemView(
      {super.key,
      required this.context,
      required this.titleText,
      this.bgColor,
      this.iconColor,
      this.onTap});

  final BuildContext? context;
  final String? titleText;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      // onTap: () => Get.to(const DetailsScreen()),
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        color: bgColor,
        child: Container(
          //decoration: getRoundCornerBox(color: white),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          // height: 190,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: SizedBox(
                      width: 25,
                      child: SvgPicture.asset(
                        AssetConstants.icDocument,
                        color: context.theme.focusColor,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoMetropolis(
                          titleText!,
                          fontSize: Dimens.fontSizeRegular,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    trailing: iconView(
                        icon: Icons.share,
                        iconSize: 20,
                        iconColor: iconColor ?? context.theme.disabledColor),
                    // trailing: const Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     // StatusIndicator(status: 'pending'),
                    //     // SizedBox(height: 20),
                    //     StatusIndicator(status: 'accepted'),
                    //   ],
                    // ),
                  ),

                  // OnlyIcon(
                  //   iconData: Icons.pending,
                  //   onTap: () {
                  //     // onTap;
                  //   },
                  // ),
                  // ),
                ],
              ),
              // InkWell(
              //   onTap: () {},
              //   child: SvgPicture.asset(
              //     AssetConstants.icCross,
              //     color: context.theme.primaryColorDark,
              //     height: 20,
              //     width: 20,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


class DocumentsItemView1 extends StatelessWidget {
  const DocumentsItemView1({
    super.key,
    required this.context,
    required this.titleText,
    this.bgColor,
    this.iconColor,
    this.onTap,
    this.fileOriginalName,
  });

  final BuildContext context;
  final String titleText;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? fileOriginalName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate the count of items in the fileOriginalName string
    int itemCount = 0;
    if (fileOriginalName != null && fileOriginalName!.isNotEmpty) {
      try {
        // Convert string to list and get the count
        List<dynamic> list = jsonDecode(fileOriginalName!);
        itemCount = list.length;
      } catch (e) {
        // Handle parsing error
        print('Error parsing fileOriginalName: $e');
      }
    }

    // Determine which icon to display
    String iconPath = itemCount > 1
        ? AssetConstants.icMultipleDocument
        : AssetConstants.icDocument;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        color: bgColor ?? theme.cardColor,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: SizedBox(
                      width: 30, // Increased width for better visibility
                      height: 30, // Increased height for better visibility
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SvgPicture.asset(
                            iconPath,
                            color: context.theme.focusColor,height: 40,width: 40,
                          ),
                          if (itemCount > 0) // Show the count above the icon if multiple items
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$itemCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10, // Adjust font size as needed
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    title: Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 16, // Adjust font size as needed
                      ),
                    ),
                    trailing: Icon(
                      Icons.share,
                      color: iconColor ?? context.theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*class CollaborationItemView extends StatelessWidget {
  const CollaborationItemView(
      {super.key,
      required this.context,
      required this.titleText,
      this.bgColor,
      this.onTap});

  final BuildContext? context;
  final String? titleText;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      // onTap: () => Get.to(const DetailsScreen()),
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        color: bgColor,
        child: Container(
          //decoration: getRoundCornerBox(color: white),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          // height: 190,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading:  ButtonOnlyCircleIcon(
                        iconData: Icons.people_alt_outlined, iconColor: context.theme.primaryColorDark,),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoMetropolis(
                          titleText!,
                          fontSize: 16,
                          textAlign: TextAlign.start,maxLines: 2,
                        ),
                        // const Row(
                        //   children: [
                        //     TextAutoMetropolis(
                        //       "0 Documents",
                        //       fontSize: Dimens.fontSizeSmall,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    trailing: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // StatusIndicator(status: 'pending'),
                        // SizedBox(height: 20),
                        StatusIndicator(status: 'accepted'),
                      ],
                    ),
                  ),

                  // OnlyIcon(
                  //   iconData: Icons.pending,
                  //   onTap: () {
                  //     // onTap;
                  //   },
                  // ),
                  // ),
                ],
              ),
              // InkWell(
              //   onTap: () {},
              //   child: SvgPicture.asset(
              //     AssetConstants.icCross,
              //     color: context.theme.primaryColorDark,
              //     height: 20,
              //     width: 20,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}*/

class ImmutabilityCheckItemView extends StatelessWidget {
  const ImmutabilityCheckItemView(
      {super.key,
      required this.context,
      required this.titleText,
      required this.iconData,
      required this.status,
      this.bgColor,
      this.onTap});

  final BuildContext? context;
  final String? titleText;
  final String? iconData;
  final String? status;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 5.0,
          color: bgColor,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: CircleIconSvg(
                        iconData: iconData,
                        iconColor: context.theme.primaryColorDark)),
                hSpacer10(),
                Expanded(
                    flex: 7,
                    child: TextAutoMetropolis(
                      titleText!,
                      fontSize: Dimens.fontSizeRegular,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    )),
                // Expanded(flex:1, child: StatusIndicator(status: status!)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class CollaborationItemView2 extends StatelessWidget {
  const CollaborationItemView2(
      {super.key,
      required this.context,
      required this.titleText,
      required this.status,
      this.bgColor,
      this.onTap});

  final BuildContext? context;
  final String? titleText;
  final String? status;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 5.0,
          color: bgColor,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    // child: SvgPicture.asset(AssetConstants.icStartNewCollaboration,color: context.theme.primaryColorDark, height: 22, width: 22)),

                    // child: ButtonOnlyCircleIcon(
                    //     iconData: Icons.people_alt_outlined,
                    //     iconColor: context.theme.primaryColorDark)),
                    child: SvgCircleIcon(
                        iconName: AssetConstants.icStartNewCollaboration,
                        iconColor: context.theme.primaryColorDark)),
                Expanded(
                    flex: 4,
                    child: TextAutoMetropolis(
                      titleText!,
                      fontSize: Dimens.fontSizeRegular,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    )),
                Expanded(flex: 1, child: StatusIndicator(status: status!)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final String status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String displayText;

    switch (status) {
      case 'pending':
        icon = Icons.hourglass_empty;
        color = context.theme.primaryColorDark;
        displayText = 'Pending';
        break;
      case 'accepted':
        icon = Icons.check_circle;
        color = context.theme.primaryColorDark;
        displayText = 'Accepted';
        break;
      case 'declined':
        icon = Icons.close;
        color = context.theme.primaryColorDark;
        displayText = 'Accepted';
        break;
      default:
        icon = Icons.help;
        color = context.theme.primaryColorDark;
        displayText = 'Unknown Status';
    }

    return SizedBox(
      width: Get.width / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // TextAutoMetropolis(displayText ?? '', fontSize: Dimens.fontSizeRegular),
          const SizedBox(width: 10),
          Icon(
            icon,
            color: color,
          ),
        ],
      ),
    );
  }
}

class ProfileDetailsCard extends StatelessWidget {
  final String userName;
  final String userPublicAddress;
  final String userPublicKey;

  const ProfileDetailsCard({
    super.key,
    required this.userName,
    required this.userPublicAddress,
    required this.userPublicKey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: context.theme.primaryColorLight,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildRow('User Name:', userName),
            buildRow('User Public Address:', userPublicAddress),
            buildRow('UserPublicKey:', userPublicKey),
          ],
        ),
      ),
    );
  }
}

class CollaborationCard extends StatelessWidget {
  final String id;
  final String collaborationName;
  final String collaborationId;
  final String collaborationStatus;
  final String transactionId;
  final String senderIotaAddress;
  final String receiverIotaAddress;
  final String senderPublicKey;
  final String receiverPublicKey;

  const CollaborationCard({
    super.key,
    required this.id,
    required this.collaborationName,
    required this.collaborationId,
    required this.collaborationStatus,
    required this.transactionId,
    required this.senderIotaAddress,
    required this.receiverIotaAddress,
    required this.senderPublicKey,
    required this.receiverPublicKey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: context.theme.primaryColorLight,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildRow('ID:', id),
            buildRow('Collaboration Name:', collaborationName),
            buildRow('Collaboration ID:', collaborationId),
            buildStatusRow(
                'Collaboration Status:', collaborationStatus, context),
            // const StatusIndicator(status: 'pending'),
            buildRow('Transaction ID:', transactionId),
            buildRow('Sender IOTA Address:', senderIotaAddress),
            buildRow('Receiver IOTA Address:', receiverIotaAddress),
            buildRow('Sender Public Key:', senderPublicKey),
            buildRow('Receiver Public Key:', receiverPublicKey),
          ],
        ),
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final String collaborationId;
  final String documentName;
  final String documentShareStatus;
  final String filePath;
  final String fileId;
  final String fileOriginalName;
  final String generateKeyFileForSymmetricCryptography;
  final String symmetricEncryptFile;
  final String asymmetricEncryptFile;
  final String asymmetricDecryptFile;
  final String symmetricDecryptFile;
  final String originalFileHash;
  final String symmetricEncryptFileHash;
  final String ownDocument;
  final String originalFileHashTransactionId;
  final String symmetricEncryptFileHashTransactionId;
  final String asymmetricDecryptFileHash;
  final String asymmetricDecryptFileHashTransactionId;
  final String isCryptographicKeyShared;
  final String cryptographicKeyTransactionId;

  final String isFileEncrypted;

  const DocumentCard({
    super.key,
    required this.collaborationId,
    required this.documentName,
    required this.documentShareStatus,
    required this.filePath,
    required this.fileId,
    required this.fileOriginalName,
    required this.generateKeyFileForSymmetricCryptography,
    required this.symmetricEncryptFile,
    required this.asymmetricEncryptFile,
    required this.asymmetricDecryptFile,
    required this.symmetricDecryptFile,
    required this.originalFileHash,
    required this.symmetricEncryptFileHash,
    required this.ownDocument,
    required this.originalFileHashTransactionId,
    required this.symmetricEncryptFileHashTransactionId,
    required this.asymmetricDecryptFileHash,
    required this.asymmetricDecryptFileHashTransactionId,
    required this.isCryptographicKeyShared,
    required this.cryptographicKeyTransactionId,
    required this.isFileEncrypted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: context.theme.primaryColorLight,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildRow('collaborationId:', collaborationId),
            buildRow('document Name:', documentName),
            buildRow('documentShareStatus:', documentShareStatus.toString()),
            buildRow('isFileEncrypted:', isFileEncrypted.toString()),
            buildRow2('filePath:', filePath),
            buildRow('fileId:', fileId),
            buildRow('fileOriginalName:', fileOriginalName),
            buildRow2('generateKeyFileForSymmetricCryptography:',
                generateKeyFileForSymmetricCryptography),
            buildRow2('symmetricEncryptFile:', symmetricEncryptFile),
            buildRow2('asymmetricEncryptFile:', asymmetricEncryptFile),
            buildRow('asymmetricDecryptFile:', asymmetricDecryptFile),
            buildRow('symmetricDecryptFile:', symmetricDecryptFile),
            buildRow2('originalFileHash:', originalFileHash),
            buildRow2('symmetricEncryptFileHash:', symmetricEncryptFileHash),
            buildRow('ownDocument:', ownDocument.toString()),

            //buildRow2('originalFileHashTransactionId:', originalFileHashTransactionId),
            //buildRow2('symmetricEncryptFileHashTransactionId:', symmetricEncryptFileHashTransactionId),

            buildUrlLauncher('Original File Hash Transaction', originalFileHashTransactionId),
            buildUrlLauncher('Symmetric Encrypt File Hash Transaction', symmetricEncryptFileHashTransactionId),

            buildRow2('asymmetricDecryptFileHash:',
                asymmetricDecryptFileHash),
            buildRow2('asymmetricDecryptFileHashTransactionId:',
                asymmetricDecryptFileHashTransactionId),
            buildRow2('isCryptographicKeyShared:',
                isCryptographicKeyShared.toString()),
            buildRow2('cryptographicKeyTransactionId:',
                cryptographicKeyTransactionId.toString()),
          ],
        ),
      ),
    );
  }
}

Widget getTabView({
  List<String>? titles,
  TabController? controller,
  Function(int)? onTap,
  TabBarIndicatorSize indicatorSize = TabBarIndicatorSize.tab,
  List<String>? icons,
}) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Get.theme.primaryColor, width: 0.5))),
    child: TabBar(
      controller: controller,
      labelColor: Get.theme.primaryColor,
      labelStyle: Get.textTheme.titleMedium!
          .copyWith(fontWeight: FontWeight.bold, fontSize: Dimens.fontSizeMid),
      unselectedLabelStyle:
          Get.textTheme.titleMedium!.copyWith(fontSize: Dimens.fontSizeRegular),
      unselectedLabelColor: Get.theme.primaryColor,
      labelPadding: const EdgeInsets.only(left: 0, right: 0),
      indicatorColor: Get.theme.primaryColorDark,
      indicatorSize: indicatorSize,
      tabs: List.generate(titles != null ? titles.length : icons!.length,
          (index) {
        return Tab(
            text: (icons == null && titles != null) ? titles[index] : null,
            icon: (icons != null && titles == null)
                ? SvgPicture.asset(icons[index])
                : null,
            child: (icons != null && titles != null)
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SvgPicture.asset(icons[index]),
                    const SizedBox(width: 5),
                    Text(titles[index])
                  ])
                : null);
      }),
      onTap: (int x) {
        if (onTap != null) onTap(x);
      },
    ),
  );
}

Widget buildStatusRow(String label, String status, BuildContext context) {
  IconData icon;
  Color color;

  switch (status.toLowerCase()) {
    case 'pending':
      icon = Icons.hourglass_empty;
      color = context.theme.primaryColorDark;
      break;
    case 'accepted':
      icon = Icons.check_circle;
      color = context.theme.primaryColorDark;
      break;
    case 'rejected':
      icon = Icons.cancel;
      color = Colors.red;
      break;
    default:
      icon = Icons.help;
      color = Colors.grey;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(width: 8.0),
        Icon(
          icon,
          color: color,
          size: 22,
        ),
        const SizedBox(width: 4.0),
        Text(
          status,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    ),
  );
}

Widget buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextAutoMetropolis(
          label,
          fontSize: Dimens.fontSizeRegular,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextAutoPoppins(
            value,
            maxLines: 100,
          ),
        ),
      ],
    ),
  );
}

Widget buildUrlLauncher(String label, String url) {
  // Clean the URL to remove any extra quotes
  String cleanUrl = url.replaceAll('"', '').trim();

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 16.0), // Adjust as needed
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse("https://explorer.iota.org/shimmer-testnet/transaction/$cleanUrl");
            print('Launching URL: ${uri.toString()}'); // Debug print

            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                print('Could not launch URL: ${uri.toString()}');
              }
            } catch (e) {
              print('Error launching URL: $e');
            }
          },

          child: Text(
            cleanUrl,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 16.0, // Adjust as needed
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget buildUrlLauncher3(String label, String url) {
  // Clean the URL to remove any extra quotes
  String cleanUrl = url.replaceAll('"', '').trim();

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 16.0), // Adjust as needed
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse("https://explorer.iota.org/shimmer-testnet/transaction/$cleanUrl");
            print('Launching URL: ${uri.toString()}'); // Debug print

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $uri';
            }
          },
          child: Text(
            cleanUrl,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 16.0, // Adjust as needed
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget buildUrlLauncher2(String label, String url) {

  print('urlPrint');
  print(url);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 16.0), // Adjust as needed
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final encodedUrl = Uri.encodeComponent(url);
            final uri = Uri.parse("https://explorer.iota.org/shimmer-testnet/transaction/$encodedUrl");
            print('Launching URL: ${uri.toString()}'); // Debug print

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $uri';
            }
          },
          child: TextAutoPoppins(
            url,
            color: Colors.blue,
            decoration: TextDecoration.underline,
            maxLines: 100,
          ),
        ),
      ],
    ),
  );
}

Widget buildUrlLauncher1(String label, String url) {
  print(url);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextAutoMetropolis(
          label,
          fontSize: Dimens.fontSizeRegular,
        ),
        const SizedBox(width: 8.0),
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse("https://explorer.iota.org/shimmer-testnet/transaction/$url");
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: TextAutoPoppins(
            url,
            color: Colors.blue,
            decoration: TextDecoration.underline,
            maxLines: 100,
          ),
        ),
      ],
    ),
  );
}

Widget buildRow2(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextAutoMetropolis(
          label,
          fontSize: Dimens.fontSizeRegular,
        ),
        const SizedBox(width: 8.0),
        TextAutoPoppins(
          value,
          maxLines: 100,
        ),
      ],
    ),
  );
}

class EventItemView extends StatelessWidget {
  const EventItemView(
      {super.key,
      required this.context,
      required this.titleText,
      this.bgColor,
      this.onTap});

  final BuildContext? context;
  final String? titleText;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          // onTap: () => Get.to(const DetailsScreen()),
          child: Card(
            elevation: 4.0,
            color: bgColor,
            child: Container(
              //decoration: getRoundCornerBox(color: white),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              // height: 190,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        leading: const ButtonOnlyCircleIcon(
                            iconData: Icons.people_alt_outlined),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextAutoMetropolis(
                              titleText!,
                              fontSize: Dimens.fontSizeRegular,
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      TextAutoMetropolis(
                                        "0 Documents",
                                        fontSize: Dimens.fontSizeSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      iconView(
                                          icon: Icons.business_center_outlined,
                                          iconSize: 20),
                                      hSpacer5(),
                                      const TextAutoMetropolis("Xyz Company",
                                          fontSize: Dimens.fontSizeSmall),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: OnlyIcon(
                          iconData: Icons.more_vert,
                          onTap: () {
                            onTap;
                          },
                        ),
                      ),
                    ],
                  ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: SvgPicture.asset(
                  //     AssetConstants.icCross,
                  //     color: context.theme.primaryColorDark,
                  //     height: 20,
                  //     width: 20,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget iconView(
    {IconData? icon,
    VoidCallback? onPressCallback,
    Color? iconColor,
    double? iconSize}) {
  return InkWell(
    onTap: onPressCallback,
    child: Icon(
      icon!,
      size: iconSize,
      color: iconColor,
    ),
  );
}
