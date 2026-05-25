import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../loginModules/data/localStorage.dart';
import '../../loginModules/data/sharePreferencesKeys.dart';
import '../app_exception.dart';
import '../storage/hive_storage.dart';
import 'base_api_services.dart';

class NetworkApiService extends BaseApiService {

  @override
  Future getGetApiResponseObject(String controllerName, Map<String, dynamic> queryParams) async {
    await HiveStorage.init();
    String url = await HiveStorage.fetchString(HiveStorage.keyURL) ?? "";
    String token =
        await HiveStorage.fetchString(HiveStorage.keyToken) ?? "";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Token': '${token}'
    };
    dynamic responseJson;
    String urlString = "$url$controllerName";
    try {
      final Uri uri = Uri.parse(urlString).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApiResponse(String controller, Map<String, dynamic> queryParams, String data) async {
    await HiveStorage.init();
    String url = await HiveStorage.fetchString(HiveStorage.keyURL) ?? "";
    String token = await HiveStorage.fetchString(HiveStorage.keyToken) ?? "";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${token}'
    };
    dynamic responseJson;
    String urlString = "$url$controller";
    try {
      final Uri uri =
      Uri.parse(urlString).replace(queryParameters: queryParams);
      final response = await http.post(uri, body: data, headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApiResponseWithQueryParameter(String controller, Map<String, dynamic> queryParams) async {
    await HiveStorage.init();
    String url = await HiveStorage.fetchString(HiveStorage.keyURL) ?? "";
    String token = await HiveStorage.fetchString(HiveStorage.keyToken) ?? "";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    dynamic responseJson;
    String urlString = "$url$controller";
    try {
      final Uri uri =
      Uri.parse(urlString).replace(queryParameters: queryParams);
      final response = await http.post(uri, headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw BadRequestException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occur while communicating server with status code${response.statusCode}');
    }
  }
}