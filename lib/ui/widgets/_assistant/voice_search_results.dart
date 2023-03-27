// import 'dart:convert';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/services/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_assistant/visualization_card.dart';
import 'package:provider/provider.dart';
import '../../../models/_models/profile_model.dart';
import '../../../respositories/_respositories/profile_repository.dart';
import '../index.dart';
import './../../../constants/index.dart';
import './../../../respositories/index.dart';
import './../../../ui/pages/index.dart';
import './../../../util/faderoute.dart';
import 'package:socket_io_client/socket_io_client.dart';
// import 'dart:developer' as developer;

class VoiceSearchResults extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;
  final String searchText;

  VoiceSearchResults(this.searchText);
  @override
  _VoiceSearchResultsState createState() => _VoiceSearchResultsState();
}

class _VoiceSearchResultsState extends State<VoiceSearchResults> {
  Socket _socket;
  bool isDirect = false;
  var _dataReceived;
  List _vegaDiscussions = [];
  bool isDiscussion = false;
  bool isContact = false;
  List _vegaContacts = [];
  List _vegaCourses = [];
  List _vegaTags = [];
  bool isTags = false;
  bool isCourse = false;
  bool isCompetencyByType = false;
  List _vegaCompetencyListByType = [];
  bool isLearner = false;
  List _vegaCourseLearners = [];
  bool isHelp = false;
  bool isVisualization = false;
  Map _visualizationData = {};
  String _searchText;
  bool _hasError = false;
  // List _vegaHelps = [];

  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _searchText = widget.searchText;
    _connectToServer();
    _sendMessageToServer();
  }

  _sendMessageToServer() async {
    // _connectToServer();
    Future.delayed(Duration.zero, () {
      _sendMessage(widget.searchText);
    });
    Future.delayed(Duration(seconds: 5), () {
      FocusManager.instance.primaryFocus.unfocus();
    });
  }

  void _connectToServer() {
    // print('connection to server...');
    try {
      // Configure socket transports must be specified
      _socket = io(ApiUrl.vegaSocketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to websocket
      _socket.connect();
      // _socket.onConnect(
      //     (data) => developer.log("on Connect data: " + data.toString()));
      _socket.onConnectError((data) {
        // developer.log("onConnectError: " + data.toString());
        setState(() {
          _hasError = true;
        });
      });
      // _socket.onConnecting(
      //     (data) => developer.log("onConnecting: " + data.toString()));

      // _socket.onConnectTimeout(
      //     (data) => developer.log("onConnection timeout: " + data.toString()));

      _socket.onError((data) {
        // developer.log("onError: " + data.toString());
        setState(() {
          setState(() {
            _hasError = true;
          });
        });
      });

      // _socket.onConnectTimeout(
      //     (data) => developer.log("onConnectTimeout: " + data.toString()));

      // Handle socket events
      _socket.on(
          'connect',
          (_) => {
                // print(
                //     'CONNECT =======================================: ${socket.id}')
              });

      // _socket.on('bot_uttered',
      //     (data) => {_processResponse(data), _dataReceived = data});
    } catch (e) {
      throw e;
      // print(e.toString());
    }
  }

  // Send a Message to the server
  _sendMessage(String message) async {
    try {
      String token = await _storage.read(key: Storage.authToken);
      String wid = await _storage.read(key: Storage.wid);
      String nodebbUserId = await _storage.read(key: Storage.nodebbUserId);
      String userName = await _storage.read(key: Storage.userName);
      String deptname = await _storage.read(key: Storage.deptName);

      Future.delayed(
          Duration.zero,
          (() => _socket.emit(
                "user_uttered",
                {
                  "mail": Vega.userEmail,
                  "message": message,
                  "endpoint": Vega.endpoint,
                  'jwt': token,
                  'wid': wid,
                  'username': userName,
                  'uid': nodebbUserId,
                  'dept': deptname,
                  'mdoId': mdoID,
                  'mdo': mdo
                },
              ))).then((value) => _socket.on('bot_uttered',
          (data) => {_processResponse(data), _dataReceived = data}));
    } catch (e) {
      // print('$e');
      throw e;
    }
  }

  void _processResponse(data) {
    // developer.log('Test: ' + data.toString());
    switch (data[0]['type']) {
      case IntentType.direct:
        {
          if (mounted) {
            setState(() {
              isDirect = true;
            });
          }
        }
        break;

      case IntentType.discussions:
        {
          if (mounted) {
            setState(() {
              isDiscussion = true;
              _vegaDiscussions = data[0]['quick_replies'][0]['data'];
              // print(_vegaDiscussions);
            });
          }
        }
        break;

      case IntentType.competencyList:
        {
          if (mounted) {
            setState(() {
              isCompetencyByType = true;
              _vegaCompetencyListByType = data[0]['quick_replies'][0]['data'];
            });
          }
        }
        break;

      case IntentType.contact:
        {
          if (mounted) {
            setState(() {
              isContact = true;
              _vegaContacts = data[0]['quick_replies'][0]['data'];
            });
          }
        }
        break;
      case IntentType.course:
        {
          if (mounted) {
            setState(() {
              isCourse = true;
              _vegaCourses = data[0]['quick_replies'][0]['data'];
              // print(data[0]['text']);
            });
          }
        }
        break;
      case IntentType.tags:
        {
          if (mounted) {
            setState(() {
              isTags = true;
              _vegaTags = data[0]['text'];
            });
          }
        }
        break;

      case IntentType.learners:
        {
          if (mounted) {
            setState(() {
              isLearner = true;
              _vegaCourseLearners = data[0]['quick_replies'][0]['data'];
            });
          }
        }
        break;

      case IntentType.visualisation:
        {
          if (mounted) {
            setState(() {
              isVisualization = true;
              _visualizationData = data[0]['quick_replies'][0]['data'];
              // print(data[0]['quick_replies'][0]['data']);
            });
          }
        }
        break;
    }
  }

  _navigateToDetail(tid) {
    Navigator.push(
      context,
      FadeRoute(
        page: ChangeNotifierProvider<DiscussRepository>(
          create: (context) => DiscussRepository(),
          child: DiscussionPage(tid: tid),
        ),
      ),
    );
  }

  Future<void> _createConnectionRequest(id) async {
    var _response;
    try {
      List<Profile> profileDetailsFrom;
      profileDetailsFrom =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById('');
      List<Profile> profileDetailsTo;
      profileDetailsTo =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById(id);
      _response = await NetworkService.postConnectionRequest(
          id, profileDetailsFrom, profileDetailsTo);

      if (_response['result']['status'] == 'CREATED') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.connectionRequestSent),
            backgroundColor: AppColors.positiveLight,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
      setState(() {});
    } catch (err) {
      throw e;
      // print(err);
    }
  }

  void _dummyAction(String param) {
    // print(param);
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
    // _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchText != widget.searchText) {
      _dataReceived = null;
      _sendMessageToServer();
      _searchText = widget.searchText;
      _hasError = false;
    }
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 1)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return NotificationListener<ScrollNotification>(
              // ignore: missing_return
              onNotification: (ScrollNotification scrollInfo) {
                // _loadMore();
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  // _loadMore();
                }
              },
              child: SingleChildScrollView(
                  child: Container(
                      child: _dataReceived != null
                          ? Column(
                              children: <Widget>[
                                isDirect == true
                                    ? IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BotChatMessage((_dataReceived[0]
                                                                ['text']
                                                            .runtimeType ==
                                                        String
                                                    ? _dataReceived[0]['text']
                                                    : _dataReceived[0]['text']
                                                        [0])
                                                .toString())
                                          ],
                                        ),
                                      )
                                    : Center(),
                                isVisualization == true
                                    ? IntrinsicHeight(
                                        child: Column(
                                          children: [
                                            BotChatMessage(
                                              _dataReceived[0]['text']
                                                  .toString(),
                                              isDirect: false,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // mainAxisSize: MainAxisSize.min,
                                              children: [
                                                VisualizationCard(
                                                    _visualizationData)
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(),
                                (isDiscussion == true)
                                    ? (_vegaDiscussions.length > 0)
                                        ? Column(
                                            children: [
                                              BotChatMessage(
                                                _dataReceived[0]['text']
                                                    .toString(),
                                                isDirect: false,
                                              ),
                                              Container(
                                                color: AppColors
                                                    .scaffoldBackground,
                                                margin: const EdgeInsets.only(
                                                    top: 5, bottom: 100),
                                                child: Column(
                                                  children: <Widget>[
                                                    ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          _vegaDiscussions
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                            onTap: () =>
                                                                _navigateToDetail(
                                                                    _vegaDiscussions[
                                                                            index]
                                                                        [
                                                                        'tid']),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8),
                                                              child: (
                                                                  // Text('Discuss')));
                                                                  VegaDiscussionCard(
                                                                      data: _vegaDiscussions[
                                                                          index])),
                                                            ));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : PageLoader(
                                            bottom: 350,
                                          )
                                    : Center(),
                                (isContact == true)
                                    ? (_vegaContacts.length > 0)
                                        ? Column(
                                            children: [
                                              BotChatMessage(
                                                _dataReceived[0]['text']
                                                    .toString(),
                                                isDirect: false,
                                              ),
                                              Container(
                                                  color: Colors.white,
                                                  height:
                                                      _vegaContacts.length > 0
                                                          ? 230
                                                          : 0,
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 16,
                                                  ),
                                                  child:
                                                      MediaQuery.removePadding(
                                                    context: context,
                                                    removeTop: true,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _vegaContacts.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return VegaContactCard(
                                                            suggestion:
                                                                _vegaContacts[
                                                                    index],
                                                            parentAction1:
                                                                _createConnectionRequest,
                                                            parentAction2:
                                                                _dummyAction);
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          )
                                        : PageLoader(
                                            bottom: 350,
                                          )
                                    : Center(),
                                (isCourse == true)
                                    ? (_vegaCourses.length > 0)
                                        ? Column(
                                            children: [
                                              BotChatMessage(
                                                _dataReceived[0]['text']
                                                    .toString(),
                                                isDirect: false,
                                              ),
                                              Container(
                                                  height:
                                                      _vegaCourses.length > 0
                                                          ? 314
                                                          : 0,
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5, bottom: 20),
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        _vegaCourses.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          // _generateInteractTelemetryData(
                                                          // _vegaCourses[index].id);
                                                          Navigator.push(
                                                              context,
                                                              FadeRoute(
                                                                  page: CourseDetailsPage(
                                                                      id: _vegaCourses[
                                                                              index]
                                                                          [
                                                                          'identifier'])));
                                                        },
                                                        child: VegaCourseCard(
                                                            course:
                                                                _vegaCourses[
                                                                    index]),
                                                      );
                                                      // return Text(_vegaCourses[index].toString());
                                                    },
                                                  )),
                                            ],
                                          )
                                        : PageLoader(
                                            bottom: 350,
                                          )
                                    : Center(),
                                (isTags == true)
                                    ? (_vegaTags.length > 0)
                                        ? VegaTagsList(_vegaTags)
                                        : PageLoader(
                                            bottom: 350,
                                          )
                                    : Center(),
                                (isCompetencyByType == true)
                                    ? (_vegaCompetencyListByType.length > 0)
                                        // ? VegaCompetencyCard()
                                        ? Column(
                                            children: [
                                              BotChatMessage(
                                                _dataReceived[0]['text']
                                                    .toString(),
                                                isDirect: false,
                                              ),
                                              Container(
                                                // height: 100,
                                                child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _vegaCompetencyListByType
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: VegaCompetencyCard(
                                                          competency:
                                                              _vegaCompetencyListByType[
                                                                  index]),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : PageLoader(
                                            bottom: 350,
                                          )
                                    : Center(),
                                (isLearner == true)
                                    ? (_vegaCourseLearners.length > 0)
                                        ? Column(
                                            children: [
                                              BotChatMessage(
                                                _dataReceived[0]['text']
                                                    .toString(),
                                                isDirect: false,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 100),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: _vegaCourseLearners
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    // return Text("data");
                                                    return VegaCourseLearners(
                                                        learner:
                                                            _vegaCourseLearners[
                                                                index]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center()
                                    : Center(),
                                // (isHelp && _vegaHelps.length > 0)
                                //     ? (Container(
                                //         margin: const EdgeInsets.only(bottom: 100),
                                //         child: BotChatMessage(_vegaHelps.toString()),
                                //       ))
                                //     : (Center())
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            )
                          : (_hasError
                              ? ErrorPage(
                                  isVegaError: true,
                                )
                              : PageLoader(
                                  bottom: 350,
                                )))));
        });
  }
}
