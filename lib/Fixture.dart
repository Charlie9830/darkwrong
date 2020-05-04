import 'package:darkwrong/FieldValue.dart';
import 'package:flutter/foundation.dart';

class Fixture {
  final String uid;
  final Map<String, FieldValue> fieldValues;

  Fixture({
    @required this.uid,
    @required this.fieldValues,
  });
}
