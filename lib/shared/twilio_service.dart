import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TwilioFunctionsService {
  TwilioFunctionsService._();
  static final instance = TwilioFunctionsService._();

  final http.Client client = http.Client();
  final accessTokenUrl =
      'https://twiliochatroomaccesstoken-4680.twil.io/accessToken';

  Future<dynamic> createToken(String identity) async {
    try {
      // Map<String, String> header = {
      //   'Accept':
      //       'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      //   "Access-Control-Allow-Origin": "*",
      //   "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
      // };
      //var url = Uri.parse(accessTokenUrl + '?user=' + identity);
      var url = Uri.https('twiliochatroomaccesstoken-4680.twil.io',
          '/accessToken', {'user': identity});
      final response = await http.get(url);
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      responseMap["user"] = identity;
      print(responseMap);
      return responseMap;
    } catch (error) {
      throw Exception([error.toString()]);
    }
  }
}
