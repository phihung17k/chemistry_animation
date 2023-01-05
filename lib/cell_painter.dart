import 'package:flutter/material.dart';

import 'atomic.dart';

class CellPainter extends CustomPainter {
  final Color? color;
  final Atomic? atomic;

  CellPainter({this.color, this.atomic});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color!
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    double width = size.width;
    double height = size.height;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rectCell =
        Rect.fromCenter(center: center, width: width, height: height);
    Radius radius = Radius.circular(width / 25);
    RRect roundRectCell = RRect.fromRectAndRadius(rectCell, radius);
    canvas.drawRRect(roundRectCell, paint);

    double normalFontSize = width / 7;

    TextPainter atomicNumberPainter =
        getTextPainter(atomic!.atomicNumber.toString(), normalFontSize);
    atomicNumberPainter.layout(minWidth: 0, maxWidth: width / 2);
    double atomicNumberPadding = width / 25;
    atomicNumberPainter.paint(
        canvas, Offset(atomicNumberPadding, atomicNumberPadding));

    TextPainter symbolPainter = getTextPainter(atomic!.symbol, width / 2.7);
    symbolPainter.layout();
    // print("width: ${symbolPainter.width} height: ${symbolPainter.height}");
    // print("size.width: ${size.width} size.height: ${size.height}");
    // print(
    //     "center.width: ${width - symbolPainter.width} center.height: ${height - symbolPainter.height}");
    Offset symbolOffset = Offset(
        (width - symbolPainter.width) / 2, (height - symbolPainter.height) / 2);
    symbolPainter.paint(canvas, symbolOffset);

    TextPainter nameAtomicPainter =
        getTextPainter(atomic!.name, normalFontSize);
    nameAtomicPainter.layout();
    double bottomPadding = width / 25;

    Offset nameOffset = Offset((width - nameAtomicPainter.width) / 2,
        (height - nameAtomicPainter.height - bottomPadding));
    nameAtomicPainter.paint(canvas, nameOffset);
  }

  TextPainter getTextPainter(String? text, double? fontSize) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
