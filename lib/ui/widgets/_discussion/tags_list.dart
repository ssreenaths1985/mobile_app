import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../ui/pages/index.dart';
import './../../../constants/index.dart';
import './../../../util/faderoute.dart';
import './../../../localization/index.dart';

class TagsList extends StatefulWidget {
  final data;
  final ValueChanged<String> parentAction;

  TagsList(this.data, this.parentAction);

  @override
  State<TagsList> createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  final _textController = TextEditingController();
  List _filteredTagsList = [];

  @override
  void initState() {
    super.initState();
    _filteredTagsList = widget.data;
  }

  _filterTags(value) {
    setState(() {
      _filteredTagsList = widget.data
          .where((tag) => tag.tagValue.toString().toLowerCase().contains(value))
          .toList();
      // });
    });
  }

  @override
  void dispose() async {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          // Heading
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            color: Colors.white,
            height: 48,
            child: TextFormField(
                controller: _textController,
                onChanged: (value) {
                  _filterTags(value);
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.lato(fontSize: 14.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: AppColors.grey16,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1.0),
                    borderSide: BorderSide(
                      color: AppColors.primaryThree,
                    ),
                  ),
                  hintText: EnglishLang.searchByName,
                  hintStyle: GoogleFonts.lato(
                      color: AppColors.greys60,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: '',
                )),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              // Tags list
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < _filteredTagsList.length; i++)
                          InkWell(
                              onTap: () {
                                this.widget.parentAction(
                                    _filteredTagsList[i].tagValue);
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                      page: FilteredDiscussionsPage(
                                    isCategory: false,
                                    id: _filteredTagsList[i].tagScore,
                                    title: _filteredTagsList[i].tagValue,
                                    backToTitle: EnglishLang.backToTrendingTags,
                                  )),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 10.0,
                                  right: 15.0,
                                ),
                                padding: EdgeInsets.fromLTRB(20, 5, 15, 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(color: AppColors.grey08),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(05),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(05)),
                                ),
                                child: Wrap(
                                  children: [
                                    Text(
                                      _filteredTagsList[i].tagValue,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys87,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 2, 4, 2),
                                        // decoration: BoxDecoration(
                                        //   color: AppColors.grey08,
                                        //   border:
                                        //       Border.all(color: AppColors.grey08),
                                        //   borderRadius: BorderRadius.circular(4),
                                        // ),
                                        child: Text(
                                          _filteredTagsList[i]
                                              .tagScore
                                              .toString(),
                                          style: GoogleFonts.lato(
                                            color: AppColors.primaryThree,
                                            // wordSpacing: 1.0,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ))
                                  ],
                                ),
                              ))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
