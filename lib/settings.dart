import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/data/datastructure.dart';
import 'package:entitlements/main.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

// ignore_for_file: deprecated_member_use

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(
        title:"settings"
        ),
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
                  var box = Hive.box('settingsBox');
                  box.put('language', value);
                },
              ),
                RadioListTile<String>(
                activeColor: MyColors.darkYellow,
                title: Text(getword(context, 'chinese_language')),
                value: 'zh',
                groupValue: Localizations.localeOf(context).languageCode,
                onChanged: (value) {
                  DebtManager.setLocale(context, Locale('zh', 'CN'));
                  var box = Hive.box('settingsBox');
                  box.put('language', value);
                },
              ),
                RadioListTile<String>(
                activeColor: MyColors.darkYellow,
                title: Text(getword(context, 'english_language')),
                value: 'en',
                groupValue: Localizations.localeOf(context).languageCode,
                onChanged: (value) {
                  DebtManager.setLocale(context, Locale('en', 'US'));
                  var box = Hive.box('settingsBox');
                  box.put('language', value);
                },
              ),
            ],
          ),
         
        ],
      ),
    );
  }
}
