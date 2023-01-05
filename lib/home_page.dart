import 'dart:math';

import 'package:chemistry/data.dart';
import 'package:chemistry/selecting_bar.dart';
import 'package:flutter/material.dart';

import 'cell_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? tranformAnimation;

  double x = 0;
  double y = 0;
  double z = 0;

  var random = Random();
  List<Widget> cellWidgetList = [];
  List<CellWidget> tempCellWidgetList = [];
  final duration = const Duration(seconds: 1);
  final curve = Curves.easeInOut;

  bool isTranslateAtomicTable = false;

  // Sphere
  /// sphere equation (S): (x-a)² + (y-b)² + (z-c)² = R²
  /// With center I (a; b; c) and radius R
  double radius = 0;
  Offset centerSphere = const Offset(0, 0);

// #region Table
  void initRandomCellList() {
    int i = 0;
    tempCellWidgetList = atomicMap.values.map((atomic) {
      i++;
      return CellWidget(
        index: i,
        atomic: atomicMap[i]!,
        ratio: getRandomRatioCell(),
      );
    }).toList();
    tempCellWidgetList.sort((a, b) => b.ratio.compareTo(a.ratio));
    addAnimatedCell();
  }

  void addAnimatedCell() {
    cellWidgetList.clear();
    tempCellWidgetList.sort((a, b) => a.index!.compareTo(b.index!));

    int indexInRow = 0; //1 row, range 1 - 18
    int indexInTable = 0; //1 table, range 1 - 162 cells

    int firstIndexInRow = 0;
    for (int i = 0; i <= tempCellWidgetList.length; i++) {
      var tempPosition = i;
      int row = indexInTable ~/ 18 + 1;

      indexInRow % 18 == 0 ? indexInRow = 1 : indexInRow++;
      indexInTable++;
      var xCordinate = calculateXCordinate(indexInRow);
      var yCordinate = calculateYCordinate(row);

      switch (row) {
        case 1:
          if (indexInRow == 2) {
            indexInRow = 18; //16 empty + 1 cell Hidro
            indexInTable = indexInRow;
            xCordinate = calculateXCordinate(indexInRow);
          }
          break;
        case 2:
        case 3:
          if (indexInRow == 3) {
            indexInRow = 13;
            indexInTable = (row - 1) * 18 + indexInRow; //31
            xCordinate = calculateXCordinate(indexInRow);
          }
          break;
        case 4:
        case 5:
          break;
        case 6:
          if (indexInRow >= 4) {
            tempPosition = tempPosition + 72 - 57 - 1; //Hf - La - 1
          }
          break;
        case 7:
          if (indexInRow >= 1 && indexInRow <= 3) {
            tempPosition = 86 + indexInRow - 1; // 72
          } else {
            tempPosition = 100 + indexInRow - 1;
          }
          break;
        case 8:
          if (indexInRow == 1) {
            indexInRow = 4;
            indexInTable = (row - 1) * 18 + indexInRow; //
            xCordinate = calculateXCordinate(indexInRow);
            firstIndexInRow = 57;
          }
          if (indexInRow < 18) {
            tempPosition = firstIndexInRow++;
          } else {
            continue;
          }
          break;
        default:
          if (indexInRow == 1) {
            indexInRow = 4;
            indexInTable = (row - 1) * 18 + indexInRow; //145
            xCordinate = calculateXCordinate(indexInRow);
            firstIndexInRow = 89;
          }

          if (indexInRow < 18) {
            tempPosition = firstIndexInRow++;
          }
          break;
      }

      cellWidgetList.add(AnimatedPositioned(
          left: isTranslateAtomicTable ? xCordinate : getRandomX(),
          top: isTranslateAtomicTable ? yCordinate : getRandomY(),
          curve: curve,
          duration: duration,
          child: tempCellWidgetList[tempPosition]
            ..ratio = 0
            ..elevation = 5));
    }
  }

  double calculateXCordinate(int indexInRow) {
    double xInit = 155;
    double xAxis = 70;
    double xSpace = 5;
    var rowSpace = (indexInRow - 1) % 18;
    return xInit + xAxis * rowSpace + xSpace * rowSpace;
  }

  double calculateYCordinate(int row) {
    double yInit = 15;
    double yAxis = 80;
    double ySpace = 5;
    var columnSpace = row - 1;
    return yInit + yAxis * columnSpace + ySpace * columnSpace;
  }

  double getRandomX({double? maxWidth}) {
    return 1800 * random.nextDouble();
  }

  double getRandomY({double? maxHeight}) {
    return 800 * random.nextDouble();
  }

  double getRandomRatioCell() {
    return 1 * random.nextDouble();
  }
  // #endregion

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    tranformAnimation = CurvedAnimation(parent: controller!, curve: curve);
    initRandomCellList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    radius = size.height / 1.5;
    centerSphere = Offset(size.width / 2, size.height / 2);
    return Scaffold(
      body: GestureDetector(
        onLongPressMoveUpdate: (details) {
          setState(() {
            x = x + details.localOffsetFromOrigin.dy / 2000;
            y = y - details.localOffsetFromOrigin.dx / 2000;
          });
        },
        onDoubleTap: () {
          setState(() {
            isTranslateAtomicTable = true;
            addAnimatedCell();
          });
        },
        child: InteractiveViewer.builder(
          transformationController: TransformationController(),
          minScale: 0.2,
          maxScale: 3,
          scaleFactor: 1000,
          boundaryMargin: EdgeInsets.all(size.width * 2),
          builder: (context, viewport) {
            return Container(
              color: Colors.amber,
              width: size.width * 1,
              height: size.height,
              child: AnimatedBuilder(
                animation: tranformAnimation!,
                builder: (context, child) {
                  return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(x)
                        ..rotateY(y)
                        ..rotateZ(z),
                      alignment: Alignment.center,
                      child: Stack(children: [
                        ...cellWidgetList,
                      ]));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
