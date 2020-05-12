import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';

class WorksheetNavigationDrawerViewModel {
  final String fieldName;
  final Map<FieldValueKey, FieldValue> fieldValues;
  final Set<FieldValueKey> selectedFieldValues;
  final dynamic onAddFieldValueSelection;
  final dynamic onRemoveFieldValueSelection;
  final dynamic onShowAllFieldValues;


  WorksheetNavigationDrawerViewModel({
    this.fieldName,
    this.fieldValues,
    this.selectedFieldValues,
    this.onAddFieldValueSelection,
    this.onRemoveFieldValueSelection,
    this.onShowAllFieldValues,
  });
}