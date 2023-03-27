import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:provider/provider.dart';
import './../../../ui/pages/_pages/ai_assistant_page.dart';
import './../../../ui/pages/_pages/assistant_page.dart';
import './../../../ui/pages/_pages/text_search_results/text_search_page.dart';
import './../../../ui/screens/_screens/text_search_result_screen.dart';
import './../../../ui/widgets/_home/home_silver_list.dart';
import './../../../ui/widgets/index.dart';
import './../../../util/speech_recognizer.dart';

class AssistantScreen extends StatefulWidget {
  static const route = '/assistantScreen';
  final int index;

  AssistantScreen({Key key, this.index}) : super(key: key);

  @override
  AssistantScreenState createState() {
    return new AssistantScreenState();
  }
}

class AssistantScreenState extends State<AssistantScreen> {
  var searchActionIcon = Icons.mic_rounded;
  final _textController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isListening;
  // SpeechRecognizer _speechRecognizer;
  String _recognizedText;
  // SpeechRecognizer _speechRecognizer;

  // var route = ModalRoute.of(context);

  @override
  void initState() {
    super.initState();
    if (widget.index == 2) {
      _isListening = true;
      _textController.addListener(_manageSearchActionIcon);
    }
    // isListening();
  }

  void _manageSearchActionIcon() {
    var icon;
    if (_textController.text != null && _textController.text != '') {
      icon = Icons.arrow_forward;
    } else {
      icon = Icons.mic_rounded;
    }
    setState(() {
      searchActionIcon = icon;
    });
  }

  void searchResults(String searchKey) async {
    if (VegaConfiguration.isEnabled) {
      setState(() {
        _recognizedText = searchKey;
      });
    }
    // print('$searchKey');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AiAssistantPage(searchKeyword: searchKey)));
  }

  Future _navigateToSubPage(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TextSearchResultScreen(searchKeyword: _textController.text)));
  }

  _getWelcomeText() async {
    String firstName = await _storage.read(key: Storage.firstName);
    return Text(
      'Hi ' + firstName + ',',
      style: GoogleFonts.montserrat(
        color: Colors.black87,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void isListening() {
    final sr = Provider.of<SpeechRecognizer>(context, listen: true);
    setState(() {
      _isListening = sr.isStatusListening;
    });
    // print(_isListening.toString());
  }

  @override
  void dispose() {
    _textController.removeListener(_manageSearchActionIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == 2) {
      isListening();
    }
    return widget.index == 2
        ? Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                HomeAppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 5.5),
                            child: FutureBuilder(
                                future: _getWelcomeText(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data;
                                  } else {
                                    return Text('');
                                  }
                                }))
                      ]),
                      Container(
                          height: 34,
                          width: 81,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ImageIcon(
                                AssetImage('assets/img/icon_bulb.png'),
                                color: Color.fromRGBO(246, 156, 83, 1),
                              ),
                              Text('Ideas',
                                  style: GoogleFonts.lato(
                                    color: Colors.black87,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(21)),
                              color: AppColors.lightOrange))
                    ],
                  ),
                ),
                HomeSilverList(
                  child: Container(
                    color: Color.fromRGBO(240, 243, 244, 1),
                    child: Column(
                      children: [
                        AssistantPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: (_isListening == true)
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 0, 12),
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
                                    setState(() {
                                      _isListening = false;
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 10),
                                      child: Icon(
                                        Icons.close,
                                        color: AppColors.greys60,
                                      )),
                                ),
                                SizedBox(
                                  height: 38,
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
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
                                backgroundColor: AppColors.negativeLight,
                                // backgroundColor: AppColors.primaryThree,
                                child: SvgPicture.asset(
                                  'assets/img/karma_yogi.svg',
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _navigateToSubPage(context);
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
                          borderRadius: BorderRadius.all(Radius.circular(28)),
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
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 0, 12),
                    child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 10),
                                    child: Icon(
                                      Icons.search,
                                      color: AppColors.greys60,
                                    )),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TextSearchPage()));
                                  },
                                  child: SizedBox(
                                    height: 38,
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Ask vega ',
                                        style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
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
                                // backgroundColor: AppColors.negativeLight,
                                backgroundColor: AppColors.primaryThree,
                                child: Icon(searchActionIcon),
                                onPressed: () {
                                  if (searchActionIcon == Icons.mic_rounded) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AiAssistantPage(
                                                    searchKeyword: '...')));
                                  } else {
                                    _navigateToSubPage(context);
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
                            borderRadius: BorderRadius.all(Radius.circular(28)),
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
          )
        : Center();
  }
}
