// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

List<Transaction> transactionFromJson(String str) => List<Transaction>.from(json.decode(str).map((x) => Transaction.fromJson(x)));

String transactionToJson(List<Transaction> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaction {
  String transactionId;
  String metadata;
  int timestamp;
  bool incoming;

  Transaction({
    required this.transactionId,
    required this.metadata,
    required this.timestamp,
    required this.incoming,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    transactionId: json["transaction_id"],
    metadata: json["metadata"],
    timestamp: json["timestamp"],
    incoming: json["incoming"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "metadata": metadata,
    "timestamp": timestamp,
    "incoming": incoming,
  };
}
