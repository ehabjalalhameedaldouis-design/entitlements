import 'package:entitlements/appwords.dart';
import 'package:entitlements/datastructure.dart';
import 'package:entitlements/main.dart';
import 'package:entitlements/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getword(context, 'settings'))),
      body: Column(
        children: [
          ExpansionTile(
            leading: Icon(Icons.language),
            title: Text(getword(context, 'language')),
            childrenPadding: EdgeInsets.all(10),
            backgroundColor: MyColors.lightBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedBackgroundColor: MyColors.lightBlack,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            iconColor: MyColors.darkYellow,
            textColor: MyColors.darkYellow,
            children: [
              RadioListTile<String>(
                activeColor: MyColors.darkYellow,
                title: Text(getword(context, 'arabic_language')),
                value: 'ar',
                groupValue: Localizations.localeOf(context).languageCode,
                onChanged: (value) {
                  DebtManager.setLocale(context, Locale('ar', 'SA'));
                },
              ),
              RadioListTile<String>(
                activeColor: MyColors.darkYellow,
                title: Text(getword(context, 'chinese_language')),
                value: 'zh',
                groupValue: Localizations.localeOf(context).languageCode,
                onChanged: (value) {
                  DebtManager.setLocale(context, Locale('zh', 'CN'));
                },
              ),
              RadioListTile<String>(
                activeColor: MyColors.darkYellow,
                title: Text(getword(context, 'english_language')),
                value: 'en',
                groupValue: Localizations.localeOf(context).languageCode,
                onChanged: (value) {
                  DebtManager.setLocale(context, Locale('en', 'US'));
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.bug_report, color: MyColors.darkYellow),
            title: Text(
              getword(context, 'show_data'),
              style: TextStyle(
                color: MyColors.darkYellow,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              getword(context, 'show_data_subtitle'),
              style: TextStyle(
                color: MyColors.darkYellow,
                fontSize: 14,
              ),
            ),
            onTap: () {
              var box = Hive.box<Person>('clientsBox');
              print("==========${getword(context, 'data_log')}==========");
              if (box.isEmpty) {
                print(getword(context, 'database is empty'));
              } else {
                for (var key in box.keys) {
                  var person = box.get(key);
                  print("Name: ${person?.name}");
                  print("Transactions: ${person?.transactions.length}");
                }
              }
              print("======================================");
            },
          ),
        ],
      ),
    );
  }
}
