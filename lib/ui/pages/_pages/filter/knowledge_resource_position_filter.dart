import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../constants/index.dart';
// import '../../../widgets/index.dart';
import './../../../../respositories/index.dart';
import './../../../../localization/index.dart';

class KnowledeResourcePositionFilter extends StatefulWidget {
  final String selectedId;
  final String selectedPosition;
  final ValueChanged<Map> parentAction;
  KnowledeResourcePositionFilter(
      {Key key, this.selectedId, this.selectedPosition, this.parentAction})
      : super(key: key);

  @override
  _KnowledeResourcePositionFilterState createState() {
    return _KnowledeResourcePositionFilterState();
  }
}

class _KnowledeResourcePositionFilterState
    extends State<KnowledeResourcePositionFilter> {
  bool isSwitched = false;
  List<dynamic> _positions;
  bool selectionStatus = false;
  String selectedId;
  String selectedPosition;

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    selectedPosition = widget.selectedPosition;
  }

  Future<dynamic> _getAllPositions() async {
    // var positions = [];
    try {
      _positions = await Provider.of<KnowledgeResourceRespository>(context,
              listen: false)
          .getAllPositions();
      // print("Screen" + _positions.length.toString());
    } catch (err) {
      return err;
    }

    return _positions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          // automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.greys87,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                'Position',
                style: GoogleFonts.montserrat(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: _getAllPositions(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                // print(MediaQuery.of(context).size.height.toString());
                if (snapshot.hasData && snapshot.data != null) {
                  return _positions != null
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            color: Color.fromRGBO(241, 244, 244, 1),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _positions.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                        groupValue: selectedId,
                                        title: Text(
                                          _positions[index].name,
                                          style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        value: _positions[index].id,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedId = val;
                                            selectedPosition =
                                                _positions[index].name;
                                          });
                                        },
                                        selected: (selectedId ==
                                            _positions[index].id),
                                        selectedTileColor:
                                            AppColors.selectedTile,
                                      );
                                    },
                                  ),
                                ]),
                          ))
                      : Center();
                } else {
                  return Center();
                }
              }),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () => setState(() {
                        widget.parentAction({'id': '', 'position': ''});
                        Navigator.pop(context);
                      }),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      EnglishLang.resetToDefault,
                      style: GoogleFonts.lato(
                        color: AppColors.primaryThree,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 180,
                  color: AppColors.primaryThree,
                  child: TextButton(
                    onPressed: () => setState(() {
                      widget.parentAction(
                        {'id': selectedId, 'position': selectedPosition},
                      );
                      Navigator.pop(context);
                    }),
                    style: TextButton.styleFrom(
                      // primary: Colors.white,
                      backgroundColor: AppColors.primaryThree,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // onSurface: Colors.grey,
                    ),
                    child: Text(
                      EnglishLang.apply,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
