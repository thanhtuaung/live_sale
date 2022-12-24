import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_sale/business/api_repo/login_api_repo.dart';
import 'package:live_sale/src/constant_strings.dart';
import 'package:live_sale/utils/mscm_retail_app.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../../model/readable_api_error.dart';
import '../../../sh_utils.dart';
import '../../../share_preference/sh_keys.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SharePrefUtils _sharePrefUtils;

  LoginCubit()
      : _sharePrefUtils = SharePrefUtils(),
        super(LoginInitial());

  login(String username, String password, String database) async {
    emit(LoginLoading());
    print(username);
    print(password);
    print(database);
    try {
      OdooSession odooSession = await LoginApiRepo()
          .loginProcess(name: username, password: password, db: database);
      MSCMRetail.odooSession = odooSession;
      await _sharePrefUtils.saveObject(ShKeys.sessionKey, odooSession);
      await _sharePrefUtils.saveString(ShKeys.database, database);
      await _sharePrefUtils.saveString(ShKeys.currentUser, username);
      await _sharePrefUtils.saveString(ShKeys.password, password);
      MSCMRetail.password = password;
      emit(LoginSuccess());
    } on Exception catch (e) {
      print(e.toString());
      emit(
        LoginFail(
          error: const ReadableApiError(
              message: 'Username and password not match', errorCode: 0),
        ),
      );
      // }
    }
  }

  void loginCheck() async {
    emit(LoginLoading());
    String? database = await SharePrefUtils().getString(ShKeys.database);
    String? username = await SharePrefUtils().getString(ShKeys.currentUser);
    String? password = await SharePrefUtils().getString(ShKeys.password);
    // String? database = await SharePrefUtils().getString(ShKeys.database);
    // String? username = await SharePrefUtils().getString(ShKeys.currentUser);
    // String? password = await SharePrefUtils().getString(ShKeys.password);
    database ??= ConstantStrings.defaultDatabase;
    username ??= ConstantStrings.defaultUsername;
    password ??= ConstantStrings.defaultPassword;
    login(username, password, database);
  }
}
