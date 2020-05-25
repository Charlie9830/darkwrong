import 'package:darkwrong/presentation/tool_rail/ToolOptionPressedCallbackProvider.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailBase.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailController.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOption.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOptionsRail.dart';
import 'package:flutter/material.dart';

typedef void OnToolOptionPressedCallback(String value);

class ToolRail extends StatelessWidget implements PreferredSizeWidget {
  final List<ToolRailOption> options;
  final List<Widget> children;
  final String selectedValue;
  final OnToolOptionPressedCallback onOptionPressed;

  const ToolRail(
      {Key key,
      @required this.options,
      @required this.children,
      @required this.onOptionPressed,
      this.selectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _assertOptions(options);
    _assertChildren(options, children);
    _assertController(context);

    final railController = ToolRailController.of(context);
    final open = railController.open;
    final width = open
        ? railController.drawerOpenedWidth
        : railController.drawerClosedWidth;

    return ToolRailBase(
      drawerMoveDuration: railController.drawerMoveDuration,
      width: width,
      child: Stack(
        children: [
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            left: open ? railController.drawerClosedWidth : 0,
            width: width - railController.drawerClosedWidth,
            duration: railController.drawerMoveDuration,
            child: _getDrawerChild(),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: ToolOptionPressedCallbackProvider(
              callback: onOptionPressed,
              child: ToolRailOptionsRail(options: options),
            ),
          ),
        ],
      ),
    );
  }

  void _assertController(BuildContext context) {
    if (ToolRailController.of(context) == null) {
      throw AssertionError(
          '''ToolRail could not find an instance of a ToolRailController in it's ancestors.
          Please ensure that this widget is a child of a ToolRailController''');
    }
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
      return Container();
    }

    final widgetIndex =
        options.indexWhere((item) => item.value == selectedValue);
    if (widgetIndex == -1) {
      throw AssertionError(
          '''A valid index could not be found match the ToolRailOption value '$selectedValue'. 
          If you intended to to deselect the current value set ToolRail.selectedValue to null or
          check that you have not set ToolRailOption.value to a value that does not point to an option''');
    }

    return children[widgetIndex];
  }

  @override
  Size get preferredSize => Size.fromWidth(40.0);
}
