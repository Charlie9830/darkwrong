import 'package:darkwrong/containers/HomeScreenContainer.dart';
import 'package:darkwrong/presentation/layout_editor/DragBox.dart';
import 'package:darkwrong/presentation/layout_editor/ResizeHandle.dart';
import 'package:darkwrong/presentation/layout_editor/LayoutCanvas.dart';
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
  double xPos = 100;
  double yPos = 100;
  double width = 100;
  double height = 100;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp(
        title: 'Darkwrong',
        theme: ThemeData(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.compact,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('Layout Editor')),
          body: Row(
            children: [
              Container(
                width: 100.0,
                color: Colors.blue,
              ),
              Expanded(
                child: LayoutCanvas(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
