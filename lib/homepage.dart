// import 'package:entitlements/datastructure.dart';
import 'package:entitlements/mybuttom.dart';
import 'package:entitlements/mytextfield.dart';
import 'package:entitlements/fakedata.dart';
import 'package:entitlements/payables.dart';
import 'package:entitlements/receivablespage.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mycolors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List getRecentTransactions() {
    List recentTransactions = [];
    for (var person in myClients) {
      for (var transaction in person.transactions) {
        recentTransactions.add({"name": person.name, "data": transaction});
      }
    }
    recentTransactions.sort((a, b) => b['data'].time.compareTo(a['data'].time));
    return recentTransactions.take(4).toList();
  }

  List get recentTran => getRecentTransactions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.account_balance_wallet,
          color: Color.fromARGB(255, 34, 28, 28),
          size: 30,
        ),
        title: Text(
          'Entitlements',
          style: TextStyle(
            color: const Color.fromARGB(255, 34, 28, 28),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 34, 28, 28),
              size: 30,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: MyColors.darkYellow,
        elevation: 8,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            MyTextField(hintText: 'Search', icon: Icons.search),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: MyButtom(
                    text: 'RECEIVABLES',
                    icon: Icons.arrow_upward,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceivablesPage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: MyButtom(
                    text: 'PAYABLES',
                    icon: Icons.arrow_downward,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PayablesPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 60,
                decoration: BoxDecoration(
                  color: MyColors.lightBlack,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      color: MyColors.darkYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recentTran.length,
                itemBuilder: (context, index) {
                  final tran = recentTran[index];
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
