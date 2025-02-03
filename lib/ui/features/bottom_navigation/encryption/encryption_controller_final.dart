/*import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_utils.dart';

class EncryptionControllerFinal extends GetxController {
  EncryptionUtils objectInstance = EncryptionUtils();

  /// From bellow methods we can call methods from EncryptionUtils wherever needed

  Future<void> generateKeyPemFile() async {
    print("generateKeyPemFile");
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.generateKeyPemFile(
        '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/',
        updateFlag: true);
  }


  Future<void> asymmetricEncryptFile(
      {String? collaborationId, String? fileId}
      ) async {
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.asymmetricEncryptFile(
        '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/public_key.pem',
        '${appSupportDir.path}/cryptographic_documents/level_1_encrypted_files/${collaborationId}fileId.enc',
        '${appSupportDir.path}/cryptographic_documents/level_2_encrypted_files/',
        '${collaborationId}fileId.enc');
  }

  Future<void> asymmetricDecryptFile(
      {String? collaborationId, String? fileId}
      ) async {
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.asymmetricDecryptFile(
        '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/private_key.pem',
        '${appSupportDir.path}/cryptographic_documents/level_2_encrypted_files/${collaborationId}_$fileId.enc',
        '${appSupportDir.path}/cryptographic_documents/level_2_decrypted_files/',
        '${collaborationId}_$fileId.enc');
  }


  Future<void> generateKeyFileForSymmetricCryptography(
      {String? collaborationId, String? fileId}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.generateKeyFileForSymmetricCryptography(
      '${appSupportDir.path}/cryptographic_documents/symmetric_keys/',
      '${collaborationId}_$fileId.key',
    );
  }

  Future<void> symmetricEncryptFile(
      {String? collaborationId,
        String? fileId,
        String? fileToEncryptPath}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.symmetricEncryptFile(
        '${appSupportDir.path}/cryptographic_documents/symmetric_keys/${collaborationId}_$fileId.key',
        //'${appSupportDir.path}/cryptographic_documents/original_files/original_file_1.txt',
        fileToEncryptPath!,
        '${appSupportDir.path}/cryptographic_documents/level_1_encrypted_files/',
        '${collaborationId}_$fileId.enc'
    );
  }


  Future<void> symmetricDecryptFile(
      {String? collaborationId, String? fileId, String? fileName}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.symmetricDecryptFile(
        '${appSupportDir.path}/cryptographic_documents/symmetric_keys/${collaborationId}_$fileId.key',
        '${appSupportDir.path}/cryptographic_documents/level_2_decrypted_files/${collaborationId}_$fileId.enc',
        //'${appSupportDir.path}/cryptographic_documents/level_1_encrypted_files/${collaborationId}_$fileId.enc',
        '${appSupportDir.path}/cryptographic_documents/level_1_decrypted_files/',
        fileName!);
  }

  Future<void> compareHashedFiles(String firstFilePath, String secondFilePath) async {
    final appSupportDir = await getApplicationSupportDirectory();
    var firstFileHash = await objectInstance.createHashFromFile(
        '${appSupportDir.path}/cryptographic_documents/$firstFilePath');
    var secondFileHash = await objectInstance.createHashFromFile(
        '${appSupportDir.path}/cryptographic_documents/$secondFilePath');
    var isMatched = await objectInstance.compareHashedFiles(firstFileHash, secondFileHash);
    print(isMatched);
  }

  Future<String> getPublicKeyAsString() async {
    final appSupportDir = await getApplicationSupportDirectory();
    return await objectInstance.getPublicKeyAsString(
        '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/public_key.pem');
  }

  Future<void> generateRsaKeyPemFileFromReceivedPublicKey(
      {String? collaborationId,
        String? iotaAddress,
        String? receivedPublicKey}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    var isGenerated = await objectInstance.generateRsaKeyPemFileFromReceivedPublicKey(
        '${appSupportDir.path}/cryptographic_documents/received_cryptographic_keys/$collaborationId/$iotaAddress/',
        receivedPublicKey!);
    print('isGenerated');
    print(isGenerated);
  }
}*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/ui/features/bottom_navigation/encryption/encryption_utils.dart';

class EncryptionControllerFinal extends GetxController {
  EncryptionUtils objectInstance = EncryptionUtils();

  Future<String> generateKeyFileForSymmetricCryptography(
      {String? collaborationId, String? fileId}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final keyFilePath = '${appSupportDir.path}/cryptographic_documents/symmetric_keys/${collaborationId}_$fileId.key';
    await objectInstance.generateKeyFileForSymmetricCryptography(
      '${appSupportDir.path}/cryptographic_documents/symmetric_keys/',
      '${collaborationId}_$fileId.key',
    );
    return keyFilePath;
  }


  Future<String> generateFileForReceivedSymmetricKey(
      {String? collaborationId, String? fileId, String? cryptographicKey}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final keyFileName = '${collaborationId}_$fileId.key';
    final keyFilePathDirectory = '${appSupportDir.path}/cryptographic_documents/received_cryptographic_keys/symmetric_keys/';

    final symmetricKeysDirectory = Directory(keyFilePathDirectory);
    if (!await symmetricKeysDirectory.exists()) {
      await symmetricKeysDirectory.create(recursive: true);
      debugPrint('${symmetricKeysDirectory.path}  created successfully');
    }

    await objectInstance.writeFile(
        '${symmetricKeysDirectory.path}$keyFileName', cryptographicKey.toString());

    return '${symmetricKeysDirectory.path}$keyFileName';
  }

  Future<String> symmetricEncryptFile(
      {String? collaborationId, String? fileId, String? fileToEncryptPath, int? fileCount}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    return await objectInstance.symmetricEncryptFile(
      '${appSupportDir.path}/cryptographic_documents/symmetric_keys/${collaborationId}_$fileId.key',
      fileToEncryptPath!,
      '${appSupportDir.path}/cryptographic_documents/level_1_encrypted_files/',
      'sym_${collaborationId}_${fileId}_$fileCount.enc',
    );
  }

  // Future<String> asymmetricEncryptFile(
  //     {String? collaborationId, String? fileId}) async {
  //   final appSupportDir = await getApplicationSupportDirectory();
  //   return await objectInstance.asymmetricEncryptFile(
  //     '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/public_key.pem',
  //     '${appSupportDir.path}/cryptographic_documents/level_1_encrypted_files/sym_${collaborationId}_$fileId.enc',
  //     '${appSupportDir.path}/cryptographic_documents/level_2_encrypted_files/',
  //     'asy_${collaborationId}_$fileId.enc',
  //   );
  // }



  Future<String> asymmetricEncryptFile(
      {String? collaborationId, String? fileId, String? publicKeyPemFilePath, int?fileCount}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    return await objectInstance.asymmetricEncryptFile(
      publicKeyPemFilePath.toString(),
      '${appSupportDir.path}/cryptographic_documents/level_1_encrypted_files/sym_${collaborationId}_${fileId}_$fileCount.enc',
      '${appSupportDir.path}/cryptographic_documents/level_2_encrypted_files/',
      'asy_${collaborationId}_${fileId}_$fileCount.enc',
    );
  }

  // Future<String> asymmetricDecryptFile(
  //     {String? collaborationId, String? fileId}) async {
  //   final appSupportDir = await getApplicationSupportDirectory();
  //   return await objectInstance.asymmetricDecryptFile(
  //     '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/private_key.pem',
  //     '${appSupportDir.path}/cryptographic_documents/level_2_encrypted_files/asy_${collaborationId}_$fileId.enc',
  //     '${appSupportDir.path}/cryptographic_documents/level_2_decrypted_files/',
  //     'asy_${collaborationId}_$fileId.enc',
  //   );
  // }


  Future<String> asymmetricDecryptFile(
      {String? collaborationId, String? fileId, String? filePath, String? fileCount}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    return await objectInstance.asymmetricDecryptFile(
      '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/private_key.pem',
      filePath.toString(),
      // '/data/user/0/de.hsheilbronn.ipact/cache/file_picker/1718930671428/asy_1718911216824589_1718924685343708.enc',
      '${appSupportDir.path}/cryptographic_documents/level_2_decrypted_files/',
      'asy_${collaborationId}_${fileId}_$fileCount.enc',
    );
  }

  Future<String> symmetricDecryptFile(
      {String? collaborationId, String? fileId, String? fileExtension,  int? fileCount}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.symmetricDecryptFile(
      '${appSupportDir.path}/cryptographic_documents/received_cryptographic_keys/symmetric_keys/${collaborationId}_$fileId.key',
      '${appSupportDir.path}/cryptographic_documents/level_2_decrypted_files/asy_${collaborationId}_${fileId}_$fileCount.enc',
      '${appSupportDir.path}/cryptographic_documents/level_1_decrypted_files/',
        'ori_${collaborationId}_${fileId}_$fileCount.$fileExtension',
    );

    return '${appSupportDir.path}/cryptographic_documents/level_1_decrypted_files/ori_${collaborationId}_${fileId}_$fileCount.$fileExtension';
  }

  /// From bellow methods we can call methods from EncryptionUtils wherever needed

  Future<void> generateKeyPemFile() async {
    print("generateKeyPemFile");
    final appSupportDir = await getApplicationSupportDirectory();
    await objectInstance.generateKeyPemFile(
        '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/',
        updateFlag: true);
  }

  Future<void> compareHashedFiles(String firstFilePath, String secondFilePath) async {
    final appSupportDir = await getApplicationSupportDirectory();
    var firstFileHash = await objectInstance.createHashFromFile(
        '${appSupportDir.path}/cryptographic_documents/$firstFilePath');
    var secondFileHash = await objectInstance.createHashFromFile(
        '${appSupportDir.path}/cryptographic_documents/$secondFilePath');
    var isMatched = await objectInstance.compareHashedFiles(firstFileHash, secondFileHash);
    print(isMatched);
  }

  Future<String> getPublicKeyAsString() async {
    final appSupportDir = await getApplicationSupportDirectory();
    return await objectInstance.getPublicKeyAsString(
        '${appSupportDir.path}/cryptographic_documents/asymmetric_key_pairs/asymmetric_key_pair_1/public_key.pem');
  }

  Future<void> generateRsaKeyPemFileFromReceivedPublicKey(
      {String? collaborationId,
        String? iotaAddress,
        String? receivedPublicKey}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    var isGenerated = await objectInstance.generateRsaKeyPemFileFromReceivedPublicKey(
        '${appSupportDir.path}/cryptographic_documents/received_cryptographic_keys/$collaborationId/$iotaAddress/',
        receivedPublicKey!);
    print('isGenerated');
    print(isGenerated);
  }


  Future<String> readSymmetricKey(
      {String? collaborationId, fileId}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    var symmetricKeyData = await objectInstance.readFile(
      '${appSupportDir.path}/cryptographic_documents/symmetric_keys/${collaborationId}_$fileId.key',
    );
    return symmetricKeyData;
  }

  Future<String> symmetricDecryptFile2(
      {String? collaborationId, String? fileId, String? fileName}) async {

    var symmetricKeyData = await readSymmetricKey(collaborationId: collaborationId, fileId: fileId);
    final appSupportDir = await getApplicationSupportDirectory();
    return await objectInstance.symmetricDecryptFile2(
      symmetricKeyData,
      '${appSupportDir.path}/cryptographic_documents/level_2_decrypted_files/asy_${collaborationId}_$fileId.enc',
      '${appSupportDir.path}/cryptographic_documents/level_1_decrypted_files/',
      fileName!,
    );
  }



}

