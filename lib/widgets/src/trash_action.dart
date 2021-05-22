import 'dart:math';
import 'package:flutter/material.dart';
import 'package:removable_trash_package/config/custom_icon.dart';

class TrashAction extends StatelessWidget {
  /// Constructor [TrashAction]
  const TrashAction({
    Key? key,
    this.color,
    this.radius,
    this.iconData,
    this.foregroundColor,
    this.animValue,
  }) : super(key: key);

  /// Trash background color default
  /// Colors.green.
  final Color? color;

  /// Size value radius default 10.0
  final double? radius;

  /// Trash iconData.
  final IconData? iconData;

  final double? animValue;

  /// Trash foreground color
  /// default value is Colors.white
  final Color? foregroundColor;

  double get _padding => radius ?? 5.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.0 + 40 * sin(animValue!),
      right: 10.0,
      child: AnimatedContainer(
        padding: EdgeInsets.all(_padding),
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: color ?? Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData ?? CustomIcon.ic_trash,
          color: foregroundColor ?? Colors.white,
          size: _padding == 20.0 ? 20.0 : null,
        ),
      ),
    );
  }
}
