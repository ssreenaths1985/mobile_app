import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/_models/register_organisation_model.dart';
// import 'dart:developer' as developer;

import 'package:karmayogi_mobile/models/_models/registration_position_model.dart';
import 'package:karmayogi_mobile/util/helper.dart';

import '../../constants/_constants/storage_constants.dart';

class RegistrationService {
  // final _storage = FlutterSecureStorage();
  Future<List<RegistrationPosition>> getPositions() async {
    Response response = await get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.getAllPosition),
    );
    var contents = jsonDecode(response.body);
    List<dynamic> data = contents['positions'];
    List<RegistrationPosition> positions = data
        .map(
          (dynamic item) => RegistrationPosition.fromJson(item),
        )
        .toList();
    // developer.log(positions.toString());
    return positions;
  }

  Future<List<OrganisationModel>> getMinistries({String parentId = ''}) async {
    Response response = await get(
      Uri.parse(ApiUrl.baseUrl +
          (parentId == ''
              ? ApiUrl.getAllMinistries
              : ApiUrl.getAllMinistries.replaceAll('ministry', parentId))),
    );
    var contents = jsonDecode(response.body);
    List<dynamic> data = contents['result']['response']['content'];
    List<OrganisationModel> ministries = data
        .map(
          (dynamic item) => OrganisationModel.fromJson(item),
        )
        .toList();
    // developer.log(ministries.toString());
    return ministries;
  }

  Future<List<OrganisationModel>> getStates() async {
    Response response = await get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.getAllStates),
    );
    var contents = jsonDecode(response.body);
    List<dynamic> data = contents['result']['response']['content'];
    List<OrganisationModel> states = data
        .map(
          (dynamic item) => OrganisationModel.fromJson(item),
        )
        .toList();
    // developer.log(states.toString());
    return states;
  }

  Future<dynamic> registerAccount(
    String firstName,
    String email,
    String surName,
    String position,
    OrganisationModel organisation, {
    bool isParichayUser = false,
  }) async {
    // var _profileDetails = json.encode(profileDetails);
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);

    Map data;
    if (isParichayUser) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token.toString());
      // print(decodedToken['sub']);
      String userId = decodedToken['sub'].split(':')[2];
      await _storage.write(key: Storage.userId, value: userId);
      data = {
        "request": {
          "userId": userId,
          "firstName": firstName,
          "lastName": surName,
          "email": email,
          "position": position,
          "orgName": organisation.name,
          "channel": organisation.name,
          "organisationType": organisation.orgType,
          "organisationSubType": organisation.subOrgType,
          "mapId": organisation.id,
          "sbOrgId": organisation.subOrgId,
          "sbRootOrgId": organisation.subRootOrgId,
          "source": SOURCE_NAME,
        }
      };
    } else {
      data = {
        "firstName": firstName,
        "lastName": surName,
        "email": email,
        "position": position,
        "orgName": organisation.name,
        "channel": organisation.name,
        "organisationType": organisation.orgType,
        "organisationSubType": organisation.subOrgType,
        "mapId": organisation.id,
        "sbOrgId": organisation.subOrgId,
        "sbRootOrgId": organisation.subRootOrgId,
        "source": SOURCE_NAME,
      };
    }

    var body = json.encode(data);
    // print(body);
    String url = ApiUrl.baseUrl +
        (isParichayUser ? ApiUrl.registerParichayAccount : ApiUrl.register);
    Response response = await post(Uri.parse(url),
        headers: isParichayUser
            ? Helper.registerParichayUserPostHeaders(token)
            : Helper.registerPostHeaders(),
        body: body);
    // developer.log(response.body.toString());
    return response;
  }
}
