import 'package:flutter/material.dart';

class DarkwrongScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final PreferredSizeWidget leftRail;
  final PreferredSizeWidget rightRail;
  final bool persistentLeftRail;
  final bool persistentRightRail;

  DarkwrongScaffold({
    Key key,
    this.appBar,
    this.body,
    this.leftRail,
    this.rightRail,
    this.persistentRightRail = false,
    this.persistentLeftRail = false,
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
              child: _canUseSimpleBody(
                widget.persistentLeftRail,
                widget.persistentRightRail,
              )
                  ? _SimpleBodyBuilder(
                      body: body,
                      leftRail: widget.leftRail,
                      rightRail: widget.rightRail,
                    )
                  : _ComplexBodyBuilder(
                      body: body,
                      leftRail: widget.leftRail,
                      rightRail: widget.rightRail,
                    ),
            )
          ],
        ));
  }

  bool _canUseSimpleBody(bool persistentLeftRail, bool persistentRightRail) {
    return persistentLeftRail || persistentRightRail;
  }
}

/// Responsible for building a complex body. This is requried if either or both of the Rails are non persistent.
class _ComplexBodyBuilder extends StatelessWidget {
  final PreferredSizeWidget leftRail;
  final PreferredSizeWidget rightRail;
  final Widget body;

  const _ComplexBodyBuilder({Key key, this.leftRail, this.rightRail, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final positionedLeftRail =
        Positioned(top: 0, left: 0, bottom: 0, child: leftRail);
    final positionedRightRail =
        Positioned(top: 0, right: 0, bottom: 0, child: rightRail);

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: leftRail?.preferredSize?.width ?? 0,
          right: rightRail?.preferredSize?.width ?? 0,
          child: body,
        ),
        if (leftRail != null) positionedLeftRail,
        if (rightRail != null) positionedRightRail,
      ],
    );
  }
}

/// Responsible for building a simple body. This is available when both Rails are set to persistent.
class _SimpleBodyBuilder extends StatelessWidget {
  final PreferredSizeWidget leftRail;
  final PreferredSizeWidget rightRail;
  final Widget body;

  const _SimpleBodyBuilder({
    Key key,
    this.leftRail,
    this.rightRail,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leftRail != null) leftRail,
        Expanded(
          child: body,
        ),
        if (rightRail != null) rightRail
      ],
    );
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
