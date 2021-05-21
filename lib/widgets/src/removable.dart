import 'package:flutter/material.dart';

typedef RemovableActionBuilder = Widget Function(
    BuildContext context, int index, Animation<double> animation);

/// A delegate that supplies remove actions.
///
abstract class RemovableActionDelegate {
  /// Constructor [RemovableActionDelegate]
  const RemovableActionDelegate();

  /// Returns child widget.
  Widget build(BuildContext context, int index, Animation<double> animation);

  /// Action count returns.
  int get actionCount;
}

/// A delegate that supplies remove actions using a builder callback.
///
class RemovableActionBuilderDelegate extends RemovableActionDelegate {
  const RemovableActionBuilderDelegate({
    required this.actionCount,
    required this.builder,
  }) : assert(actionCount >= 0);

  /// Called to build remove actions.
  ///
  /// Will be called only for indices greater than or equal to zero and less
  /// than [childCount].
  final RemovableActionBuilder builder;

  /// The total number of slide actions this delegate can provide.
  @override
  final int actionCount;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
      builder(context, index, animation);
}

class RemoveActionListDelegate extends RemovableActionDelegate {
  RemoveActionListDelegate({
    required this.actions,
  });

  final List<Widget>? actions;

  @override
  int get actionCount => actions!.length;

  @override
  Widget build(BuildContext context, int index, Animation<double> animation) =>
      actions![index];
}

class _RemovableScope extends InheritedWidget {
  _RemovableScope({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final RemovableState state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      (oldWidget as _RemovableScope).state != state;
}

class RemovableData extends InheritedWidget {
  RemovableData({
    Key? key,
    required this.removable,
    required this.actionDelegate,
    required this.overallAnimation,
    required Widget child,
  }) : super(key: key, child: child);

  final RemovableActionDelegate? actionDelegate;

  final Animation<double> overallAnimation;

  final Removable removable;

  int get actionCount => actionDelegate?.actionCount ?? 0;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return (oldWidget is RemovableData) &&
        oldWidget.actionDelegate != actionDelegate &&
        oldWidget.overallAnimation != overallAnimation &&
        oldWidget.removable != removable;
  }

  static RemovableData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RemovableData>();

  List<Widget> buildAction(BuildContext context) {
    return List.generate(
      actionCount,
      (int index) => actionDelegate!.build(
        context,
        index,
        overallAnimation,
      ),
    );
  }
}

class Removable extends StatefulWidget {
  Removable({
    Key? key,
    required List<Widget> pages,
    required this.actionDelegate,
  }) : super(key: key);

  final RemovableActionDelegate? actionDelegate;

  static RemovableState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RemovableScope>()!.state;
  @override
  RemovableState createState() => RemovableState();
}

class RemovableState extends State<Removable> {
  @override
  Widget build(BuildContext context) {
    print(widget.actionDelegate!.actionCount);
    return Stack(
      children: [],
    );
  }
}
