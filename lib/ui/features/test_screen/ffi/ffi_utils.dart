import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/ffi.dart';

/// A utility class to handle FFI calls for the Unify Secret project.
class FFIUtils {
  /// Get the stronghold file path.
  ///
  /// This method fetches the application support directory and creates a
  /// directory for Stronghold files, returning its path.
  ///
  /// Returns the path as a [String].
  static Future<String> getStrongholdFilePath() async {
    final Directory appSupportDir = await getApplicationSupportDirectory();
    final Directory appSupportDirStrongholdFolder = Directory('${appSupportDir.path}/');
    return appSupportDirStrongholdFolder.path;
  }

  /// Call FFI to get a single transaction by ID.
  ///
  /// [transactionId]: The ID of the transaction to fetch.
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiGetSingleTransaction(String transactionId, WalletInfo walletInfo) async {
    final receivedText = await api.getSingleTransaction(
        transactionId: transactionId,
        walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to get sent transactions.
  ///
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiGetSentTransactions(WalletInfo walletInfo) async {
    final receivedText = await api.getSentTransactions(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to get received transactions.
  ///
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiGetReceivedTransactions(WalletInfo walletInfo) async {
    final receivedText = await api.getReceivedTransactions(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to get addresses.
  ///
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiGetAddresses(WalletInfo walletInfo) async {
    final receivedText = await api.getAddresses(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to create a transaction.
  ///
  /// [transactionParams]: Parameters for the transaction.
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiCreateTransaction(TransactionParams transactionParams, WalletInfo walletInfo) async {
    final receivedText = await api.createTransaction(transactionParams: transactionParams, walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to create an advanced transaction.
  ///
  /// [transactionParams]: Parameters for the transaction.
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiCreateAdvancedTransaction(TransactionParams transactionParams, WalletInfo walletInfo) async {
    final receivedText = await api.createAdvancedTransaction(transactionParams: transactionParams, walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to generate an address.
  ///
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiGenerateAddress(WalletInfo walletInfo) async {
    final receivedText = await api.generateAddress(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to check balance.
  ///
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiCheckBalance(WalletInfo walletInfo) async {
    final receivedText = await api.checkBalance(walletInfo: walletInfo);
    print(receivedText.toString());
  }

  /// Call FFI to request funds.
  ///
  /// [networkInfo]: Network information required for the API call.
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiRequestFunds(NetworkInfo networkInfo, WalletInfo walletInfo) async {
    final receivedText = await api.requestFunds(networkInfo: networkInfo, walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to create a wallet account.
  ///
  /// [networkInfo]: Network information required for the API call.
  /// [walletInfo]: Wallet information required for the API call.
  static Future<void> callFfiCreateWalletAccount(NetworkInfo networkInfo, WalletInfo walletInfo) async {
    final receivedText = await api.createWalletAccount(networkInfo: networkInfo, walletInfo: walletInfo);
    print(receivedText);
  }
}

/*
import 'dart:io';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unify_secret/bridge_definitions.dart';
import 'package:unify_secret/ffi.dart';

class FFIUtils {
  /// Get the stronghold file path
  static Future<String> getStrongholdFilePath() async {
    final Directory appSupportDir = await getApplicationSupportDirectory();
    final Directory appSupportDirStrongholdFolder = Directory('${appSupportDir.path}/');
    return appSupportDirStrongholdFolder.path;
  }

  /// Call FFI to get single transaction
  static Future<void> callFfiGetSingleTransaction(String transactionId, WalletInfo walletInfo) async {
    final receivedText = await api.getSingleTransaction(
        transactionId: transactionId,
        walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to get sent transactions
  static Future<void> callFfiGetSentTransactions(WalletInfo walletInfo) async {
    final receivedText = await api.getSentTransactions(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to get received transactions
  static Future<void> callFfiGetReceivedTransactions(WalletInfo walletInfo) async {
    final receivedText = await api.getReceivedTransactions(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to get addresses
  static Future<void> callFfiGetAddresses(WalletInfo walletInfo) async {
    final receivedText = await api.getAddresses(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to create a transaction
  static Future<void> callFfiCreateTransaction(TransactionParams transactionParams, WalletInfo walletInfo) async {
    final receivedText = await api.createTransaction(transactionParams: transactionParams, walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to create an advanced transaction
  static Future<void> callFfiCreateAdvancedTransaction(TransactionParams transactionParams, WalletInfo walletInfo) async {
    final receivedText = await api.createAdvancedTransaction(transactionParams: transactionParams, walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to generate an address
  static Future<void> callFfiGenerateAddress(WalletInfo walletInfo) async {
    final receivedText = await api.generateAddress(walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to check balance
  static Future<void> callFfiCheckBalance(WalletInfo walletInfo) async {
    final receivedText = await api.checkBalance(walletInfo: walletInfo);
    print(receivedText.toString());
  }

  /// Call FFI to request funds
  static Future<void> callFfiRequestFunds(NetworkInfo networkInfo, WalletInfo walletInfo) async {
    final receivedText = await api.requestFunds(networkInfo: networkInfo, walletInfo: walletInfo);
    print(receivedText);
  }

  /// Call FFI to create a wallet account
  static Future<void> callFfiCreateWalletAccount(NetworkInfo networkInfo, WalletInfo walletInfo) async {
    final receivedText = await api.createWalletAccount(networkInfo: networkInfo, walletInfo: walletInfo);
    print(receivedText);
  }
}
*/
