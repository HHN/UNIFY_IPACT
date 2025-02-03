import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/features/auth/auth_widgets.dart';
import 'package:unify_secret/ui/features/auth/create_new_profile/create_new_profile_controller.dart';
import 'package:unify_secret/ui/features/auth/sign_up/sign_up_screen.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/alert_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';

class CreateNewProfile extends StatefulWidget {
  const CreateNewProfile({super.key});

  @override
  State<CreateNewProfile> createState() => _CreateNewProfileState();
}

class _CreateNewProfileState extends State<CreateNewProfile> {
  final _controller = Get.put(CreateNewProfileController());

  // bool _isCheck = false;

  @override
  void initState() {
    super.initState();
    _controller.callFfiGenerateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    //
    // List<String> splitItems = _controller.mnemonicText.value.split(" ");

    final List<int> numbers = List.generate(24, (index) => index + 1);

    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingLarge),
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 65.0,
                    maxHeight: 65.0,
                    child: Container(
                      color: context.theme.scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          vSpacer10(),
                          ScreenStepForAccountCreation(
                              isActive11: context.theme.focusColor),
                          vSpacer20(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthTitleView(
                              title: "Recovery Phrase".tr,
                              subTitle:
                                  "Keep this private and safely stored. It is important to have a written backup. Computers often fail and files can corrupt"
                                      .tr,
                              subMaxLines: 30),
                          vSpacer30(),
                          Obx(
                            () => _controller.rxSplitItems.isEmpty
                                ? handleEmptyViewWithLoading(
                                    _controller.isLoading)
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 4.0,
                                      childAspectRatio: (1 / .22),
                                    ),
                                    itemCount: _controller.rxSplitItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GridTile(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: context.theme.cardColor
                                                      .withOpacity(0.05),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    // Set border color
                                                    width:
                                                        0.5, // Set border width
                                                  ),
                                                ),
                                                // color: Colors.blue[100],
                                                child: Center(
                                                  child: TextAutoMetropolis(
                                                    '${numbers[index]}. ${_controller.rxSplitItems[index]} ',
                                                    maxLines: 2,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          vSpacer30(),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: Get.width / 3.5,
                              child: ButtonFillMain(
                                  title: "Continue".tr,
                                  onPress: () {
                                    alertForAction(context,
                                        title: "Caution!".tr,
                                        subTitle:
                                            "Did you save the Recovery Phrase?"
                                                .tr,
                                        buttonYesTitle: "Yes".tr,
                                        onYesAction: () {
                                          Get.back();
                                          Get.off(() => SignUpScreen(
                                              mnemonicText: _controller
                                                  .mnemonicText.value));
                                        },
                                        buttonNoTitle: "No".tr,
                                        onNoAction: () {
                                          Get.back();
                                        },
                                        noButtonColor: context.theme.focusColor,
                                        yesButtonColor:
                                            context.theme.focusColor);
                                  }),
                            ),
                          ),
                          vSpacer30(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
