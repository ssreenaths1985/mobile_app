import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './../../../ui/screens/index.dart';
import '../../../constants/index.dart';
import '../../widgets/index.dart';
import './../../../util/faderoute.dart';
import './../../../localization/index.dart';

class HubPage extends StatelessWidget {
  Future<void> _launchURL(url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw '$url: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.hubs),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              // padding: const EdgeInsets.fromLTRB(0, 20, 0 , 10),
              child: Column(
                children: HUBS
                    .map(
                      (hub) => InkWell(
                          onTap: () => hub.comingSoon
                              ? Navigator.push(
                                  context,
                                  FadeRoute(page: ComingSoonScreen()),
                                )
                              : Navigator.pushNamed(context, hub.url),
                          child: HubItem(
                              hub.id,
                              hub.title,
                              hub.description,
                              hub.icon,
                              hub.iconColor,
                              hub.comingSoon,
                              hub.url,
                              hub.svgIcon,
                              hub.svg)),
                    )
                    .toList(),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.doMore),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Column(
                children: DO_MORE
                    .map(
                      (hub) => InkWell(
                          onTap: () => hub.comingSoon
                              ? Navigator.push(
                                  context,
                                  FadeRoute(page: ComingSoonScreen()),
                                )
                              : Navigator.pushNamed(context, hub.url),
                          child: HubItem(
                              hub.id,
                              hub.title,
                              hub.description,
                              hub.icon,
                              hub.iconColor,
                              hub.comingSoon,
                              hub.url,
                              hub.svgIcon,
                              hub.svg)),
                    )
                    .toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              alignment: Alignment.center,
              child: Text(
                EnglishLang.copyRightText,
              ),
            ),
            // Container(
            //   alignment: Alignment.topLeft,
            //   child: SectionHeading(EnglishLang.externalLinks),
            // ),
            // Container(
            //   padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
            //   child: Column(
            //     children: EXTERNAL_LINKS
            //         .map(
            //           (hub) => InkWell(
            //               onTap: () {
            //                 if (hub.url != '') {
            //                   _launchURL(hub.url);
            //                 }
            //               },
            //               child: OtherItem(hub.id, hub.title, hub.description,
            //                   hub.icon, hub.iconColor, hub.url)),
            //         )
            //         .toList(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
