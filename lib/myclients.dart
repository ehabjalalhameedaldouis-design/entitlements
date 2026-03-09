import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/persondetailes.dart';
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
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users_accounts',
  );
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addUser(String name, BuildContext context) {
    final String normalizedName = name.trim().toLowerCase();
    return users
        .doc(uid)
        .collection("My_Clients")
        .add({
          'full_name': normalizedName,
          'created_at': FieldValue.serverTimestamp(),
          'total_amount': 0,
        })
        .then((value) {
          if (!context.mounted) return;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${name.trim()} ${getword(context, 'save')}')),
          );
        })
        .catchError((error) {
          if (!context.mounted) return;
          setState(() {});
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        });
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
                stream: users
                    .doc(uid)
                    .collection("My_Clients")
                    .orderBy('full_name')
                    .where('full_name', isGreaterThanOrEqualTo: searchName)
                    .where('full_name', isLessThanOrEqualTo: '$searchName\uf8ff')
                    .snapshots(),
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
                                person: users
                                    .doc(uid)
                                    .collection("My_Clients")
                                    .doc(person.id),
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
                                      semanticLabel: 'edit_person',
                                    ),
                                    title: Text(getword(context, 'edit_person')),
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
                                                    final String normalizedName =
                                                        editController.text
                                                            .trim()
                                                            .toLowerCase();
                                                    users
                                                        .doc(uid)
                                                        .collection(
                                                          "My_Clients",
                                                        )
                                                        .doc(person.id)
                                                        .update({
                                                          'full_name':
                                                              normalizedName,
                                                        });
                                                    if (!context.mounted) return;
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          getword(
                                                            context,
                                                            'person_updated',
                                                          ),
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
                                      semanticLabel: 'delete_person',
                                    ),
                                    title: Text(getword(context, 'delete_person')),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            getword(context, 'delete_person'),
                                          ),
                                          content: Text(
                                            getword(
                                              context,
                                              'confirm_delete_person',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(getword(context, 'cancel')),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                WriteBatch batch =
                                                    FirebaseFirestore.instance
                                                        .batch();
                                                var clientDoc = users
                                                    .doc(uid)
                                                    .collection("My_Clients")
                                                    .doc(person.id);
                                                var transactions =
                                                    await clientDoc
                                                        .collection(
                                                          "transactions",
                                                        )
                                                        .get();
                                                for (var transaction
                                                    in transactions.docs) {
                                                  batch.delete(
                                                    transaction.reference,
                                                  );
                                                }

                                                batch.delete(clientDoc);
                                                await batch.commit();
                                                if (!context.mounted) return;
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      getword(
                                                        context,
                                                        'person_deleted',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(getword(context, 'delete')),
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
