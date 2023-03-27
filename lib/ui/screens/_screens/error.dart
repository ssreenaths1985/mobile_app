import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import './../../../localization/index.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigTip(
        title: Text(EnglishLang.errorOccurred),
        subtitle: Text(EnglishLang.pageNotAvailableText),
        action: InkWell(
            child: Text(EnglishLang.goBack),
            onTap: () => Navigator.pop(context)),
        child: Icon(Icons.error_outline),
      ),
    );
  }
}
