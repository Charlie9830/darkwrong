import 'package:darkwrong/presentation/tool_rail/ToolRailController.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailDrawerScaffold.dart';
import 'package:flutter/material.dart';

const _drawerMoveDuration = const Duration(milliseconds: 150);

class DarkwrongScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final PreferredSizeWidget leftRail;
  final PreferredSizeWidget rightRail;
  final bool persistentLeftRail;
  final bool persistentRightRail;
  final bool leftDrawerOpen;
  final bool rightDrawerOpen;
  final double drawerOpenedWidth;
  final double drawerClosedWidth;
  final PersistButtonPressedCallback onLeftRailPersistButtonPressed;
  final PersistButtonPressedCallback onRightRailPersistButtonPressed;

  DarkwrongScaffold({
    Key key,
    this.appBar,
    this.body,
    this.leftRail,
    this.rightRail,
    this.persistentRightRail = false,
    this.persistentLeftRail = false,
    this.leftDrawerOpen = false,
    this.rightDrawerOpen = false,
    this.drawerOpenedWidth = 300.0,
    this.drawerClosedWidth = 40.0,
    this.onLeftRailPersistButtonPressed,
    this.onRightRailPersistButtonPressed,
  }) : super(key: key);

  @override
  DarkwrongScaffoldState createState() => DarkwrongScaffoldState();
}

class DarkwrongScaffoldState extends State<DarkwrongScaffold> {
  @override
  Widget build(BuildContext context) {
    final body = _BodyConstrainer(
        appBar: widget.appBar,
        leftRail: widget.leftRail,
        rightRail: widget.rightRail,
        child: widget.body);

    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.appBar != null) widget.appBar,
            Expanded(
                child: _BodyBuilder(
              leftRail: widget.leftRail,
              persistentLeftRail: widget.persistentLeftRail,
              leftDrawerOpen: widget.leftDrawerOpen,
              rightRail: widget.rightRail,
              persistentRightRail: widget.persistentRightRail,
              rightDrawerOpen: widget.rightDrawerOpen,
              drawerClosedWidth: widget.drawerClosedWidth,
              drawerOpenedWidth: widget.drawerOpenedWidth,
              onLeftRailPersistButtonPressed: widget.onLeftRailPersistButtonPressed,
              onRightRailPersistButtonPressed: widget.onRightRailPersistButtonPressed,
              body: body,
            ))
          ],
        ));
  }
}

/// Responsible for building a complex body. This is requried if either or both of the Rails are non persistent.
class _BodyBuilder extends StatelessWidget {
  final PreferredSizeWidget leftRail;
  final PreferredSizeWidget rightRail;
  final bool persistentLeftRail;
  final bool persistentRightRail;
  final bool leftDrawerOpen;
  final bool rightDrawerOpen;
  final double drawerOpenedWidth;
  final double drawerClosedWidth;
  final PersistButtonPressedCallback onLeftRailPersistButtonPressed;
  final PersistButtonPressedCallback onRightRailPersistButtonPressed;
  final Widget body;

  const _BodyBuilder({
    Key key,
    this.leftRail,
    this.rightRail,
    this.body,
    this.persistentLeftRail,
    this.persistentRightRail,
    this.drawerOpenedWidth,
    this.drawerClosedWidth,
    this.leftDrawerOpen,
    this.rightDrawerOpen,
    this.onLeftRailPersistButtonPressed,
    this.onRightRailPersistButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final positionedLeftRail = Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      child: ToolRailController(
          persistent: persistentLeftRail,
          open: leftDrawerOpen,
          drawerClosedWidth: drawerClosedWidth,
          drawerOpenedWidth: drawerOpenedWidth,
          drawerMoveDuration: _drawerMoveDuration,
          onPersistButtonPressed: onLeftRailPersistButtonPressed,
          child: leftRail),
    );

    final positionedRightRail = Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      child: ToolRailController(
          persistent: persistentRightRail,
          open: rightDrawerOpen,
          drawerClosedWidth: drawerClosedWidth,
          drawerOpenedWidth: drawerOpenedWidth,
          drawerMoveDuration: _drawerMoveDuration,
          onPersistButtonPressed: onRightRailPersistButtonPressed,
          child: rightRail),
    );

    final bodyLeftOffset = _getBodyOffset(leftRail, persistentLeftRail,
        leftDrawerOpen, drawerOpenedWidth, drawerClosedWidth);
    final bodyRightOffset = _getBodyOffset(rightRail, persistentRightRail,
        rightDrawerOpen, drawerOpenedWidth, drawerClosedWidth);

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: bodyLeftOffset,
          right: bodyRightOffset,
          child: body,
        ),
        if (leftRail != null) positionedLeftRail,
        if (rightRail != null) positionedRightRail,
      ],
    );
  }

  double _getBodyOffset(Widget rail, bool persistent, bool open,
      double openedWidth, double closedWidth) {
    if (rail == null) {
      return 0;
    }

    if (persistent) {
      return open ? openedWidth : closedWidth;
    }

    return closedWidth;
  }
}

/// Responsible for laying a constrained body based on the constraints imposed by the appBar, leftRail and rightRail.
class _BodyConstrainer extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget appBar;
  final PreferredSizeWidget leftRail;
  final PreferredSizeWidget rightRail;

  const _BodyConstrainer({
    Key key,
    @required this.child,
    @required this.appBar,
    @required this.leftRail,
    @required this.rightRail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double heightOffset =
        appBar != null ? appBar.preferredSize.height : 0.0;
    final double leftOffset =
        leftRail != null ? leftRail.preferredSize.width : 0.0;
    final double rightOffset =
        rightRail != null ? rightRail.preferredSize.width : 0.0;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - heightOffset,
        maxWidth: MediaQuery.of(context).size.width - leftOffset - rightOffset,
      ),
      child: child,
    );
  }
}
