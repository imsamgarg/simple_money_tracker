// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class TransactionModel {
  final TransactionType transactionType;
  final double amount;
  final DateTime time;
  final String id;
  final String? notes;
  final String description;
  final String categoryName;
  TransactionModel({
    required this.transactionType,
    required this.amount,
    required this.time,
    required this.id,
    this.notes,
    required this.description,
    required this.categoryName,
  });

  TransactionModel copyWith({
    TransactionType? transactionType,
    double? amount,
    DateTime? time,
    String? id,
    String? notes,
    String? description,
    String? categoryName,
  }) {
    return TransactionModel(
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      time: time ?? this.time,
      id: id ?? this.id,
      notes: notes ?? this.notes,
      description: description ?? this.description,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionType': transactionType.value,
      'amount': amount,
      'time': time.millisecondsSinceEpoch,
      'id': id,
      'notes': notes,
      'description': description,
      'categoryName': categoryName,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionType: _getTransactionType(map['transactionType'] as String),
      amount: map['amount'] as double,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      id: map['id'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
      description: map['description'] as String,
      categoryName: map['categoryName'] as String,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(transactionType: $transactionType, amount: $amount, time: $time, id: $id, notes: $notes, description: $description, categoryName: $categoryName)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.transactionType == transactionType &&
        other.amount == amount &&
        other.time == time &&
        other.id == id &&
        other.notes == notes &&
        other.description == description &&
        other.categoryName == categoryName;
  }

  @override
  int get hashCode {
    return transactionType.hashCode ^
        amount.hashCode ^
        time.hashCode ^
        id.hashCode ^
        notes.hashCode ^
        description.hashCode ^
        categoryName.hashCode;
  }

  static TransactionType _getTransactionType(String map) {
    if (map == TransactionType.expense.value) return TransactionType.expense;
    return TransactionType.income;
  }
}
