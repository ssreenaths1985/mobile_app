import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../models/_models/delete_notification_model.dart';
import './../../../respositories/_respositories/notification_repository.dart';
import './../../widgets/index.dart';
import './../../../constants/index.dart';
import './../../../util/db_helper.dart';
import './../../../localization/index.dart';

class NotificationsPage extends StatefulWidget {
  final ValueChanged<bool> updateNotificationsCount;
  NotificationsPage({Key key, this.updateNotificationsCount}) : super(key: key);

  @override
  @override
  _NotificationsPageState createState() {
    return _NotificationsPageState();
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  List _notifications = [];
  String nextPage;
  // bool _showMarkAllRead = false;
  bool _showAll = false;
  String _userId;
  List<dynamic> _deletedNotifications;

  @override
  void initState() {
    super.initState();
    setState(() {
      nextPage = '';
    });
    getUserId();
    getDeletedNotifications();
  }

  Future<void> getUserId() async {
    final _storage = FlutterSecureStorage();
    _userId = await _storage.read(key: Storage.wid);
  }

  Future<void> getDeletedNotifications() async {
    List _notificationsList =
        await DBHelper.getData(AppDatabase.deletedNotificationsTable);
    _notificationsList =
        _notificationsList.where((item) => item['user_id'] == _userId).toList();
    _deletedNotifications =
        _notificationsList.map((item) => item['notification_id']).toList();
    // print(_deletedNotification);
  }

  Future<dynamic> _getNotifications() async {
    try {
      var response =
          await Provider.of<NotificationRespository>(context, listen: false)
              .getNotifications(nextPage);
      _notifications.addAll(response);
      _notifications = _notifications.toSet().toList();
      // for (int i = 0; i < _notifications.length; i++) {
      //   if (_notifications[i].seen == false) {
      //     setState(() {
      //       _showMarkAllRead = true;
      //     });
      //   }
      // }
      setState(() {
        nextPage = response[0].nextPage;
      });
    } catch (err) {
      return err;
    }
    return _notifications;
  }

  Future<dynamic> _markAllRead() async {
    try {
      await Provider.of<NotificationRespository>(context, listen: false)
          .markAllReadNotifications();
      widget.updateNotificationsCount(true);
      setState(() {
        nextPage = '';
        _notifications = [];
      });
    } catch (err) {
      return err;
    }
    return _notifications;
  }

  Future<void> _markReadNotification(id) async {
    try {
      await Provider.of<NotificationRespository>(context, listen: false)
          .markReadNotification(id);
    } catch (err) {
      return err;
    }
    widget.updateNotificationsCount(true);
  }

  bool _loadMore() {
    if (nextPage != '-1') {
      _getNotifications();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            return _loadMore();
          } else {
            return false;
          }
        },
        child: SingleChildScrollView(
            child: Column(children: [
          (_notifications.length > 0)
              ? Container(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _showAll
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAll = false;
                                });
                              },
                              // color: AppColors.customBlue,
                              // padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                              style: TextButton.styleFrom(
                                // primary: Colors.white,
                                backgroundColor: AppColors.customBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(color: AppColors.grey08)),
                                // onSurface: Colors.grey,
                              ),
                              // minWidth: 175,
                              child: Text(
                                EnglishLang.showUnreadNotifications,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : Center(),
                      !_showAll
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAll = true;
                                });
                              },
                              // color: AppColors.customBlue,
                              // padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                              style: TextButton.styleFrom(
                                // primary: Colors.white,
                                backgroundColor: AppColors.customBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(color: AppColors.grey08)),
                                // onSurface: Colors.grey,
                              ),

                              // minWidth: 175,
                              child: Text(
                                EnglishLang.showAllNotifications,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : Center()
                    ],
                  ),
                )
              : Center(),
          FutureBuilder(
              future: _getNotifications(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                // print(MediaQuery.of(context).size.height.toString());
                if (snapshot.hasData && snapshot.data != null) {
                  // List _data = snapshot.data.length > 0 ? snapshot.data : [];
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final item = _notifications[index];
                        return (((_notifications[index].seen && _showAll) ||
                                    (!_notifications[index].seen &&
                                        !_showAll)) &&
                                !_deletedNotifications
                                    .contains(_notifications[index].id))
                            ? Dismissible(
                                // Each Dismissible must contain a Key. Keys allow Flutter to
                                // uniquely identify widgets.
                                key: Key(item.id),
                                direction: _showAll
                                    ? DismissDirection.endToStart
                                    : DismissDirection.horizontal,
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) {
                                  // Remove the item from the data source.
                                  setState(() {
                                    _notifications.removeAt(index);
                                  });
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    var data = DeleteNotification(
                                        userId: _userId,
                                        notificationId: item.id);
                                    DBHelper.insert(
                                        AppDatabase.deletedNotificationsTable,
                                        data.toMap());
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text(EnglishLang.notificationRemoved),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ));
                                  } else {
                                    _notifications[index].seen
                                        ? ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(EnglishLang
                                                .notificationMarkedAsRead),
                                            backgroundColor:
                                                AppColors.positiveLight,
                                          ))
                                        : Center();
                                  }
                                  _markReadNotification(item.id);
                                },
                                // Show a red background as the item is swiped away.
                                // background: Container(color: Colors.white),
                                child:
                                    GeneralNotification(_notifications[index]))
                            : Center();
                      });
                } else {
                  return Center();
                }
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: _showAll
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () {
                        _markAllRead();
                      },
                      // color: AppColors.customBlue,
                      // padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                      style: TextButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: AppColors.customBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: AppColors.grey08)),
                        // onSurface: Colors.grey,
                      ),

                      // minWidth: 175,
                      child: Text(
                        EnglishLang.markAllAsRead,
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ))
                : Center(),
          )
        ])));
  }
}
