import 'package:darkwrong/constants.dart';
import 'package:darkwrong/view_models/WorksheetNavigationDrawerViewModel.dart';
import 'package:flutter/material.dart';

class WorksheetNavigationDrawer extends StatelessWidget {
  final WorksheetNavigationDrawerViewModel viewModel;

  const WorksheetNavigationDrawer({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = viewModel.fieldValues.values.map((item) {
      final isSelected = viewModel.selectedFieldValues.contains(item.key);
      return ListTile(
          key: ValueKey(item.key),
          title: Text(item.asText),
          selected: isSelected,
          onTap: () => isSelected
              ? viewModel.onRemoveFieldValueSelection(item.key)
              : viewModel.onAddFieldValueSelection(item.key));
    }).toList()
      ..insert(
          0,
          ListTile(
            key: Key(allFieldFilterId),
            title: Text('All'),
            selected: viewModel.selectedFieldValues.isEmpty,
            onTap: () => viewModel.onShowAllFieldValues(),
          ));

    return Container(
        child: Column(
      children: [
        Text(viewModel.fieldName, style: Theme.of(context).textTheme.headline5),
        Text('Pick what you would like to see',
            style: Theme.of(context).textTheme.subtitle1),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) => options[index],
          ),
        )
      ],
    ));
  }
}
