import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_sale/sh_utils.dart';
import 'package:live_sale/share_preference/sh_keys.dart';
import 'package:meta/meta.dart';

part 'session_check_state.dart';

class SessionCheckCubit extends Cubit<SessionCheckState> {
  final SharePrefUtils _shUtils;

  SessionCheckCubit()
      : _shUtils = SharePrefUtils(),
        super(SessionCheckInitial());

  checkSession() async {
    String? host = await _shUtils.getString(ShKeys.wifiKey);
    if (host != null) {
      emit(SessionCheckSuccess(host));
    } else {
      print('Fail');
      emit(SessionCheckFail());
    }
  }

  giveSuccess(String host) {
    _shUtils.saveString(ShKeys.wifiKey, host);
    emit(SessionCheckSuccess(host));
  }
}
