import 'package:entitlements/appwords.dart';
import 'package:entitlements/datastructure.dart';
import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';

class Persondetailes extends StatefulWidget {
  const Persondetailes({super.key, required this.person});

  final Person person;

  @override
  State<Persondetailes> createState() => _PersondetailesState();
}

class _PersondetailesState extends State<Persondetailes> {
  bool debt = true;
  final formkeydescription = GlobalKey<FormState>();
  final formkeyamount = GlobalKey<FormState>();
  final formkeyeditdescription = GlobalKey<FormState>();
  final formkeyeditamount = GlobalKey<FormState>();

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
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        setState(() {});
                      }, child: Text(getword(context, 'cancel'))),
                      TextButton(
                        onPressed: () async {
                          if (formkeyamount.currentState!.validate() &&
                              formkeydescription.currentState!.validate()) {
                            widget.person.transactions.add(
                              Transaction(
                                amount: double.parse(amountController.text),
                                time: DateTime.now(),
                                description: descriptionController.text,
                                isdebt: debt,
                              ),
                            );
                            Navigator.pop(context);
                            await widget.person.save();
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

      appBar: AppBar(title: Text(widget.person.name)),

      body: Column(
        children: [
          if (widget.person.transactions.isEmpty)
            Center(
              child: Text(
                getword(context, 'no_transactions_yet'),
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
                itemCount: widget.person.transactions.length,
                itemBuilder: (context, index) {
                  final reversedIndex =
                      widget.person.transactions.length - 1 - index;
                  final tran = widget.person.transactions[reversedIndex];
                  return Card(
                    color: MyColors.lightBlack,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(
                          tran.isdebt ? Icons.remove_circle : Icons.add_circle,
                          color: tran.isdebt ? MyColors.red : MyColors.green,
                        ),
                        title: Text(
                          widget.person.name,
                          style: TextStyle(
                            color: tran.isdebt ? MyColors.red : MyColors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          tran.description,
                          style: TextStyle(
                            color: tran.isdebt ? MyColors.red : MyColors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Column(
                          children: [
                            SizedBox(height: 11),
                            Text(
                              '${tran.amount} RY',
                              style: TextStyle(
                                color: tran.isdebt
                                    ? MyColors.red
                                    : MyColors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${tran.time.day}/${tran.time.month}/${tran.time.year}',
                              style: TextStyle(
                                color: tran.isdebt
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
                                                text: tran.description,
                                              );
                                          TextEditingController
                                          amounteditController =
                                              TextEditingController(
                                                text: tran.amount.toString(),
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
                                                      if (amount == null ||
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
                                                  key: formkeyeditdescription,
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
                                                    tran.description =
                                                        descriptioneditController
                                                            .text;
                                                    tran.amount = double.parse(
                                                      amounteditController.text,
                                                    );
                                                    await widget.person.save();
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    }
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
                                      semanticLabel: 'Delete transaction',
                                    ),
                                    title: Text('Delete transaction'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete transaction'),
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
                                                await widget.person.transactions
                                                    .remove(tran);
                                                await widget.person.save();
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
            ),
        ],
      ),
    );
  }
}
