import 'package:ppc/api_helpers/profile_data.dart';

Map<String, String> headers = {'Accept': 'application/json'};
Map<String, String> headersWithToken = {
  'Accept': 'application/json',
  'Authorization': 'Bearer $token',
};
Map<String, String> onlyToken = {
  'Authorization': 'Bearer $token',
};
