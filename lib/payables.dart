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
      for (var transaction in person.transactions) {
        if (!transaction.isdebt) {
            payablesTransactions.add({"name": person.name, "data": transaction});
          }
      }
    }
    payablesTransactions.sort((a, b) => b['data'].time.compareTo(a['data'].time));
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
                    color: MyColors.lightBlack,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(
                          tran["data"].isdebt
                              ? Icons.remove_circle
                              : Icons.add_circle,
                          color: tran["data"].isdebt
                              ? Colors.red
                              : Colors.green,
                        ),
                        title: Text(
                          "${tran['name']}",
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${tran['data'].description}",
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Column(
                          children: [
                            SizedBox(height: 11),
                            Text(
                              '${tran["data"].amount} EGP',
                              style: TextStyle(
                                color: MyColors.darkYellow,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${tran['data'].time.day}/${tran['data'].time.month}/${tran['data'].time.year}',
                              style: TextStyle(
                                color: MyColors.darkYellow,
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
