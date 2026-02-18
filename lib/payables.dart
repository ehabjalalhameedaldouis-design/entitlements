import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/data/datastructure.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:hive/hive.dart';

class PayablesPage extends StatefulWidget {
  const PayablesPage({super.key});

  @override
  State<PayablesPage> createState() => _PayablesPageState();
}

class _PayablesPageState extends State<PayablesPage> {
  List getPayablesTransactions() {
    var box = Hive.box<Person>("clientsBox");
    List<Person> people = box.values.toList();
    List payablesTransactions = [];
    for (var person in people) {
      double balance = person.totalAmount;
      if (balance < 0) {
        payablesTransactions.add({"name": person.name, "amount": balance});
      }
    }
    payablesTransactions.sort((a, b) => b['amount'].compareTo(a['amount']));
    return payablesTransactions.toList();
  }

  List get payablesTran => getPayablesTransactions();
  double get allpayables => payablesTran.fold(0, (previousValue, element) => previousValue + element['amount']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(
        title:"payables"
        ),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            if (payablesTran.isEmpty)
              Center(child: Text(getword(context, 'no_payables_found')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: payablesTran.length,
                  itemBuilder: (context, index) {
                    final tran = payablesTran[index];
                    return Card(
                      color: MyColors.lightBlack,
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Icon(
                            Icons.remove_circle,
                            color: MyColors.red,
                          ),
                          title: Text(
                            "${tran['name']}",
                            style: TextStyle(
                              color: MyColors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              SizedBox(height: 11),
                              Text(
                                '${tran["amount"]} RY',
                                style: TextStyle(
                                  color: MyColors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
        ),
      ),
    );
  }
}

double getallpayables() {
  var box = Hive.box<Person>("clientsBox");
  double total = 0;
  for (var person in box.values) {
    if (person.totalAmount < 0) {
      total += person.totalAmount;
    }
  }
  return total;
}
