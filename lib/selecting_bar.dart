import 'package:flutter/material.dart';

class SelectingBar extends StatelessWidget {
  final Function()? onTap;
  final double? width;
  final double? height;

  const SelectingBar({super.key, this.onTap, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 10,
        right: width! / 3,
        left: width! / 3,
        child: Container(
          color: Colors.pinkAccent,
          width: width! / 5,
          height: height! / 20,
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text("Table"),
                  ),
                ),
              ),
              const VerticalDivider(
                thickness: 2,
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text("Sphere"),
                  ),
                  onTap: () {},
                ),
              )
            ],
          ),
        ));
  }
}
