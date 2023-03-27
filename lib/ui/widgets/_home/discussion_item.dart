import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';

class DiscussionItem extends StatelessWidget {
  final String user;
  final String hrs;
  final String title;
  final String category;
  final String tag;
  final String votes;
  final String comments;

  DiscussionItem(this.user, this.hrs, this.title, this.category, this.tag,
      this.votes, this.comments);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey08),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, left: 20),
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: AppColors.avatarGreen,
                      child: Center(
                        child: Text(
                          Helper.getInitials(user),
                          style: TextStyle(color: AppColors.avatarText),
                        ),
                      ),
                    ),
                    Container(
                        // alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                user,
                                style: TextStyle(
                                  color: AppColors.greys87,
                                  fontSize: 12.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  hrs,
                                  style: TextStyle(
                                    color: AppColors.greys60,
                                    fontSize: 12.0,
                                  ),
                                ),
                              )
                            ])),
                  ],
                )),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                title,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Icon(Icons.category),
                    ),
                    Text(
                      category,
                      style: GoogleFonts.lato(
                        color: AppColors.primaryThree,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                )),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
                    decoration: BoxDecoration(
                      color: AppColors.grey08,
                      border: Border.all(color: AppColors.grey08),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  // Container(
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            // Add this
                            Icons.import_export, // Add this
                            color: Colors.black, // Add this
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              votes,
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        ],
                      )),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      comments,
                      style: GoogleFonts.lato(
                        color: AppColors.greys60,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
