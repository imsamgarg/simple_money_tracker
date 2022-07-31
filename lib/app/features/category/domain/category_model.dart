// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class CategoryModel {
  final int? id;
  final String categoryName;
  final String? imagePath;
  final TransactionType type;
  CategoryModel({
    this.id,
    required this.categoryName,
    this.imagePath,
    required this.type,
  });

  CategoryModel copyWith({
    int? id,
    String? categoryName,
    String? imagePath,
    TransactionType? type,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'categoryName': categoryName,
      if (imagePath != null) 'imagePath': imagePath,
      'type': type.value,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      categoryName: map['categoryName'] as String,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
      type: TransactionType.fromString(
        map['type'] as String,
      ),
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, categoryName: $categoryName, imagePath: $imagePath, transactionType: $type)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.categoryName == categoryName &&
        other.imagePath == imagePath &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryName.hashCode ^
        imagePath.hashCode ^
        type.hashCode;
  }
}
