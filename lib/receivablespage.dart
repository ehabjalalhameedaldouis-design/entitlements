import 'package:entitlements/appwords.dart';
import 'package:entitlements/datastructure.dart';
// import 'package:entitlements/fakedata.dart';
import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mytextfield.dart';
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
      appBar: AppBar(
        title: Text(
          getword(context, 'receivables'),
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
            MyTextField(
              hintText: getword(context, 'search'),
              icon: Icons.search,
            ),
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
