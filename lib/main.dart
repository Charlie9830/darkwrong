import 'package:darkwrong/presentation/DarkwrongScaffold/DarkwrongScaffold.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRail.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOption.dart';
import 'package:darkwrong/redux/AppStore.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Darkwrong());
}

class Darkwrong extends StatefulWidget {
  @override
  _DarkwrongState createState() => _DarkwrongState();
}

class _DarkwrongState extends State<Darkwrong> {
  String _selectedValue;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: appStore,
        child: MaterialApp(
          title: 'Darkwrong',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: DarkwrongScaffold(
            appBar: AppBar(title: Text('Widget')),
            body: Container(
              color: Colors.lightGreen,
              child: ListView(
                children: List<Widget>.generate(101, (index) => ListTile(title: Text('Item $index'))),
              )
            ),
            persistentLeftRail: true,
            leftRail: ToolRail(
              selectedValue: _selectedValue,
              options: <ToolRailOption>[
                ToolRailOption(
                  icon: Icon(Icons.add_circle),
                  value: 'add',
                  selected: _selectedValue == 'add',
                  onSelected: (value) => setState(() => _selectedValue =
                      value == _selectedValue ? null : value),
                ),
                ToolRailOption(
                  icon: Icon(Icons.filter_list),
                  value: 'view',
                  selected: _selectedValue == 'view',
                  onSelected: (value) => setState(() => _selectedValue =
                      value == _selectedValue ? null : value),
                ),
              ],
              children: <Widget>[
                Text('Add Fixtures'),
                Text('View Fixtures'),
              ],
            ),
          ),
        ));
  }
}
