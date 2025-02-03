import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:unify_secret/data/local/constants.dart';
import 'package:unify_secret/ui/features/auth/welcome_screen/welcome_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/collaboration/collaboration_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/immutability_check/immutability_check_screen.dart';
import 'package:unify_secret/ui/features/download_backup/zip_and_download_screen.dart';
import 'package:unify_secret/ui/features/bottom_navigation/profile/profile_screen.dart';
import 'package:unify_secret/ui/features/privacy_policy/privacy_policy_show_screen.dart';
import 'package:unify_secret/ui/features/settings/settings_screen.dart';
import 'package:unify_secret/ui/helper/app_helper.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/colors.dart';
import 'package:unify_secret/utils/common_utils.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'root_controller.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  final RootController _rootController = Get.put(RootController());
  final NotchBottomBarController _controller = NotchBottomBarController(index: 1);
  final _pageController = PageController(initialPage: 1);



  @override
  void initState() {
    super.initState();
    _rootController.changeBottomNavIndex = changeBottomNavTab;
  }

  @override
  void dispose() {
    hideKeyboard();
    super.dispose();
  }

/*  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const ProfileScreen(),
      const CollaborationScreen(),
      const ImmutabilityCheckScreen()
    ];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            GlobalVariables.gIsDarkMode ? Brightness.light : Brightness.dark));
    GlobalVariables.currentContext = context;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      drawer: _getDrawerView(),
      drawerScrimColor: Colors.transparent,
      bottomNavigationBar: _bottomNavigationBar(),
      // body: SafeArea(child: _getBody()),
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),

      // floatingActionButtonLocation: selectedfABLocation,
      // floatingActionButton: _customFloatingSpeedDial(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const ProfileScreen(),
      const CollaborationScreen(),
      const ImmutabilityCheckScreen()
    ];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        GlobalVariables.gIsDarkMode ? Brightness.light : Brightness.dark));
    GlobalVariables.currentContext = context;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      drawer: _getDrawerView(),
      drawerScrimColor: Colors.transparent,
      bottomNavigationBar: _bottomNavigationBar(context),
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
    );
  }

  void changeBottomNavTab(int index) async {
    setState(() => _rootController.bottomNavIndex = index);
  }


/*  _bottomNavigationBar() {
    return AnimatedNotchBottomBar(
      /// Provide NotchBottomBarController
      notchBottomBarController: _controller,
      color: cExtraLight,
      showLabel: false,
      textOverflow: TextOverflow.visible,
      maxLine: 1,
      shadowElevation: 15,
      kBottomRadius: 28.0,
      notchColor: context.theme.cardColor,

      /// restart app if you change removeMargins
      removeMargins: false,
      bottomBarWidth: 400.0,
      bottomBarHeight: 56.0,
      showShadow: false,
      durationInMilliSeconds: 300,
      itemLabelStyle: const TextStyle(fontSize: 10),
      elevation: 5,
      showBlurBottomBar: true,
      blurOpacity: 0.8,
      blurFilterX: 5.0,
      blurFilterY: 10.0,
      // pageController: _pageController,
      bottomBarItems: [
        BottomBarItem(
          inActiveItem: SvgPicture.asset(
            AssetConstants.icProfile,
            color: context.theme.secondaryHeaderColor,
          ),
          activeItem: SvgPicture.asset(
            AssetConstants.icProfile,
            color: context.theme.primaryColorDark,
          ),
          itemLabel: 'Profile',
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset(
            AssetConstants.icFolder,
            color: context.theme.secondaryHeaderColor,
          ),
          activeItem: SvgPicture.asset(
            AssetConstants.icFolder,
            color: context.theme.primaryColorDark,
            width: 0,
            height: 10,
          ),
          itemLabel: 'Collaboration',
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset(
            AssetConstants.icFileChecked,
            color: context.theme.secondaryHeaderColor,
          ),
          activeItem: SvgPicture.asset(
            AssetConstants.icFileChecked,
            color: context.theme.primaryColorDark,
          ),
          itemLabel: 'Immutability Check',
        )
      ],
      onTap: (index) {
        // log('current selected index $index');
        _pageController.jumpToPage(index);
      },
      kIconSize: 23.0,
    );
  }*/
  _bottomNavigationBar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: cExtraLight,
      showLabel: false,
      textOverflow: TextOverflow.visible,
      maxLine: 1,
      shadowElevation: 15,
      kBottomRadius: 28.0,
      notchColor: context.theme.cardColor,
      removeMargins: false,
      bottomBarWidth: screenWidth,  // Use the full width of the screen
      bottomBarHeight: 56.0,
      showShadow: false,
      durationInMilliSeconds: 300,
      itemLabelStyle: const TextStyle(fontSize: 10),
      elevation: 5,
      showBlurBottomBar: true,
      blurOpacity: 0.8,
      blurFilterX: 5.0,
      blurFilterY: 10.0,
      bottomBarItems: [
        BottomBarItem(
          inActiveItem: SvgPicture.asset(
            AssetConstants.icProfile,
            color: context.theme.secondaryHeaderColor,
          ),
          activeItem: SvgPicture.asset(
            AssetConstants.icProfile,
            color: context.theme.primaryColorDark,
          ),
          itemLabel: 'Profile',
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset(
            AssetConstants.icStartNewCollaboration,
            color: context.theme.secondaryHeaderColor,
          ),
          activeItem: SvgPicture.asset(
            AssetConstants.icStartNewCollaboration,
            color: context.theme.primaryColorDark,
            width: 0,
            height: 10,
          ),
          itemLabel: 'Collaboration',
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset(
            AssetConstants.icFileChecked,
            color: context.theme.secondaryHeaderColor,
          ),
          activeItem: SvgPicture.asset(
            AssetConstants.icFileChecked,
            color: context.theme.primaryColorDark,
          ),
          itemLabel: 'Immutability Check',
        )
      ],
      onTap: (index) {
        _pageController.jumpToPage(index);
      },
      kIconSize: 23.0,
    );}

  _getDrawerView() {
    return Drawer(
      elevation: 0,
      width: context.width - 150,
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          height: Get.height,
          decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimens.cornerRadiusLarge),
                  bottomRight: Radius.circular(Dimens.cornerRadiusLarge))),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.paddingLarge, vertical: 8),
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(
                      AssetConstants.icCross,
                      color: context.theme.primaryColorDark,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
              vSpacer10(),
              const AppLogo(),
              vSpacer30(),
              const Divider(),
              // _drawerNavMenuItem("Settings".tr, Icons.settings,
              //     () => Get.to(() => const SettingsScreen())),
              // vSpacer10(),
              _drawerNavMenuItem("Privacy Policy".tr, Icons.privacy_tip,
                  () => Get.to(() => const PrivacyPolicyShowScreen())),
              vSpacer10(),
              _drawerNavMenuItem("Download Profile Backup".tr, Icons.download,
                      () => Get.to(() => const ZipAndDownloadScreen())),
              vSpacer10(),
              _drawerNavMenuItem("Log Out".tr, Icons.logout,
                  () => Get.offAll(() => const WelcomeScreen())),
              const Spacer(),
              TextAutoPoppins(getCommonSettingsLocal()?.copyrightText ?? ""),
              vSpacer10()
            ],
          ),
        ),
      ),
    );
  }


  _drawerNavMenuItem(String navTitle, IconData icon, VoidCallback navAction) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: Dimens.paddingLarge),
      leading: Icon(
        icon,
        size: Dimens.iconSizeMid,
        color: context.theme.primaryColorDark,
      ),
      title: TextAutoMetropolis(navTitle,
          fontSize: Dimens.fontSizeRegular, textAlign: TextAlign.left),
      onTap: navAction,
    );
  }
}
