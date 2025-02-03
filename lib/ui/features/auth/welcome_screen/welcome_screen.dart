import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unify_secret/data/models/user.dart';
import 'package:unify_secret/ui/features/auth/login/login_screen.dart';
import 'package:unify_secret/ui/features/privacy_policy/privacy_policy_screen.dart';
import 'package:unify_secret/ui/features/test_screen/test_screen_screen.dart';
import '../../../../utils/button_util.dart';
import '../../../../utils/dimens.dart';
import '../../../../utils/spacers.dart';
import '../../../../utils/text_util.dart';
import '../../../helper/app_widgets.dart';
import '../../../helper/global_variables.dart';
import 'welcome_controller.dart';
import 'package:path/path.dart' as p;


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = Get.put(WelcomeController());
  final _formKey = GlobalKey<FormState>();
  final emailEditController = TextEditingController();
  final passEditController = TextEditingController();
  RxBool isShowPassword = false.obs;

  //Box userBox = Hive.box<UsersCollection>('users');


  late Box<User> userBox;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('users');
  }
  
  Future<String> _getAppInternalDirectory() async {
    // Get the app's internal data directory (/data/data/<your_package_name>/)
    Directory appDir = await getApplicationSupportDirectory();
    return appDir.path;  // This is the root of the app's internal storage
  }

  Future<void> _extractAndSaveToAppData(String zipFilePath) async {
    try {
      // Get the app's internal data directory (not inside app_flutter)
      final targetDirectoryPath = await _getAppInternalDirectory();

      // Create the app_data directory inside the app's root internal directory
      final appDataDirPath = p.join(targetDirectoryPath, '../app_data'); // Go one level up from app_flutter or app_support
      Directory appDataDir = Directory(appDataDirPath);

      // Ensure the app_data directory exists
      if (!appDataDir.existsSync()) {
        appDataDir.createSync(recursive: true);
        //print('Created app_data directory: $appDataDirPath');
      }

      // 1. Read the ZIP file as bytes
      final bytes = File(zipFilePath).readAsBytesSync();

      // Decode the ZIP file using the archive package
      final archive = ZipDecoder().decodeBytes(bytes);

      // 2. Extract the contents into the app_data directory
      for (final file in archive) {
        String fileName = file.name;

        // Remove any leading slashes to make paths relative
        if (fileName.startsWith('/')) {
          fileName = fileName.substring(1);
        }

        final normalizedFileName = p.normalize(fileName); // Normalize for path comparison

        // Print statements for debugging
        //print('appDataDirPath: $appDataDirPath');
        //print('normalizedFileName: $normalizedFileName');

        // Construct the file path inside app_data directory
        final filePath = p.join(appDataDirPath, normalizedFileName);

        // Print the resulting file path for debugging
        //print('filePath to be extracted: $filePath');

        if (file.isFile) {
          // Write the file data to the target directory
          final outputFile = File(filePath);
          outputFile.createSync(recursive: true);  // Ensure directories are created before writing the file
          outputFile.writeAsBytesSync(file.content as List<int>);
          //print('File extracted: $filePath');
        } else {
          // If it's a directory, ensure the directory exists
          Directory(filePath).createSync(recursive: true);
          //print('Directory created or exists: $filePath');
        }
      }

      // 3. Move cryptographic_documents and ipact_wallet directories
      await _moveDirectory(
          sourcePath: p.join(appDataDirPath, 'files', 'cryptographic_documents'),
          destinationPath: p.join(targetDirectoryPath, '../files', 'cryptographic_documents')
      );

      await _moveDirectory(
          sourcePath: p.join(appDataDirPath, 'files', 'ipact_wallet'),
          destinationPath: p.join(targetDirectoryPath, '../files', 'ipact_wallet')
      );

      // 4. Delete /app_flutter/hive_db
      await _deleteDirectory(p.join(targetDirectoryPath, '../app_flutter', 'hive_db'));

      // 5. Move /app_data/app_flutter/hive_db to /app_flutter/hive_db
      await _moveDirectory(
          sourcePath: p.join(appDataDirPath, 'app_flutter', 'hive_db'),
          destinationPath: p.join(targetDirectoryPath, '../app_flutter', 'hive_db')
      );

      // 6. Move the individual files: users.hive and users.lock
      List<String> filesToMove = [
        'users.hive',
        'users.lock'
      ];
      for (String fileName in filesToMove) {
        final sourcePath = p.join(appDataDirPath, 'app_flutter', fileName);
        final destinationPath = p.join(targetDirectoryPath, '../app_flutter', fileName);
        await _moveFile(sourcePath: sourcePath, destinationPath: destinationPath);
      }

      // 7. After successful extraction, delete the ZIP file
      File zipFile = File(zipFilePath);
      if (zipFile.existsSync()) {
        zipFile.deleteSync();  // Delete the ZIP file
        //print('ZIP file deleted: $zipFilePath');
      }

      // 8. Delete the app_data directory after all tasks are complete
      await _deleteDirectory(appDataDirPath);
      //print('app_data directory deleted: $appDataDirPath');

      //print('Extraction, moving, and deletion of directories completed successfully.');

      SystemNavigator.pop();
    } catch (e) {
      print('Error during extraction or moving: $e');
    }
  }

  Future<void> _moveDirectory({required String sourcePath, required String destinationPath}) async {
    try {
      Directory sourceDir = Directory(sourcePath);
      Directory destinationDir = Directory(destinationPath);

      if (sourceDir.existsSync()) {
        // Check if the destination directory already exists, if so, delete it first
        if (destinationDir.existsSync()) {
          destinationDir.deleteSync(recursive: true);
          //print('Deleted existing destination directory: $destinationPath');
        }

        // Ensure the destination directory exists
        destinationDir.createSync(recursive: true);

        // Move files from source to destination
        await for (var entity in sourceDir.list(recursive: true)) {
          if (entity is File) {
            String newPath = entity.path.replaceFirst(sourceDir.path, destinationDir.path);
            File newFile = File(newPath);
            newFile.createSync(recursive: true);
            await entity.copy(newPath);
            //print('Moved file: ${entity.path} to $newPath');
          }
        }

        // After moving, delete the original directory
        sourceDir.deleteSync(recursive: true);
        //print('Deleted original directory: $sourcePath');
      } else {
        //print('Source directory does not exist: $sourcePath');
      }
    } catch (e) {
      //print('Error during moving directory: $e');
    }
  }

  Future<void> _moveFile({required String sourcePath, required String destinationPath}) async {
    try {
      File sourceFile = File(sourcePath);
      if (sourceFile.existsSync()) {
        File destinationFile = File(destinationPath);

        // Check if the destination file already exists, if so, delete it first
        if (destinationFile.existsSync()) {
          destinationFile.deleteSync();
          //'Deleted existing destination file: $destinationPath');
        }

        destinationFile.createSync(recursive: true);  // Ensure the directory structure exists
        await sourceFile.copy(destinationFile.path);
        //print('Moved file: $sourcePath to $destinationPath');
        sourceFile.deleteSync(); // Delete the source file after copying
      } else {
        print('Source file does not exist: $sourcePath');
      }
    } catch (e) {
      //print('Error moving file: $e');
    }
  }

  Future<void> _deleteDirectory(String directoryPath) async {
    try {
      Directory dir = Directory(directoryPath);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
        //print('Deleted directory: $directoryPath');
      } else {
        print('Directory does not exist: $directoryPath');
      }
    } catch (e) {
      print('Error deleting directory: $e');
    }
  }

  Future<void> restoreProfileFromBackup() async {
    // Logic to pick the file and restore from backup
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'], // Only allow zip files
    );

    if (result != null && result.files.single.path != null) {
      File selectedFile = File(result.files.single.path!);
      String appDirPath = '/data/data/de.hsheilbronn.ipact';
      String zipFilePath = p.join(appDirPath, 'app_data.zip');

      // Ensure the directory exists
      Directory appDir = Directory(appDirPath);
      if (!appDir.existsSync()) {
        appDir.createSync(recursive: true);
      }

      // If a previous ZIP exists, delete it
      File zipFile = File(zipFilePath);
      if (zipFile.existsSync()) {
        zipFile.deleteSync();
      }

      // Copy the selected file to the application path as 'app_data.zip'
      await selectedFile.copy(zipFilePath);

      // Now extract the ZIP and replace conflicting files
      await _extractAndSaveToAppData(zipFilePath);

      Get.back(); // Close the popup

      // Show success message
      Get.snackbar("Success", "Backup restored and files replaced successfully!");
    } else {
      Get.snackbar("Error", "No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        // appBar: appBarMain(title: "".tr, context: context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingLarge),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    // const AppLogo(),
                    const AppLogoWithTitle(),
                    vSpacer30(),
                    // const Center(
                    //     child: TextAutoMetropolis(
                    //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                    //   fontSize: 12,
                    //   maxLines: 12,
                    //   textAlign: TextAlign.center,
                    // )),
                    // vSpacer30(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      userBox.isEmpty
                          ?

                      Column(
                          children: [
                            SizedBox(
                            width: Get.width / 1.5,
                            child: Obx(() => ButtonFillMainWhiteBg(
                                title: "Create new IOTA Profile".tr,
                                isLoading: _controller.isLoading.value,
                                onPress: () {
                                  Get.to(() => const PrivacyPolicyScreen()
                                    // Get.to(() => const CreateNewProfile()
                                  );
                                })),
                          ),
                            vSpacer10(),
                            SizedBox(
                              width: Get.width / 1.5,
                              child: Obx(() => ButtonFillMainWhiteBg(
                                  title: "Restore Profile From Backup".tr,
                                  isLoading: _controller.isLoading.value,
                                  onPress: () async {
                                    await restoreProfileFromBackup();
                                    //restoreProfileFromBackup();
                                      // Get.to(() => const CreateNewProfile()
                                  })),
                            ),

                          ]
                      )

                          : const SizedBox(),
                      // vSpacer10(),
                      // SizedBox(
                      //   width: Get.width / 1.5,
                      //   child: Obx(() => ButtonFillMainWhiteBg(
                      //       title: "Add Existing Shimmer Profile".tr,
                      //       isLoading: _controller.isLoading.value,
                      //       onPress: () {
                      //         Get.to(() => const TestScreen());
                      //       })),
                      // ),
                      vSpacer20(),
                      userBox.isNotEmpty?
                      Center(
                        child: SizedBox(
                          width: Get.width / 3.5,
                          child: Obx(() => ButtonFillMain(
                              title: "Login".tr,
                              isLoading: _controller.isLoading.value,
                              onPress: () {
                                Get.to(() => const LogInScreen());
                              })),
                        ),
                      ): const SizedBox(),
                      vSpacer100(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
