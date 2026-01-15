import 'package:entitlements/datastructure.dart';
import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mytextfield.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payables',
          style: TextStyle(
            color: MyColors.title,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            MyTextField(hintText: 'Search', icon: Icons.search),
            SizedBox(height: 30),
            if (payablesTran.isEmpty)
              Center(child: Text('No payables found'))
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
