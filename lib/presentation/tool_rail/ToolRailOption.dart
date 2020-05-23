import 'package:flutter/material.dart';

typedef void ToolRailOptionSelectedCallback(String value);

class ToolRailOption extends StatelessWidget {
  final Widget icon;
  final String value;
  final String tooltip;
  final bool selected;
  final ToolRailOptionSelectedCallback onSelected;
  const ToolRailOption({
    Key key,
    @required this.icon,
    @required this.value,
    @required this.selected,
    @required this.onSelected,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: Theme.of(context).iconTheme.merge(
            IconThemeData(
              color: selected ? Theme.of(context).indicatorColor : null,
            ),
          ),
      child: IconButton(
          icon: icon, tooltip: tooltip, onPressed: () => onSelected(value)),
    );
  }
}
