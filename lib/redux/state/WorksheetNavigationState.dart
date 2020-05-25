import 'package:darkwrong/constants.dart';

class WorksheetNavigationState {
  final String selectedLeftRailTool;
  final bool isLeftRailPersistent;

  WorksheetNavigationState({
    this.selectedLeftRailTool,
    this.isLeftRailPersistent,
  });

  WorksheetNavigationState.initial() : selectedLeftRailTool = WorksheetToolOptions.noSelection, isLeftRailPersistent = false;

  WorksheetNavigationState copyWith({
    String selectedLeftRailTool,
    bool isLeftRailPersistent,
  }) {
    return WorksheetNavigationState(
      selectedLeftRailTool: selectedLeftRailTool ?? this.selectedLeftRailTool,
      isLeftRailPersistent: isLeftRailPersistent ?? this.isLeftRailPersistent,
    );
  }
}
