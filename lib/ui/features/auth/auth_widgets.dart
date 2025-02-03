import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';

class AuthTitleView extends StatelessWidget {
  const AuthTitleView({super.key, required this.title, required this.subTitle, this.subMaxLines});
  final String title;
  final String subTitle;
  final int? subMaxLines;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextAutoMetropolis(title,fontSize: Dimens.fontSizeLarge,color: context.theme.secondaryHeaderColor,),
        vSpacer10(),
        TextAutoPoppins(subTitle, maxLines: subMaxLines,color: context.theme.secondaryHeaderColor),
      ],
    );
  }
}
