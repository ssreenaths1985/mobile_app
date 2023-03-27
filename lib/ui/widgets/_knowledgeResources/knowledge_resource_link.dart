import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class KnowledgeResourceLink extends StatefulWidget {
  final String name;
  final String source;
  final dynamic link;

  const KnowledgeResourceLink(this.name, this.source, this.link);

  @override
  _KnowledgeResourceLinkState createState() => _KnowledgeResourceLinkState();
}

class _KnowledgeResourceLinkState extends State<KnowledgeResourceLink> {
  Future<void> _launchURL(url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw '$url: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('name: ' +
    //     widget.name +
    //     ' link: ' +
    //     widget.link +
    //     ' Source: ' +
    //     widget.source);
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       widget.source,
                //       style: GoogleFonts.lato(
                //           color: AppColors.greys60,
                //           fontSize: 14.0,
                //           fontWeight: FontWeight.w400),
                //     ),
                //   ],
                // ),
                widget.link['name'] != null
                    ? Container(
                        child: Text(
                          widget.link['name'],
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    : Center(),
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.link['value'] != '') {
                            _launchURL(widget.link['value']);
                          }
                          // print('Could not open.');
                        },
                        child: Icon(
                          Icons.link,
                          color: AppColors.primaryThree,
                        ),
                      )

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10.0, right: 18),
                      //   child: Icon(Icons.download_outlined),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
