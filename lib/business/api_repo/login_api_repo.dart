import 'dart:convert';
import 'dart:io';

import 'package:live_sale/sh_utils.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../share_preference/sh_keys.dart';
import '../../utils/mscm_retail_app.dart';
import '../exception/admin_login_require_exception.dart';
import '../exception/login_fail_exception.dart';

class LoginApiRepo {
  final SharePrefUtils sharePrefUtils = SharePrefUtils();

  Future<OdooSession> loginProcess(
      {required String name,
      required String password,
      required String db}) async {
    final OdooClient client = OdooClient(MSCMRetail.serverUrl);
    final OdooSession session = await client.authenticate(db, name, password);
    // set globally don't delete code
    MSCMRetail.odooSession = session; // <--- important code
    await sharePrefUtils.saveString(
        ShKeys.sessionKey, json.encode(session.toJson()));
    return session;
  }

  Future<OdooSession> loginCheck() async {
    final OdooClient client = OdooClient(MSCMRetail.serverUrl);
    final OdooSession session = await client.checkSession();
    // set globally don't delete code
    MSCMRetail.odooSession = session; // <--- important code
    await sharePrefUtils.saveString(
        ShKeys.sessionKey, json.encode(session.toJson()));
    return session;
  }

  Future<void> employeeLogin(
      {required String name, required String password}) async {
    String? sessionJsonString =
        await sharePrefUtils.getString(ShKeys.sessionKey);
    String? baseUrl = await sharePrefUtils.getString(ShKeys.serverUrlKey);
    if (sessionJsonString != null &&
        sessionJsonString.length > 5 &&
        baseUrl != null) {
      OdooSession odooSession =
          OdooSession.fromJson(json.decode(sessionJsonString));
      final OdooClient client = OdooClient(baseUrl, odooSession);
      List<dynamic> responseList = await client.callKw({
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['user_name', '=', name],
            ['password', '=', password]
          ],
          'fields': [
            'work_phone',
            'employee_type',
            'display_name',
            'short_code'
          ],
          'limit': 1,
        },
      });

      if (responseList.isEmpty) {
        throw LoginFailException('Username and password not match');
      } else {
        await sharePrefUtils.saveString(
            ShKeys.currentUser, json.encode(responseList.first));
      }
    } else {
      throw AdminLoginRequireException('Admin login required');
    }
  }

  Future<void> adminLogout() async {
    String? sessionJsonString =
        await sharePrefUtils.getString(ShKeys.sessionKey);
    String? baseUrl = await sharePrefUtils.getString(ShKeys.serverUrlKey);
    if (sessionJsonString != null &&
        sessionJsonString.length > 5 &&
        baseUrl != null) {
      OdooSession odooSession =
          OdooSession.fromJson(json.decode(sessionJsonString));
      final OdooClient client = OdooClient(baseUrl, odooSession);
      await client.destroySession();
    }
  }
}
