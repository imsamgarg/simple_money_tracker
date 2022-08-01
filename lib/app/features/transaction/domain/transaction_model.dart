// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class TransactionModel {
  final TransactionType transactionType;
  final double amount;
  final DateTime time;
  final String id;
  final String? notes;
  final String? description;
  final CategoryModel category;
  TransactionModel({
    required this.transactionType,
    required this.amount,
    required this.time,
    required this.id,
    this.notes,
    required this.description,
    required this.category,
  });

  TransactionModel copyWith({
    TransactionType? transactionType,
    double? amount,
    DateTime? time,
    String? id,
    String? notes,
    String? description,
    CategoryModel? category,
  }) {
    return TransactionModel(
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      time: time ?? this.time,
      id: id ?? this.id,
      notes: notes ?? this.notes,
      description: description ?? this.description,
      category: category ?? this.category,
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
      'category': category.toMap(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionType:
          TransactionType.fromString(map['transactionType'] as String),
      amount: map['amount'] as double,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      id: map['id'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'TransactionModel(transactionType: $transactionType, amount: $amount, time: $time, id: $id, notes: $notes, description: $description, category: $category)';
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
        other.category == category;
  }

  @override
  int get hashCode {
    return transactionType.hashCode ^
        amount.hashCode ^
        time.hashCode ^
        id.hashCode ^
        notes.hashCode ^
        description.hashCode ^
        category.hashCode;
  }
}
