import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/data/datastructure.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/persondetailes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyClients extends StatefulWidget {
  const MyClients({super.key});

  @override
  State<MyClients> createState() => _MyClientsState();
}

class _MyClientsState extends State<MyClients> {
  String searchName = '';
  final formkey = GlobalKey<FormState>();
  final editkey = GlobalKey<FormState>();

  List<Person> getAllPeople() {
    var box = Hive.box<Person>("clientsBox");
    return box.values.toList();
  }

  List<Person> get people => getAllPeople()
      .where(
        (person) =>
            person.name.toLowerCase().contains(searchName.toLowerCase()),
      )
      .toList();

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
                title: Text(getword(context, 'add_a_new_person')),
                content: Form(
                  key: formkey,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: getword(context, 'enter_person_name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return getword(context, 'please_enter_a_name');
                      }
                      if (!RegExp(
                        r'^[\p{L}\s]+$',
                        unicode: true,
                      ).hasMatch(value)) {
                        return getword(context, 'please_enter_a_valid_name');
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        var box = Hive.box<Person>("clientsBox");
                        box.add(
                          Person(name: nameController.text, transactions: []),
                        );
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: Text(getword(context, 'save')),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: MyColors.darkYellow, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      appBar:  Myappbar(
        title:"clients"
        ),
      body: Column(
        children: [
          SizedBox(height: 10),
          MyTextField(
            label: getword(context, 'search'),
            hintText: getword(context, 'search'),
            iconpre: Icons.search,
            onChanged: (value) {
              setState(() {
                searchName = value.toLowerCase();
              });
            },
          ),
          if (people.isEmpty)
            Center(
              child: Text(
                getword(context, 'no_people_yet'),
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
                          person.name,
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          "${person.totalAmount.toInt()}",
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Persondetailes(person: person),
                            ),
                          );
                          setState(() {});
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: MyColors.background,
                            builder: (context) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: MyColors.darkYellow,
                                      size: 30,
                                      semanticLabel: 'Edit person',
                                    ),
                                    title: Text('Edit person'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          TextEditingController editController =
                                              TextEditingController(
                                                text: person.name,
                                              );
                                          return AlertDialog(
                                            title: Text(
                                              getword(context, 'edit_name'),
                                            ),
                                            content: Form(
                                              key: editkey,
                                              child: TextFormField(
                                                controller: editController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: getword(
                                                    context,
                                                    'enter_person_name',
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return getword(
                                                      context,
                                                      'please_enter_a_name',
                                                    );
                                                  }
                                                  if (!RegExp(
                                                    r'^[\p{L}\s]+$',
                                                    unicode: true,
                                                  ).hasMatch(value)) {
                                                    return getword(
                                                      context,
                                                      'please_enter_a_valid_name',
                                                    );
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  if (editkey.currentState!
                                                      .validate()) {
                                                    person.name =
                                                        editController.text;
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Text(
                                                  getword(context, 'save'),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.delete,
                                      color: MyColors.darkYellow,
                                      size: 30,
                                      semanticLabel: 'Delete person',
                                    ),
                                    title: Text('Delete person'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete person'),
                                          content: Text(
                                            'Are you sure you want to delete this person?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                              TextButton(
                                                onPressed: () async {
                                                  final dialogContext = context;
                                                    await person.delete();
                                                    if (!dialogContext.mounted) return;
                                                    if (!mounted) return;
                                                    Navigator.pop(dialogContext);
                                                    setState(() {});
                                                    ScaffoldMessenger.of(dialogContext)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      'Person deleted',
                                                    ),
                                                  ));
                                                },
                                                child: Text('Delete'),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
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
