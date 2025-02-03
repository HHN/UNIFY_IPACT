// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:crypto/crypto.dart' as crypto;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pointycastle/export.dart';
// import 'package:pointycastle/src/platform_check/platform_check.dart';
// import 'package:asn1lib/asn1lib.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:encrypt/encrypt.dart' as encrypt_lib;
//
// class EncryptionUtils {
//
//
//   AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
//       SecureRandom secureRandom,
//       {int bitLength = 2048}) {
//     // Create an RSA key generator and initialize it
//
//     // final keyGen = KeyGenerator('RSA'); // Get using registry
//     final keyGen = RSAKeyGenerator();
//
//     keyGen.init(ParametersWithRandom(
//         RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
//         secureRandom));
//
//     // Use the generator
//
//     final pair = keyGen.generateKeyPair();
//
//     // Cast the generated key pair into the RSA key types
//
//     final myPublic = pair.publicKey as RSAPublicKey;
//     final myPrivate = pair.privateKey as RSAPrivateKey;
//
//     return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
//   }
//
//   SecureRandom generateSecureRandom() {
//     final secureRandom = SecureRandom('Fortuna')
//       ..seed(
//           KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
//     return secureRandom;
//   }
//
//   String encodeKeyToPem(
//       AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair, String keyType) {
//     var asn1Sequence = ASN1Sequence();
//     switch (keyType) {
//       case "PUBLIC KEY":
//         asn1Sequence.add(ASN1Integer(keyPair.publicKey.modulus!));
//         asn1Sequence.add(ASN1Integer(keyPair.publicKey.exponent!));
//         // do something
//         break;
//       case "PRIVATE KEY":
//         asn1Sequence.add(ASN1Integer(keyPair.privateKey.modulus!));
//         asn1Sequence.add(ASN1Integer(keyPair.privateKey.exponent!));
//         // do something else
//         break;
//     }
//     var encodedBytes = asn1Sequence.encodedBytes;
//     var encodedKey = base64.encode(encodedBytes);
//     //String keyPem = """-----BEGIN $keyType-----\r\n$encodedKey\r\n-----END $keyType-----""";
//     String keyPem = encodedKey;
//     debugPrint("$keyType Pem:  $keyPem");
//     return keyPem;
//   }
//
//   decodePemToKey(String keyType) async {
//     final appSupportDir = await getApplicationSupportDirectory();
//     final directory = Directory(
//         '${appSupportDir.path}/cryptographic_documents/rsa_key_pair/');
//
//     // Read the file content
//     final pemString =
//     await File('${directory.path}public_key.pem').readAsString();
//
//     var decodedKey = base64.decode(pemString);
//
//     var asn1Parser = ASN1Parser(decodedKey);
//     var asn1Sequence = asn1Parser.nextObject() as ASN1Sequence;
//
//     var modulus = asn1Sequence.elements[0] as ASN1Integer;
//     var exponent = asn1Sequence.elements[1] as ASN1Integer;
//
//     RSAPublicKey rsaPublicKey =
//     RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
//
//     //print('rsaPublicKey.modulus');
//     //print(rsaPublicKey.modulus);
//     //print('rsaPublicKey.exponent');
//     //print(rsaPublicKey.exponent);
//   }
//
//   String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
//     var topLevel = ASN1Sequence();
//
//     topLevel.add(ASN1Integer(publicKey.modulus!));
//     topLevel.add(ASN1Integer(publicKey.exponent!));
//
//     var dataBase64 = base64.encode(topLevel.encodedBytes);
//
//     return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
//   }
//
//   String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
//     var topLevel = ASN1Sequence();
//     var version = ASN1Integer(BigInt.from(0));
//     var modulus = ASN1Integer(privateKey.n!);
//     var publicExponent = ASN1Integer(privateKey.exponent!);
//     var privateExponent = ASN1Integer(privateKey.d!);
//     var p = ASN1Integer(privateKey.p!);
//     var q = ASN1Integer(privateKey.q!);
//     var dP = privateKey.d! % (privateKey.p! - BigInt.from(1));
//     var exp1 = ASN1Integer(dP);
//     var dQ = privateKey.d! % (privateKey.q! - BigInt.from(1));
//     var exp2 = ASN1Integer(dQ);
//     var iQ = privateKey.q!.modInverse(privateKey.p!);
//     var co = ASN1Integer(iQ);
//
//     topLevel.add(version);
//     topLevel.add(modulus);
//     topLevel.add(publicExponent);
//     topLevel.add(privateExponent);
//     topLevel.add(p);
//     topLevel.add(q);
//     topLevel.add(exp1);
//     topLevel.add(exp2);
//     topLevel.add(co);
//
//     var dataBase64 = base64.encode(topLevel.encodedBytes);
//
//     return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
//   }
//
//   RSAPublicKey parsePublicKeyFromPem(String pemString) {
//     var decodedPem = base64.decode(removePemHeaderAndFooter(pemString));
//     var asn1Parser = ASN1Parser(decodedPem);
//     var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
//
//     var modulus = topLevelSeq.elements[0] as ASN1Integer;
//     var exponent = topLevelSeq.elements[1] as ASN1Integer;
//
//     RSAPublicKey rsaPublicKey =
//     RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
//
//     return rsaPublicKey;
//   }
//
//   RSAPrivateKey parsePrivateKeyFromPem(pemString) {
//     var decodedPem = base64.decode(removePemHeaderAndFooter(pemString));
//     var asn1Parser = ASN1Parser(decodedPem);
//
//     var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
//
//     var modulus, privateExponent, p, q;
//     // Depending on the number of elements, we will either use PKCS1 or PKCS8
//     if (topLevelSeq.elements.length == 3) {
//       var privateKey = topLevelSeq.elements[2];
//
//       asn1Parser = ASN1Parser(privateKey.contentBytes());
//       var pkSeq = asn1Parser.nextObject() as ASN1Sequence;
//
//       modulus = pkSeq.elements[1] as ASN1Integer;
//       privateExponent = pkSeq.elements[3] as ASN1Integer;
//       p = pkSeq.elements[4] as ASN1Integer;
//       q = pkSeq.elements[5] as ASN1Integer;
//     } else {
//       modulus = topLevelSeq.elements[1] as ASN1Integer;
//       privateExponent = topLevelSeq.elements[3] as ASN1Integer;
//       p = topLevelSeq.elements[4] as ASN1Integer;
//       q = topLevelSeq.elements[5] as ASN1Integer;
//     }
//
//     RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
//         modulus.valueAsBigInteger,
//         privateExponent.valueAsBigInteger,
//         p.valueAsBigInteger,
//         q.valueAsBigInteger);
//
//     return rsaPrivateKey;
//   }
//
//   String removePemHeaderAndFooter(String pem) {
//     var startsWith = [
//       "-----BEGIN PUBLIC KEY-----",
//       "-----BEGIN RSA PRIVATE KEY-----",
//       "-----BEGIN RSA PUBLIC KEY-----",
//       "-----BEGIN PRIVATE KEY-----",
//       "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
//       "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
//     ];
//     var endsWith = [
//       "-----END PUBLIC KEY-----",
//       "-----END PRIVATE KEY-----",
//       "-----END RSA PRIVATE KEY-----",
//       "-----END RSA PUBLIC KEY-----",
//       "-----END PGP PUBLIC KEY BLOCK-----",
//       "-----END PGP PRIVATE KEY BLOCK-----",
//     ];
//     bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;
//
//     pem = pem.replaceAll(' ', '');
//     pem = pem.replaceAll('\n', '');
//     pem = pem.replaceAll('\r', '');
//
//     for (var s in startsWith) {
//       s = s.replaceAll(' ', '');
//       if (pem.startsWith(s)) {
//         pem = pem.substring(s.length);
//       }
//     }
//
//     for (var s in endsWith) {
//       s = s.replaceAll(' ', '');
//       if (pem.endsWith(s)) {
//         pem = pem.substring(0, pem.length - s.length);
//       }
//     }
//
//     if (isOpenPgp) {
//       var index = pem.indexOf('\r\n');
//       pem = pem.substring(0, index);
//     }
//
//     return pem;
//   }
//
//   void writeFile(String filePath, String data) async {
//     final file = File(filePath);
//     if(!await file.exists()){
//       file.writeAsString(data);
//       debugPrint('$filePath creation successful');
//     }else{
//       debugPrint('$filePath Already file exists');
//     }
//   }
//
//   Future<void> writeEncryptedFile(String filePath, String data) async {
//     final file = await File(filePath).writeAsBytes(utf8.encode(data));
//     //file.writeAsString(data);
//     debugPrint('$filePath creation successful');
//   }
//
//   Future<Uint8List> readEncryptedFile(String filePath) async {
//     final file = File(filePath);
//     var data = file.readAsBytes();
//     debugPrint('$filePath creation successful');
//     return data;
//   }
//
//   Future<String> readFile(String filePath) async {
//     final file = File(filePath);
//     var dataAsString = file.readAsString();
//     return dataAsString;
//   }
//
//   Future<Uint8List> readFileAsBytes(String filePath) async {
//     final file = File(filePath);
//     var data = file.readAsBytes();
//     return data;
//   }
//
//   String readTextFromPdfFile(String filePath) {
//     final PdfDocument document =
//     PdfDocument(inputBytes: File(filePath).readAsBytesSync());
//     String text = PdfTextExtractor(document).extractText();
//     document.dispose();
//     return text;
//   }
//
//   Future<void> generateKeyPemFile(String asymmetricKeyPairDirectoryPath,
//       {bool updateFlag = false}) async {
//     final keyPair = generateRSAkeyPair(generateSecureRandom());
//
//     final asymmetricKeyPairDirectory =
//     Directory(asymmetricKeyPairDirectoryPath);
//
//     if (updateFlag && await asymmetricKeyPairDirectory.exists()) {
//       asymmetricKeyPairDirectory.deleteSync(recursive: true);
//     }
//
//     if (!await asymmetricKeyPairDirectory.exists()) {
//       await asymmetricKeyPairDirectory.create(recursive: true);
//       debugPrint('${asymmetricKeyPairDirectory.path}  created successfully');
//       //String publicKeyPem = encodeKeyToPem( keyPair, "PUBLIC KEY");
//
//       String publicKeyPem = encodePublicKeyToPemPKCS1(keyPair.publicKey);
//       writeFile(
//           '${asymmetricKeyPairDirectory.path}public_key.pem', publicKeyPem);
//
//       //String privateKeyPem = encodeKeyToPem( keyPair, "PRIVATE KEY");
//       String privateKeyPem = encodePrivateKeyToPemPKCS1(keyPair.privateKey);
//       writeFile(
//           '${asymmetricKeyPairDirectory.path}private_key.pem', privateKeyPem);
//     } else {
//       debugPrint(
//           '${asymmetricKeyPairDirectory.path} Directory already existed');
//     }
//   }
//
//   Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
//     final encryptor = OAEPEncoding(RSAEngine())
//       ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt
//
//     return _processInBlocks(encryptor, dataToEncrypt);
//   }
//
//   Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
//     final decryptor = OAEPEncoding(RSAEngine())
//       ..init(false,
//           PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt
//
//     return _processInBlocks(decryptor, cipherText);
//   }
//
//   Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
//     final numBlocks = input.length ~/ engine.inputBlockSize +
//         ((input.length % engine.inputBlockSize != 0) ? 1 : 0);
//
//     final output = Uint8List(numBlocks * engine.outputBlockSize);
//
//     var inputOffset = 0;
//     var outputOffset = 0;
//     while (inputOffset < input.length) {
//       final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
//           ? engine.inputBlockSize
//           : input.length - inputOffset;
//
//       outputOffset += engine.processBlock(
//           input, inputOffset, chunkSize, output, outputOffset);
//
//       inputOffset += chunkSize;
//     }
//
//     return (output.length == outputOffset)
//         ? output
//         : output.sublist(0, outputOffset);
//   }
//
//   asymmetricEncryptFile(String publicKeyPemFilePath, String fileToEncryptPath,
//       String encryptedFilesDirectoryPath, String encryptedFileName) async {
//     // Read the file content
//     final publicKeyPemString = await File(publicKeyPemFilePath).readAsString();
//     var publicKey = parsePublicKeyFromPem(publicKeyPemString);
//
//     var dataFromOriginalFile = await readFile(fileToEncryptPath);
//     debugPrint(dataFromOriginalFile);
//
//     final bytesOfData = utf8.encode(dataFromOriginalFile);
//     var encryptedCypher = rsaEncrypt(publicKey, bytesOfData);
//
//     var encryptedDataAsString = String.fromCharCodes(encryptedCypher);
//
//     final encryptedFilesDirectory = Directory(encryptedFilesDirectoryPath);
//     if (!await encryptedFilesDirectory.exists()) {
//       await encryptedFilesDirectory.create(recursive: true);
//       debugPrint('${encryptedFilesDirectory.path}  created successfully');
//     }
//     writeFile('${encryptedFilesDirectory.path}$encryptedFileName',
//         encryptedDataAsString);
//   }
//
//   asymmetricDecryptFile(String privateKeyPemFilePath, String fileToDecryptPath,
//       String decryptedFilesDirectoryPath, String decryptedFileName) async {
//     var encryptedDataFromFile = await readFile(fileToDecryptPath);
//     var encryptedDataCipher =
//     Uint8List.fromList(encryptedDataFromFile.codeUnits);
//
//     final privateKeyPemString =
//     await File(privateKeyPemFilePath).readAsString();
//     var privateKey = parsePrivateKeyFromPem(privateKeyPemString);
//     var decryptedData = rsaDecrypt(privateKey, encryptedDataCipher);
//     var decryptedPlainData = utf8.decode(decryptedData);
//
//     final decryptedFilesDirectory = Directory(decryptedFilesDirectoryPath);
//     if (!await decryptedFilesDirectory.exists()) {
//       await decryptedFilesDirectory.create(recursive: true);
//       debugPrint('${decryptedFilesDirectory.path}  created successfully');
//     }
//     writeFile('${decryptedFilesDirectory.path}$decryptedFileName',
//         decryptedPlainData);
//
//     debugPrint(decryptedPlainData);
//   }
//
//   Future<crypto.Digest> createHashFromFile(String filePath) async {
//     var dataFromFile = await readFile(filePath);
//     var bytes = utf8.encode(dataFromFile); // data being hashed
//     var digest = crypto.sha256.convert(bytes);
//
//     print("Digest as bytes: ${digest.bytes}");
//     print("Digest as hex string: $digest");
//
//     return digest;
//   }
//
//   Future<void> symmetricEncryptFile(
//       String symmetricKeyFilePath,
//       String fileToEncryptPath,
//       String encryptedFilesDirectoryPath,
//       String encryptedFileName) async {
//     var symmetricKeyData = await readFile(symmetricKeyFilePath);
//     print(symmetricKeyData);
//
//     final key = encrypt_lib.Key.fromUtf8(symmetricKeyData);
//
//     final b64key = encrypt_lib.Key.fromBase64(base64Url.encode(key.bytes));
//     // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
//     final fernet = encrypt_lib.Fernet(b64key);
//     final encrypter = encrypt_lib.Encrypter(fernet);
//
//     var dataFromFileToEncrypt = await readFile(fileToEncryptPath);
//     print(dataFromFileToEncrypt);
//
//     final encryptedData = encrypter.encrypt(dataFromFileToEncrypt);
//     var encryptedDataBase64 = encryptedData.base64;
//     debugPrint(encryptedDataBase64); // random cipher text
//
//     final encryptedFilesDirectory = Directory(encryptedFilesDirectoryPath);
//     if (!await encryptedFilesDirectory.exists()) {
//       await encryptedFilesDirectory.create(recursive: true);
//       debugPrint('${encryptedFilesDirectory.path}  created successfully');
//     }
//     writeFile('${encryptedFilesDirectory.path}$encryptedFileName',
//         encryptedDataBase64);
//   }
//
//   Future<void> symmetricDecryptFile(
//       String symmetricKeyFilePath,
//       String fileToDecryptPath,
//       String decryptedFilesDirectoryPath,
//       String decryptedFileName) async {
//     var symmetricKeyData = await readFile(symmetricKeyFilePath);
//     print(symmetricKeyData);
//
//     final key = encrypt_lib.Key.fromUtf8(symmetricKeyData);
//     final b64key = encrypt_lib.Key.fromBase64(base64Url.encode(key.bytes));
//     // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
//     final fernet = encrypt_lib.Fernet(b64key);
//     final encrypter = encrypt_lib.Encrypter(fernet);
//
//     var encryptedFileData = await readFile(fileToDecryptPath);
//     debugPrint(encryptedFileData); // random cipher text
//     var encryptedDataCypher =
//     encrypt_lib.Encrypted.fromBase64(encryptedFileData);
//
//     final decryptedData = encrypter.decrypt(encryptedDataCypher);
//     print(decryptedData); // random cipher text
//
//     final decryptedFilesDirectory = Directory(decryptedFilesDirectoryPath);
//     if (!await decryptedFilesDirectory.exists()) {
//       await decryptedFilesDirectory.create(recursive: true);
//       debugPrint('${decryptedFilesDirectory.path}  created successfully');
//     }
//     writeFile(
//         '${decryptedFilesDirectory.path}$decryptedFileName', decryptedData);
//   }
//
//   generateKeyFileForSymmetricCryptography(
//       String symmetricKeysDirectoryPath, String symmetricKeyFileName) async {
//     const charPool =
//         "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#\$%^&*()_+-=[]{}|\:;<,>.?/";
//     final random = Random();
//     final chars = List<String>.generate(
//         32, (i) => charPool[random.nextInt(charPool.length)]);
//     var randomString = chars.join();
//
//     print(randomString);
//     final symmetricKeysDirectory = Directory(symmetricKeysDirectoryPath);
//     if (!await symmetricKeysDirectory.exists()) {
//       await symmetricKeysDirectory.create(recursive: true);
//       debugPrint('${symmetricKeysDirectory.path}  created successfully');
//     }
//
//     // final symmetricKeysDirectory = File(symmetricKeysDirectoryPath);
//     writeFile('${symmetricKeysDirectory.path}$symmetricKeyFileName', randomString);
//     print('${symmetricKeysDirectory.path}$symmetricKeyFileName');
//   }
//
//   Future<String> getPublicKeyAsString(filePath) async {
//     var dataFromFile = await readFile(filePath);
//     var publicKeyString = removePemHeaderAndFooter( dataFromFile);
//     debugPrint(publicKeyString);
//     return publicKeyString;
//   }
//
//   Future<bool> compareHashedFiles(originalFileHash, level1DecryptedFileHash) async {
//
//     if (originalFileHash == level1DecryptedFileHash) {
//       debugPrint('Hashes matched');
//       return true;
//     }else{
//       debugPrint('Hashes not matched');
//       return false;
//     }
//   }
//
//   Future<bool> generateRsaKeyPemFileFromReceivedPublicKey(String publicKeyPemFileDirectoryPath, String publicKeyString) async {
//
//     final publicKeyPemFileDirectory = Directory(publicKeyPemFileDirectoryPath);
//     if (!await publicKeyPemFileDirectory.exists()) {
//       await publicKeyPemFileDirectory.create(recursive: true);
//       debugPrint('${publicKeyPemFileDirectory.path}  created successfully');
//
//       var publicKey = parsePublicKeyFromPem(publicKeyString);
//       String publicKeyPem = encodePublicKeyToPemPKCS1(publicKey);
//
//       writeFile('${publicKeyPemFileDirectory.path}public_key.pem', publicKeyPem);
//       return true;
//
//     } else {
//       debugPrint(
//           '${publicKeyPemFileDirectory.path} Directory already existed');
//       return false;
//     }
//   }
//
//
//
// }

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:asn1lib/asn1lib.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:encrypt/encrypt.dart' as encrypt_lib;

class EncryptionUtils {
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    // Create an RSA key generator and initialize it
    final keyGen = RSAKeyGenerator();

    keyGen.init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        secureRandom));

    // Use the generator
    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types
    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom generateSecureRandom() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    return secureRandom;
  }

  String encodeKeyToPem(
      AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair, String keyType) {
    var asn1Sequence = ASN1Sequence();
    switch (keyType) {
      case "PUBLIC KEY":
        asn1Sequence.add(ASN1Integer(keyPair.publicKey.modulus!));
        asn1Sequence.add(ASN1Integer(keyPair.publicKey.exponent!));
        break;
      case "PRIVATE KEY":
        asn1Sequence.add(ASN1Integer(keyPair.privateKey.modulus!));
        asn1Sequence.add(ASN1Integer(keyPair.privateKey.exponent!));
        break;
    }
    var encodedBytes = asn1Sequence.encodedBytes;
    var encodedKey = base64.encode(encodedBytes);
    String keyPem = encodedKey;
    debugPrint("$keyType Pem:  $keyPem");
    return keyPem;
  }

  decodePemToKey(String keyType) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final directory = Directory(
        '${appSupportDir.path}/cryptographic_documents/rsa_key_pair/');

    // Read the file content
    final pemString =
    await File('${directory.path}public_key.pem').readAsString();

    var decodedKey = base64.decode(pemString);

    var asn1Parser = ASN1Parser(decodedKey);
    var asn1Sequence = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = asn1Sequence.elements[0] as ASN1Integer;
    var exponent = asn1Sequence.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey =
    RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
  }

  String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    var topLevel = ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus!));
    topLevel.add(ASN1Integer(publicKey.exponent!));

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    var topLevel = ASN1Sequence();
    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n!);
    var publicExponent = ASN1Integer(privateKey.exponent!);
    var privateExponent = ASN1Integer(privateKey.d!);
    var p = ASN1Integer(privateKey.p!);
    var q = ASN1Integer(privateKey.q!);
    var dP = privateKey.d! % (privateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d! % (privateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q!.modInverse(privateKey.p!);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }

  RSAPublicKey parsePublicKeyFromPem(String pemString) {
    var decodedPem = base64.decode(removePemHeaderAndFooter(pemString));
    var asn1Parser = ASN1Parser(decodedPem);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = topLevelSeq.elements[0] as ASN1Integer;
    var exponent = topLevelSeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey =
    RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);

    return rsaPublicKey;
  }

  RSAPrivateKey parsePrivateKeyFromPem(pemString) {
    var decodedPem = base64.decode(removePemHeaderAndFooter(pemString));
    var asn1Parser = ASN1Parser(decodedPem);

    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus, privateExponent, p, q;
    if (topLevelSeq.elements.length == 3) {
      var privateKey = topLevelSeq.elements[2];

      asn1Parser = ASN1Parser(privateKey.contentBytes());
      var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

      modulus = pkSeq.elements[1] as ASN1Integer;
      privateExponent = pkSeq.elements[3] as ASN1Integer;
      p = pkSeq.elements[4] as ASN1Integer;
      q = pkSeq.elements[5] as ASN1Integer;
    } else {
      modulus = topLevelSeq.elements[1] as ASN1Integer;
      privateExponent = topLevelSeq.elements[3] as ASN1Integer;
      p = topLevelSeq.elements[4] as ASN1Integer;
      q = topLevelSeq.elements[5] as ASN1Integer;
    }

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }

  String removePemHeaderAndFooter(String pem) {
    var startsWith = [
      "-----BEGIN PUBLIC KEY-----",
      "-----BEGIN RSA PRIVATE KEY-----",
      "-----BEGIN RSA PUBLIC KEY-----",
      "-----BEGIN PRIVATE KEY-----",
      "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
      "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    ];
    var endsWith = [
      "-----END PUBLIC KEY-----",
      "-----END PRIVATE KEY-----",
      "-----END RSA PRIVATE KEY-----",
      "-----END RSA PUBLIC KEY-----",
      "-----END PGP PUBLIC KEY BLOCK-----",
      "-----END PGP PRIVATE KEY BLOCK-----",
    ];
    bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

    pem = pem.replaceAll(' ', '');
    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    for (var s in startsWith) {
      s = s.replaceAll(' ', '');
      if (pem.startsWith(s)) {
        pem = pem.substring(s.length);
      }
    }

    for (var s in endsWith) {
      s = s.replaceAll(' ', '');
      if (pem.endsWith(s)) {
        pem = pem.substring(0, pem.length - s.length);
      }
    }

    if (isOpenPgp) {
      var index = pem.indexOf('\r\n');
      pem = pem.substring(0, index);
    }

    return pem;
  }

  Future<void> writeFile(String filePath, String data) async {
    final file = File(filePath);
    if (!await file.exists()) {
      file.writeAsString(data);
      debugPrint('$filePath creation successful');
    } else {
      debugPrint('$filePath Already file exists');
    }
  }

  Future<void> writeEncryptedFile(String filePath, String data) async {
    final file = await File(filePath).writeAsBytes(utf8.encode(data));
    debugPrint('$filePath creation successful');
  }

  Future<Uint8List> readEncryptedFile(String filePath) async {
    final file = File(filePath);
    var data = file.readAsBytes();
    debugPrint('$filePath creation successful');
    return data;
  }

  Future<String> readFile(String filePath) async {
    final file = File(filePath);
    var dataAsString = file.readAsString();
    return dataAsString;
  }
  // Future<String> readFile(String filePath) async {
  //   if (filePath.startsWith('File: ')) {
  //     filePath = filePath.replaceFirst('File: ', '');
  //   }
  //
  //   final file = File(filePath);
  //   var dataAsString = await file.readAsString();
  //   return dataAsString;
  // }

  Future<Uint8List> readFileAsBytes(String filePath) async {
    final file = File(filePath);
    var data = file.readAsBytes();
    return data;
  }

  String readTextFromPdfFile(String filePath) {
    final PdfDocument document =
    PdfDocument(inputBytes: File(filePath).readAsBytesSync());
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }

  Future<void> generateKeyPemFile(String asymmetricKeyPairDirectoryPath,
      {bool updateFlag = false}) async {
    final keyPair = generateRSAkeyPair(generateSecureRandom());

    final asymmetricKeyPairDirectory =
    Directory(asymmetricKeyPairDirectoryPath);

    if (updateFlag && await asymmetricKeyPairDirectory.exists()) {
      asymmetricKeyPairDirectory.deleteSync(recursive: true);
    }

    if (!await asymmetricKeyPairDirectory.exists()) {
      await asymmetricKeyPairDirectory.create(recursive: true);
      debugPrint('${asymmetricKeyPairDirectory.path}  created successfully');

      String publicKeyPem = encodePublicKeyToPemPKCS1(keyPair.publicKey);
      await writeFile(
          '${asymmetricKeyPairDirectory.path}public_key.pem', publicKeyPem);

      String privateKeyPem = encodePrivateKeyToPemPKCS1(keyPair.privateKey);
      await writeFile(
          '${asymmetricKeyPairDirectory.path}private_key.pem', privateKeyPem);
    } else {
      debugPrint(
          '${asymmetricKeyPairDirectory.path} Directory already existed');
    }
  }

  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic));

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate));

    return _processInBlocks(decryptor, cipherText);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  Future<String> asymmetricEncryptFile(String publicKeyPemFilePath, String fileToEncryptPath,
      String encryptedFilesDirectoryPath, String encryptedFileName) async {
    // Read the file content
    final publicKeyPemString = await File(publicKeyPemFilePath).readAsString();
    var publicKey = parsePublicKeyFromPem(publicKeyPemString);

    var dataFromOriginalFile = await readFile(fileToEncryptPath);
    debugPrint(dataFromOriginalFile);

    final bytesOfData = utf8.encode(dataFromOriginalFile);
    var encryptedCypher = rsaEncrypt(publicKey, bytesOfData);

    var encryptedDataAsString = String.fromCharCodes(encryptedCypher);

    final encryptedFilesDirectory = Directory(encryptedFilesDirectoryPath);
    if (!await encryptedFilesDirectory.exists()) {
      await encryptedFilesDirectory.create(recursive: true);
      debugPrint('${encryptedFilesDirectory.path}  created successfully');
    }
    await writeFile('${encryptedFilesDirectory.path}$encryptedFileName',
        encryptedDataAsString);

    return '${encryptedFilesDirectory.path}$encryptedFileName';
  }

  Future<String> asymmetricDecryptFile(String privateKeyPemFilePath, String fileToDecryptPath,
      String decryptedFilesDirectoryPath, String decryptedFileName) async {
    var encryptedDataFromFile = await readFile(fileToDecryptPath);
    var encryptedDataCipher =
    Uint8List.fromList(encryptedDataFromFile.codeUnits);

    final privateKeyPemString =
    await File(privateKeyPemFilePath).readAsString();
    var privateKey = parsePrivateKeyFromPem(privateKeyPemString);
    var decryptedData = rsaDecrypt(privateKey, encryptedDataCipher);
    var decryptedPlainData = utf8.decode(decryptedData);

    final decryptedFilesDirectory = Directory(decryptedFilesDirectoryPath);
    if (!await decryptedFilesDirectory.exists()) {
      await decryptedFilesDirectory.create(recursive: true);
      debugPrint('${decryptedFilesDirectory.path}  created successfully');
    }
    await writeFile('${decryptedFilesDirectory.path}$decryptedFileName',
        decryptedPlainData);

    debugPrint(decryptedPlainData);

    return '${decryptedFilesDirectory.path}$decryptedFileName';
  }

  Future<crypto.Digest> createHashFromFile(String filePath) async {
    var dataFromFile = await readFile(filePath);
    var bytes = utf8.encode(dataFromFile);
    var digest = crypto.sha256.convert(bytes);

    print("Digest as bytes: ${digest.bytes}");
    print("Digest as hex string: $digest");

    return digest;
  }

  Future<String> symmetricEncryptFile(
      String symmetricKeyFilePath,
      String fileToEncryptPath,
      String encryptedFilesDirectoryPath,
      String encryptedFileName) async {
    var symmetricKeyData = await readFile(symmetricKeyFilePath);
    print(symmetricKeyData);

    final key = encrypt_lib.Key.fromUtf8(symmetricKeyData);

    final b64key = encrypt_lib.Key.fromBase64(base64Url.encode(key.bytes));
    final fernet = encrypt_lib.Fernet(b64key);
    final encrypter = encrypt_lib.Encrypter(fernet);

    var dataFromFileToEncrypt = await readFile(fileToEncryptPath);
    print(dataFromFileToEncrypt);

    final encryptedData = encrypter.encrypt(dataFromFileToEncrypt);
    var encryptedDataBase64 = encryptedData.base64;
    debugPrint(encryptedDataBase64);

    final encryptedFilesDirectory = Directory(encryptedFilesDirectoryPath);
    if (!await encryptedFilesDirectory.exists()) {
      await encryptedFilesDirectory.create(recursive: true);
      debugPrint('${encryptedFilesDirectory.path}  created successfully');
    }
    await writeFile('${encryptedFilesDirectory.path}$encryptedFileName',
        encryptedDataBase64);

    return '${encryptedFilesDirectory.path}$encryptedFileName';
  }

  Future<String> symmetricDecryptFile2(
      String symmetricKeyData,
      String fileToDecryptPath,
      String decryptedFilesDirectoryPath,
      String decryptedFileName) async {

    print(symmetricKeyData);

    final key = encrypt_lib.Key.fromUtf8(symmetricKeyData);
    final b64key = encrypt_lib.Key.fromBase64(base64Url.encode(key.bytes));
    final fernet = encrypt_lib.Fernet(b64key);
    final encrypter = encrypt_lib.Encrypter(fernet);

    var encryptedFileData = await readFile(fileToDecryptPath);
    debugPrint(encryptedFileData);
    var encryptedDataCypher =
    encrypt_lib.Encrypted.fromBase64(encryptedFileData);

    final decryptedData = encrypter.decrypt(encryptedDataCypher);
    print(decryptedData);

    final decryptedFilesDirectory = Directory(decryptedFilesDirectoryPath);
    if (!await decryptedFilesDirectory.exists()) {
      await decryptedFilesDirectory.create(recursive: true);
      debugPrint('${decryptedFilesDirectory.path}  created successfully');
    }
    await writeFile(
        '${decryptedFilesDirectory.path}$decryptedFileName', decryptedData);

    return '${decryptedFilesDirectory.path}$decryptedFileName';
  }

  Future<String> symmetricDecryptFile(
      String symmetricKeyFilePath,
      String fileToDecryptPath,
      String decryptedFilesDirectoryPath,
      String decryptedFileName) async {
    var symmetricKeyData = await readFile(symmetricKeyFilePath);
    print(symmetricKeyData);

    final key = encrypt_lib.Key.fromUtf8(symmetricKeyData);
    final b64key = encrypt_lib.Key.fromBase64(base64Url.encode(key.bytes));
    final fernet = encrypt_lib.Fernet(b64key);
    final encrypter = encrypt_lib.Encrypter(fernet);

    var encryptedFileData = await readFile(fileToDecryptPath);
    debugPrint(encryptedFileData);
    var encryptedDataCypher =
    encrypt_lib.Encrypted.fromBase64(encryptedFileData);

    final decryptedData = encrypter.decrypt(encryptedDataCypher);
    print(decryptedData);

    final decryptedFilesDirectory = Directory(decryptedFilesDirectoryPath);
    if (!await decryptedFilesDirectory.exists()) {
      await decryptedFilesDirectory.create(recursive: true);
      debugPrint('${decryptedFilesDirectory.path}  created successfully');
    }
    await writeFile(
        '${decryptedFilesDirectory.path}$decryptedFileName', decryptedData);

    return '${decryptedFilesDirectory.path}$decryptedFileName';
  }

  Future<void> generateKeyFileForSymmetricCryptography(
      String symmetricKeysDirectoryPath, String symmetricKeyFileName) async {
    const charPool =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#\$%^&*()_+-=[]{}|\:;<,>.?/";
    final random = Random();
    final chars = List<String>.generate(
        32, (i) => charPool[random.nextInt(charPool.length)]);
    var randomString = chars.join();

    print(randomString);
    final symmetricKeysDirectory = Directory(symmetricKeysDirectoryPath);
    if (!await symmetricKeysDirectory.exists()) {
      await symmetricKeysDirectory.create(recursive: true);
      debugPrint('${symmetricKeysDirectory.path}  created successfully');
    }

    await writeFile(
        '${symmetricKeysDirectory.path}$symmetricKeyFileName', randomString);
    print('${symmetricKeysDirectory.path}$symmetricKeyFileName');
  }

  Future<String> getPublicKeyAsString(filePath) async {
    var dataFromFile = await readFile(filePath);
    var publicKeyString = removePemHeaderAndFooter(dataFromFile);
    debugPrint(publicKeyString);
    return publicKeyString;
  }

  Future<bool> compareHashedFiles(originalFileHash, level1DecryptedFileHash) async {
    if (originalFileHash == level1DecryptedFileHash) {
      debugPrint('Hashes matched');
      return true;
    } else {
      debugPrint('Hashes not matched');
      return false;
    }
  }

  Future<bool> generateRsaKeyPemFileFromReceivedPublicKey(
      String publicKeyPemFileDirectoryPath, String publicKeyString) async {
    final publicKeyPemFileDirectory = Directory(publicKeyPemFileDirectoryPath);
    if (!await publicKeyPemFileDirectory.exists()) {
      await publicKeyPemFileDirectory.create(recursive: true);
      debugPrint('${publicKeyPemFileDirectory.path}  created successfully');

      var publicKey = parsePublicKeyFromPem(publicKeyString);
      String publicKeyPem = encodePublicKeyToPemPKCS1(publicKey);

      await writeFile('${publicKeyPemFileDirectory.path}public_key.pem',
          publicKeyPem);
      return true;
    } else {
      debugPrint(
          '${publicKeyPemFileDirectory.path} Directory already existed');
      return false;
    }
  }

  Future<crypto.Digest> getHashFromFile(File file) async {
    var dataAsString = await file.readAsString();
    var bytes = utf8.encode(dataAsString);
    var digest = crypto.sha256.convert(bytes);
    return digest;
  }

}
