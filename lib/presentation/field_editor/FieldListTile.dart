import 'package:darkwrong/enums.dart';
import 'package:darkwrong/presentation/field_editor/FieldEncodingSelector.dart';
import 'package:darkwrong/presentation/inheritated_widgets/Hovering.dart';
import 'package:darkwrong/util/getHumanFriendlyValueEncoding.dart';
import 'package:flutter/material.dart';

typedef void FieldEditingCompleteCallback(FieldChangeRequest request);

class FieldListTile extends StatelessWidget {
  final String fieldName;
  final ValueEncoding fieldEncoding;
  final bool enabled;
  final bool open;
  final dynamic onViewValuesPressed;
  final dynamic onDeletePressed;
  final dynamic onEditPressed;
  final FieldEditingCompleteCallback onEditingComplete;

  FieldListTile({
    Key key,
    this.fieldName,
    this.enabled = true,
    this.open = false,
    this.fieldEncoding,
    this.onViewValuesPressed,
    this.onDeletePressed,
    this.onEditPressed,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return open
        ? _Open(
            fieldName: fieldName,
            fieldEncoding: fieldEncoding,
            onCleared: () => onEditingComplete(null),
            onChanged: (changeRequest) => onEditingComplete(changeRequest),
          )
        : _Closed(
            fieldName: fieldName,
            fieldEncoding: fieldEncoding,
            enabled: enabled,
            onDelete: onDeletePressed,
            onEdit: onEditPressed,
            onViewValues: onViewValuesPressed,
          );
  }
}

class _Open extends StatefulWidget {
  final String fieldName;
  final ValueEncoding fieldEncoding;
  final dynamic onCleared;
  final dynamic onChanged;

  const _Open(
      {Key key,
      this.fieldName,
      this.fieldEncoding,
      this.onCleared,
      this.onChanged})
      : super(key: key);

  @override
  _OpenState createState() => _OpenState();
}

class _OpenState extends State<_Open> {
  TextEditingController _fieldNameController;
  ValueEncoding _newEncoding;

  @override
  void initState() {
    _fieldNameController = TextEditingController(text: widget.fieldName);
    _newEncoding = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: _fieldNameController,
        decoration: InputDecoration(
          hintText: 'Field name',
        ),
      ),
      subtitle: FieldEncodingSelector(
          selectedValue: _newEncoding ?? widget.fieldEncoding,
          onChanged: (newValue) {
            setState(() {
              _newEncoding = newValue;
            });
          }),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: widget.onCleared,
          ),
          IconButton(
              icon: Icon(Icons.done),
              color: Theme.of(context).accentColor,
              onPressed: () {
                widget.onChanged(FieldChangeRequest(
                  encoding: _newEncoding,
                  fieldName: _fieldNameController.text != widget.fieldName
                      ? _fieldNameController.text
                      : null,
                ));
              })
        ],
      ),
    );
  }

  String _getEncodingName(ValueEncoding encoding) {
    switch (encoding) {
      case ValueEncoding.number:
        return 'Number';
      case ValueEncoding.text:
        return 'Text';
      default:
        return 'UNKNOWN';
    }
  }
}

class _Closed extends StatelessWidget {
  final String fieldName;
  final ValueEncoding fieldEncoding;
  final bool enabled;
  final dynamic onViewValues;
  final dynamic onEdit;
  final dynamic onDelete;

  const _Closed(
      {Key key,
      this.fieldName,
      this.fieldEncoding,
      this.onDelete,
      this.onEdit,
      this.onViewValues,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hovering(child: Builder(
      builder: (context) {
        final hovering = HoveringProvider.of(context).hovering;
        return GestureDetector(
          onDoubleTap: onEdit,
          child: ListTile(
            enabled: enabled,
            title: Text(fieldName ?? ''),
            subtitle: Text(getHumanFriendlyValueEncoding(fieldEncoding) ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hovering)
                  IconButton(
                    icon: Icon(Icons.view_list),
                    onPressed: onViewValues,
                  ),
                if (hovering)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onEdit,
                  )
              ],
            ),
          ),
        );
      },
    ));
  }
}

class FieldChangeRequest {
  final String fieldName;
  final ValueEncoding encoding;

  FieldChangeRequest({
    this.fieldName,
    this.encoding,
  });
}
