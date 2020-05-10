import 'dart:math';

import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:random_words/random_words.dart';

AppState initMockData(AppState state) {
  const desiredFieldCount = 12;
  const desiredFixtureCount = 200;
  const wordCount = 1000;

  final words = generateWordPairs().take(wordCount).toList();

  final fieldIds =
      List<String>.generate(desiredFieldCount, (index) => getUid());

  final fields = List<FieldModel>.generate(
    desiredFieldCount,
    (index) => FieldModel(
        name: 'Field ${index + 1}', type: FieldType.text, uid: fieldIds[index]),
  );

  final fixtureIds =
      List<String>.generate(desiredFixtureCount, (index) => getUid());
  final fixtures = List<FixtureModel>.generate(
      desiredFixtureCount,
      (index) => FixtureModel(
            uid: fixtureIds[index],
            values: _generateRandomFieldValues(fields, words),
          ));

  final fieldValues = Map<String, Map<String, FieldValue>>.fromEntries(
      fields.map((field) => MapEntry(field.uid, <String, FieldValue>{})));

  for (var fixture in fixtures) {
    for (var entry in fixture.values.entries) {
      if (fieldValues[entry.key].containsKey(entry.value.key) == false) {
        fieldValues[entry.key][entry.value.key] = entry.value;
      }
    }
  }

  return state.copyWith(
      fixtureState: FixtureState(
    fixtures: Map<String, FixtureModel>.fromEntries(
        fixtures.map((item) => MapEntry(item.uid, item))),
    fieldValues: FieldValuesStore(valueMap: fieldValues),
    fields: Map<String, FieldModel>.fromEntries(
        fields.map((item) => MapEntry(item.uid, item))),
  ));
}

Map<String, FieldValue> _generateRandomFieldValues(
    List<FieldModel> fields, List<WordPair> nouns) {
  final random = Random();
  return Map<String, FieldValue>.fromEntries(fields.map((field) => MapEntry(
      field.uid, FieldValue(nouns[random.nextInt(nouns.length - 1)].asString))));
}
