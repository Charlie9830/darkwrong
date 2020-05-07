import 'package:darkwrong/models/WorksheetModel.dart';

class WorksheetViewModel {
  final WorksheetModel data;
  final dynamic onCellSelect;
  final dynamic onCellDeselect;

  WorksheetViewModel({
    this.data,
    this.onCellSelect,
    this.onCellDeselect
  });
}