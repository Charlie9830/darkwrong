import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

class WorksheetViewModel {
  final WorksheetState state;
  final CellValueChangedCallback onCellValueChanged;
  final CellSelectionChangedCallback onCellSelectionChanged;

  WorksheetViewModel({
    this.state,
    this.onCellValueChanged,
    this.onCellSelectionChanged,
  });
}