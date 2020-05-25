import 'package:darkwrong/presentation/tool_rail/ToolOptionPressedCallbackProvider.dart';
import 'package:flutter/material.dart';

class ToolRailOption extends StatelessWidget {
  final Widget icon;
  final String value;
  final String tooltip;
  final bool selected;
  const ToolRailOption({
    Key key,
    @required this.icon,
    @required this.value,
    @required this.selected,
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
          icon: icon,
          tooltip: tooltip,
          onPressed: () => _handleOnPressed(value, context)),
    );
  }

  void _handleOnPressed(String value, BuildContext context) {
    final callbackProvider = ToolOptionPressedCallbackProvider.of(context);
    if (callbackProvider == null) {
      throw AssertionError(
          'Cannot find a ToolOptionPressedCallbackProvider ancestor. Ensure that ToolRailOption is wrapped in a ToolOptionPressedCallbackProvider');
    }

    callbackProvider.callback?.call(value);
  }
}
