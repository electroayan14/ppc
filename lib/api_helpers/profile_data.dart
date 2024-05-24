import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/main.dart';

String? token = prefs.getString('token');
String customerId = '';
String userName = " ",
    userEmail = " ",
    phone = " ",
    whatsapp = " ",
    address = " ",
    bio = " ",
    clubName = " ",
    storeId = " ",
    storeName = " ";
String cardNumber = " ", dob = " ";
Map _checkProfileBody(dynamic body) {
  if (body
      case {
        "msg": var message,
        "error": var _,
        "success": var _,
        "code": var code,
        "data": {"data": Map<dynamic, dynamic> userDataResponse},
      }) {
    print("Loading profile complete");
    return userDataResponse;
  } else {
    return {};
  }
}

Future<Map> loadProfile(BuildContext context) async {
  final url =
      Uri.parse('https://app.premscollectionskolkata.com/api/fetch-profile');
  try {
    final result = await getGetResponseWithHeader(url, onlyToken);

    return _checkProfileBody(result);
  } on HttpException catch (e) {
    if (context.mounted) {
      showSnackBarMessage(context, message: e.message);
    }
  } catch (e) {
    if (!context.mounted) {
      return {};
    }
    showSnackBarMessage(context, message: e.toString());
  }
  return {};
}
