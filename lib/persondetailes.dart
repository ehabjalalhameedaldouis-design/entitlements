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
                        TextField(
                          controller: amountController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: getword(context, 'enter_amount'),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: getword(context, 'enter_description'),
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
                      // TextButton(onPressed: (){}, child: Text("Cancel")),
                      TextButton(
                        onPressed: () async {
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
                  final tran = widget.person.transactions[index];
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
