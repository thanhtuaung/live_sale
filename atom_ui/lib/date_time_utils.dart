import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateFormat ddMmYYYFormat = DateFormat('dd-MM-yyyy');
  static DateFormat ddMmYYYFormatSlug = DateFormat('dd/MM/yyyy');
  static DateFormat hhMMFull = DateFormat('hh:mm a');
  static DateFormat yMmDdHMS = DateFormat('yyyy-MM-dd HH:mm:ss');
  static DateFormat yMmDdHMSsA = DateFormat('yyyy-MM-dd HH:mm:ss a');
  static DateFormat yMmDdHMA = DateFormat('yyyy-MM-dd HH:mm a');
  static DateFormat yMmDd = DateFormat('yyyy-MM-dd');
}
