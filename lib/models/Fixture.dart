import 'package:darkwrong/models/ValueReferenceModel.dart';
import 'package:flutter/foundation.dart';

class FixtureModel {
  final String uid;
  final Map<String, ValueReferenceModel> values;

  FixtureModel({
    @required this.uid,
    @required this.values,
  });
}
