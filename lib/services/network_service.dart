import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static const API_BASE_URL = 'https://api.buylink.app/users';

  void throwExceptionOnFail(http.Response response) {
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('response.body ${response.body}');
      print('response.statusCode ${response.statusCode}');
      // print(
      //     'Errors.fromJson(jsonDecode(response.body)["errors"]) ${Errors.fromJson(jsonDecode(response.body)['errors'])}');
      throw NetworkException(
        jsonDecode(response.body)['message'],
        // errors: Errors.fromJson(jsonDecode(response.body)['errors']),
        errors: jsonDecode(response.body)['errors'],
        statusCode: response.statusCode,
      );
    }
  }

  Future<dynamic> get(String url, {Map<String, String>? header}) async {
    try {
      print('$API_BASE_URL/$url');
      var response = await http
          .get(
            Uri.parse('$API_BASE_URL/$url'),
            headers: header,
          )
          .timeout(Duration(minutes: 2));

      print('Response body ${response.body}');

      throwExceptionOnFail(response);
      return jsonDecode(response.body);
    } on TimeoutException {
      print('Request timeout');
      throw NetworkException('Request timeout');
    } on SocketException {
      throw NetworkException('There is no internet');
    } on HttpException {
      throw NetworkException('There is an http exception');
    } on FormatException {
      throw NetworkException('There is a format exception');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await http
          .post(
            Uri.parse('$API_BASE_URL/$url'),
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(Duration(minutes: 2));

      throwExceptionOnFail(response);
      return jsonDecode(response.body);
    } on TimeoutException {
      print('Request timeout');
      throw NetworkException('Request timeout');
    } on SocketException {
      throw NetworkException('There is no internet');
    } on HttpException {
      throw NetworkException('There is an http exception');
    } on FormatException {
      throw NetworkException('There is a format exception');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postMultipart(
    String url, {
    Map<String, dynamic>? files,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      var request =
          new http.MultipartRequest("POST", Uri.parse('$API_BASE_URL/$url'));

      request.headers.addAll(headers!);

      if (body != null) {
        for (var data in body.entries) {
          // if (data.value.runtimeType == int) {
          //   data.value.toString();
          //   // print('${data.key} ######## ${data.value}');
          //   // request.fields[data.key] = data.value;
          // }
          print('${data.key} ######## ${data.value}');
          request.fields[data.key] = data.value.toString();
        }
      }

      if (files != null) {
        for (var data in files.entries) {
          if (data.value != null) {
            print('${data.key} ######## ${data.value}');
            request.files.add(await http.MultipartFile.fromPath(
              data.key,
              data.value,
              // contentType: new MediaType('application', 'x-tar'),
            ));
          }
        }
      }

      final http.StreamedResponse streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse)
          .timeout(Duration(minutes: 2));

      throwExceptionOnFail(response);
      return jsonDecode(response.body);
    } on TimeoutException {
      print('Request timeout');
      throw NetworkException('Request timeout');
    } on SocketException {
      throw NetworkException('There is no internet');
    } on HttpException {
      throw NetworkException('There is an http exception');
    } on FormatException {
      throw NetworkException('There is a format exception');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await http
          .delete(
            Uri.parse('$API_BASE_URL/$url'),
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(Duration(minutes: 2));

      throwExceptionOnFail(response);
      return jsonDecode(response.body);
    } on TimeoutException {
      print('Request timeout');
      throw NetworkException('Request timeout');
    } on SocketException {
      throw NetworkException('There is no internet');
    } on HttpException {
      throw NetworkException('There is an http exception');
    } on FormatException {
      throw NetworkException('There is a format exception');
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> downloadFile(String urlPath, String savePath) async {
  //   try {
  //     // print('$API_BASE_URL/$url');
  //     var response = await Dio().download(urlPath, savePath,
  //         onReceiveProgress: (rec, total) {
  //       print('Received $rec, Total $total');
  //     });
  //
  //     // throwExceptionOnFail(response as http.Response);
  //     // return '$rec/$total';
  //   } on SocketException {
  //     throw NetworkException('There is no internet');
  //   } on HttpException {
  //     throw NetworkException('There is an http exception');
  //   } on FormatException {
  //     throw NetworkException('There is a format exception');
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }
}

class NetworkException {
  final int? statusCode;
  final Map? errors;
  final String message;

  NetworkException(
    this.message, {
    this.statusCode,
    this.errors,
  });
}
