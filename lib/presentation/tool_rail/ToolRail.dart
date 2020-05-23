import 'package:darkwrong/presentation/tool_rail/ToolRailBase.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailDrawer.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOption.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOptionsRail.dart';
import 'package:flutter/material.dart';

const Duration _drawerMoveDuration = const Duration(milliseconds: 150);
const double _drawerOpenWidth = 300.0;
const double _drawerClosedWith = 40.0;

class ToolRail extends StatelessWidget implements PreferredSizeWidget {
  final List<ToolRailOption> options;
  final List<Widget> children;
  final String selectedValue;
  const ToolRail(
      {Key key, @required this.options, @required this.children, this.selectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _assertOptions(options);
    _assertChildren(options, children);
    final width = selectedValue != null
        ? _drawerOpenWidth
        : _drawerClosedWith;

    return ToolRailBase(
      drawerMoveDuration: _drawerMoveDuration,
      width: width,
      child: Stack(
        children: [
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            left: selectedValue == null ? 0 : 40,
            width: width,
            duration: _drawerMoveDuration,
            child: ToolRailDrawer(
              child: _getDrawerChild(),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: ToolRailOptionsRail(options: options),
          ),
        ],
      ),
    );
  }

  void _assertOptions(List<ToolRailOption> options) {
    if (options == null) {
      throw AssertionError('ToolRail.options cannot be null');
    }

    if (options.isEmpty) {
      throw AssertionError('ToolRail.options cannot be empty');
    }
  }

  void _assertChildren(List<ToolRailOption> options, List<Widget> children) {
    if (children == null) {
      throw AssertionError('ToolRail.children must not be null');
    }
    if (options.length != children.length) {
      throw AssertionError(
          'ToolRail.children must be the same length as ToolRail.options');
    }
  }

  Widget _getDrawerChild() {
    if (selectedValue == null) {
      return null;
    }

    final widgetIndex = options.indexWhere((item) => item.value == selectedValue);
    if (widgetIndex == -1) {
      throw AssertionError(
          '''A valid index could not be found match the ToolRailOption value '$selectedValue'. 
          Check that you have not set ToolRailOption.value to a value that does not point to an option''');
    }

    return children[widgetIndex];
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromWidth(_drawerClosedWith);
}
