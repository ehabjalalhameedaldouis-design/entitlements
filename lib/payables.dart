import 'package:entitlements/fakedata.dart';
import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mytextfield.dart';

class PayablesPage extends StatefulWidget {
  const PayablesPage({super.key});

  @override
  State<PayablesPage> createState() => _PayablesPageState();
}

class _PayablesPageState extends State<PayablesPage> {
  List getPayablesTransactions() {
    List payablesTransactions = [];
    for (var person in myClients) {
      double balance = person.totalAmount;
      if (balance < 0) {
        payablesTransactions.add({"name": person.name, "amount": balance});
      }
    }
    payablesTransactions.sort(
      (a, b) => b['amount'].compareTo(a['amount']),
    );
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
            color: const Color.fromARGB(255, 34, 33, 28),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkYellow,
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
            Expanded(
              child: ListView.builder(
                itemCount: payablesTran.length,
                itemBuilder: (context, index) {
                  final tran = payablesTran[index];
                  return Card(
                    color: const Color.fromARGB(255, 240, 47, 12),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(Icons.remove_circle,
                          color: Colors.red,
                        ),
                        title: Text(
                          "${tran['name']}",
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // subtitle: Text(
                        //   "${tran['data'].description}",
                        //   style: TextStyle(
                        //     color: MyColors.darkYellow,
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        trailing: Column(
                          children: [
                            SizedBox(height: 11),
                            Text(
                              '${tran["amount"]} EGP',
                              style: TextStyle(
                                color: MyColors.darkYellow,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Text(
                            //   '${tran['data'].time.day}/${tran['data'].time.month}/${tran['data'].time.year}',
                            //   style: TextStyle(
                            //     color: MyColors.darkYellow,
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
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
