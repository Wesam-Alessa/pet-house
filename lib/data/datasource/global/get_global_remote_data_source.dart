
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GlobalRemoteDataSource {

  Future<Response> getGlobalData(String url) async {
    var response = await http.get(Uri.parse(url));
      return response;
  }
  Future<Response> deleteGlobalData(String url, Map<String, String> header) async {
    var response = await http.delete(Uri.parse(url),headers:header );
      return response;
  }
}
