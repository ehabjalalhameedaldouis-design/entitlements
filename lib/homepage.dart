import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/signin.dart';
import 'package:entitlements/myclients.dart';
import 'package:entitlements/mywidgets/mycard.dart';
import 'package:entitlements/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mywidgets/mycolors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users_accounts',
  );
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(
        title: "entitlements"
        ),


      drawer: Drawer(
        backgroundColor: MyColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListView(
          children: [
            Mycard(label: 'settings', icon: Icons.settings, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            }),
              Mycard(label: 'sign out', icon: Icons.person_add, onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              }),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
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
             Card(
              color: MyColors.lightBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: StreamBuilder(
                stream: users.doc(uid).collection("My_Clients").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(getword(context, 'no_net_balance')),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(getword(context, 'no_net_balance')),
                      ),
                    );
                  }
                  double allmoney = 0;
                  for (var person in snapshot.data!.docs) {
                    allmoney += person['total_amount'];
                  }
                  return ListTile(
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
