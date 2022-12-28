import 'dart:io';
import 'package:cmcp/theme_utils/strings.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Api {
  static final _api = Api._internal();

  factory Api() {
    return _api;
  }
  Api._internal();

  String token;
  String baseUrl = default_url;
// Map<String, String> headers = {}
  Future<http.Response> httpGet(String endPath) {
    // Uri uri = Uri.http(baseUrl, '$path/$endPath');
    var uri = Uri.parse("${this.baseUrl}/$endPath");
    print(uri);
    return http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  Future<http.Response> httpTenantLogin(String path, Object body) {
    final uri = Uri.parse("https://$path");
    // print(uri);

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    return http.post(uri, body: body, headers: headers);
  }

  Future<http.Response> httpPost(String endPath, Object body,
      {bool cType = false}) {
    final uri = Uri.parse("${this.baseUrl}/$endPath");
    print(uri);

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    if (cType) {
      headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-type': 'application/json',
      };
    }
    return http.post(uri, body: body, headers: headers);
  }

  Future<http.Response> httpPostWithFile(
      String endPath, Map<String, String> body,
      {File file, String path = 'app'}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    var uri = Uri.parse("${this.baseUrl}/$endPath");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    if (file == null) {
    } else {
      var length = await file.length();
      request.files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: basename(file.path)),
      );
    }
    return await http.Response.fromStream(await request.send());
  }

  Future<http.Response> httpPostWithMultiFile(
      String endPath, Map<String, String> body,
      {List<File> allFile, String path = 'app'}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    var uri = Uri.parse("${this.baseUrl}/$endPath");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    if (allFile == null) {
    } else {
      List<MultipartFile> newList = new List<MultipartFile>();

      for (int i = 0; i < allFile.length; i++) {
        var length = await allFile[i].length();
        var multipartFile = new http.MultipartFile(
            "files[]", allFile[i].openRead(), length,
            filename: basename(allFile[i].path));
        newList.add(multipartFile);
      }
      request.files.addAll(newList);
    }
    return await http.Response.fromStream(await request.send());
  }

  Future<http.Response> httpPutWithFile(
      String endPath, Map<String, String> body,
      {File file, String path = 'app'}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    // print('check');
    var uri = Uri.parse("${this.baseUrl}/$endPath");
    http.MultipartRequest request = new http.MultipartRequest('PUT', uri);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    if (file == null) {
    } else {
      var length = await file.length();
      request.files.add(
        http.MultipartFile('files', file.openRead(), length,
            filename: basename(file.path)),
      );
    }
    // print('check 2');
    return await http.Response.fromStream(await request.send());
  }
}
