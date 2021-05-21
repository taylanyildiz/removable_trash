import 'package:flutter/material.dart';
import 'package:removable_trash_package/widgets/removable_trash.dart';

const bool cIsDrag = false;

abstract class RemovableAction extends StatelessWidget {
  /// Constructor [RemovableAction]
  RemovableAction({
    Key? key,
    required this.index,
    required this.animation,
    required this.alignment,
    required this.radius,
    this.isDrag = cIsDrag,
  }) : super(key: key);

  /// Every widget have different index
  final int index;

  /// Position change with alignment
  /// alignment.x-alignment.y
  final Alignment alignment;

  /// Removable change position animation.
  final Animation<double> animation;

  /// if index == 0 isDrag = true.
  final bool isDrag;

  /// ???
  final double radius;

  void handlerChangePosition(
      BuildContext context, detail, int index, Size size) {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onPanUpdate: !isDrag
            ? null
            : (detail) => handlerChangePosition(context, detail, index, size),
        onPanDown: !isDrag
            ? null
            : (detail) => handlerChangePosition(context, detail, index, size),
        onPanEnd: !isDrag
            ? null
            : (detail) => handlerChangePosition(context, detail, index, size),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              painter: RemovablePaint(animation: animation),
              child: child,
            );
          },
          child: buildAction(context),
        ),
      ),
    );
  }

  /// Returns child widget
  @protected
  Widget buildAction(BuildContext context);
}

class RemoveAction extends RemovableAction {
  /// Constructor [RemoveAction]
  RemoveAction({
    required this.index,
    required this.animation,
    required this.alignment,
    required this.radius,
    required this.child,
    this.isDrag = cIsDrag,
  }) : super(
          index: index,
          animation: animation,
          alignment: alignment,
          radius: radius,
          isDrag: isDrag,
        );

  /// Every widget have different index
  final int index;

  /// Position change with alignment
  /// alignment.x-alignment.y
  final Alignment alignment;

  /// Removable change position animation.
  final Animation<double> animation;

  /// if index == 0 isDrag = true.
  final bool isDrag;

  /// ???
  final double radius;

  /// Returns child widget.
  final Widget child;

  @override
  Widget buildAction(BuildContext context) => child;
}
