enum TransactionType {
  expense("Expense"),
  income("Income");

  const TransactionType(this.value);
  final String value;

  factory TransactionType.fromString(String type) {
    if (type == TransactionType.expense.value) return TransactionType.expense;
    if (type == TransactionType.income.value) return TransactionType.income;
    throw UnsupportedError("$type not supported");
  }
}
