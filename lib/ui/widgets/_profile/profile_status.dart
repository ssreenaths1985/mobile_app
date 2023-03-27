import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/edit_profile_screen.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import './../../../constants/index.dart';
import './../../../models/index.dart';
import './../../../util/helper.dart';

class ProfileStatus extends StatefulWidget {
  final Profile profileDetails;
  ProfileStatus({Key key, this.profileDetails}) : super(key: key);

  @override
  _ProfileStatusState createState() => _ProfileStatusState();
}

class _ProfileStatusState extends State<ProfileStatus> {
  int _profileCompleted = 0;

  @override
  void initState() {
    _getProfileCompleted();
    super.initState();
  }

  void _getProfileCompleted() {
    setState(() {
      _profileCompleted = Helper.calculateProfilePercent(widget.profileDetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.grey08),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Your profile is ' + _profileCompleted.toString() + '% complete',
              style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontWeight: FontWeight.w700,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: LinearProgressIndicator(
              minHeight: 8,
              backgroundColor: AppColors.grey16,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.positiveLight,
              ),
              value: _profileCompleted / 100,
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            child: TextButton(
              onPressed: () {
                // print('Received click');
                Navigator.push(
                  context,
                  FadeRoute(page: EditProfileScreen()),
                );
              },
              style: TextButton.styleFrom(
                // primary: Colors.white,
                backgroundColor: AppColors.customBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: AppColors.grey16)),
                // onSurface: Colors.grey,
              ),
              child: Text(
                'Complete profile',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
