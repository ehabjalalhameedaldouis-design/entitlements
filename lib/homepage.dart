// import 'package:entitlements/addtransaction.dart';
import 'package:entitlements/datastructure.dart';
import 'package:entitlements/mybuttom.dart';
import 'package:entitlements/myclients.dart';
import 'package:entitlements/mytextfield.dart';
// import 'package:entitlements/fakedata.dart';
import 'package:entitlements/payables.dart';
// import 'package:entitlements/persondetailes.dart';
import 'package:entitlements/receivablespage.dart';
import 'package:entitlements/settings.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mycolors.dart';
import 'package:hive/hive.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List getRecentTransactions() {
    var box = Hive.box<Person>("clientsBox");
    List<Person> people = box.values.toList();
    List recentTransactions = [];
    for (var person in people) {
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.lightBlack,
        shape: StadiumBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController nameController = TextEditingController();
              return AlertDialog(
                title: Text("add a new person"),
                content: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter person name",
                  ),
                ),
                actions: [
                  // TextButton(onPressed: (){}, child: Text("Cancel")),
                  TextButton(
                    onPressed: () {
                      var box = Hive.box<Person>("clientsBox");
                      box.add(
                        Person(name: nameController.text, transactions: []),
                      );
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: MyColors.darkYellow, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      appBar: AppBar(
        // leading: Icon(
        //   Icons.account_balance_wallet,
        //   color: MyColors.title,
        //   size: 30,
        // ),
        title: Text(
          'Entitlements',
          style: TextStyle(
            color: MyColors.title,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColors.background,
        elevation: 8,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),

      drawer: Drawer(
        backgroundColor: MyColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListView(
          children: [
            Card(
              color: MyColors.lightBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: MyColors.darkYellow),
                title: Text(
                  "My Clients",
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyClients())),
              ),
            ),
            Card(
              color: MyColors.lightBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Icon(Icons.settings, color: MyColors.darkYellow),
                title: Text(
                  "Settings",
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
              ),
            ),
          ],
        ),
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
            if (recentTran.isEmpty)
              Center(
                child: Text(
                  "No transactions yet",
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
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
                                ? Icons.add_circle
                                : Icons.remove_circle,
                            color: tran["data"].isdebt
                                ? MyColors.green
                                : MyColors.red,
                          ),
                          title: Text(
                            "${tran['name']}",
                            style: TextStyle(
                              color: tran["data"].isdebt
                                  ?MyColors.green
                                : MyColors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${tran['data'].description}",
                            style: TextStyle(
                              color: tran["data"].isdebt
                                  ? MyColors.green
                                  : MyColors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              SizedBox(height: 11),
                              Text(
                                '${tran["data"].amount} RY',
                                style: TextStyle(
                                  color: tran["data"].isdebt
                                      ? MyColors.green
                                      : MyColors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${tran['data'].time.day}/${tran['data'].time.month}/${tran['data'].time.year}',
                                style: TextStyle(
                                  color: tran["data"].isdebt
                                      ? MyColors.green
                                      : MyColors.red,
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
