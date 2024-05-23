import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<dynamic> getPostResponse(
    {required Uri url,
    required Object body,
    required Map<String, String> headers}) async {
  final response = await http.post(url, body: body, headers: headers);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final body = jsonDecode(response.body);
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": false,
          "code": var _,
          "data": var _
        }) {
      throw HttpException(message);
    }
    throw HttpException(response.statusCode.toString());
  }
}

Future<dynamic> getGetResponse(Uri url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final body = jsonDecode(response.body);
    if (body
        case {
          'message': String message,
        }) {
      throw HttpException(message);
    }
    throw HttpException(response.statusCode.toString());
  }
}

Future<dynamic> getGetResponseWithHeader(
    Uri url, Map<String, String> headers) async {
  final response = await http.get(url, headers: headers);
  print('response $response');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final body = jsonDecode(response.body);
    if (body
        case {
          'message': String message,
        }) {
      throw HttpException(message);
    }
    throw HttpException(response.statusCode.toString());
  }
}
