import 'package:chemistry/cell_painter.dart';
import 'package:flutter/material.dart';

import 'atomic.dart';

class CellWidget extends StatelessWidget {
  final int? index;
  final Atomic? atomic;
  final Color? color;
  final double width;
  final double height;
  double ratio;
  EdgeInsetsGeometry margin;
  double elevation;

  CellWidget(
      {super.key,
      this.index,
      this.atomic,
      this.color = Colors.cyan,
      this.width = 70,
      this.height = 80,
      this.ratio = 0,
      this.margin = const EdgeInsets.all(4),
      this.elevation = 28})
      : assert(ratio >= 0 && ratio <= 1);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: margin,
      child: CustomPaint(
        painter: CellPainter(color: color, atomic: atomic),
        child: SizedBox(
            width: width / (1 + ratio / 1.2),
            height: height / (1 + ratio / 1.2)),
      ),
    );
  }
}
