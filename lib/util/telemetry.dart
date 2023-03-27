import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import '../constants/_constants/telemetry_constants.dart';
import './../constants/index.dart';
// import 'dart:developer' as developer;

class Telemetry {
  static generateUserSessionId() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String hash = md5.convert(utf8.encode(timestamp)).toString();
    final _storage = FlutterSecureStorage();
    _storage.write(key: Storage.sessionId, value: hash);
    // print('hash: $hash');
    return hash;
  }

  static getUserId({bool isPublic = false}) async {
    final _storage = FlutterSecureStorage();
    String userId = !isPublic ? await _storage.read(key: Storage.wid) : '';
    // print('deptId: $deptId');
    return userId;
  }

  static getUserNodeBbUid() async {
    final _storage = FlutterSecureStorage();
    String nodebbUserId = await _storage.read(key: Storage.nodebbUserId);
    return nodebbUserId;
  }

  static getUserSessionId() async {
    final _storage = FlutterSecureStorage();
    String sessionId = await _storage.read(key: Storage.sessionId);
    // print('sessionId: $sessionId');
    return sessionId;
  }

  static getUserDeptId({bool isPublic = false}) async {
    final _storage = FlutterSecureStorage();
    String deptId =
        !isPublic ? await _storage.read(key: Storage.deptId) : DEFAULT_CHANNEL;
    // print('deptId: $deptId');
    return deptId;
  }

  static getDeviceIdentifier() async {
    final _storage = FlutterSecureStorage();
    String deviceIdentifier =
        await _storage.read(key: Storage.deviceIdentifier);
    return deviceIdentifier;
  }

  static generateMessageId() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String hash = md5.convert(utf8.encode(timestamp)).toString();
    return hash;
  }

  static getStartTelemetryEvent(
    String deviceIdentifier,
    String userId,
    String departmentId,
    String pageIdentifier,
    String userSessionId,
    String messageIdentifier,
    String telemetryType,
    String pageUri,
  ) {
    // String objectId, objectType;
    // if (telemetryType == TelemetryType.player) {
    //   List identifier = pageIdentifier.split('/');
    //   objectId = identifier.last;
    //   objectType = identifier[1] == EDisplayContentTypes.pdf.toLowerCase()
    //       ? EMimeTypes.pdf
    //       : identifier[1] == EDisplayContentTypes.html.toLowerCase()
    //           ? EMimeTypes.html
    //           : identifier[1] == EDisplayContentTypes.video.toLowerCase()
    //               ? EMimeTypes.mp4
    //               : identifier[1] == EDisplayContentTypes.audio.toLowerCase()
    //                   ? EMimeTypes.mp3
    //                   : identifier[1] == EDisplayContentTypes.quiz.toLowerCase()
    //                       ? EMimeTypes.assessment
    //                       : 'Content';
    // } else {
    //   objectId = pageIdentifier;
    //   objectType = 'Content';
    // }

    Map eventData = {
      'eid': TelemetryEvent.start,
      'ets': DateTime.now().millisecondsSinceEpoch,
      'ver': TELEMETRY_EVENT_VERSION,
      'mid': '${TelemetryEvent.start}:$messageIdentifier',
      'actor': {'id': userId, 'type': 'User'},
      'context': {
        'channel': departmentId,
        'pdata': {
          'id': TELEMETRY_PDATA_ID,
          'ver': APP_VERSION,
          'pid': TELEMETRY_PDATA_PID
        },
        'env': pageIdentifier,
        'sid': userSessionId,
        'did': deviceIdentifier,
        // 'did': '4f4b7baafbd8b0d8919a3a2848473be4',
        'cdata': [],
        'rollup': {}
      },
      // 'object': {'ver': APP_VERSION, 'id': objectId, 'type': objectType},
      'object': {},
      'tags': [],
      'edata': {
        'type': telemetryType,
        'mode': telemetryType == TelemetryType.player
            ? TelemetryMode.play
            : TelemetryMode.view,
        'pageid': pageIdentifier,
        // 'uri': pageUri,
        // 'duration': ''
      }
    };
    // print('eventData: $eventData');
    return eventData;
  }

  static getEndTelemetryEvent(
      String deviceIdentifier,
      String userId,
      String departmentId,
      String pageIdentifier,
      String userSessionId,
      String messageIdentifier,
      int duration,
      String telemetryType,
      String pageUri,
      Map rollup) {
    // String objectId, objectType;
    // if (telemetryType == TelemetryType.player) {
    //   List identifier = pageIdentifier.split('/');
    //   objectId = identifier.last;
    //   objectType = identifier[1] == EDisplayContentTypes.pdf.toLowerCase()
    //       ? EMimeTypes.pdf
    //       : identifier[1] == EDisplayContentTypes.html.toLowerCase()
    //           ? EMimeTypes.html
    //           : identifier[1] == EDisplayContentTypes.video.toLowerCase()
    //               ? EMimeTypes.mp4
    //               : identifier[1] == EDisplayContentTypes.audio.toLowerCase()
    //                   ? EMimeTypes.mp3
    //                   : identifier[1] == EDisplayContentTypes.quiz.toLowerCase()
    //                       ? EMimeTypes.assessment
    //                       : 'Content';
    // } else {
    //   objectId = pageIdentifier;
    //   objectType = 'Content';
    // }

    Map eventData = {
      'eid': TelemetryEvent.end,
      'ets': DateTime.now().millisecondsSinceEpoch,
      'ver': TELEMETRY_EVENT_VERSION,
      'mid': '${TelemetryEvent.end}:$messageIdentifier',
      'actor': {'id': userId, 'type': 'User'},
      'context': {
        'channel': departmentId,
        'pdata': {
          'id': TELEMETRY_PDATA_ID,
          'ver': APP_VERSION,
          'pid': TELEMETRY_PDATA_PID
        },
        'env': pageIdentifier,
        'sid': userSessionId,
        'did': deviceIdentifier,
        // 'did': '4f4b7baafbd8b0d8919a3a2848473be4',
        'cdata': [],
        'rollup': rollup
      },
      // 'object': {'ver': APP_VERSION, 'id': objectId, 'type': objectType},
      'object': {},
      'tags': [],
      'edata': {
        'type': telemetryType,
        'mode': telemetryType == TelemetryType.player
            ? TelemetryMode.play
            : TelemetryMode.view,
        'pageid': pageIdentifier,
        // 'uri': pageUri,
        'duration': duration
      }
    };
    // print('eventData: $eventData');
    return eventData;
  }

  static getImpressionTelemetryEvent(
    String deviceIdentifier,
    String userId,
    String departmentId,
    String pageIdentifier,
    String userSessionId,
    String messageIdentifier,
    String telemetryType,
    String pageUri,
  ) {
    // String objectId, objectType;
    // if (telemetryType == TelemetryType.player) {
    //   List identifier = pageIdentifier.split('/');
    //   objectId = identifier.last;
    //   objectType = identifier[1] == EDisplayContentTypes.pdf.toLowerCase()
    //       ? EMimeTypes.pdf
    //       : identifier[1] == EDisplayContentTypes.html.toLowerCase()
    //           ? EMimeTypes.html
    //           : identifier[1] == EDisplayContentTypes.video.toLowerCase()
    //               ? EMimeTypes.mp4
    //               : identifier[1] == EDisplayContentTypes.audio.toLowerCase()
    //                   ? EMimeTypes.mp3
    //                   : identifier[1] == EDisplayContentTypes.quiz.toLowerCase()
    //                       ? EMimeTypes.assessment
    //                       : '';
    // } else {
    //   objectId = pageIdentifier;
    //   objectType = '';
    // }
    Map eventData = {
      'eid': TelemetryEvent.impression,
      'ets': DateTime.now().millisecondsSinceEpoch,
      'ver': TELEMETRY_EVENT_VERSION,
      'mid': '${TelemetryEvent.impression}:$messageIdentifier',
      'actor': {'id': userId, 'type': 'User'},
      'context': {
        'channel': departmentId,
        'pdata': {
          'id': TELEMETRY_PDATA_ID,
          'ver': APP_VERSION,
          'pid': TELEMETRY_PDATA_PID
        },
        'env': pageIdentifier,
        'sid': userSessionId,
        'did': deviceIdentifier,
        // 'did': '4f4b7baafbd8b0d8919a3a2848473be4',
        'cdata': [],
        'rollup': {}
      },
      // 'object': {'ver': APP_VERSION, 'id': objectId, 'type': objectType},
      'object': {},
      'tags': [],
      'edata': {'type': telemetryType, 'pageid': pageIdentifier, 'uri': pageUri}
    };
    // print('eventData: $eventData');
    return eventData;
  }

  static getInteractTelemetryEvent(
      String deviceIdentifier,
      String userId,
      String departmentId,
      String pageIdentifier,
      String userSessionId,
      String messageIdentifier,
      String contentId,
      String subType) {
    Map eventData = {
      'eid': TelemetryEvent.interact,
      'ets': DateTime.now().millisecondsSinceEpoch,
      'ver': TELEMETRY_EVENT_VERSION,
      'mid': '${TelemetryEvent.interact}:$messageIdentifier',
      'actor': {'id': userId, 'type': 'User'},
      'context': {
        'channel': departmentId,
        'pdata': {
          'id': TELEMETRY_PDATA_ID,
          'ver': APP_VERSION,
          'pid': TELEMETRY_PDATA_PID
        },
        'env': pageIdentifier,
        'sid': userSessionId,
        'did': deviceIdentifier,
        // 'did': '4f4b7baafbd8b0d8919a3a2848473be4',
        'cdata': [],
        'rollup': {}
      },
      'object': {'ver': APP_VERSION, 'id': contentId},
      'tags': [],
      'edata': {
        'id': contentId,
        'type': 'click',
        'subtype': subType,
        'pageid': pageIdentifier
      }
    };
    // print('eventData: $eventData');
    return eventData;
  }

  // static getAuditTelemetryEvent(
  //   String deviceIdentifier,
  //   String userId,
  //   String departmentId,
  //   String userSessionId,
  //   String messageIdentifier,
  // ) {
  //   Map eventData = {
  //     'eid': TelemetryEvent.audit,
  //     'ets': DateTime.now().millisecondsSinceEpoch,
  //     'ver': APP_VERSION,
  //     'mid': '${TelemetryEvent.audit}:$messageIdentifier',
  //     'actor': {'id': userId, 'type': 'User'},
  //     'context': {
  //       'channel': departmentId,
  //       'pdata': {
  //         'id': TELEMETRY_PDATA_ID,
  //         'ver': APP_VERSION,
  //         'pid': TELEMETRY_PDATA_PID
  //       },
  //       'env': TelemetryPageIdentifier.home,
  //       'sid': userSessionId,
  //       'did': deviceIdentifier,
  //       // 'did': '4f4b7baafbd8b0d8919a3a2848473be4',
  //       'cdata': [],
  //       'rollup': {}
  //     },
  //     'object': {
  //       'ver': APP_VERSION,
  //       'id': TelemetryPageIdentifier.home // True here
  //     },
  //     'tags': [],
  //     'edata': {
  //       'type': TelemetryType.page,
  //       'pageid': TelemetryPageIdentifier.home,
  //       'uri': TelemetryPageIdentifier.home
  //     }
  //   };
  //   // print('eventData: $eventData');
  //   return eventData;
  // }
}
