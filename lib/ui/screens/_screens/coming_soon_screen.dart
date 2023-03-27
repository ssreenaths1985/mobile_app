import 'package:flutter/material.dart';
import './../../../ui/widgets/index.dart';
import '../../../constants/index.dart';

class ComingSoonScreen extends StatefulWidget {
  final bool removeGoToWeb;
  static const route = AppUrl.comingSoonPage;

  const ComingSoonScreen({Key key, this.removeGoToWeb = false})
      : super(key: key);

  @override
  _ComingSoonScreenState createState() {
    return new _ComingSoonScreenState();
  }
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   titleSpacing: 0,
        //   // leading: IconButton(
        //   //   icon: Icon(Icons.clear, color: AppColors.greys60),
        //   //   onPressed: () => Navigator.of(context).pop(),
        //   // ),
        //   // title: Text(
        //   //   'New Discussion',
        //   //   style: GoogleFonts.montserrat(
        //   //     color: AppColors.greys87,
        //   //     fontSize: 16.0,
        //   //     fontWeight: FontWeight.w600,
        //   //   ),
        //   // ),
        //   // centerTitle: true,
        // ),
        body: Padding(
      padding: const EdgeInsets.only(top: 100),
      child: ComingSoon(
        removeGoToWebButton: (widget.removeGoToWeb ? true : false),
      ),
    ));
  }
}
