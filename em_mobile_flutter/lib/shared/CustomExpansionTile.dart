//Copied these lines of code from Flutter package "configurable_expansion_tile"
//Removed some of the variables and their usage from the code.
//Making changes for expansion control (Programmatically)

import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key key,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    @required this.header,
    this.kExpand = const Duration(milliseconds: 200),
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final ValueChanged<bool> onExpansionChanged;

  final List<Widget> children;

  final bool initiallyExpanded;

  final Widget header;

  final Duration kExpand;

  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.kExpand, vsync: this);
    _heightFactor = _controller.drive(CustomExpansionTile._easeInTween);
    _isExpanded = PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void collapseTile() {
    setState(() {
      _isExpanded = false;
      _controller.reverse().then<void>((void value) {
        if (!mounted) return;
        setState(() {
          // Rebuild without widget.children.
        });
      });
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: _handleTap,
            child: widget.header,
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed
          ? Container()
          : Container(
              color: Colors.transparent,
              child: Column(children: widget.children),
            ),
    );
  }
}
