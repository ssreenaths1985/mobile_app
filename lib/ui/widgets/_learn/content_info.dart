import 'package:flutter/material.dart';

import '../../../constants/_constants/color_constants.dart';

class ContentInfo extends StatelessWidget {
  final String infoMessage;
  const ContentInfo({Key key, this.infoMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Tooltip(
        child: Icon(
          Icons.info_outline,
          color: AppColors.greys87,
        ),
        // textStyle: GoogleFonts.lato(color: AppColors.greys87),
        message: infoMessage
            .replaceAll('<p class="ws-mat-primary-text">', '')
            .replaceAll('</p>', ''),
        showDuration: Duration(seconds: 10),
        // preferBelow: false,
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 32, right: 32),
        verticalOffset: 20,
        triggerMode: TooltipTriggerMode.tap,
      ),
    );
  }
}
