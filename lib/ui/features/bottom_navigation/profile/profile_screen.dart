import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ProfileController _controller = Get.put(ProfileController());
  late Box<User> userBox;
  late User? data; // Use nullable User for safety

  @override
  void initState() {
    super.initState();
    // Initialize Hive and load the data safely
    try {
      userBox = Hive.box<User>('users');
      if (userBox.isNotEmpty) {
        data = userBox.values.first;
        _controller.userPublicAddress.value = data!.userPublicAddress ?? '';
        _controller.userPublicKey.value = data!.userPublicKey ?? '';
        _controller.userName.value = data!.userName ?? '';
      } else {
        // Handle empty state if necessary
        data = null;
      }
    } catch (e) {
      print("Error loading Hive box: $e");
      data = null;
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              vSpacer20(),
              // Profile Avatar
              SizedBox(
                height: 150,
                width: 150,
                child: CircleAvatar(
                  backgroundColor: context.theme.dividerColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      AssetConstants.icProfile,
                      color: context.theme.primaryColorDark,
                      height: 100,
                    ),
                  ),
                ),
              ),
              vSpacer20(),
              // Using Obx to handle reactive state changes
              Obx(() {
                return data != null
                    ? ProfileDetailsCard(
                  userName: _controller.userName.value,
                  userPublicAddress: _controller.userPublicAddress.value,
                  userPublicKey: _controller.userPublicKey.value,
                )
                    : Center(
                  child: Text(
                    "No user data available",
                    style: TextStyle(
                      color: context.theme.primaryColorDark,
                      fontSize: 16,
                    ),
                  ),
                );
              }),
              vSpacer20(),
              // Copy Button (You can place this wherever needed in the UI)
              ElevatedButton(
                onPressed: copyToClipboard,
                child: const Text('Copy Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
