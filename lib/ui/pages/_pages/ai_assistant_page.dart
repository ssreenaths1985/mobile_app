import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:karmayogi_mobile/constants/_constants/vega_help.dart';
import 'package:karmayogi_mobile/models/_models/vega_help_model.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../services/index.dart';
// import './../../../ui/pages/_pages/text_search_results/text_search_page.dart';
// import './../../../ui/widgets/_assistant/bot_chat_message.dart';
import './../../../ui/widgets/_assistant/chat_message.dart';
import './../../../ui/widgets/_assistant/recently_searched.dart';
import './../../../ui/widgets/_assistant/voice_search_results.dart';
import './../../../util/speech_recognizer.dart';

class AiAssistantPage extends StatefulWidget {
  static const route = AppUrl.aiAssistantPage;
  final int index;
  final String searchKeyword;
  AiAssistantPage({Key key, this.searchKeyword, this.index}) : super(key: key);

  @override
  _AiAssistantPageState createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage>
    with SingleTickerProviderStateMixin {
  var _searchActionIcon = Icons.mic_rounded;
  final textController = TextEditingController();
  final SuggestionService suggestionService = SuggestionService();
  SpeechRecognizer _speechRecognizer;
  String _searchKeyword;
  bool _isListening;
  bool _isNewSearchkey = true;
  bool _hasPressedMore = false;
  final _commandController = TextEditingController();

  List recentlySearchedNames = [
    'Raman Srivastava',
    'Communication Skills',
    'Administrative Law'
  ];

  @override
  void initState() {
    super.initState();
    // textController.addListener(searchResults(searchKey));
    _isListening = true;
    _searchKeyword = widget.searchKeyword;
    textController.text = widget.searchKeyword;
    // print(_speechRecognizer);

    if (widget.index == 2) {
      Future.delayed(Duration.zero, () async {
        _speechRecognizer =
            Provider.of<SpeechRecognizer>(context, listen: false);
        _speechRecognizer.initialize(_searchResults);
        _speechRecognizer.listen();
      });
    }
  }

  _navigateToSubPage(context) async {
    // _recognizedText = 'None';
    Future.delayed(Duration.zero, () async {
      _speechRecognizer = Provider.of<SpeechRecognizer>(context, listen: false);
      _speechRecognizer.initialize(_searchResults);
      _speechRecognizer.listen();
      if (mounted) {
        setState(() {
          _isNewSearchkey = false;
        });
      }
    });
  }

  Widget buildRecentlySearchedList(BuildContext context, int index) {
    final recent = recentlySearchedNames[index];
    return Center(child: RecentlySearched(recent));
  }

  void _searchResults(String searchKey) async {
    if (mounted) {
      setState(() {
        textController.text = searchKey;
        _searchKeyword = searchKey;
        _isNewSearchkey = true;
      });
    }
    // print('$searchKey');
  }

  void isListening() {
    final sr = Provider.of<SpeechRecognizer>(context, listen: true);
    if (mounted) {
      setState(() {
        _isListening = sr.isStatusListening;
      });
    }
    // print(_isListening.toString());
  }

  _getListData() {
    List<Widget> widgets = [];
    List<String> intents = [
      "CBP provider leaderboard",
      "Top courses by user ratings",
      "Top mdos by course completion",
      "Top 10 posts",
      "Latest courses",
    ];
    for (int i = 0; i < 5; i++) {
      widgets.add(Container(
          padding: EdgeInsets.only(left: 12, bottom: 1),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _searchKeyword = intents[i];
                _isNewSearchkey = false;
                Future.delayed(Duration(milliseconds: 100), () async {
                  _searchResults(_searchKeyword);
                });
              });
            },
            child: Text(
              intents[i],
            ),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0)),
                textStyle: GoogleFonts.lato(letterSpacing: 0.5, fontSize: 16),
                elevation: 0,
                foregroundColor: AppColors.greys87,
                backgroundColor: intents[i] == textController.text
                    ? AppColors.primaryOne.withOpacity(0.2)
                    : Colors.white,
                side: intents[i] == textController.text
                    ? null
                    : BorderSide(width: 1.0, color: AppColors.grey16)),
          )));
    }
    widgets.add(Container(
        padding: EdgeInsets.only(left: 12, bottom: 1),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _hasPressedMore = !_hasPressedMore;
            });
          },
          child: Text("More"),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.0)),
              textStyle: GoogleFonts.lato(letterSpacing: 0.5, fontSize: 16),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.greys87,
              side: BorderSide(width: 1.0, color: AppColors.grey16)
              // minimumSize: const Size.fromHeight(40), // NEW
              ),
        )));

    return widgets;
  }

  _showHelpWidget() {
    List<VegaHelpItem> helpItem =
        isMDOAdmin ? VEGA_HELP_ITEMS_MDO : VEGA_HELP_ITEMS_SPV;
    List<Widget> widgets = [];

    _getEachIntents(List<String> intents) {
      List<Widget> widgets = [];
      for (var i = 0; i < intents.length; i++) {
        widgets.add(ElevatedButton(
          onPressed: () {
            setState(() {
              _searchKeyword = intents[i];
              _isNewSearchkey = false;
              Future.delayed(Duration(milliseconds: 100), () async {
                _searchResults(_searchKeyword);
              });
              _hasPressedMore = !_hasPressedMore;
            });
          },
          child: Text(intents[i]),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.0)),
              textStyle: GoogleFonts.lato(
                letterSpacing: 0.5,
                fontSize: 16,
              ),
              elevation: 0,
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.greys87,
              side: BorderSide(width: 1.0, color: AppColors.grey16)
              // minimumSize: const Size.fromHeight(40), // NEW
              ),
        ));
      }
      return widgets;
    }

    for (var i = 0; i < helpItem.length; i++) {
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            helpItem[i].heading,
            style: GoogleFonts.lato(
                fontSize: 18,
                color: AppColors.greys87,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(helpItem[i].description),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              children: _getEachIntents(helpItem[i].intents),
            ),
          )
        ],
      ));
    }
    return widgets;
  }

  @override
  void dispose() {
    textController.dispose();
    _commandController.dispose();
    // _speechRecognizer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == 2) {
      // print('Assistant page build method');
      isListening();
    }
    return widget.index == 2
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          pinned: false,
                          // expandedHeight: 280,
                          flexibleSpace: _hasPressedMore
                              ? IconButton(
                                  padding: EdgeInsets.all(16),
                                  alignment: Alignment.centerRight,
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _hasPressedMore = false;
                                    });
                                  },
                                )
                              : Center()),
                    ];
                  },
                  body: !_hasPressedMore
                      ? Container(
                          color: Colors.white,
                          height: double.infinity,
                          child: ListView(
                            children: [
                              IntrinsicHeight(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (textController.text != '...' ||
                                          !_isListening)
                                      ? ChatMessage(textController.text)
                                      : ChatMessage('...')
                                ],
                              )),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     textController.text != '...'
                              //         ? BotChatMessage('Here\'s what I found')
                              //         : Center()
                              //   ],
                              // ),
                              // FutureBuilder(
                              //     future: Future.delayed(Duration(milliseconds: 5)),
                              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                              //       // print(_searchKeyword);
                              //       return AllSearchPage(_searchKeyword);
                              //     }),
                              _isNewSearchkey
                                  ? VoiceSearchResults(_searchKeyword)
                                  : Center()
                            ],
                          ))
                      : Container(
                          color: Colors.white,
                          height: double.infinity,
                          padding: EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _showHelpWidget(),
                            ),
                          ),
                        )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: !_hasPressedMore
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 64,
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: ListView(
                          padding: EdgeInsets.only(left: 16),
                          scrollDirection: Axis.horizontal,
                          children: _getListData(),
                        ),
                      ),
                      (_isListening == true)
                          ? Container(
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35, 8, 0, 16),
                                child: Container(
                                    height: 48,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      // MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (mounted) {
                                                  setState(() {
                                                    _isListening = false;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, right: 10),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.greys60,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 38,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                  'Vega is listening.. ',
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys87,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          // height: 55,
                                          width: 46,
                                          // margin: const EdgeInsets.only(left: 15),
                                          child: FloatingActionButton(
                                            backgroundColor:
                                                AppColors.negativeLight,
                                            // backgroundColor: AppColors.primaryThree,
                                            child: SvgPicture.asset(
                                              'assets/img/karma_yogi.svg',
                                              width: 25.0,
                                              height: 25.0,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              await _navigateToSubPage(context);
                                            },
                                            heroTag: null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.grey08,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(28)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.24),
                                          blurRadius: 16.0,
                                          spreadRadius: 0,
                                          offset: Offset(
                                            0,
                                            8,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          : Container(
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35, 8, 0, 16),
                                child: Container(
                                    height: 48,
                                    // color: Colors.white,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            style: GoogleFonts.lato(
                                                fontSize: 14.0),
                                            controller: _commandController,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                size: 25,
                                              ),
                                              suffixIcon: _commandController
                                                      .text.isNotEmpty
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _commandController
                                                              .clear();
                                                        });
                                                      },
                                                      icon: Icon(Icons.clear))
                                                  : null,
                                              hintText: 'Ask Vega',
                                              hintStyle: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  _isNewSearchkey = false;
                                                  _searchKeyword = value;
                                                  // _searchActionIcon =
                                                  //     Icons.arrow_forward;
                                                  textController.text = '...';
                                                });
                                              }
                                              // else {
                                              //   setState(() {
                                              //     _searchActionIcon =
                                              //         Icons.mic_rounded;
                                              //   });
                                              // }
                                            },
                                          ),
                                        ),
                                        // Spacer(),
                                        Container(
                                          // color: Colors.white,
                                          height: 55,
                                          width: 46,
                                          // margin: const EdgeInsets.only(left: 15),
                                          child: FloatingActionButton(
                                            // backgroundColor: AppColors.negativeLight,
                                            backgroundColor:
                                                AppColors.primaryThree,
                                            child: Icon(_commandController
                                                    .text.isNotEmpty
                                                ? Icons.arrow_forward
                                                : Icons.mic_rounded),
                                            onPressed: () async {
                                              if (_commandController
                                                  .text.isEmpty) {
                                                await _navigateToSubPage(
                                                    context);
                                              } else {
                                                Future.delayed(Duration.zero,
                                                    () async {
                                                  _searchResults(
                                                      _searchKeyword);
                                                });
                                              }
                                            },
                                            heroTag: null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.grey08,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(28)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey08,
                                            blurRadius: 20.0,
                                            spreadRadius: 2,
                                            offset: Offset(
                                              3,
                                              3,
                                            ),
                                          ),
                                        ])),
                              ),
                            ),
                    ],
                  )
                : Center())
        : Center();
  }
}
