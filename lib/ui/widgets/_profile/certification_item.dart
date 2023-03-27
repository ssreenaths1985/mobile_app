import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../models/index.dart';

class CertificationItem extends StatelessWidget {
  final Badge badge;

  CertificationItem(this.badge);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      child: Card(
        child: ClipPath(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  // Container(
                  //   // padding: const EdgeInsets.all(25),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.lightGrey,
                  //     border: Border.all(color: AppColors.lightGrey),
                  //     borderRadius: BorderRadius.all(Radius.circular(4)),
                  //   ),
                  //   child: Image.asset('assets/img/certificate.jpeg',
                  //       // child: Image.network(ApiUrl.baseUrl + badge.image,
                  //       fit: BoxFit.cover,
                  //       width: 75),
                  // ),
                  Container(
                      // width: 245,'
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            badge.name,
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            badge.group + '\nIssued on ' + badge.recievedDate,
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                height: 1.5,
                                fontSize: 14),
                          ),
                        ],
                      )),
                ],
              )),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
  }
}
