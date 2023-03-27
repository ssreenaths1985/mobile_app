import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import './../../../constants/index.dart';
import './../../../respositories/_respositories/notification_repository.dart';
import '../../widgets/index.dart';

class BottomBar extends StatefulWidget {
  BottomBar();

  _BottomBarState createState() => _BottomBarState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomBarState extends State<BottomBar> {
  int _unSeenNotificationsCount = 0;

  void initState() {
    super.initState();
    _getUnSeenNotificationsCount(context);
  }

  Future<dynamic> _getUnSeenNotificationsCount(context) async {
    try {
      var unSeenNotificationsCount =
          await Provider.of<NotificationRespository>(context, listen: false)
              .getUnSeenNotificationsCount();
      setState(() {
        _unSeenNotificationsCount = int.parse(unSeenNotificationsCount);
      });
      return _unSeenNotificationsCount;
    } catch (err) {
      return err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: AppColors.grey08,
            blurRadius: 6.0,
            spreadRadius: 0,
            offset: Offset(
              0,
              -3,
            ),
          ),
        ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (final tabItem in !VegaConfiguration.isEnabled
                  ? CustomBottomNavigation.itemsWithVegaDisabled
                  : CustomBottomNavigation.items)
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => CustomTabs(
                          customIndex: tabItem.index,
                        ),
                      ));
                    },
                    child: Stack(children: <Widget>[
                      SizedBox(
                        height: 62.0,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0),
                            // color: Colors.amber,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 8, 20, 5),
                                  child: SvgPicture.asset(
                                    tabItem.unselectedSvgIcon,
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                ),
                                Text(
                                  tabItem.title,
                                  style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )),
                      ),
                      (tabItem.index == 3 && _unSeenNotificationsCount > 0)
                          ? Positioned(
                              top: 5,
                              right: 0,
                              child: Container(
                                height: 20,
                                child: CircleAvatar(
                                    backgroundColor: AppColors.negativeLight,
                                    child: Center(
                                      child: Text(
                                        _unSeenNotificationsCount.toString(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )),
                              ),
                            )
                          : Positioned(
                              child: Text(''),
                            ),
                    ]))
            ]),
      ),
    );
  }
}
