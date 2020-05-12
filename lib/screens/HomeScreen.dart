import 'package:darkwrong/constants.dart';
import 'package:darkwrong/containers/WorksheetContainer.dart';
import 'package:darkwrong/keys.dart';
import 'package:darkwrong/presentation/FixtureEditTextField.dart';
import 'package:darkwrong/view_models/HomeScreenViewModel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;
  const HomeScreen({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homescreenScaffoldKey,
      appBar: AppBar(
        title: Text('Darkwrong'),
        actions: [
          DropdownButton<String>(
            value: viewModel.selectedFieldFilterId,
            hint: viewModel.selectedFieldFilterId == allFieldFilterId
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
                        key: Key(allFieldFilterId),
                        child: Text('All'),
                        value: allFieldFilterId,
                      )),
          ),
          Expanded(
            child: FixtureEditTextField(
              enabled: viewModel.isFixtureEditEnabled,
              onSubmitted: (newValue) => viewModel.onValueUpdate(newValue),
            ),
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: viewModel.onAddFixtureButtonPressed),
          RaisedButton(
            child: Text('Debug'),
            onPressed: viewModel.onDebugButtonPressed,
          ),
        ],
      ),
      body: WorksheetContainer(),
    );
  }
}
