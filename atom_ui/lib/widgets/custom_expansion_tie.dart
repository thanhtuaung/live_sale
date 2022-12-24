import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KExpansionTie extends StatefulWidget {
  final String title;
  final List<Widget>? children;
  final Widget? trailing;
  Color? expandedTitleColor;
  Color? collapseTitleColor;

  KExpansionTie({
    Key? key,
    required this.title,
    this.children,
    this.collapseTitleColor,
    this.expandedTitleColor = Colors.teal,
    this.trailing,
  }) : super(key: key);

  @override
  State<KExpansionTie> createState() => _KExpansionTieState();
}

class _KExpansionTieState extends State<KExpansionTie>
    with SingleTickerProviderStateMixin {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    Widget? childrenWidget = null;
    if (widget.children != null) {
      childrenWidget = Column(
        children: widget.children!,
      );
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
            leading: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => RotationTransition(
                      turns: child.key == ValueKey('icon1')
                          ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                          : Tween<double>(begin: 0.75, end: 1).animate(anim),
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                child: !_isCollapsed
                    ? Icon(Icons.arrow_drop_up_outlined,
                        key: const ValueKey('icon1'))
                    : Icon(
                        Icons.arrow_drop_down_outlined,
                        key: const ValueKey('icon2'),
                      )),
            title: Text(widget.title,
                style: TextStyle(
                    color: !_isCollapsed
                        ? widget.expandedTitleColor
                        : widget.collapseTitleColor)),
            trailing: widget.trailing,
          ),
          if (!_isCollapsed) Divider(),
          AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Container(
                child: childrenWidget,
                height: _isCollapsed ? 0 : null,
              )),
        ],
      ),
    );
  }
}
