import 'package:darkwrong/presentation/tool_rail/ToolRailBase.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailDrawer.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOpenToProvider.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOption.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailOptionsRail.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailStateSelectedProvider.dart';
import 'package:flutter/material.dart';

const Duration _drawerMoveDuration = const Duration(milliseconds: 150);
const double _drawerOpenWidth = 300.0;
const double _drawerClosedWith = 40.0;

class ToolRail extends StatefulWidget {
  final GlobalKey<ToolRailState> key;
  final List<ToolRailOption> options;
  final List<Widget> children;
  const ToolRail({this.key, this.options, this.children}) : super(key: key);

  @override
  ToolRailState createState() => ToolRailState();
}

class ToolRailState extends State<ToolRail> {
  String _selectedValue;
  bool _open;

  @override
  void initState() {
    _selectedValue = null;
    _open = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = _open ? _drawerOpenWidth : _drawerClosedWith;
    return ToolRailStateSelectedProvider(
      value: _selectedValue,
      child: ToolRailOpenToProvider(
        openToCallback: openTo,
        child: ToolRailBase(
          drawerMoveDuration: _drawerMoveDuration,
          width: width,
          child: Stack(
            children: [
              AnimatedPositioned(
                top: 0,
                bottom: 0,
                left: 0,
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
                child: ToolRailOptionsRail(options: widget.options),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getDrawerChild() {
    return Container(
      color: Colors.yellowAccent,
    );
  }

  void openTo(String value) {
    if (_selectedValue == value) {
      // Close.
      setState(() {
        _selectedValue = null;
        _open = false;
      });
    } else {
      setState(() {
        _selectedValue = value;
        _open = true;
      });
    }
  }
}
