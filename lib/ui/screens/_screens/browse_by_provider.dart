import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
// import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/collection_card.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';
// import './../../../ui/pages/_pages/text_search_results/text_search_page.dart';
// import './../../../ui/pages/index.dart';

import '../../../constants/_constants/telemetry_constants.dart';
import '../../../constants/index.dart';

class BrowseByProvider extends StatefulWidget {
  static const route = AppUrl.browseByProviderPage;
  final int index;
  final bool isCollections;
  final bool isFromHome;

  BrowseByProvider(
      {Key key,
      this.index,
      this.isCollections = false,
      this.isFromHome = false})
      : super(key: key);

  @override
  _BrowseByProviderState createState() {
    return new _BrowseByProviderState();
  }
}

class _BrowseByProviderState extends State<BrowseByProvider>
    with WidgetsBindingObserver {
  ScrollController _scrollController;
  final _textController = TextEditingController();

  List<ProviderCardModel> _providerCard = [];
  List<ProviderCardModel> _filteredProviderCard = [];
  List<Course> _collections = [];
  List<Course> _filteredCollections = [];
  bool _scrollStatus = true;
  bool _pageInitilized = false;

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String deviceIdentifier;
  var telemetryEventData;

  _scrollListener() {
    if (isScroll != _scrollStatus) {
      setState(() {
        _scrollStatus = isScroll;
      });
    }
  }

  bool get isScroll {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    // if (widget.index == 1) {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _textController.addListener(_filterProviders);
    _generateTelemetryData();
    // }
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
      !widget.isCollections
          ? TelemetryPageIdentifier.browseByAllProviderPageId
          : TelemetryPageIdentifier.allCollectionsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      !widget.isCollections
          ? TelemetryPageIdentifier.browseByAllProviderPageUri
          : TelemetryPageIdentifier.allCollectionsPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<List<ProviderCardModel>> _getListOfProviders() async {
    _providerCard = await Provider.of<LearnRepository>(context, listen: false)
        .getListOfProviders();
    _providerCard.removeWhere((element) => element.name == null);

    if (!_pageInitilized) {
      setState(() {
        _filteredProviderCard = _providerCard;
        _pageInitilized = true;
      });
    }
    return _providerCard;
  }

  Future<List<Course>> _getCollections() async {
    if (!_pageInitilized) {
      _collections = await Provider.of<LearnRepository>(context, listen: false)
          .getCourses(1, '', ['CuratedCollections'], [], [],
              isCollection: true);
      setState(() {
        _filteredCollections = _collections;
        _pageInitilized = true;
      });
    }
    return _collections;
  }

  _filterProviders() {
    String value = _textController.text;
    setState(() {
      if (!widget.isCollections) {
        _filteredProviderCard = _providerCard
            .where((provider) =>
                provider.name.toString().toLowerCase().contains(value))
            .toList();
      } else {
        _filteredCollections = _collections
            .where((collection) =>
                collection.name.toString().toLowerCase().contains(value))
            .toList();
      }
    });
    // setState(() {});
  }

  void _sortProviders(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredProviderCard
            .sort((a, b) => a.name.trim().compareTo(b.name.trim()));
      } else
        _filteredProviderCard
            .sort((a, b) => b.name.trim().compareTo(a.name.trim()));
    });
  }

  void _sortCollections(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredCollections
            .sort((a, b) => a.name.trim().compareTo(b.name.trim()));
      } else
        _filteredCollections
            .sort((a, b) => b.name.trim().compareTo(a.name.trim()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          // automaticallyImplyLeading: false,
          // leading: Row(children: [
          //   IconButton(
          //       icon: Icon(
          //         Icons.close,
          //         color: AppColors.greys87,
          //       ),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       }),
          //   Text(widget.backToTitle)
          // ]),
          title: Text(
            !widget.isFromHome ? 'Back to \'Explore by\'' : 'Back',
            style: GoogleFonts.lato(
                color: AppColors.greys60,
                wordSpacing: 1.0,
                fontSize: 16.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: FutureBuilder(
                future: !widget.isCollections
                    ? _getListOfProviders()
                    : _getCollections(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Container(
                      // color: Color.fromRGBO(241, 244, 244, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Text(
                              !widget.isCollections
                                  ? 'All providers'
                                  : 'All collections',
                              style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.12,
                                  height: 1.5),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/img/provider_landing.svg',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ),
                          (!widget.isCollections ? _providerCard : _collections)
                                      .length >
                                  0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        !widget.isCollections
                                            ? 'Popular providers'
                                            : 'Popular collections',
                                        style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            letterSpacing: 0.12,
                                            height: 1.5),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          return ProviderCard(
                                            providerCardModel:
                                                (!widget.isCollections
                                                    ? _providerCard
                                                    : _collections)[index],
                                            isCollection: widget.isCollections,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : Stack(
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Container(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100),
                                              child: SvgPicture.asset(
                                                'assets/img/empty_search.svg',
                                                alignment: Alignment.center,
                                                // color: AppColors.grey16,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Text(
                                            !widget.isCollections
                                                ? 'No providers found!'
                                                : 'No curated collections found!',
                                            style: GoogleFonts.lato(
                                              color: AppColors.greys60,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              height: 1.5,
                                              letterSpacing: 0.25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                          (!widget.isCollections ? _providerCard : _collections)
                                      .length >
                                  0
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      top: 24, bottom: 16),
                                  child: Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    // height: 112,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 16, 16, 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            !widget.isCollections
                                                ? 'Explore all providers within the learn hub'
                                                : EnglishLang
                                                    .browseCuratedCollections,
                                            style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: 0.12,
                                                height: 1.5),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  // width: 316,
                                                  height: 48,
                                                  child: TextFormField(
                                                      controller:
                                                          _textController,
                                                      onChanged: (value) {
                                                        // _filterTopics(
                                                        //     value.toLowerCase());
                                                      },
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                16.0,
                                                                10.0,
                                                                0.0,
                                                                10.0),
                                                        // border: OutlineInputBorder(
                                                        //     borderSide: BorderSide(
                                                        //         color: AppColors
                                                        //             .primaryThree, width: 10),),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: AppColors
                                                                .grey16,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      1.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: AppColors
                                                                .primaryThree,
                                                          ),
                                                        ),
                                                        hintText: 'Search',
                                                        hintStyle: GoogleFonts
                                                            .lato(
                                                                color: AppColors
                                                                    .greys60,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        // focusedBorder: OutlineInputBorder(
                                                        //   borderSide: const BorderSide(
                                                        //       color: AppColors.primaryThree, width: 1.0),
                                                        // ),
                                                        counterStyle: TextStyle(
                                                          height: double
                                                              .minPositive,
                                                        ),
                                                        counterText: '',
                                                      )),
                                                ),
                                                Container(
                                                  height: 48,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: AppColors.grey16,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    // color: AppColors.lightGrey,
                                                  ),
                                                  // color: Colors.white,
                                                  // width: double.infinity,
                                                  // margin: EdgeInsets.only(right: 225, top: 2),
                                                  child: DropdownButton<String>(
                                                    value: dropdownValue != null
                                                        ? dropdownValue
                                                        : null,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: AppColors.greys60,
                                                      size: 18,
                                                    ),
                                                    hint: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text('Sort by')),
                                                    ),
                                                    iconSize: 26,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.greys87),
                                                    underline: Container(
                                                      // height: 2,
                                                      color:
                                                          AppColors.lightGrey,
                                                    ),
                                                    selectedItemBuilder:
                                                        (BuildContext context) {
                                                      return dropdownItems
                                                          .map<Widget>(
                                                              (String item) {
                                                        return Row(
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                        15.0,
                                                                        15.0,
                                                                        0,
                                                                        15.0),
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    color: AppColors
                                                                        .greys87,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ))
                                                          ],
                                                        );
                                                      }).toList();
                                                    },
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                      });
                                                      !widget.isCollections
                                                          ? _sortProviders(
                                                              dropdownValue)
                                                          : _sortCollections(
                                                              dropdownValue);
                                                    },
                                                    items: dropdownItems.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(),
                          for (int i = 0;
                              i <
                                  (!widget.isCollections
                                          ? _filteredProviderCard
                                          : _filteredCollections)
                                      .length;
                              i = i + 2)
                            Container(
                              height: widget.isCollections ? 180 : 100,
                              child: Row(
                                children: [
                                  !widget.isCollections
                                      ? ProviderCard(
                                          providerCardModel:
                                              _filteredProviderCard[i],
                                        )
                                      : CollectionCard(
                                          collection: _filteredCollections[i],
                                        ),
                                  // ProviderCard(
                                  //   providerCardModel: (!widget.isCollections
                                  //       ? _providerCard
                                  //       : _collections)[i],
                                  //   isCollection: widget.isCollections,
                                  // ),
                                  (!widget.isCollections
                                                  ? _filteredProviderCard
                                                  : _filteredCollections)
                                              .length >
                                          i + 1
                                      ?
                                      // ProviderCard(
                                      //     providerCardModel:
                                      //         (!widget.isCollections
                                      //             ? _providerCard
                                      //             : _collections)[i + 1],
                                      //     isCollection: widget.isCollections,
                                      //   )
                                      (!widget.isCollections
                                          ? ProviderCard(
                                              providerCardModel:
                                                  _filteredProviderCard[i + 1],
                                            )
                                          : CollectionCard(
                                              collection:
                                                  _filteredCollections[i + 1],
                                            ))
                                      : Center()
                                ],
                              ),
                            ),
                          Padding(padding: const EdgeInsets.only(bottom: 20))

                          // HubPage(),
                        ],
                      ),
                    );
                  } else {
                    return PageLoader(
                      bottom: 150,
                    );
                  }
                }),
          ),
        ));
  }
}
