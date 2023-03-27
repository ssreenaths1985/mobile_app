import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/_models/browse_competency_card_model.dart';
import 'package:karmayogi_mobile/services/_services/competencies_service.dart';
import 'package:karmayogi_mobile/ui/widgets/_competency/competency_level_card.dart';
import 'package:provider/provider.dart';

import '../../../../models/_models/profile_model.dart';
import '../../../../respositories/_respositories/profile_repository.dart';

class SelfAttestCompetency extends StatefulWidget {
  // const SelfAttestCompetency({ Key? key }) : super(key: key);
  final BrowseCompetencyCardModel currentCompetencySelected;
  final ValueChanged<bool> isAlreadyAdded;
  final ValueChanged<dynamic> addedStatus;
  final profileCompetencies;
  final levels;
  SelfAttestCompetency(
      {this.currentCompetencySelected,
      this.profileCompetencies,
      this.isAlreadyAdded,
      this.addedStatus,
      this.levels});

  @override
  _SelfAttestCompetencyState createState() => _SelfAttestCompetencyState();
}

class _SelfAttestCompetencyState extends State<SelfAttestCompetency> {
  final CompetencyService competencyService = CompetencyService();
  int _selectedLevel;
  Map _attestedCompetency;
  bool _selectStatus = false;

  @override
  void initState() {
    super.initState();
    // _getLevelsAndDescription();
  }

  void _checkSelectStatus(bool value) {
    setState(() {
      _selectStatus = value;
    });
  }

  void _selectLevel(Map levelDetails) async {
    // print('Level details: ' + levelDetails.toString());
    setState(() {
      _selectedLevel = levelDetails['levelValue'];
    });
    _attestedCompetency = {
      "type": widget.currentCompetencySelected.rawDetails['type'],
      "id": widget.currentCompetencySelected.id,
      "name": widget.currentCompetencySelected.name,
      "description": widget.currentCompetencySelected.description,
      "status": widget.currentCompetencySelected.status,
      "source": widget.currentCompetencySelected.source,
      "competencyType": widget.currentCompetencySelected.competencyType,
      // "competencySelfAttestedLevel": _selectedLevel + 1,
      "competencySelfAttestedLevel": levelDetails['id'],
      "competencySelfAttestedLevelName": levelDetails['name'],
      "competencySelfAttestedLevelValue": levelDetails['level']
    };
    // print('selectedCompetency: ' + _attestedCompetency.toString());
  }

  Future<void> _selfAttestCompetency(Map attestedCompetency) async {
    List<Profile> profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    var _response = await competencyService.selfAttestCompetency(
        attestedCompetency, profileDetails);
    widget.addedStatus(_response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        // automaticallyImplyLeading: false,
        // leading: Row(children: [
        //   IconButton(
        //       icon: Icon(
        //         Icons.close,
        //         color: AppColors.greys87,
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       }),
        //   Text(widget.backToTitle)
        // ]),
        title: Text(
          EnglishLang.back,
          style: GoogleFonts.lato(
              color: AppColors.greys60,
              wordSpacing: 1.0,
              fontSize: 16.0,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          EnglishLang.selectYourLevel,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        EnglishLang.selfAttestDeclaration,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.levels.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: CompetencyLevelCard(
                          index: index,
                          selectLevel: _selectLevel,
                          selectedLevel: _selectedLevel,
                          levelDetails: widget.levels[index],
                          checkSelectStatus: _checkSelectStatus,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
            height: 50,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryThree,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {
                    if (_selectStatus) {
                      _selfAttestCompetency(_attestedCompetency);
                      widget.isAlreadyAdded(true);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(EnglishLang.pleaseSelectLevel),
                          backgroundColor: AppColors.primaryOne,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    EnglishLang.addToYourCompetency,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
