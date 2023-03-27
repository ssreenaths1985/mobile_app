import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';

import '../../../constants/_constants/color_constants.dart';
import '../../../models/_models/course_model.dart';
import '../../pages/_pages/learn/courses_by_provider.dart';

class CollectionCard extends StatelessWidget {
  final Course collection;
  const CollectionCard({Key key, this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          FadeRoute(
              page: CoursesByProvider(
            collection.name,
            isCollection: true,
            collectionId: collection.id,
            collectionDescription: collection.description,
          )),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, bottom: 16),
        child: Container(
          width: (MediaQuery.of(context).size.width) / 2 - 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(const Radius.circular(8.0)),
            border: Border.all(color: AppColors.grey16),
            color: Colors.white,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: collection.appIcon != null
                    ? Image.network(
                        collection.appIcon.toString(),
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        height: 90,
                      )
                    : Image.asset(
                        'assets/img/image_placeholder.jpg',
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        height: 90,
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 4),
                      width: (MediaQuery.of(context).size.width) * 0.435,
                      child: Text(
                        collection.name != null ? collection.name : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      width: (MediaQuery.of(context).size.width) * 0.47,
                      child: Text(
                          collection.description != null
                              ? collection.description
                              : '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              color: Colors.black, fontSize: 12)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
