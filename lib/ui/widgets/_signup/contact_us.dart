import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/_constants/color_constants.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key key}) : super(key: key);

  void _mailTo(String mailId) async {
    // To create email with params
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mailId,
    );
    // To launch the link
    await launchUrl(Uri.parse(_emailLaunchUri.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(
            'Contact us',
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white),
      body: Container(
        margin: EdgeInsets.all(16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.30,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For any technical issues please contact:",
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 0.25,
                        height: 1.5),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text('Email: ',
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontSize: 16)),
                      Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse('mission.karmayogi@gov.in'),
                          builder: (context, followLink) => InkWell(
                                onTap: () =>
                                    _mailTo('mission.karmayogi@gov.in'),
                                child: Text(
                                  ('mission.karmayogi@gov.in'),
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.25,
                                      height: 1.5),
                                ),
                              )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text('Helpdesk: ',
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontSize: 16)),
                      Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse('https://servicedesk.nic.in/'),
                          builder: (context, followLink) => InkWell(
                                onTap: followLink,
                                child: Text(
                                  ('servicedesk.nic.in'),
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.25,
                                      height: 1.5),
                                ),
                              )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text('Call: ',
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontSize: 16)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Icon(Icons.call),
                      ),
                      Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse('1800 111 555'),
                          builder: (context, followLink) => InkWell(
                                onTap: () =>
                                    launchUrl(Uri.parse("tel://1800 111 555")),
                                child: Text(
                                  ('1800 111 555'),
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.25,
                                      height: 1.5),
                                ),
                              )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text('To know more click ',
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontSize: 16)),
                      Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse('https://dopttrg.nic.in/igotmk/'),
                          builder: (context, followLink) => InkWell(
                                onTap: followLink,
                                child: Text(
                                  ('here'),
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.25,
                                      height: 1.5),
                                ),
                              )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
