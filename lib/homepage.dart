import 'package:entitlements/mywidget.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
          backgroundColor: const Color.fromARGB(255, 222, 169, 10),
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
            ],
          ),
        ),
      );
  }
}
