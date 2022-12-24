part of 'session_check_cubit.dart';

@immutable
abstract class SessionCheckState {}

class SessionCheckInitial extends SessionCheckState {}

class SessionCheckFail extends SessionCheckState {}

class SessionCheckSuccess extends SessionCheckState {
  final String wifiName;

  SessionCheckSuccess(this.wifiName);
}
