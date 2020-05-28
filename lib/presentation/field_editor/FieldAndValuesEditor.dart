import 'package:darkwrong/presentation/field_editor/FieldEditor.dart';
import 'package:darkwrong/presentation/field_editor/ValuesEditor.dart';
import 'package:flutter/material.dart';

class FieldAndValuesEditor extends StatefulWidget {
  const FieldAndValuesEditor({Key key}) : super(key: key);

  @override
  _FieldAndValuesEditorState createState() => _FieldAndValuesEditorState();
}

class _FieldAndValuesEditorState extends State<FieldAndValuesEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(text: 'Fields'),
            Tab(text: 'Values'),
          ]),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                FieldEditor(),
                ValuesEditor(),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
