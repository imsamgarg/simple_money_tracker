// ignore_for_file: public_member_api_docs, sort_constructors_first
class SummaryModel {
  final double totalIncome;
  final double totalExpenses;
  SummaryModel({
    required this.totalIncome,
    required this.totalExpenses,
  });

  SummaryModel copyWith({
    double? income,
    double? expenses,
  }) {
    return SummaryModel(
      totalIncome: income ?? totalIncome,
      totalExpenses: expenses ?? totalExpenses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'income': totalIncome,
      'expenses': totalExpenses,
    };
  }

  factory SummaryModel.fromMap(Map<String, dynamic> map) {
    return SummaryModel(
      totalIncome: map['income'] as double,
      totalExpenses: map['expenses'] as double,
    );
  }

  @override
  String toString() =>
      'BalanceModel(income: $totalIncome, expenses: $totalExpenses)';

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
