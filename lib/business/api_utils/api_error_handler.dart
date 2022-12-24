import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:odoo_rpc/odoo_rpc.dart';

import '../../model/readable_api_error.dart';
import '../exception/admin_login_require_exception.dart';
import '../exception/login_fail_exception.dart';

class ApiErrorHandler {
  static const String internetError = 'internet connection error';
  static const int errorCode = 0;

  static ReadableApiError createReadableErrorMessage(Exception exception) {
    String message = 'server error';
    int errorCode = 500;
    if (exception is OdooException) {
      debugPrint(exception.message);
      // OdooErrorResponse errorResponse = _getErrorResponse(exception.message);
      message = exception.message.substring(0, 100);
      errorCode = 400;
    } else if (exception is OdooSessionExpiredException) {
      message = exception.message.substring(0, 100);
      errorCode = 201;
    } else if (exception is AdminLoginRequireException) {
      message = exception.message.substring(0, 100);
      errorCode = 401;
    } else if (exception is LoginFailException) {
      message = exception.message;
      errorCode = 404;
    } else {
      message = internetError;
      errorCode = errorCode;
    }

    return ReadableApiError(message: message, errorCode: errorCode);
  }

// static OdooErrorResponse _getErrorResponse(String jsonString) {
//   // final something = json.decode(jsonString);
//   OdooErrorResponse odooErrorResponse =
//       OdooErrorResponse.fromJson(jsonString);
//   return odooErrorResponse;
// }
}
