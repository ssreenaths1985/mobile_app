import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String id;
  final dynamic timeStamp;
  final String message;
  final String nextPage;
  final bool seen;

  const Notification({
    this.id,
    this.timeStamp,
    this.message,
    this.nextPage,
    this.seen,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['notificationId'],
      timeStamp: json['receivedOn'],
      message: json['message'],
      nextPage: json['nextPage'],
      seen: json['seen'],
    );
  }

  @override
  List<Object> get props => [
        id,
        timeStamp,
        message,
        nextPage,
        seen,
      ];
}
