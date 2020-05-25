import 'package:flutter/material.dart';

typedef void OnPersistButtonPressedCallback(bool currentValue);

class ToolRailDrawerScaffold extends StatelessWidget {
  final bool isPersistent;
  final OnPersistButtonPressedCallback onPersistButtonPressed;
  final Widget child;

  const ToolRailDrawerScaffold(
      {Key key,
      @required this.isPersistent,
      this.onPersistButtonPressed,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    Text('Add Fixtures', style: Theme.of(context).textTheme.subtitle1),
                    IconButton(
                      icon: Icon(isPersistent ? Icons.lock_open : Icons.lock),
                      onPressed: () => onPersistButtonPressed(isPersistent),
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
