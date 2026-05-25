class ResponseUrl {
  String? _Result;
  String? _APIURL;

  ResponseUrl(this._Result, this._APIURL);

  static Map<String, dynamic> toMap(ResponseUrl obj) {
    var map = Map<String, dynamic>();
    map["Result"] = obj.Result.toString();
    map["APIURL"] = obj.APIURL.toString();
    return map;
  }

  static Map<String, dynamic> toConverJson(ResponseUrl obj) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Result"] = obj.Result.toString();
    data["APIURL"] = obj.APIURL.toString();
    return data;
  }

  ResponseUrl.fromMap(Map<String, dynamic> map) {
    this._Result = map["Result"];
    this._APIURL = map["APIURL"];
  }

  String get Result => _Result ?? "";

  set Result(String? value) {
    _Result = value;
  }

  String get APIURL => _APIURL ?? "";

  set APIURL(String? value) {
    _APIURL = value ?? "";
  }

//\"{\\"Result\\":\\"success\\",\\"APIURL\\":\\"http://www.jwttmsapi.in/api/\\"}\"
}
