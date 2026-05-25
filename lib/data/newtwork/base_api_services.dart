import 'package:flutter/cupertino.dart';

abstract class BaseApiService {

  Future<dynamic> getGetApiResponseObject(String controller, Map<String,dynamic> data);
  Future<dynamic> postApiResponse(String controller, Map<String,dynamic> queryString ,String data);

  Future<dynamic> postApiResponseWithQueryParameter(String controller, Map<String,dynamic> queryString);

}