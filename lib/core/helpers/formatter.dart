import 'dart:developer';

import 'package:intl/intl.dart';

class ValueFormatter {
  static final ValueFormatter _singleton = ValueFormatter._internal();
  final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  factory ValueFormatter() => _singleton;

  ValueFormatter._internal();

  final NumberFormat _formatterSimple = NumberFormat.compactSimpleCurrency(
    name: "",
  );

  String formatValueSimple(String value) {
    try {
      return removeDecimalZeroFormat(
          _formatterSimple.format(num.parse(value)).replaceAll('.', ','));
    } catch (e, s) {
      log("$e\n$s");
      return value;
    }
  }

  String formatPriceCurrency(String value) {
    try {
      return "${removeDecimalZeroFormat(value)} \$";
    } catch (e, s) {
      log("$e\n$s");
      return value;
    }
  }

  String removeDecimalZeroFormat(String value) {
    return value.replaceFirst(RegExp(r'\.?0*$'), '');
  }
}
