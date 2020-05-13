import 'package:darkwrong/constants.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';

class WorksheetState {
  final Map<String, WorksheetRowModel> rows;
  final Map<String, WorksheetHeaderModel> headers;
  final Map<String, SelectedCellModel> selectedCells;
  final Set<FieldValueKey> fieldValueQueries;
  final String selectedFieldQueryId;

  WorksheetState({
    this.rows,
    this.headers,
    this.selectedCells,
    this.fieldValueQueries,
    this.selectedFieldQueryId,
  });

  WorksheetState.initial() :
  rows = <String, WorksheetRowModel>{},
  headers = <String, WorksheetHeaderModel>{},
  selectedCells = <String, SelectedCellModel>{},
  fieldValueQueries = <FieldValueKey>{},
  selectedFieldQueryId = allFieldQueryId;

  WorksheetState copyWith({
    Map<String, WorksheetRowModel> rows,
    Map<String, WorksheetHeaderModel> headers,
    Map<String, SelectedCellModel> selectedCells,
    Set<FieldValueKey> fieldValueQueries,
    String selectedFieldQueryId,
  }) {
    return WorksheetState(
      rows: rows ?? this.rows,
      headers: headers ?? this.headers,
      selectedCells: selectedCells ?? this.selectedCells,
      fieldValueQueries: fieldValueQueries ?? this.fieldValueQueries,
      selectedFieldQueryId: selectedFieldQueryId ?? this.selectedFieldQueryId,
    );
  }
}