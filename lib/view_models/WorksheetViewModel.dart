import 'package:darkwrong/redux/state/WorksheetState.dart';

class WorksheetViewModel {
  final WorksheetState state;
  final dynamic onCellSelect;
  final dynamic onCellDeselect;

  WorksheetViewModel({
    this.state,
    this.onCellSelect,
    this.onCellDeselect
  });
}