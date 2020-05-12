import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

class InitMockData {
  InitMockData();
}

class UpdateFixturesAndFieldValues {
  final Map<String, FixtureModel> fixtureUpdates;
  final FieldValuesStore fieldValueUpdates;
  final FieldValuesStore existingFieldValues;

  UpdateFixturesAndFieldValues({
    this.fixtureUpdates,
    this.fieldValueUpdates,
    this.existingFieldValues,
  });
}

class BuildWorksheetState {
  final WorksheetState state;

  BuildWorksheetState({
    this.state,
  });
}

class AddFields {
  final List<String> names;

  AddFields({
    this.names,
  });
}

class AddBlankFixture {
 AddBlankFixture(); 
}


class SelectWorksheetCell {
  final String cellId;
  final String rowId;
  final String columnId;

  SelectWorksheetCell({
    this.cellId,
    this.rowId,
    this.columnId,
  });
}

class DeselectWorksheetCell {
  final String cellId;
  final String rowId;
  final String columnId;

  DeselectWorksheetCell({
    this.cellId,
    this.rowId,
    this.columnId,
  });
}