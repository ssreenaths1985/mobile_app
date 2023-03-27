import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../localization/_langs/english_lang.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';
// import 'dart:developer' as developer;

class NetworkSearchPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;
  final networks;

  NetworkSearchPage(this.networks);
  @override
  _NetworkSearchPageState createState() => _NetworkSearchPageState();
}

class _NetworkSearchPageState extends State<NetworkSearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.networks != null && widget.networks.length > 0) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: SectionHeading('Network search results'),
              ),
              widget.networks.length > 0
                  ? Wrap(
                      // alignment: WrapAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            PeopleYouMayKnow(
                                peopleYouMayKnow: widget.networks,
                                sortBy: EnglishLang.lastAdded),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 65),
                          child: Center(),
                        )
                      ],
                    )
                  : PageLoader(
                      bottom: 150,
                    )
            ],
          ),
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 125),
                    child: SvgPicture.asset(
                      'assets/img/empty_search.svg',
                      alignment: Alignment.center,
                      // color: AppColors.grey16,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  EnglishLang.noResultsFound,
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
      );
    }
  }
}
