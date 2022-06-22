import 'dart:convert';
import 'package:dio/dio.dart';
import '/utils/gm_utils.dart';
import 'custom_exception.dart';
import 'error_code.dart';
import 'meta.dart';

class APIServices {
  static int connectionTimeOut = 300000;
  static int receiveTimeout = 300000;
  static int retryCount = 3;
  static Dio dio = Dio();

  void configAPI() {
    // Set default configs
    dio = Dio();
    dio.options.connectTimeout = connectionTimeOut;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.headers["content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
  }

  bool validateRequest(String url) {
    if (url.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<Meta> processGetURL(String url, String authToken) async {
    if (validateRequest(url)) {
      final bool isNetworkAvailable = await GMUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
          dio.options.headers['Content-Length'] = 0;

          final Response response = await dio.get(url);
          return _getResponse(response);
        } catch (error) {

          return handleError(error);
        }
      } else {
        final Meta meta = Meta(
            statusCode: ErrorCode.internetError,
            statusMsg: 'Please check your network connection');
        return meta;
      }
    } else {
      final Meta meta =
          Meta(statusCode: ErrorCode.urlNotValid, statusMsg: "Not a valid URL");
      return meta;
    }
  }

  Meta _getResponse(Response response) {
    Meta data;
    switch (response.statusCode) {
      case 200:
        final String responseJson = _isJsonValid(response.data.toString())
            ? response.data.toString()
            : json.encode(response.data).toString();
        data = Meta(statusCode: 200, statusMsg: responseJson);
        break;
      case 400:
        data = Meta(
            statusCode: 400,
            statusMsg: json.encode((response.data).toString()));
        break;
      case 403:
        data = Meta(
            statusCode: response.statusCode!,
            statusMsg:
                json.encode(UnauthorisedException(response.data.toString())));
        break;
      case 500:

      default:
        data = Meta(
            statusCode: response.statusCode!,
            statusMsg: json.encode(FetchDataException(
                'Error occurs while Communication with Server with StatusCode : ${response.statusCode}')));
    }

    return data;
  }

  bool _isJsonValid(String response) {
    try {
      json.decode(response);
    } catch (e) {
      return false;
    }
    return true;
  }

  Meta throwError(int errorCode, String errorMsg) {
    final Meta meta = Meta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  Meta throwLoginError(int errorCode, String errorMsg) {
    final Meta meta = Meta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  Meta handleError(dynamic error) {
    if (error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.connectTimeout) {
      return throwError(ErrorCode.connectionTimeout, "Connection Timeout!");
    } else if (error.type == DioErrorType.response) {
      return throwError(
          error.response.statusCode as int, error.response.toString());
    } else {
      return throwError(ErrorCode.communicationError, "Communication Error");
    }
  }

  Meta handleLoginError(dynamic error) {
    if (error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.connectTimeout) {
      return throwLoginError(
          ErrorCode.connectionTimeout, "Connection Timeout!");
    } else if (error.type == DioErrorType.response) {
      if (error.response.statusCode == 401 &&
          error.response.data == 'TOKEN EXPIRED') {
        return throwLoginError(
            ErrorCode.unauthorizedUser, error.response.data.toString());
      } else {
        switch (error.response.statusCode) {
          case 400:
            return throwLoginError(ErrorCode.unauthorizedUser,
                "Email Id or Password entered is Invalid");
          case 403:
            return throwLoginError(403, "Forbidden");
          case 404:
            return throwLoginError(404, "Not Found");
          case 409:
            return throwLoginError(ErrorCode.throttleError, "Throttle Error");
          case 422:
            return throwLoginError(
                ErrorCode.userAlreadyExists, "User Already Exists");
          case 500:
            return throwLoginError(500, "Internal Server Error");
        }
      }
    } else {
      return throwLoginError(
          ErrorCode.communicationError, "Communication Error");
    }
    return throwError(500, "Internal Server Error");
  }
}
