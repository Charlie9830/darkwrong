import 'package:darkwrong/enums.dart';
import 'package:darkwrong/presentation/field_editor/FieldEncodingSelector.dart';
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
            onPopupMenuSelect: _handlePopupMenuItemSelect,
          );
  }

  void _handlePopupMenuItemSelect(String value) {
    switch (value) {
      case 'view-values':
        onViewValuesPressed();
        break;

      case 'edit':
        onEditPressed();
        break;

      case 'delete':
        onDeletePressed();
        break;
    }
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
  final dynamic onPopupMenuSelect;

  const _Closed(
      {Key key,
      this.fieldName,
      this.fieldEncoding,
      this.onPopupMenuSelect,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      title: Text(fieldName ?? ''),
      subtitle: Text(getHumanFriendlyValueEncoding(fieldEncoding) ?? ''),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        enabled: enabled,
        icon: Icon(Icons.more_vert),
        onSelected: onPopupMenuSelect,
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              value: 'view-values',
              child: Text('View values'),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ];
        },
      ),
    );
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
