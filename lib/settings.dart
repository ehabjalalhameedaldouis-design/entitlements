import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/main.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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
         
        ],
      ),
    );
  }
}
