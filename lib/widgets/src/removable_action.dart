import 'package:flutter/material.dart';
import 'package:removable_trash_package/widgets/removable_trash.dart';

const bool cIsDrag = false;

abstract class RemovableAction extends StatelessWidget {
  /// Constructor [RemovableAction]
  RemovableAction({
    Key? key,
    required this.index,
    required this.alignment,
    this.isDrag = cIsDrag,
  }) : super(key: key);

  /// Every widget have different index
  final int index;

  /// Position change with alignment
  /// alignment.x-alignment.y
  final Alignment alignment;

  /// if index == 0 isDrag = true.
  final bool isDrag;

  void handlerChangePosition(
      BuildContext context, detail, int index, Size size) {
    Removable.of(context)!.handlerDrag(detail, index, size);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => handlerChangePosition(context, 0, index, size),
        onPanUpdate: !isDrag
            ? null
            : (detail) => handlerChangePosition(context, detail, index, size),
        onPanDown: !isDrag
            ? null
            : (detail) => handlerChangePosition(context, detail, index, size),
        onPanEnd: !isDrag
            ? null
            : (detail) => handlerChangePosition(context, detail, index, size),
        child: buildAction(context),
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
    required this.alignment,
    required this.child,
    this.isDrag = cIsDrag,
  }) : super(
          index: index,
          alignment: alignment,
          isDrag: isDrag,
        );

  /// Every widget have different index
  final int index;

  /// Position change with alignment
  /// alignment.x-alignment.y
  final Alignment alignment;

  /// if index == 0 isDrag = true.
  final bool isDrag;

  /// Returns child widget.
  final Widget child;

  @override
  Widget buildAction(BuildContext context) => child;
}
