import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../respositories/index.dart';
import './../../../widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../../localization/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class NewDiscussionPage extends StatefulWidget {
  final int tid;
  final bool isCourseDiscussion;
  final int cid;
  static const route = AppUrl.profilePage;

  NewDiscussionPage(
      {Key key, this.tid, this.isCourseDiscussion = false, this.cid})
      : super(key: key);

  @override
  NewDiscussionPageState createState() => NewDiscussionPageState();
}

class NewDiscussionPageState extends State<NewDiscussionPage> {
  final ProfileService profileService = ProfileService();
  final TelemetryService telemetryService = TelemetryService();
  List<String> dropdownItems = [];
  List<String> _tags = [];
  // String selectedDropdownItem = 'Select category';
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final tagsController = TextfieldTagsController();
  bool isInitilized = false;
  var categories = [];
  int selectedIndex = 1;
  int catId;

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  List allEventsData = [];
  String deviceIdentifier;
  var telemetryEventData;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    if (_start == 0) {
      allEventsData = [];
      _generateTelemetryData();
    }
    if (widget.tid != null) {
      _discussionByTid(context);
    }
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      TelemetryPageIdentifier.addDiscussionPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.addDiscussionPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<dynamic> _getCategoryList(context) async {
    try {
      // print('_getCategoryList...');
      isInitilized = true;
      categories = await Provider.of<CategoryRepository>(context, listen: false)
          .getListOfCategories();
      // dropdownItems.add('Select category');
      // print('Hello');
      for (int i = 0; i <= categories.length; i++) {
        if (i == 0) {
          // setState(() {
          catId = categories[i].cid;
          // });

          // print('catId: $catId');
        }
        dropdownItems.add(categories[i].title);
      }
      dropdownItems = dropdownItems.toSet().toList();

      setState(() {});
      // print(dropdownItems.toString());
      return dropdownItems;
    } catch (err) {
      return err;
    }
  }

  void _setCatId(category) {
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].title == category) {
        catId = categories[i].cid;
        selectedIndex = i;
      }
    }
    // print(catId.toString());
  }

  Future<void> _discussionByTid(context) async {
    // print('CP: ' + _currentPage.toString());
    var _discussionDetails;
    try {
      var response =
          await Provider.of<DiscussRepository>(context, listen: false)
              .getDiscussionById(widget.tid, 1, '');
      titleController.text = response.title;
      String description = response.posts[0]['content'];
      description = description.replaceAll('<p dir="auto">', '');
      description = description.replaceAll('</p>', '');
      contentController.text = description;
      // print('tags' + response.tags.toString());
      for (var tag in response.tags) {
        _tags.add(tag['value']);
      }
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].cid == response.category['cid']) {
          catId = categories[i].cid;
          selectedIndex = i;
          // print('catId $catId, selectedIndex $selectedIndex');
        }
      }
      setState(() {});
      return _discussionDetails;
    } catch (err) {
      return err;
    }
  }

  Future<void> _saveDiscussion(context) async {
    // print('_saveDiscussion...');
    var response;
    try {
      if (contentController.text.length >= 8) {
        response = await Provider.of<DiscussRepository>(context, listen: false)
            .saveDiscussion(widget.tid, widget.cid == null ? catId : widget.cid,
                titleController.text, contentController.text, _tags);
        if (response == 'ok') {
          Navigator.of(context).pop();
          if (!widget.isCourseDiscussion) {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppUrl.discussionHub);
          }

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(EnglishLang.discussionAddedText),
          //     backgroundColor: AppColors.positiveLight,
          //   ),
          // );
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(EnglishLang.sentForReview),
                    content: Text(EnglishLang.moderationMessage),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(EnglishLang.close))
                    ],
                    elevation: 24.0,
                  ),
              barrierDismissible: true);
          // Future.delayed(new Duration(milliseconds: 550), () {
          //   showDialog(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //             title: Text(EnglishLang.sentForReview),
          //             content: Text(EnglishLang.moderationMessage),
          //             actions: [
          //               TextButton(
          //                   onPressed: () => Navigator.pop(context),
          //                   child: Text(EnglishLang.close))
          //             ],
          //             elevation: 24.0,
          //           ),
          //       barrierDismissible: true);
          // });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(EnglishLang.errorMessage),
              backgroundColor: AppColors.negativeLight,
            ),
          );
        }
      } else {
        final snackBar = SnackBar(
          content: Text(
            EnglishLang.postMinLengthText,
          ),
          backgroundColor: AppColors.negativeLight,
          margin: const EdgeInsets.only(bottom: 60),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (err) {
      return err;
    }
  }

  @override
  void dispose() async {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    tagsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: AppColors.greys60),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.tid != null
                ? EnglishLang.editDiscussion
                : EnglishLang.newDiscussion,
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        // Tab controller
        bottomSheet: Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: AppColors.grey08,
                blurRadius: 6.0,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  -3,
                ),
              ),
            ]),
            child: ScaffoldMessenger(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Container(
                  //   margin: const EdgeInsets.only(right: 10),
                  //   padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(color: AppColors.grey16),
                  //       borderRadius: BorderRadius.circular(4)),
                  //   child: SimpleDropdown(
                  //     items: dropdownItems,
                  //     selectedItem: dropdownItems[selectedIndex],
                  //     parentAction: _setCatId,
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {
                      _saveDiscussion(context);
                    },
                    style: TextButton.styleFrom(
                      // primary: Colors.white,
                      backgroundColor: AppColors.customBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: AppColors.grey16)),
                      // onSurface: Colors.grey,
                    ),
                    // color: AppColors.customBlue,
                    // padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(4),
                    //     side: BorderSide(color: AppColors.grey16)),
                    child: Text(
                      EnglishLang.submitPost,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: FutureBuilder(
            future: _getCategoryList(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            !widget.isCourseDiscussion
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 16),
                                    // padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    // color: Colors.blue,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: AppColors.grey16),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SimpleDropdown(
                                            items: dropdownItems,
                                            selectedItem:
                                                dropdownItems[selectedIndex],
                                            parentAction: _setCatId,
                                          ),
                                        ),
                                        // TextButton(
                                        //   onPressed: () {
                                        //     _saveDiscussion(context);
                                        //   },
                                        //   style: TextButton.styleFrom(
                                        //     // primary: Colors.white,
                                        //     backgroundColor: AppColors.customBlue,
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(4),
                                        //         side: BorderSide(
                                        //             color: AppColors.grey16)),
                                        //     // onSurface: Colors.grey,
                                        //   ),

                                        //   // padding: const EdgeInsets.fromLTRB(
                                        //   //     40, 15, 40, 15),

                                        //   child: Text(
                                        //     'Submit post',
                                        //     style: GoogleFonts.lato(
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w700,
                                        //       fontSize: 14,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )
                                : Center(),
                            TextFormField(
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              focusNode: _titleFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _titleFocus, _contentFocus);
                              },
                              keyboardType: TextInputType.multiline,
                              controller: titleController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: EnglishLang.title,
                              ),
                              onTap: () {
                                // print('Hello');
                              },
                            ),
                            TextFormField(
                              // autofocus: true,
                              focusNode: _contentFocus,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              minLines:
                                  15, //Normal textInputField will be displayed
                              maxLines: 15, // wh
                              controller: contentController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: EnglishLang.elaborateYourQuestionText,
                              ),
                            ),
                            TextFieldTags(
                              textfieldTagsController: tagsController,
                              initialTags: _tags.toSet().toList(),
                              validator: (String tag) {
                                if (tagsController.getTags.contains(tag)) {
                                  return 'you already entered that';
                                }
                                return null;
                              },
                              inputfieldBuilder: (BuildContext context,
                                  TextEditingController tec,
                                  FocusNode fn,
                                  String error,
                                  void Function(String) onChanged,
                                  void Function(String) onSubmitted) {
                                return ((context, sc, tags, onTagDelete) {
                                  _tags = tags;
                                  return TextField(
                                    controller: tec,
                                    focusNode: fn,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      isDense: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      helperText: '',
                                      hintText: tagsController.hasTags
                                          ? ''
                                          : EnglishLang.enterTags,
                                      errorText: error,
                                      prefixIconConstraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.74),
                                      prefixIcon: tags.isNotEmpty
                                          ? SingleChildScrollView(
                                              controller: sc,
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children:
                                                      tags.map((String tag) {
                                                return Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                    color:
                                                        AppColors.primaryThree,
                                                  ),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          '#$tag',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        onTap: () {
                                                          // print(
                                                          //     "$tag selected");
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          width: 4.0),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 14.0,
                                                          color: Color.fromARGB(
                                                              255,
                                                              233,
                                                              233,
                                                              233),
                                                        ),
                                                        onTap: () {
                                                          onTagDelete(tag);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList()),
                                            )
                                          : null,
                                    ),
                                    onChanged: onChanged,
                                    onSubmitted: onSubmitted,
                                  );
                                });
                              },
                              // tagsStyler: TagsStyler(
                              //     tagTextStyle: TextStyle(
                              //         fontSize: 14.0,
                              //         color: AppColors.primaryThree,
                              //         fontWeight: FontWeight.w700),
                              //     tagDecoration: BoxDecoration(
                              //       color: AppColors.grey04,
                              //       borderRadius: BorderRadius.circular(23),
                              //     ),
                              //     tagCancelIcon: Icon(Icons.cancel,
                              //         size: 18.0,
                              //         color: AppColors.primaryThree),
                              //     tagPadding:
                              //         const EdgeInsets.fromLTRB(12, 6, 6, 6)),
                              // textFieldStyler: TextFieldStyler(
                              //     helperText: '',
                              //     hintText: EnglishLang.enterTags,
                              //     textFieldBorder: OutlineInputBorder(
                              //       borderSide: BorderSide.none,
                              //     )),
                              // onTag: (tag) {
                              //   _addTag(tag);
                              // },
                              // onDelete: (tag) {
                              //   _deleteTag(tag);
                              // }
                            ),
                          ],
                        )));
              } else {
                return PageLoader(
                  bottom: 20,
                );
              }
            }));
  }
}
