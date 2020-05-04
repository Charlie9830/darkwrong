import 'package:darkwrong/FieldValue.dart';
import 'package:flutter/foundation.dart';

class FixtureModel {
  final String uid;
  final Map<String, FieldValue> fieldValues;

  FixtureModel({
    @required this.uid,
    @required this.fieldValues,
  });
}
