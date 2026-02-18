import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/data/datastructure.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:hive/hive.dart';

class ReceivablesPage extends StatefulWidget {
  const ReceivablesPage({super.key});

  @override
  State<ReceivablesPage> createState() => _ReceivablesPageState();
}

class _ReceivablesPageState extends State<ReceivablesPage> {
  List getReceivablesTransactions() {
    var box = Hive.box<Person>("clientsBox");
    List<Person> people = box.values.toList();
    List receivablesTransactions = [];
    for (var person in people) {
      double balance = person.totalAmount;
      if (balance > 0) {
        receivablesTransactions.add({"name": person.name, "amount": balance});
      }
    }
    receivablesTransactions.sort((a, b) => b['amount'].compareTo(a['amount']));
    return receivablesTransactions.toList();
  }

  List get receivablesTran => getReceivablesTransactions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(
        title:"receivables"
        ),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            if (receivablesTran.isEmpty)
              Center(child: Text(getword(context, 'no_receivables_found')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: receivablesTran.length,
                  itemBuilder: (context, index) {
                    final tran = receivablesTran[index];
                    return Card(
                      color: MyColors.lightBlack,
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Icon(
                            Icons.add_circle,
                            color: MyColors.green,
                          ),
                          title: Text(
                            "${tran['name']}",
                            style: TextStyle(
                              color: MyColors.green,
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
                                  color: MyColors.green,
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

double getallreceivables() {
  var box = Hive.box<Person>("clientsBox");
  double total = 0;
  for (var person in box.values) {
    if (person.totalAmount > 0) {
      total += person.totalAmount;
    }
  }
  return total;
}
