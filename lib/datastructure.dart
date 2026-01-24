import 'package:hive/hive.dart';
part 'datastructure.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  double amount;
  @HiveField(1)
  final DateTime time;
  @HiveField(2)
  String description;
  @HiveField(3)
  bool isdebt;

  Transaction({
    required this.amount,
    required this.time,
    required this.description,
    required this.isdebt,
  });
}

@HiveType(typeId: 1)
class Person extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
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
