import 'package:darkwrong/presentation/tool_rail/ToolRailOption.dart';
import 'package:flutter/material.dart';

class ToolRailOptionsRail extends StatelessWidget {
  final List<ToolRailOption> options;
  const ToolRailOptionsRail({Key key, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: options ?? <ToolRailOption>[],
      ),
    );
  }
}
