import 'package:cloud_firestore/cloud_firestore.dart';

extension TimeStampExtension on Timestamp {
  String toHumanTime() {
    final date = toDate();
    return "${_toReadable(date.hour)}:${_toReadable(date.minute)}";
  }

  String _toReadable(int number) {
    String res = '';
    if (number < 10) {
      res = '0$number';
    } else {
      res = '$number';
    }
    return res;
  }
}
