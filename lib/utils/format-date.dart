import 'package:intl/intl.dart';

String formatDate(String isoString) {
  DateTime date = DateTime.parse(isoString);
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();
  return '$day/$month/$year';
}

String formatStringDateWithTime(String isoString) {
  DateTime date = DateTime.parse(isoString);
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();
  String hour = date.hour.toString().padLeft(2, '0');
  String minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/$year às $hour:$minute';
}

DateTime? stringDateToDatetime(String date) {
  try {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.parse(date);
  } catch (e) {
    print('Erro ao converter a data: $e');
    return null;
  }
}
