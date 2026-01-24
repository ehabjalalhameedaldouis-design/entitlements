// import 'package:entitlements/addtransaction.dart';
import 'package:entitlements/appwords.dart';
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
    return recentTransactions.take(3).toList();
  }

  List get recentTran => getRecentTransactions();
  double allreceivables = 0;
  double allpayables = 0;
  double allmoney = 0;

  @override
  void initState() {
    allreceivables = getallreceivables();
    allpayables = getallpayables();
    allmoney = allreceivables - allpayables;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getword(context, 'entitlements'),
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
                leading: Icon(Icons.settings, color: MyColors.darkYellow),
                title: Text(
                  getword(context, 'settings'),
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                ),
              ),
            ),
            Card(
              color: MyColors.lightBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Icon(Icons.money, color: MyColors.darkYellow),
                title: Text(
                  getword(context, 'allmoney'),
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  allmoney.toString(),
                  style: TextStyle(
                    color: MyColors.darkYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            Row(
              children: [
                Expanded(
                  child: MyButtom(
                    text: getword(context, 'receivables'),
                    icon: Icons.arrow_upward,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceivablesPage(),
                        ),
                      );
                    },
                    allamount: allreceivables,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: MyButtom(
                    text: getword(context, 'payables'),
                    icon: Icons.arrow_downward,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PayablesPage()),
                      );
                    },
                    allamount: allpayables,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyClients()),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: MyColors.lightBlack,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: MyColors.darkYellow),
                          SizedBox(width: 4),
                          Text(
                            getword(context, 'my_clients'),
                            style: TextStyle(
                              color: MyColors.darkYellow,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
