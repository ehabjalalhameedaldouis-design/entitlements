import 'package:entitlements/datastructure.dart';

List<Person> myClients = [
  Person(
    name: "عصام محمد",
    transactions: [
      Transaction(
        amount: 15000,
        time: DateTime(2025, 12, 20),
        description: " سلف هاتف",
        isdebt: true,
      ),
      Transaction(
        amount: 5000,
        time: DateTime(2026, 1, 1),
        description: " دفعة أولى",
        isdebt: false,
      ),
    ],
  ),
  Person(
    name: " صالح العبسي",
    transactions: [
      Transaction(
        amount: 45000,
        time: DateTime(2025, 11, 15),
        description: "بضاعة محل",
        isdebt: true,
      ),
    ],
  ),
  Person(
    name: " محل الأمل (أنا أطلبهم)",
    transactions: [
      Transaction(
        amount: 10000,
        time: DateTime(2025, 12, 28),
        description: " توريد بضاعة",
        isdebt: true,
      ),
    ],
  ),
  Person(
    name: " شركة الثقة (يطلبوني)",
    transactions: [
      Transaction(
        amount: 20000,
        time: DateTime(2026, 1, 2),
        description: "قيمة مواد بناء",
        isdebt: false,
      ),
    ],
  ),
];
