import 'package:darkwrong/presentation/field_editor/FieldEditor.dart';
import 'package:darkwrong/presentation/field_editor/ValuesEditor.dart';
import 'package:darkwrong/view_models/FieldAndValuesEditorViewModel.dart';
import 'package:flutter/material.dart';

class FieldAndValuesEditor extends StatefulWidget {
  final FieldAndValuesEditorViewModel viewModel;
  const FieldAndValuesEditor({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _FieldAndValuesEditorState createState() => _FieldAndValuesEditorState();
}

class _FieldAndValuesEditorState extends State<FieldAndValuesEditor> {
  String editingFieldId;

  @override
  void initState() {
    editingFieldId = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      initialIndex: widget.viewModel.tabIndex,
      length: 2,
      child: Column(
        children: [
          TabBar(onTap: (index) => widget.viewModel.onTabChanged(index), tabs: [
            Tab(text: 'Fields'),
            Tab(text: 'Values'),
          ]),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                FieldEditor(
                  viewModel: widget.viewModel,
                  editingFieldId: editingFieldId,
                  onFieldEditingStart: (fieldId) {
                    setState(() {
                      editingFieldId = fieldId;
                    });
                  },
                  onFieldEditingComplete: () {
                    setState(() {
                      editingFieldId = '';
                    });
                  },
                ),
                ValuesEditor(),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
