import 'dart:math';

import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:random_words/random_words.dart';

AppState initMockData(AppState state) {
  const desiredFieldCount = 10;
  const desiredFixtureCount = 20;
  const wordCount = 10;

  final wordPairs = generateWordPairs().take(wordCount).toList();

  final fieldIds =
      List<String>.generate(desiredFieldCount, (index) => getUid());

  final fields = List<FieldModel>.generate(
    desiredFieldCount,
    (index) => FieldModel(
        name: 'Field ${index + 1}', type: FieldType.text, uid: fieldIds[index]),
  );

  final fieldValues = _generateRandomFieldValues(fields, wordPairs);

  final fixtureIds =
      List<String>.generate(desiredFixtureCount, (index) => getUid());
  final fixtures = List<FixtureModel>.generate(
      desiredFixtureCount,
      (index) => FixtureModel(
            uid: fixtureIds[index],
            valueKeys: _generateRandomFieldValueKeysMap(fields, fieldValues),
          ));

  return state.copyWith(
      fixtureState: FixtureState(
    fixtures: Map<String, FixtureModel>.fromEntries(
        fixtures.map((item) => MapEntry(item.uid, item))),
    fieldValues: FieldValuesStore(valueMap: fieldValues),
    fields: Map<String, FieldModel>.fromEntries(
        fields.map((item) => MapEntry(item.uid, item))),
  ));
}

Map<String, FieldValueKey> _generateRandomFieldValueKeysMap(
    List<FieldModel> fields,
    Map<String, Map<FieldValueKey, FieldValue>> fieldValues) {
  final random = Random();
  return Map<String, FieldValueKey>.fromEntries(fields.map((field) {
    final options = fieldValues[field.uid].keys;
    final pickIndex = random.nextInt(options.length);


    return MapEntry(field.uid, options.elementAt(pickIndex));
  }));
}

Map<String, Map<FieldValueKey, FieldValue>> _generateRandomFieldValues(
    List<FieldModel> fields, List<WordPair> wordPairs) {
  return Map<String, Map<FieldValueKey, FieldValue>>.fromEntries(
      fields.map((field) {
    return MapEntry(field.uid, _generateRandomFieldValuesValue(wordPairs));
  }));
}

Map<FieldValueKey, FieldValue> _generateRandomFieldValuesValue(
    List<WordPair> wordPairs) {
  final random = Random();
  final map = <FieldValueKey, FieldValue>{};
  final loopCount = random.nextInt(wordPairs.length);

  for (var i = 0; i <= loopCount; i++) {
    final textValue =
        '${wordPairs[random.nextInt(wordPairs.length)].first} ${wordPairs[random.nextInt(wordPairs.length)].second}';
    final fieldValueKey = FieldValueKey.fromText(textValue);

    if (map.containsKey(fieldValueKey) == false) {
      map[fieldValueKey] = FieldValue.fromText(textValue, fieldValueKey);
    }
  }

  return map;
}
