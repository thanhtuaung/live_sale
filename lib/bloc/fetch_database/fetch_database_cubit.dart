import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/api_utils/api_error_handler.dart';
import '../../model/odoo_response.dart';
import '../../model/readable_api_error.dart';
import '../../sh_utils.dart';
import '../../share_preference/sh_keys.dart';

part 'fetch_database_state.dart';

class FetchDatabaseCubit extends Cubit<FetchDatabaseState> {
  FetchDatabaseCubit() : super(FetchDatabaseInitial());

  fetchDatabase({required String baseUrl}) async {
    emit(FetchDatabaseFetching());
    try {
      Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
      dio.interceptors.add(
          LogInterceptor(requestHeader: true, responseBody: true, error: true));
      Response response = await dio.post('/jsonrpc', data: {
        "jsonrpc": "2.0",
        "method": "call",
        "id": 921359310,
        "params": {"method": "list", "service": "db", "args": {}}
      });
      OdooErrorResponse<String> odooErrorResponse =
          OdooErrorResponse.fromJson(response.data);
      await SharePrefUtils().saveString(ShKeys.serverUrlKey, baseUrl);

      emit(FetchDatabaseSuccess(odooErrorResponse.result ?? []));
    } on DioError catch (e) {
      emit(FetchDatabaseFail(
          const ReadableApiError(message: 'Connection error', errorCode: 0)));
    } on Exception catch (e) {
      emit(FetchDatabaseFail(const ReadableApiError(
          message: ApiErrorHandler.internetError, errorCode: 0)));
    }
  }
}
