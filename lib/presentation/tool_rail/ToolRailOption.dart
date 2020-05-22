import 'package:darkwrong/presentation/tool_rail/ToolRailOpenToProvider.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailStateSelectedProvider.dart';
import 'package:flutter/material.dart';

typedef void ToolRailOptionSelectedCallback(String value);

class ToolRailOption extends StatelessWidget {
  final Widget icon;
  final String value;
  final String tooltip;
  final ToolRailOptionSelectedCallback onSelected;
  const ToolRailOption({
    Key key,
    @required this.icon,
    @required this.value,
    this.tooltip,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = ToolRailStateSelectedProvider.of(context).value == value;

    return Material(
      child: IconTheme(
        data: Theme.of(context).iconTheme.merge(
              IconThemeData(
                color: selected ? Theme.of(context).indicatorColor : null,
              ),
            ),
        child: IconButton(
            icon: icon,
            tooltip: tooltip,
            onPressed: () {
              ToolRailOpenToProvider.of(context).openToCallback(value);
              onSelected(value);
            }),
      ),
    );
  }
}
