import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/persondetailes.dart';
import 'package:entitlements/services/clients_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyClients extends StatefulWidget {
  const MyClients({super.key});

  @override
  State<MyClients> createState() => _MyClientsState();
}

class _MyClientsState extends State<MyClients> {
  String searchName = '';
  final formkey = GlobalKey<FormState>();
  final editkey = GlobalKey<FormState>();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late final ClientsService clientsService;

  Future<void> addUser(String name, BuildContext context) {
    return clientsService
        .addClient(name)
        .then((value) {
          if (!context.mounted) return;
          setState(() {});
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$name added successfully")));
        })
        .catchError((error) {
          if (!context.mounted) return;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add client: $error")),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    clientsService = ClientsService(uid: uid);
  }

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
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await addUser(nameController.text, context);
                        if (!context.mounted) return;
                        Navigator.pop(context);
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

      appBar: Myappbar(title: "clients"),
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
            Expanded(
              child: StreamBuilder(
                stream: clientsService.getClientsQuery(searchName).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text(getword(context, 'no_clients_found')));
                  }
                    List people = snapshot.data!.docs;
                  return ListView.builder(
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
                          person['full_name'],
                          style: TextStyle(
                            color: MyColors.darkYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          "${person['total_amount']} ${getword(context, 'currency')}",
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
                              builder: (context) => Persondetailes(
                                person: clientsService.clientDoc(person.id),
                                name: person['full_name'],
                              ),
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
                                                text: person['full_name'],
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
                                                onPressed: () async {
                                                  if (editkey.currentState!
                                                      .validate()) {
                                                    await clientsService
                                                        .updateClientName(
                                                          person.id,
                                                          editController.text,
                                                        );
                                                    if (!context.mounted) return;
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Person updated',
                                                        ),
                                                      ),
                                                    );
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
                                                await clientsService
                                                    .deleteClientWithTransactions(
                                                      person.id,
                                                    );
                                                if (!context.mounted) return;
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Person deleted',
                                                    ),
                                                  ),
                                                );
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
              );
                },              ),
            ),
        ],
      ),
    );
  }
}
