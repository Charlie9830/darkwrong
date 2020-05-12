import 'package:darkwrong/constants.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';

class WorksheetState {
  final Map<String, WorksheetRowModel> rows;
  final Map<String, WorksheetHeaderModel> headers;
  final Map<String, SelectedCellModel> selectedCells;
  final Map<String, Set<FieldValueKey>> fieldValueQueries;
  final String selectedFieldFilterId;

  WorksheetState({
    this.rows,
    this.headers,
    this.selectedCells,
    this.fieldValueQueries,
    this.selectedFieldFilterId,
  });

  WorksheetState.initial() :
  rows = <String, WorksheetRowModel>{},
  headers = <String, WorksheetHeaderModel>{},
  selectedCells = <String, SelectedCellModel>{},
  fieldValueQueries = <String, Set<FieldValueKey>>{},
  selectedFieldFilterId = allFieldFilterId;

  WorksheetState copyWith({
    Map<String, WorksheetRowModel> rows,
    Map<String, WorksheetHeaderModel> headers,
    Map<String, SelectedCellModel> selectedCells,
    Map<String, Set<FieldValueKey>> fieldValueQueries,
    String selectedFieldFilterId,
  }) {
    return WorksheetState(
      rows: rows ?? this.rows,
      headers: headers ?? this.headers,
      selectedCells: selectedCells ?? this.selectedCells,
      fieldValueQueries: fieldValueQueries ?? this.fieldValueQueries,
      selectedFieldFilterId: selectedFieldFilterId ?? this.selectedFieldFilterId,
    );
  }
}