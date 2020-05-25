import 'package:darkwrong/presentation/tool_rail/ToolRailDrawerScaffold.dart';

class WorksheetLeftRailViewModel {
  final String selectedTool;
  final bool isPersistent;
  final dynamic onToolSelect;
  final OnPersistButtonPressedCallback onPersistButtonPressed;

  WorksheetLeftRailViewModel({
    this.selectedTool,
    this.onToolSelect,
    this.isPersistent,
    this.onPersistButtonPressed,
  });
}