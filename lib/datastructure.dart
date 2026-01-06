class Transaction {
  final double amount;
  final DateTime time;
  final String description;
  final bool isdebt;

  Transaction({
    required this.amount,
    required this.time,
    required this.description,
    required this.isdebt,
  });
}

class Person {
  final String name;
  final List<Transaction> transactions;

  Person({required this.name, required this.transactions});

  double get totalAmount {
    double total = 0;
    for (var transaction in transactions) {
      total += (transaction.isdebt ? transaction.amount : -transaction.amount);
    }
    return total;
  }
}
