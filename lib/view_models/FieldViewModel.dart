import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/presentation/field_editor/FieldListTile.dart';

class FieldViewModel {
  final FieldModel data;
  final dynamic onDeletePressed;
  final dynamic onViewValuesPressed;
  final FieldEditingCompleteCallback onChanged;

  FieldViewModel({
    this.onDeletePressed,
    this.onViewValuesPressed,
    this.data,
    this.onChanged,
  });
}
