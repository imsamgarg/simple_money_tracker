// ignore_for_file: public_member_api_docs, sort_constructors_first
class SummaryModel {
  final double totalIncome;
  final double totalExpenses;
  SummaryModel({
    this.totalIncome = 0,
    this.totalExpenses = 0,
  });

  SummaryModel copyWith({
    double? totalIncome,
    double? totalExpenses,
  }) {
    return SummaryModel(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
    };
  }

  factory SummaryModel.fromMap(Map<String, dynamic> map) {
    return SummaryModel(
      totalIncome: map['totalIncome'] as double,
      totalExpenses: map['totalExpenses'] as double,
    );
  }

  @override
  String toString() =>
      'SummaryModel(totalIncome: $totalIncome, totalExpenses: $totalExpenses)';

  @override
  bool operator ==(covariant SummaryModel other) {
    if (identical(this, other)) return true;

    return other.totalIncome == totalIncome &&
        other.totalExpenses == totalExpenses;
  }

  @override
  int get hashCode => totalIncome.hashCode ^ totalExpenses.hashCode;
}

extension SummaryExt on SummaryModel {
  double get balance => totalIncome - totalExpenses;
}
