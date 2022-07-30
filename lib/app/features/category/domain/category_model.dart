// ignore_for_file: public_member_api_docs, sort_constructors_first

class CategoryModel {
  final String categoryName;
  final String? imagePath;
  CategoryModel({
    required this.categoryName,
    this.imagePath,
  });

  CategoryModel copyWith({
    String? categoryName,
    String? imagePath,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryName': categoryName,
      'imagePath': imagePath,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'] as String,
      imagePath: map['imagePath'] as String?,
    );
  }

  @override
  String toString() =>
      'CategoryModel(categoryName: $categoryName, imagePath: $imagePath)';

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.categoryName == categoryName && other.imagePath == imagePath;
  }

  @override
  int get hashCode => categoryName.hashCode ^ imagePath.hashCode;
}
