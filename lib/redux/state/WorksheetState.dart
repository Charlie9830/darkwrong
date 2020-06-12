import 'package:darkwrong/constants.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';

class WorksheetState {
  final Map<String, WorksheetRowModel> rows;
  final Map<String, WorksheetHeaderModel> headers;
  final Set<CellId> selectedCellIds;
  final Set<FieldValueKey> fieldValueQueries;
  final String selectedFieldQueryId;
  final List<FieldModel> displayedFields;

  WorksheetState({
    this.rows,
    this.headers,
    this.selectedCellIds,
    this.fieldValueQueries,
    this.selectedFieldQueryId,
    this.displayedFields,
  });

  WorksheetState.initial()
      : rows = <String, WorksheetRowModel>{},
        headers = <String, WorksheetHeaderModel>{},
        selectedCellIds = <CellId>{},
        fieldValueQueries = <FieldValueKey>{},
        selectedFieldQueryId = allFieldQueryId,
        displayedFields = <FieldModel>[];

  WorksheetState copyWith({
    Map<String, WorksheetRowModel> rows,
    Map<String, WorksheetHeaderModel> headers,
    Set<CellId> selectedCellIds,
    Set<FieldValueKey> fieldValueQueries,
    String selectedFieldQueryId,
    List<FieldModel> displayedFields,
  }) {
    return WorksheetState(
      rows: rows ?? this.rows,
      headers: headers ?? this.headers,
      selectedCellIds: selectedCellIds ?? this.selectedCellIds,
      fieldValueQueries: fieldValueQueries ?? this.fieldValueQueries,
      selectedFieldQueryId: selectedFieldQueryId ?? this.selectedFieldQueryId,
      displayedFields: displayedFields ?? this.displayedFields,
    );
  }
}
