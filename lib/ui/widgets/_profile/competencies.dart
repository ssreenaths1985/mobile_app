import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../ui/screens/index.dart';
import './../../../util/faderoute.dart';

class Competencies extends StatelessWidget {
  final List competencies;

  Competencies(this.competencies);

  generateCompetencies(context, competencies) {
    var competencyWidgets = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    for (var competency in competencies) {
      competencyWidgets.children.add(
        ElevatedButton(
          // elevation: false,
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.lightGrey),
          ),
          // color: AppColors.lightGrey,
          child: Text(
            competency['name'],
            style: GoogleFonts.lato(
                fontSize: 14,
                color: AppColors.greys87,
                letterSpacing: 0.25,
                fontWeight: FontWeight.w400),
          ),
        ),
      );
    }
    competencyWidgets.children.add(Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Spacer(),
          Row(children: <Widget>[
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  FadeRoute(
                      page: CompetencyHub(
                    isAddedCompetencies: true,
                  ))),
              child: Text(
                'See all',
                style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryThree),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primaryThree)
          ])
        ],
      ),
    ));
    return competencyWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      alignment: Alignment.topLeft,
      child: generateCompetencies(context, competencies),
    );
  }
}
