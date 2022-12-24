import 'package:odoo_rpc/odoo_rpc.dart';

import 'base_api_repo/base_api_repo.dart';

class SessionCheckApiRepo extends BaseApiRepo {
  Future<bool> checkSessionExpired() async {
    try {
      await client.checkSession();
    } on OdooSessionExpiredException catch (e) {
      return true;
    } on Exception catch (e) {
      return false;
    }
    return false;
  }
}
