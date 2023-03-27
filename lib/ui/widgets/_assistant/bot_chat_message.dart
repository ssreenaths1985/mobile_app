import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

class BotChatMessage extends StatefulWidget {
  // static const route = AppUrl.dashboardProfilePage;
  final botChatMessage;
  final isDirect;

  BotChatMessage(this.botChatMessage, {this.isDirect = true});
  @override
  _BotChatMessageState createState() => _BotChatMessageState();
}

class _BotChatMessageState extends State<BotChatMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height:
            MediaQuery.of(context).size.height * (widget.isDirect ? 0.75 : 0.1),
        // width: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  // height: MediaQuery.of(context).size.width * 0.75,
                  // width: 300,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    child: HtmlWidget(widget.botChatMessage,
                        // maxLines: 20,
                        textStyle: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    // border: Border.all(color: Color.fromRGBO(0, 116, 182, 1)),
                  )),
            ),
          ),
        ]));
  }
}
