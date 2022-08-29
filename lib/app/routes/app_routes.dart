enum AppRoutes {
  home("/"),
  addExpense("add-expense"),
  addIncome("add-income"),
  transactions("transactions");

  final String path;
  const AppRoutes(this.path);
}
