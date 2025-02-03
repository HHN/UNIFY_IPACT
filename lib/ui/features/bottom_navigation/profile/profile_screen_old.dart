import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/common_widgets.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _controller = Get.put(ProfileController());
  late Box<User> userBox;
  late User data;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('users');

    if (userBox.isNotEmpty) {
      data = userBox.values.first;
      print('--------------userPublicAddress');
      print(data.userPublicAddress.toString());
      _controller.userPublicAddress.value = data.userPublicAddress.toString();
      _controller.userPublicKey.value = data.userPublicKey.toString();
      _controller.userName.value = data.userName.toString();
    } else {
      // empty state
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _controller.userPublicAddress.toString()));
    Get.snackbar('Copied', 'User Profile Address copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarMain(title: "Profile".tr, context: context),
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                vSpacer20(),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircleAvatar(
                    radius: 0,
                    backgroundColor:
                    context.theme.dividerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        AssetConstants.icProfile,
                        color: context.theme.primaryColorDark,height: 100,
                      ),
                    ),
                  ),
                ),
                Obx((){
                  return Center(
                    child: ProfileDetailsCard(
                      userName: _controller.userName.toString(),
                      userPublicAddress: _controller.userPublicAddress.toString(),
                      userPublicKey: _controller.userPublicKey.toString(),
                    ),
                  );
                })

                // Stack(
                //   children: [
                //     Card(
                //       elevation: 5,
                //       color: context.theme.primaryColorLight,
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //         child: Column(
                //           children: [
                //             vSpacer20(),
                //             const Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment
                //               children: [
                //                 TextAutoPoppins(
                //                   'User Profile Address:',
                //                   fontSize: Dimens.fontSizeMid,
                //                   textAlign: TextAlign.center,
                //                   maxLines: 3,
                //                 ),
                //
                //               ],
                //             ),
                //             TextAutoPoppins(
                //               _controller.userPublicAddress.toString(),
                //               fontSize: Dimens.fontSizeMid,
                //               textAlign: TextAlign.center,
                //               maxLines: 2,
                //             ),
                //             vSpacer30(),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Positioned(top:20,right:20,child:
                //     IconButton(
                //       icon: const Icon(Icons.copy,size: 25,),
                //       onPressed: copyToClipboard,
                //     ),)
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
