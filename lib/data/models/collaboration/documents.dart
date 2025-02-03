import 'package:hive/hive.dart';

part 'documents.g.dart';

@HiveType(typeId: 2)
class Documents extends HiveObject {
  @HiveField(0)
  String? collaborationId;
  @HiveField(1)
  String? documentName;
  @HiveField(2)
  bool? documentShareStatus;
  @HiveField(3)
  String? filePath;
  @HiveField(4)
  String? fileId;
  @HiveField(5)
  String? fileOriginalName;
  @HiveField(6)
  String? generateKeyFileForSymmetricCryptography;
  @HiveField(7)
  String? symmetricEncryptFile;
  @HiveField(8)
  String? asymmetricEncryptFile;
  @HiveField(9)
  String? asymmetricDecryptFile;
  @HiveField(10)
  String? symmetricDecryptFile;
  @HiveField(11)
  String? originalFileHash;
  @HiveField(12)
  String? symmetricEncryptFileHash;
  @HiveField(13)
  bool? ownDocument;
  @HiveField(14)
  String? originalFileHashTransactionId;
  @HiveField(15)
  String? symmetricEncryptFileHashTransactionId;
  @HiveField(16)
  String? symmetricDecryptFileHash;
  @HiveField(17)
  String? asymmetricDecryptFileHash;
  @HiveField(18)
  String? symmetricDecryptFileHashTransactionId;
  @HiveField(19)
  String? asymmetricDecryptFileHashTransactionId;
  @HiveField(20)
  bool? isCryptographicKeyShared;
  @HiveField(21)
  String? cryptographicKeyTransactionId;
  @HiveField(22)
  bool? isFileEncrypted;


  Documents({
    this.collaborationId,
    this.documentName,
    this.documentShareStatus,
    this.filePath,
    this.fileId,
    this.fileOriginalName,
    this.generateKeyFileForSymmetricCryptography,
    this.symmetricEncryptFile,
    this.asymmetricEncryptFile,
    this.asymmetricDecryptFile,
    this.symmetricDecryptFile,
    this.originalFileHash,
    this.symmetricEncryptFileHash,
    this.ownDocument,
    this.originalFileHashTransactionId,
    this.symmetricEncryptFileHashTransactionId,
    this.symmetricDecryptFileHash,
    this.asymmetricDecryptFileHash,
    this.symmetricDecryptFileHashTransactionId,
    this.asymmetricDecryptFileHashTransactionId,
    this.isCryptographicKeyShared,
    this.cryptographicKeyTransactionId,
    this.isFileEncrypted,
  });
}
