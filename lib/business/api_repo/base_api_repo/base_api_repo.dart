import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../utils/mscm_retail_app.dart';

class BaseApiRepo {
  late OdooClient _client;
  late Dio _dio;
  late Stream<OdooSession> _listenSessionChange;
  final String jsonRpc = '/jsonrpc';
  final String createMethod = 'create';
  final String searchRead = 'search_read';
  final String executeMethod = 'execute';

  BaseApiRepo() {
    _client = OdooClient(MSCMRetail.serverUrl, MSCMRetail.odooSession);
    _dio = Dio(
      BaseOptions(
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        baseUrl: MSCMRetail.serverUrl,
        connectTimeout: 50000,
        sendTimeout: 50000,
        receiveTimeout: 50000,
      ),
    );
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

    _listenSessionChange = client.sessionStream;
  }

  Dio get dio => _dio;

  OdooClient get client => _client;

  Stream<OdooSession> get listenSessionChange => _listenSessionChange;

  Future<dynamic> callKw(Map<String, dynamic> json) async {
    dynamic response = await client.callKw(json);
    debugPrint(response.toString());
    return response;
  }

  Map<String, dynamic> createApiRequest(
      {required String model,
      required String method,
      List? args,
      dynamic? kwargs}) {
    return {
      'service': 'object',
      'model': model,
      'method': method,
      'args': args ?? [],
      'kwargs': kwargs ?? {},
    };
  }

  Map<String, dynamic> createOneToManyApiRequest({List? args, dynamic kwargs}) {
    return {
      "service": "object",
      "method": "execute",
      'args': args ?? [],
      'kwargs': kwargs ?? {},
    };
  }
}
