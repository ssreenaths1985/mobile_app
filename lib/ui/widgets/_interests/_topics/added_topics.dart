import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/_constants/color_constants.dart';

class AddedTopics extends StatefulWidget {
  final addedTopics;
  final removeFromAddedTopic;
  const AddedTopics({Key key, this.addedTopics, this.removeFromAddedTopic})
      : super(key: key);

  @override
  State<AddedTopics> createState() => _AddedTopicsState();
}

class _AddedTopicsState extends State<AddedTopics> {
  List<Widget> _getSelectedTopics(List<dynamic> data) {
    List<Widget> selectedTopics = [];
    // var selected = [];

    // for (var topic in data) {
    //   for (var selectedTopic in widget.selectedTopics) {
    //     if (topic['identifier'] == selectedTopic['identifier']) {
    //       selected.add(topic);
    //     }
    //   }
    // }

    for (int i = 0; i < data.length; i++) {
      selectedTopics.add(InkWell(
        onTap: () {
          widget.removeFromAddedTopic(data[i]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryThree,
            border: Border.all(color: AppColors.primaryThree),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Text(
              data[i],
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                wordSpacing: 1.0,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ));
    }
    return selectedTopics;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        expandedAlignment: Alignment.topLeft,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        childrenPadding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
        // collapsedTextColor: AppColors.primaryThree,
        onExpansionChanged: (value) async {
          // setState(() {
          //   _isExpanded = value;
          // });
        },
        tilePadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        title: Text(
          'Added by you',
          style: GoogleFonts.lato(
              color: AppColors.greys87,
              letterSpacing: 0.25,
              height: 1.5,
              fontSize: 14.0,
              fontWeight: FontWeight.w700),
        ),

        // subtitle: Text('data'),
        children: [
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getSelectedTopics(widget.addedTopics))
        ],
      ),
    );
  }
}
