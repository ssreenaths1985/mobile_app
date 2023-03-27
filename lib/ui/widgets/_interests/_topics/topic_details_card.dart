import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/_constants/color_constants.dart';
import '../../../../models/_models/course_topics_model.dart';
import '../../../../services/_services/profile_service.dart';

class TopicDetailsCard extends StatefulWidget {
  final CourseTopics topic;
  final getTopicSelectedStatus;
  final saveProfile;
  final List<dynamic> selectedTopics;

  const TopicDetailsCard(
      {Key key,
      this.topic,
      this.selectedTopics,
      this.getTopicSelectedStatus,
      this.saveProfile})
      : super(key: key);

  @override
  State<TopicDetailsCard> createState() => _TopicDetailsCardState();
}

class _TopicDetailsCardState extends State<TopicDetailsCard> {
  final ProfileService profileService = ProfileService();
  bool _isExpanded = false;

  int _getSelectedTopicsLength(List<dynamic> data) {
    var selected = [];

    for (var topic in data) {
      for (var selectedTopic in widget.selectedTopics) {
        if (topic['identifier'] == selectedTopic['identifier']) {
          selected.add(topic);
        }
      }
    }

    return selected.length;
  }

  // Future<void> _saveProfile(
  //     {String succussMessage = 'Updated successfully'}) async {
  //   Map _profileData;
  //   _profileData = {'systemTopics': widget.selectedTopics};
  //   var response;
  //   try {
  //     response = await profileService.updateProfileDetails(_profileData);
  //     // print(response.toString());
  //     if (response['params']['status'] == 'success' ||
  //         response['params']['status'] == 'SUCCESS') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(succussMessage),
  //           backgroundColor: AppColors.positiveLight,
  //         ),
  //       );
  //       widget.getTopicSelectedStatus(true);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(EnglishLang.errorMessage),
  //           backgroundColor: AppColors.positiveLight,
  //         ),
  //       );
  //     }
  //   } catch (err) {
  //     return err;
  //   }
  // }

  List<Widget> _getSelectedTopics(List<dynamic> data) {
    List<Widget> selectedTopics = [];
    var selected = [];

    for (var topic in data) {
      for (var selectedTopic in widget.selectedTopics) {
        if (topic['identifier'] == selectedTopic['identifier']) {
          selected.add(topic);
        }
      }
    }

    for (int i = 0; i < selected.length; i++) {
      selectedTopics.add(InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryThree,
            border: Border.all(color: AppColors.primaryThree),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Text(
              selected[i]['name'],
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

  List<Widget> _getSubTopics(List<dynamic> data) {
    List<Widget> subTopics = [];
    List<dynamic> temp = data;
    for (int i = 0; i < temp.length; i++) {
      if ((widget.selectedTopics.where(
              (element) => element['identifier'] == temp[i]['identifier']))
          .isNotEmpty) {
        temp[i]['isSelected'] = true;
      } else if (((widget.selectedTopics.where(
              (element) => element['identifier'] == temp[i]['identifier']))
          .isEmpty)) {
        temp[i]['isSelected'] = false;
      }
      subTopics.add(InkWell(
        onTap: () {
          setState(() {
            temp[i]['isSelected'] = !temp[i]['isSelected'];
            Map selected = {
              'identifier': temp[i]['identifier'],
              'name': temp[i]['name'],
              'children': temp[i]['children'],
            };
            if (temp[i]['isSelected']) {
              widget.selectedTopics.add(selected);
              widget.saveProfile();
            } else {
              if (widget.selectedTopics
                  .where((element) =>
                      element['identifier'] == selected['identifier'])
                  .isNotEmpty) {
                widget.selectedTopics.removeWhere((element) =>
                    element['identifier'] == selected['identifier']);
                widget.saveProfile();
              }
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: temp[i]['isSelected']
                ? AppColors.primaryThree
                : AppColors.grey04,
            border: Border.all(
                color: temp[i]['isSelected']
                    ? AppColors.primaryThree
                    : AppColors.grey08),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Text(
              temp[i]['name'],
              style: GoogleFonts.lato(
                color: temp[i]['isSelected'] ? Colors.white : AppColors.greys87,
                fontWeight: FontWeight.w400,
                wordSpacing: 1.0,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ));
    }
    return subTopics;
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
          setState(() {
            _isExpanded = value;
          });
        },
        tilePadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        title: Text(
          widget.topic.name,
          style: GoogleFonts.lato(
              color: AppColors.greys87,
              letterSpacing: 0.25,
              height: 1.5,
              fontSize: 14.0,
              fontWeight: FontWeight.w700),
        ),

        subtitle: (widget.topic.raw['children'] != null &&
                widget.topic.raw['children'].length > 0)
            ? (!_isExpanded
                ? (_getSelectedTopicsLength(widget.topic.raw['children']) > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppColors.grey16,
                              height: 32,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                "Selected topics",
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    letterSpacing: 0.25,
                                    height: 1.33,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _getSelectedTopics(
                                  widget.topic.raw['children']),
                            )
                          ],
                        ),
                      )
                    : null)
                : null)
            : null,
        children: [
          (widget.topic.raw['children'] != null &&
                  widget.topic.raw['children'].length > 0)
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _getSubTopics(widget.topic.raw['children']))
              : Center()
        ],
      ),
    );
  }
}
