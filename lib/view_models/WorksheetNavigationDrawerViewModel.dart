import 'package:darkwrong/models/field_values/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';

class WorksheetNavigationDrawerViewModel {
  final String fieldName;
  final Map<FieldValueKey, FieldValue> fieldValues;
  final Set<FieldValueKey> activeFieldValueQueries;
  final dynamic onAddFieldValueSelection;
  final dynamic onRemoveFieldValueSelection;
  final dynamic onShowAllFieldValues;


  WorksheetNavigationDrawerViewModel({
    this.fieldName,
    this.fieldValues,
    this.activeFieldValueQueries,
    this.onAddFieldValueSelection,
    this.onRemoveFieldValueSelection,
    this.onShowAllFieldValues,
  });
}