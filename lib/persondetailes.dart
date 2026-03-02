import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';

class Persondetailes extends StatefulWidget {
  const Persondetailes({super.key, required this.person, required this.name});

  final DocumentReference person;
  final String name;

  @override
  State<Persondetailes> createState() => _PersondetailesState();
}

class _PersondetailesState extends State<Persondetailes> {
  bool debt = true;
  final formkeydescription = GlobalKey<FormState>();
  final formkeyamount = GlobalKey<FormState>();
  final formkeyeditdescription = GlobalKey<FormState>();
  final formkeyeditamount = GlobalKey<FormState>();

  double _toSignedAmount(double amount, bool isDebt) {
    return isDebt ? amount : -amount;
  }

  double _editDelta({
    required double oldAmount,
    required double newAmount,
    required bool isDebt,
  }) {
    final oldSigned = _toSignedAmount(oldAmount, isDebt);
    final newSigned = _toSignedAmount(newAmount, isDebt);
    return newSigned - oldSigned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.lightBlack,
        shape: StadiumBorder(),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController amountController = TextEditingController();
              TextEditingController descriptionController =
                  TextEditingController();
              return StatefulBuilder(
                builder: (context, dialogSetState) {
                  return AlertDialog(
                    title: Text(getword(context, 'add_a_new_transaction')),
                    content: Column(
                      children: [
                        Form(
                          key: formkeyamount,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: getword(context, 'enter_amount'),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return getword(
                                  context,
                                  'please_enter_a_amount',
                                );
                              }
                              double? amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return getword(
                                  context,
                                  'please_enter_a_valid_amount',
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Form(
                          key: formkeydescription,
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: getword(context, 'enter_description'),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return getword(context, 'please_enter_a_name');
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
                        SizedBox(height: 10),
                        SwitchListTile(
                          title: Text(getword(context, 'is_debt')),
                          value: debt,
                          onChanged: (value) {
                            dialogSetState(() {
                              debt = value;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(getword(context, 'cancel')),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (formkeyamount.currentState!.validate() &&
                              formkeydescription.currentState!.validate()) {
                            double amount = debt
                                ? double.parse(amountController.text)
                                : -double.parse(amountController.text);
                            WriteBatch batch = FirebaseFirestore.instance
                                .batch();
                            batch.update(widget.person, {
                              'total_amount': FieldValue.increment(amount),
                            });

                            batch.set(
                              widget.person.collection('transactions').doc(),
                              {
                                'amount': double.parse(amountController.text),
                                'description': descriptionController.text,
                                'isdebt': debt,
                                'time': DateTime.now(),
                              },
                            );
                            await batch.commit();
                            if (!context.mounted) return;
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
          );
        },
        child: Icon(Icons.add, color: MyColors.darkYellow, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      appBar: Myappbar(title: widget.name),

      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: widget.person.collection('transactions').orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data.docs.isEmpty) {
                  return Center(
                    child: Text(getword(context, 'no_transactions_yet')),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> tran = snapshot.data.docs[index]
                            .data();
                        tran['id'] = snapshot.data.docs[index].id;
                        return Card(
                          color: MyColors.lightBlack,
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: Icon(
                                tran['isdebt']
                                    ? Icons.remove_circle
                                    : Icons.add_circle,
                                color: tran['isdebt']
                                    ? MyColors.red
                                    : MyColors.green,
                              ),
                              title: Text(
                                widget.name,
                                style: TextStyle(
                                  color: tran['isdebt']
                                      ? MyColors.red
                                      : MyColors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                tran['description'],
                                style: TextStyle(
                                  color: tran['isdebt']
                                      ? MyColors.red
                                      : MyColors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  SizedBox(height: 11),
                                  Text(
                                    '${tran['amount']} RY',
                                    style: TextStyle(
                                      color: tran['isdebt']
                                          ? MyColors.red
                                          : MyColors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${tran['time'].toDate().day}/${tran['time'].toDate().month}/${tran['time'].toDate().year}',
                                    style: TextStyle(
                                      color: tran['isdebt']
                                          ? MyColors.red
                                          : MyColors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
                                            semanticLabel: 'Edit transaction',
                                          ),
                                          title: Text('Edit transaction'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                TextEditingController
                                                descriptioneditController =
                                                    TextEditingController(
                                                      text: tran['description']
                                                          .toString(),
                                                    );
                                                TextEditingController
                                                amounteditController =
                                                    TextEditingController(
                                                      text: tran['amount']
                                                          .toString(),
                                                    );
                                                return AlertDialog(
                                                  title: Text(
                                                    getword(
                                                      context,
                                                      'edit_description',
                                                    ),
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      Form(
                                                        key: formkeyeditamount,
                                                        child: TextFormField(
                                                          controller:
                                                              amounteditController,
                                                          keyboardType:
                                                              TextInputType.numberWithOptions(
                                                                decimal: true,
                                                              ),
                                                          decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText: getword(
                                                              context,
                                                              'enter_amount',
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return getword(
                                                                context,
                                                                'please_enter_a_amount',
                                                              );
                                                            }
                                                            double? amount =
                                                                double.tryParse(
                                                                  value,
                                                                );
                                                            if (amount ==
                                                                    null ||
                                                                amount <= 0) {
                                                              return getword(
                                                                context,
                                                                'please_enter_a_valid_amount',
                                                              );
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Form(
                                                        key:
                                                            formkeyeditdescription,
                                                        child: TextFormField(
                                                          controller:
                                                              descriptioneditController,
                                                          decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText: getword(
                                                              context,
                                                              'enter_description',
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
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (formkeyeditamount
                                                                .currentState!
                                                                .validate() &&
                                                            formkeyeditdescription
                                                                .currentState!
                                                                .validate()) {
                                                          final double oldAmount =
                                                              (tran['amount']
                                                                      as num)
                                                                  .toDouble();
                                                          final double newAmount =
                                                              double.parse(
                                                                amounteditController
                                                                    .text,
                                                              );
                                                          final bool isDebt =
                                                              tran['isdebt'] ==
                                                              true;
                                                          final double delta =
                                                              _editDelta(
                                                                oldAmount:
                                                                    oldAmount,
                                                                newAmount:
                                                                    newAmount,
                                                                isDebt: isDebt,
                                                              );

                                                          WriteBatch batch =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .batch();
                                                          batch.update(
                                                            widget.person
                                                                .collection(
                                                                  'transactions',
                                                                )
                                                                .doc(
                                                                  tran['id'],
                                                                ),
                                                            {
                                                              'description':
                                                                  descriptioneditController
                                                                      .text,
                                                              'amount': newAmount,
                                                            },
                                                          );
                                                          batch.update(
                                                            widget.person,
                                                            {
                                                              'total_amount':
                                                                  FieldValue.increment(
                                                                    delta,
                                                                  ),
                                                            },
                                                          );
                                                          await batch.commit();
                                                          if (context.mounted) {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        getword(
                                                          context,
                                                          'save',
                                                        ),
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
                                            semanticLabel: 'Delete transaction',
                                          ),
                                          title: Text('Delete transaction'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Delete transaction',
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete this transaction?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      double amount =
                                                          tran['amount'];
                                                      if (tran['isdebt']) {
                                                        amount = -amount;
                                                      }
                                                      WriteBatch batch =
                                                          FirebaseFirestore
                                                              .instance
                                                              .batch();
                                                      batch.update(
                                                        widget.person,
                                                        {
                                                          'total_amount':
                                                              FieldValue.increment(
                                                                amount,
                                                              ),
                                                        },
                                                      );
                                                      batch.delete(
                                                        widget.person
                                                            .collection(
                                                              'transactions',
                                                            )
                                                            .doc(tran['id']),
                                                      );
                                                      await batch.commit();
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Transaction deleted',
                                                            ),
                                                          ),
                                                        );
                                                      }
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
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
