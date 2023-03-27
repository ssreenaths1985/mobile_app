import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_moment/simple_moment.dart';
import './../../../models/_models/notification_model.dart' as NotificationModal;
import '../../../constants/index.dart';
// import './../../../util/helper.dart';

class GeneralNotification extends StatelessWidget {
  final NotificationModal.Notification notification;
  final dateNow = Moment.now();

  GeneralNotification(this.notification);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: notification.seen ? AppColors.white70 : AppColors.grey04,
        border: Border.all(color: AppColors.lightGrey),
        // borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                      (dateNow.from(DateTime.fromMillisecondsSinceEpoch(
                              notification.timeStamp)))
                          .toString(),
                      style: GoogleFonts.lato(
                        color: AppColors.greys60,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      )))
            ],
          ),
        ),
      ]),
    );
  }
}
