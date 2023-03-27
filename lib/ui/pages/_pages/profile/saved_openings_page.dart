import 'package:flutter/material.dart';
import './../../../../localization/_langs/english_lang.dart';

class SavedOpeningsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(EnglishLang.savedOpenings)))
          ],
        ),
      ),
    );
  }
}
