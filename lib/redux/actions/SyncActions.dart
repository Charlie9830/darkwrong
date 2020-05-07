class InitMockData {
  InitMockData();
}

class UpdateValue {
  final String newValue;

  UpdateValue({
    this.newValue,
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