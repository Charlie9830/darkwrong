import 'dart:math';

import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/util/getUid.dart';

AppState initMockData(AppState state) {
  final firstId = getUid();
  final secondId = getUid();
  final thirdId = getUid();

  return state.copyWith(
    fields: {
      firstId : FieldModel(
        name: 'Unit Number',
        type: FieldType.text,
        uid: firstId,
      ),
      secondId : FieldModel(
        name: 'Instrument Type',
        type: FieldType.text,
        uid: secondId,
      ),
      thirdId : FieldModel(
        name: 'Position',
        type: FieldType.text,
        uid: thirdId,
      ),
    },
  );
}