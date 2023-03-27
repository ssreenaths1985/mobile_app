import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';

class RolesAndActivitiesCard extends StatefulWidget {
  final roleAndActivities;
  final deleteAction;
  final editAction;
  final index;
  const RolesAndActivitiesCard(
      {Key key,
      this.roleAndActivities,
      this.editAction,
      this.deleteAction,
      this.index})
      : super(key: key);

  @override
  State<RolesAndActivitiesCard> createState() => _RolesAndActivitiesCardState();
}

class _RolesAndActivitiesCardState extends State<RolesAndActivitiesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.roleAndActivities['name'],
            style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          Wrap(
            spacing: 5,
            children: [
              for (var activity in widget.roleAndActivities['activities'])
                (Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: AppColors.grey08,
                    ),
                    margin: EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Text(activity['name'])))
            ],
          ),
          Row(
            children: [
              InkWell(
                child: TextButton(
                    onPressed: () async {
                      await widget.editAction(widget.index);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: AppColors.greys60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Edit',
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                child: TextButton(
                    onPressed: () async {
                      await widget.deleteAction(widget.index);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 18,
                          color: AppColors.greys60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Delete',
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
