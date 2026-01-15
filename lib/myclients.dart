import 'package:entitlements/datastructure.dart';
import 'package:entitlements/mycolors.dart';
import 'package:entitlements/persondetailes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyClients extends StatefulWidget {
  const MyClients({super.key});

  @override
  State<MyClients> createState() => _MyClientsState();
}

class _MyClientsState extends State<MyClients> {
  List<Person> getAllPeople() {
    var box = Hive.box<Person>("clientsBox");
    return box.values.toList();
  }

  List<Person> get people => getAllPeople();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clients")),
      body: Column(
        children: [
          if (people.isEmpty)
            Center(
              child: Text(
                "No people yet",
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
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];
                  return Card(
                    color: MyColors.lightBlack,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(Icons.person, color: MyColors.darkYellow),
                        title: Text(
                          "Person ${index + 1}",
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          person.name,
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Persondetailes(person: person),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
