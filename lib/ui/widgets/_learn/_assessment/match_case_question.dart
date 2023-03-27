import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:reorderables/reorderables.dart';
import './../../../../constants/_constants/color_constants.dart';
import './../../../../feedback/constants.dart';

class MatchCaseQuestion extends StatefulWidget {
  final question;
  final List options;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final ValueChanged<Map> parentAction;
  MatchCaseQuestion(this.question, this.options, this.currentIndex,
      this.answerGiven, this.showAnswer, this.parentAction);
  @override
  _MatchCaseQuestionQuestionState createState() =>
      _MatchCaseQuestionQuestionState();
}

class _MatchCaseQuestionQuestionState extends State<MatchCaseQuestion> {
  // ScrollController _scrollController;
  List<Widget> _rows;
  List _options = [];
  @override
  void initState() {
    super.initState();
  }

  // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
  // Otherwise an error will be thrown.

  @override
  Widget build(BuildContext context) {
    _options = widget.options;
    _rows = List<Widget>.generate(
        _options.length,
        (int index) => Container(
            // height: MediaQuery.of(context).size.height - 30,
            width: double.infinity,
            // height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: widget.showAnswer &&
                      widget.question['options'][index]['match'] !=
                          _options[index]
                  ? FeedbackColors.negativeLightBg
                  : widget.showAnswer &&
                          widget.question['options'][index]['match'] ==
                              _options[index]
                      ? FeedbackColors.positiveLightBg
                      : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey08,
                  blurRadius: 6.0,
                  spreadRadius: 0,
                  offset: Offset(
                    3,
                    3,
                  ),
                ),
              ],
              border: Border.all(
                  color: widget.showAnswer &&
                          widget.question['options'][index]['match'] !=
                              _options[index]
                      ? FeedbackColors.negativeLight
                      : widget.showAnswer &&
                              widget.question['options'][index]['match'] ==
                                  _options[index]
                          ? FeedbackColors.positiveLight
                          : AppColors.grey08),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.all(10),
            // height: 0,
            child: Text(_options[index])));

    void _onReorder(int oldIndex, int newIndex) {
      if (!widget.showAnswer) {
        setState(() {
          final temp = _options[oldIndex];
          _options[oldIndex] = _options[newIndex];
          _options[newIndex] = temp;
        });
        widget.parentAction({
          'index': widget.question['questionId'],
          'isCorrect': true,
          'value': _options
        });
      }
    }

    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: HtmlWidget(
                widget.question['question'],
                textStyle: GoogleFonts.lato(
                  color: FeedbackColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Hold and drag items on right side to reorder',
                style: GoogleFonts.lato(
                  color: FeedbackColors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.question['options'].length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        // height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey08,
                              blurRadius: 6.0,
                              spreadRadius: 0,
                              offset: Offset(
                                3,
                                3,
                              ),
                            ),
                          ],
                          border: Border.all(color: AppColors.grey08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(widget.question['options'][index]['text']),
                      );
                    },
                  ),
                ),
                Container(
                  height:
                      (widget.question['options'].length).toDouble() * 100 + 20,
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  // constraints: BoxConstraints(minHeight: 200, maxHeight: 300),
                  margin: EdgeInsets.only(top: 10),
                  child: CustomScrollView(
                    // A ScrollController must be included in CustomScrollView, otherwise
                    // ReorderableSliverList wouldn't work
                    controller: _scrollController,
                    slivers: <Widget>[
                      ReorderableSliverList(
                        delegate: ReorderableSliverChildListDelegate(_rows),
                        // or use ReorderableSliverChildBuilderDelegate if needed
                        // delegate: ReorderableSliverChildBuilderDelegate(
                        //   (BuildContext context, int index) => _rows[index],
                        //   childCount: _rows.length
                        // ),
                        onReorder: _onReorder,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
