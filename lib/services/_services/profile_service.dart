import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import './../../constants/index.dart';
import './../../util/helper.dart';

class ProfileService {
  final _storage = FlutterSecureStorage();

  Future<dynamic> getProfileDetails() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String profileDetailsUrl = ApiUrl.baseUrl + ApiUrl.getProfileDetails;
    Response response = await get(Uri.parse(profileDetailsUrl),
        headers: Helper.getHeaders(token, wid));

    return response;
  }

  Future<dynamic> getProfileDetailsById(String id) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String profileDetailsUrl =
        ApiUrl.baseUrl + ApiUrl.getProfileDetailsByUserId;
    // print("profilrdetailsbyid url ${profileDetailsUrl + id}");
    Response response = await get(
        Uri.parse(profileDetailsUrl + (id == '' ? wid : id)),
        headers: Helper.getHeaders(token, wid));
    // developer.log('Profile details' + response.body);
    return response;
  }

  Future<dynamic> updateProfileDetails(Map profileDetails) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    // var _profileDetails = json.encode(profileDetails);
    Map data = {
      "request": {"userId": "$wid", "profileDetails": profileDetails}
    };
    var body = json.encode(data);
    // developer.log(body.toString());
    String url = ApiUrl.baseUrl + ApiUrl.updateProfileDetails;
    // print("$url");
    final response = await post(Uri.parse(url),
        headers: Helper.profilePostHeaders(token, wid), body: body);
    // developer.log(response.body.toString());
    return jsonDecode(response.body);
  }

  Future<dynamic> getInReviewFields() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "serviceName": "profile",
      "applicationStatus": "SEND_FOR_APPROVAL"
    };

    var body = json.encode(data);

    Response response = await post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getInReviewFields),
        headers: Helper.postHeaders(token, wid),
        body: body);

    // developer.log(response.body);

    return jsonDecode(response.body);
  }

  Future<dynamic> getNationalities() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getNationalities),
        headers: Helper.getHeaders(token, wid));

    return response;
  }

  Future<dynamic> getLanguages() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getLanguages),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getDegrees(String type) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(Uri.parse(ApiUrl.baseUrl + ApiUrl.getDegrees),
        headers: Helper.getHeaders(token, wid));
    // print(res.body);
    return response;
  }

  Future<dynamic> getOrganisations() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getDepartments),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getIndustries() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getIndustries),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getDesignations() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getDesignationsAndGradePay),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getGradePay() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getDesignationsAndGradePay),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  // getServicesAndCadre

  Future<dynamic> getServices() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getServicesAndCadre),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getCadre() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getServicesAndCadre),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getProfilePageMeta() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getProfilePageMeta),
        headers: Helper.getHeaders(token, wid));
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      // print(contents['designations']);
      return contents;
    } else {
      throw 'Can\'t get profile page meta.';
    }
  }

  /// Return username
  Future<dynamic> getUserName(String wid) async {
    final _storage = FlutterSecureStorage();

    String token = await _storage.read(key: Storage.authToken);

    final response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.basicUserInfo + wid),
        headers: Helper.getHeaders(token, wid));
    return response;
  }

  // To send the OTP to mobile number
  Future<dynamic> generateMobileNumberOTP(String mobileNumber) async {
    Map data = {
      "request": {"type": "phone", "key": "$mobileNumber"}
    };
    var body = json.encode(data);
    String url = ApiUrl.baseUrl + ApiUrl.generateOTP;
    // print("$url");
    final response = await post(Uri.parse(url),
        headers: Helper.signUpPostHeaders(), body: body);
    // developer.log(jsonDecode(response.body).toString());
    return jsonDecode(response.body);
  }

  //To verify the OTP
  Future<dynamic> verifyMobileNumberOTP(String mobileNumber, String otp) async {
    Map data = {
      "request": {"type": "phone", "key": "$mobileNumber", "otp": "$otp"}
    };
    var body = json.encode(data);
    String url = ApiUrl.baseUrl + ApiUrl.verifyOTP;
    final response = await post(Uri.parse(url),
        headers: Helper.signUpPostHeaders(), body: body);
    // developer.log(jsonDecode(response.body).toString());
    return jsonDecode(response.body);
  }

  //get edit profile configuration
  Future<dynamic> getProfileEditConfig() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getProfileEditConfig),
        headers: Helper.getHeaders(token, wid));

    return jsonDecode(response.body);
  }
}
