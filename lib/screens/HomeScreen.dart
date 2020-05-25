import 'package:darkwrong/constants.dart';
import 'package:darkwrong/containers/FixtureCreatorContainer.dart';
import 'package:darkwrong/containers/WorksheetContainer.dart';
import 'package:darkwrong/keys.dart';
import 'package:darkwrong/presentation/DarkwrongScaffold/DarkwrongScaffold.dart';
import 'package:darkwrong/presentation/FixtureEditTextField.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRail.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailDrawerScaffold.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOption.dart';
import 'package:darkwrong/view_models/HomeScreenViewModel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;
  const HomeScreen({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DarkwrongScaffold(
      key: homescreenScaffoldKey,
      appBar: AppBar(
        title: Text('Darkwrong'),
        actions: [
          DropdownButton<String>(
            value: viewModel.selectedFieldFilterId,
            hint: viewModel.selectedFieldFilterId == allFieldQueryId
                ? Text('View Field')
                : null,
            icon: Icon(Icons.filter_list),
            onChanged: (newValue) => viewModel.onFieldFilterSelect(newValue),
            items: viewModel.fields.values
                .map(
                  (field) => DropdownMenuItem(
                    key: Key(field.uid),
                    child: Text(field.name),
                    value: field.uid,
                  ),
                )
                .toList()
                  ..insert(
                      0,
                      DropdownMenuItem(
                        key: Key(allFieldQueryId),
                        child: Text('All'),
                        value: allFieldQueryId,
                      )),
          ),
          Expanded(
            child: FixtureEditTextField(
              enabled: viewModel.isFixtureEditEnabled,
              onSubmitted: (newValue) => viewModel.onValueUpdate(newValue),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => viewModel.onDeleteFixtures(),
          ),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: viewModel.onAddFixtureButtonPressed),
          RaisedButton(
            child: Text('Debug'),
            onPressed: viewModel.onDebugButtonPressed,
          ),
        ],
      ),
      body: WorksheetContainer(),
      leftRail: _buildLeftRail(context),
      leftDrawerOpen: viewModel.worksheetLeftRailViewModel.selectedTool != WorksheetToolOptions.noSelection,
      persistentLeftRail: viewModel.worksheetLeftRailViewModel.isPersistent,
      onLeftRailPersistButtonPressed: viewModel.worksheetLeftRailViewModel.onPersistButtonPressed,
      drawerClosedWidth: 40.0,
      drawerOpenedWidth: 300.0,

    );
  }

  PreferredSizeWidget _buildLeftRail(BuildContext context) {
    return ToolRail(
      selectedValue: viewModel.worksheetLeftRailViewModel.selectedTool ==
              WorksheetToolOptions.noSelection
          ? null
          : viewModel.worksheetLeftRailViewModel.selectedTool,
      onOptionPressed: (value) =>
          viewModel.worksheetLeftRailViewModel.onToolSelect(value),
      options: <ToolRailOption>[
        ToolRailOption(
          icon: Icon(Icons.add_circle),
          value: WorksheetToolOptions.addFixtures,
          selected: viewModel.worksheetLeftRailViewModel.selectedTool ==
              WorksheetToolOptions.addFixtures,
        )
      ],
      children: <Widget>[
        ToolRailDrawerScaffold(
          child: FixtureCreatorContainer(),
        )
      ],
    );
  }
}
