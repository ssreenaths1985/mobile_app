import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/models/_models/event_detail_model.dart';
import 'package:karmayogi_mobile/models/_models/event_model.dart';
import 'package:karmayogi_mobile/services/_services/events_service.dart';

class EventRepository with ChangeNotifier {
  final EventService eventService = EventService();
  String _errorMessage = '';
  List<Event> eventsList = [];
  Response _data;

  Future<List<Event>> getAllEvents() async {
    try {
      final response = await eventService.getAllEvents();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> events = contents['result']['Event'];
      eventsList = events
          .map(
            (dynamic item) => Event.fromJson(item),
          )
          .toList();
      return eventsList;
    } else {
      // throw 'Can\'t get events.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Event>> getEventsForMDO() async {
    try {
      final response = await eventService.getEventsForMDO();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> events = contents['result']['Event'] != null
          ? contents['result']['Event']
          : [];
      eventsList = events
          .map(
            (dynamic item) => Event.fromJson(item),
          )
          .toList();
      return eventsList;
    } else {
      // throw 'Can\'t get events.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<EventDetail> getEventDetails(String id) async {
    try {
      final response = await eventService.getEventDetails(id);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(utf8.decode(_data.bodyBytes));
      var event = contents['result']['event'];
      EventDetail eventDetails = EventDetail.fromJson(event);
      return eventDetails;
    } else {
      // throw 'Can\'t get event details.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }
}
