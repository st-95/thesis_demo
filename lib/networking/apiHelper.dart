import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String baseUrl = "http://192.168.2.63:1880";

  Future<dynamic> getData() async {
    try {
      String path = "/get/status";

      final response = await http.get('$baseUrl$path', headers: {
        "Content-Type": "application/json",
      });

      return _returnResponse(response);
    } catch (err) {
      throw err;
    }
  }

  Future<dynamic> postActuatorStatus(String name, String type, int status) async {
    String path = "/post/status";
    var body = {
      "name": "$name",
      "type": "$type",
      "status": status,
      "automation": "off"
    };

    try {
      final response =
          await http.post('$baseUrl$path', body: json.encode(body), headers: {
        "Content-Type": "application/json",
      });

      return _returnResponse(response);
    } catch (err) {
      throw err;
    }
  }

  Future<dynamic> postAutomationStatus(String status) async {
    String path = "/post/status/automation";
    var body = {
      "automation": "$status"
    };

    try {
      final response =
      await http.post('$baseUrl$path', body: json.encode(body), headers: {
        "Content-Type": "application/json",
      });

      return _returnResponse(response);
    } catch (err) {
      throw err;
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        if (response.body == "") {
          return {};
        }
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 204:
        if (response.body == "") {
          return {};
        }
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        if (response.body == "") {
          return {};
        }
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(response.body.toString());
    }
  }
}
