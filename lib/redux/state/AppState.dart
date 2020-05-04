import 'package:darkwrong/Field.dart';
import 'package:darkwrong/Fixture.dart';

class AppState {
  final List<FixtureModel> fixtures;
  final Map<String, FieldModel> fields;
  final Map<String, int> maxFieldLengths;

  AppState({
    this.fixtures,
    this.fields,
    this.maxFieldLengths,
  });

  AppState.initial()
      : fixtures = [],
        fields = <String, FieldModel>{},
        maxFieldLengths = <String, int>{};

  AppState copyWith({
    List<FixtureModel> fixtures,
    Map<String, FieldModel> fields,
    Map<String, int> maxFieldLengths,
  }) {
    return AppState(
      fixtures: fixtures ?? this.fixtures,
      fields: fields ?? this.fields,
      maxFieldLengths: maxFieldLengths ?? this.maxFieldLengths,
    );
  }
}
