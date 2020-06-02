import 'package:flutter/material.dart';

class HoveringProvider extends InheritedWidget {
  final Widget child;
  final bool hovering;

  HoveringProvider({Key key, this.child, this.hovering})
      : super(key: key, child: child);

  static HoveringProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HoveringProvider>();
  }

  @override
  bool updateShouldNotify(HoveringProvider oldWidget) {
    return oldWidget.hovering != hovering;
  }
}

class Hovering extends StatefulWidget {
  final Widget child;
  Hovering({Key key, this.child}) : super(key: key);

  @override
  _HoveringState createState() => _HoveringState();
}

class _HoveringState extends State<Hovering> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: HoveringProvider(
        hovering: _hovering,
        child: widget.child,
      )
    );
  }
}
