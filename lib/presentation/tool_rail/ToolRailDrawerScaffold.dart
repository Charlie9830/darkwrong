import 'package:darkwrong/presentation/tool_rail/ToolRailController.dart';
import 'package:flutter/material.dart';

typedef void PersistButtonPressedCallback(bool currentValue);

class ToolRailDrawerScaffold extends StatelessWidget {
  final Widget child;

  const ToolRailDrawerScaffold({Key key, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final railController = ToolRailController.of(context);
    final bool persistent = railController.persistent;
    final PersistButtonPressedCallback onPersistButtonPressed =
        railController.onPersistButtonPressed;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 56.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Fixtures',
                        style: Theme.of(context).textTheme.subtitle1),
                    IconButton(
                      icon: Icon(persistent ? Icons.lock_open : Icons.lock),
                      onPressed: () => onPersistButtonPressed(persistent),
                    )
                  ],
                ),
              ),
              ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: constraints.maxHeight - 56),
                  child: child)
            ],
          ),
        );
      },
    );
  }
}
