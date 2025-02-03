import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unify_secret/ui/features/auth/create_new_profile/create_new_profile_screen.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';

class PrivacyPolicyShowScreen extends StatefulWidget {
  const PrivacyPolicyShowScreen({Key? key}) : super(key: key);

  @override
  PrivacyPolicyShowScreenState createState() => PrivacyPolicyShowScreenState();
}

class PrivacyPolicyShowScreenState extends State<PrivacyPolicyShowScreen>
    with TickerProviderStateMixin {
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWithBack(title: "iPact".tr),
            const Padding(
              padding: EdgeInsets.all(Dimens.paddingLarge),
              child: TextAutoMetropolis(
                "Privacy Policy &\nTerms of service",
                fontSize: Dimens.fontSizeLarge,
                maxLines: 2,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextAutoMetropolis(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        fontSize: Dimens.fontSizeSmall,
                        maxLines: 1000,
                      ),
                      vSpacer10(),
                      const TextAutoMetropolis(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        fontSize: Dimens.fontSizeSmall,
                        maxLines: 1000,
                      ),
                      vSpacer10(),
                      const TextAutoMetropolis(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        fontSize: Dimens.fontSizeSmall,
                        maxLines: 1000,
                      ),
                      vSpacer10(),
                      const TextAutoMetropolis(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        fontSize: Dimens.fontSizeSmall,
                        maxLines: 1000,
                      ),
                      vSpacer10(),
                      const TextAutoMetropolis(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        fontSize: Dimens.fontSizeSmall,
                        maxLines: 1000,
                      ),
                      vSpacer10(),
                    ],
                  ),
                ),
              ),
            ),
            vSpacer10(),
/*
            Row(
              children: <Widget>[
                Checkbox(
                  focusColor: context.theme.primaryColorDark,
                  activeColor: context.theme.primaryColorDark,
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
                  child: Text(
                    'I have read the terms of service and agreed',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: context.theme.primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
            _isChecked == true
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: Get.width / 3.5,
                        child: ButtonFillMain(
                            title: "Continue".tr,
                            onPress: () {
                                    Get.to(() => const CreateNewProfile());
                                  }),
                      ),
                    ),
                  )
                : const SizedBox(height: 0)*/
          ],
        ),
      ),
    );
  }
}
