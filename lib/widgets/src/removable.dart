import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:removable_trash_package/widgets/removable_trash.dart';

typedef RemovableActionBuilder = Widget Function(
    BuildContext context, int index);

/// A delegate that supplies remove actions.
///
abstract class RemovableActionDelegate {
  /// Constructor [RemovableActionDelegate]
  const RemovableActionDelegate();

  /// Returns child widget.
  Widget build(BuildContext context, int index);

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
  Widget build(BuildContext context, int index) => builder(context, index);
}

class RemoveActionListDelegate extends RemovableActionDelegate {
  RemoveActionListDelegate({
    required this.actions,
  });

  final List<Widget>? actions;

  @override
  int get actionCount => actions!.length;

  @override
  Widget build(BuildContext context, int index) => actions![index];
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

// class RemovableData extends InheritedWidget {
//   RemovableData({
//     Key? key,
//     required this.removable,
//     required this.actionDelegate,
//     required this.overallAnimation,
//     required Widget child,
//   }) : super(key: key, child: child);

//   final RemovableActionDelegate? actionDelegate;

//   final Animation<double> overallAnimation;

//   final Removable removable;

//   int get actionCount => actionDelegate?.actionCount ?? 0;

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return (oldWidget is RemovableData) &&
//         oldWidget.actionDelegate != actionDelegate &&
//         oldWidget.overallAnimation != overallAnimation &&
//         oldWidget.removable != removable;
//   }

//   List<Widget> buildAction(BuildContext context) {
//     return List.generate(
//       actionDelegate!.actionCount,
//       (int index) => actionDelegate!.build(
//         context,
//         index,
//         overallAnimation,
//       ),
//     );
//   }

//   static RemovableData? of(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType<RemovableData>();
// }

class Removable extends StatefulWidget {
  /// Constructor [Removable]
  Removable({
    Key? key,
    required this.actionDelegate,
    required this.dismissed,
    this.actionAlignment,
    this.backgroundColor,
    this.height,
    this.width,
  }) : super(key: key);

  /// Action widgets retruns
  ///
  /// [Widget] [function] ([BuildContext]context,[int]index,[Animation<double>]animation)
  final RemovableActionDelegate? actionDelegate;

  /// Removable background color
  final Color? backgroundColor;

  /// Actions widget alignment default value [Alignment.center]
  final Alignment? actionAlignment;

  /// Removable height. default value 200.0
  final double? height;

  /// Removable width. default value 200.0
  final double? width;

  /// which widget is dismissed returns widget index.
  final Function(int) dismissed;

  static RemovableState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RemovableScope>()!.state;

  @override
  RemovableState createState() => RemovableState();
}

class RemovableState extends State<Removable> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(vsync: this);
    _removeController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(microseconds: 1),
    );

    _trashController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _trashAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _trashController,
        curve: Curves.elasticInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _removeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_removeController);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_scaleController);
    _scaleAnimation.addListener(_scaleAnimationListener);
    _removeAnimation.addListener(_removeAnimationListener);
    _dragController.addListener(_dragAnimationListener);

    _alignment = _actionAlignment;
  }

  @override
  void dispose() {
    super.dispose();
    _dragController.dispose();
    _removeController.dispose();
    _scaleController.dispose();
    _trashController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actionAlignment != widget.actionAlignment) {
      _alignment = _actionAlignment;
    }
  }

  late AnimationController _trashController;

  late AnimationController _removeController;

  late AnimationController _dragController;

  late AnimationController _scaleController;

  late Animation<Alignment> _dragAnimation;

  late Animation<double> _removeAnimation;

  late Animation<double> _scaleAnimation;

  late Animation<double> _trashAnimation;

  late Alignment _alignment;

  int _index = 0;

  double _scale = 1.0;

  double _radius = 20.0;

  RemovableActionDelegate get _actionDelegete => widget.actionDelegate!;

  int get _actionCount => widget.actionDelegate?.actionCount ?? 0;

  Alignment get _actionAlignment => widget.actionAlignment ?? Alignment.center;

  double get _width => widget.width ?? 200.0;

  double get _height => widget.height ?? 200.0;

  Color get _backgroundColor => widget.backgroundColor ?? Colors.transparent;

  List<Widget> get _actions => List.generate(
        _actionCount - _index,
        (int index) {
          final dx = (_actionCount - _index - index).toDouble() * 10;
          final dy = -dx;
          final _isDrag = _actionCount - 1 == index + _index;
          return AnimatedBuilder(
            animation: _scaleController,
            builder: (context, child) => Transform(
              alignment: Alignment(.8, .8),
              transform: Matrix4.identity()
                ..translate(dx, dy)
                ..scale(_isDrag ? _scaleAnimation.value : 1.0),
              child: child,
            ),
            child: RemoveAction(
              isDrag: _actionCount - 1 - _index == index ? true : false,
              index: index,
              alignment: _actionCount - 1 - _index == index
                  ? _alignment
                  : _actionAlignment,
              child: _actionDelegete.build(context, index),
            ),
          );
        },
      );

  void handlerDrag(detail, int index, Size size) {
    switch (detail.runtimeType) {
      case DragUpdateDetails:
        _changePosition(detail, size);
        break;
      case DragDownDetails:
        _stopAnimation(index);
        break;
      case DragEndDetails:
        _desicitionAnimationCheck(detail, size, index);
        break;
      default:
        _upAction(index);
        break;
    }
  }

  void _upAction(int index) {
    /// up widget
  }

  void _changePosition(DragUpdateDetails detail, Size size) {
    setState(() {
      _alignment += Alignment(
        detail.delta.dx / _width * 4,
        detail.delta.dy / _height * 4,
      );
    });
    if (_alignment.x >= 0.7 &&
        _alignment.y >= 0.7 &&
        _alignment.x <= 2.0 &&
        _alignment.y <= 2.0) {
      if (_radius <= 20.0) {
        _radius += (_alignment.x + _alignment.y) * 4;
      }
    } else {
      _radius = 20.0;
    }
  }

  void _scaleAnimationListener() {}

  void _stopAnimation(int index) {
    _dragController.stop();
  }

  void _removeAnimationListener() {
    _alignment = _actionAlignment;
    if (_actionCount > _index) _index++;
    _removeController.stop();

    setState(() {});
  }

  void _dragAnimationListener() {
    _alignment = _dragAnimation.value;
    _radius = 20.0;
    setState(() {});
  }

  void _desicitionAnimationCheck(
      DragEndDetails details, Size size, int index) async {
    if (_alignment.x >= 0.7 &&
        _alignment.y >= 0.7 &&
        _alignment.x <= 2.0 &&
        _alignment.y <= 2.0) {
      _scaleController.forward().whenComplete(() async {
        _removeController.forward();
        _trashController.forward().whenComplete(() => _trashController.reset());
        _radius += (_alignment.x + _alignment.y) * 4;
        await _scaleController.reverse();
        _radius = 20.0;
      });
      widget.dismissed.call(_actionCount - 1 - _index);
    }
    if (_scaleController.isDismissed || !_scaleController.isAnimating) {
      _returnOldPosition(details, size);
    }
  }

  void _returnOldPosition(DragEndDetails details, Size size) {
    _dragAnimation = _dragController.drive(
      AlignmentTween(
        begin: _alignment,
        end: _actionAlignment,
      ),
    );
    final pixelPerSecond = details.velocity.pixelsPerSecond;
    final unitsPerSecondX = pixelPerSecond.dx / size.width;

    final unitsPerSecondY = pixelPerSecond.dy / size.height;

    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);

    final unitVelocity = unitsPerSecond.distance;
    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );
    final simulation = SpringSimulation(
      spring,
      0,
      1,
      unitVelocity,
    );
    _dragController.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      width: _width,
      height: _height,
      child: Stack(
        children: [
          _RemovableScope(
            state: this,
            child: Stack(
              children: _actions,
            ),
          ),
          TrashAction(
            animValue: _trashAnimation.value,
            radius: _radius,
            iconData: _index == _actionCount ? Icons.check : null,
            color: _index == _actionCount ? Colors.green : null,
          ),
        ],
      ),
    );
  }
}
