import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:unify_secret/ui/helper/global_variables.dart';
import 'package:unify_secret/utils/appbar_util.dart';
import 'package:unify_secret/utils/dimens.dart';
import 'package:unify_secret/utils/button_util.dart';
import 'package:unify_secret/utils/spacers.dart';
import 'package:unify_secret/utils/text_util.dart';
import 'package:unify_secret/ui/helper/app_widgets.dart';

class ZipAndDownloadScreen extends StatefulWidget {
  const ZipAndDownloadScreen({super.key});
  @override
  State<ZipAndDownloadScreen> createState() => _ZipAndDownloadScreenState();
}

class _ZipAndDownloadScreenState extends State<ZipAndDownloadScreen> {
  String? _zipFilePath;
  bool _isLoading = false;
  String _statusMessage = '';
  double _progress = 0;

  Future<void> _zipAndSaveDirectory() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Generating Profile Backup...';
      _progress = 0;
    });

    try {
      final appDir = Directory('/data/data/de.hsheilbronn.ipact');

      if (!appDir.existsSync()) {
        throw Exception('Directory does not exist: ${appDir.path}');
      }

      final zipFilePath = p.join(appDir.path, 'app_data.zip');
      final zipFile = File(zipFilePath);

      // Check if the ZIP file already exists, and delete if found
      if (zipFile.existsSync()) {
        zipFile.deleteSync();
        print('Previous Profile Backup Is Deleted.');
      }

      final archive = Archive();

      // List of directories to include in the ZIP
      List<String> directoriesToInclude = [
        '/data/data/de.hsheilbronn.ipact/files/cryptographic_documents',
        '/data/data/de.hsheilbronn.ipact/files/ipact_wallet',
        '/data/data/de.hsheilbronn.ipact/app_flutter/hive_db'
      ];

      // Add individual files to include in the ZIP
      List<String> filesToInclude = [
        '/data/data/de.hsheilbronn.ipact/app_flutter/users.hive',
        '/data/data/de.hsheilbronn.ipact/app_flutter/users.lock'
      ];

      int processedFiles = 0;
      int totalFiles = 0;

      // Iterate over each directory in the list
      for (String dirPath in directoriesToInclude) {
        Directory directory = Directory(dirPath);

        if (!directory.existsSync()) {
          print('Directory does not exist: $dirPath');
          continue; // Skip if the directory doesn't exist
        }

        final files = directory.listSync(recursive: true);
        totalFiles += files.length;

        // Add files from the directory to the ZIP archive
        for (var file in files) {
          if (file is File) {
            final fileBytes = file.readAsBytesSync();
            // Get the relative path by removing the base directory prefix
            final relativePath = file.path.replaceFirst(appDir.path, '');
            archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));

            processedFiles++;
            setState(() {
              _progress = processedFiles / totalFiles;
            });
          }
        }
      }

      // Now include individual files (users.hive and users.lock)
      for (String filePath in filesToInclude) {
        File file = File(filePath);

        if (file.existsSync()) {
          final fileBytes = file.readAsBytesSync();
          final relativePath = file.path.replaceFirst(appDir.path, '');
          archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));

          processedFiles++;
          totalFiles++; // Add to the total number of files
          setState(() {
            _progress = processedFiles / totalFiles;
          });
        } else {
          print('File does not exist: $filePath');
        }
      }

      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);

      if (zipData == null) throw Exception('Failed to encode ZIP data.');

      // Save the newly created ZIP file
      await zipFile.writeAsBytes(zipData);

      setState(() {
        _zipFilePath = zipFilePath;
        _isLoading = false;
        _statusMessage = 'Profile Backup Is Generated Successfully!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _downloadZipFileInDevice() async {
    if (_zipFilePath != null) {
      String? outputFile = await FilePicker.platform.getDirectoryPath();

      if (outputFile != null) {
        try {
          final fileName = p.basename(_zipFilePath!);
          final newFilePath = p.join(outputFile, fileName);
          final newFile = File(newFilePath);

          await File(_zipFilePath!).copy(newFilePath);

          setState(() {
            //_statusMessage = 'Profile Backup Is Downloaded Successfully To $newFilePath!';
            print('Profile Backup Is Downloaded Successfully To $newFilePath!');
            _statusMessage = 'Profile Backup Is Downloaded Successfully';
          });
        } catch (e) {
          setState(() {
            _statusMessage = 'Error downloading ZIP file: ${e.toString()}';
          });
        }
      } else {
        setState(() {
          _statusMessage = 'Download cancelled';
        });
      }
    }
  }

  void _shareZipFile() {
    if (_zipFilePath != null) {
      Share.shareFiles([_zipFilePath!], text: 'Here is your zipped data file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.currentContext = context;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: appBarWithBack(title: "Download Data as ZIP".tr, context: context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  vSpacer30(),
                  const AppLogo(),
                  vSpacer100(),
                  if (_isLoading)
                    Column(
                      children: [
                        LinearProgressIndicator(value: _progress),
                        SizedBox(height: 20),
                        Text(
                          (_progress * 100).toStringAsFixed(0) + '%',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  if (!_isLoading && _statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _statusMessage.contains('Error')
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  if (_zipFilePath == null) // Hide button after zip file is created
                    SizedBox(
                      width: Get.width * 0.8, // Adjusted width to fit the text
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.build),
                        label: Text('Generate Profile Backup'), // Updated button text
                        onPressed: _zipAndSaveDirectory,
                      ),
                    ),
                  if (_zipFilePath != null) ...[
                    vSpacer20(),
                    SizedBox(
                      width: Get.width * 0.8, // Adjusted width for larger text
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.share),
                        label: Text('Share Profile Backup'), // Updated button text
                        onPressed: _shareZipFile,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.8, // Adjusted width for larger text
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.download),
                        label: Text('Download Profile Backup'), // Updated button text
                        onPressed: _downloadZipFileInDevice,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
