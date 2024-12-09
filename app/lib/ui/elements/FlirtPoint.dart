import 'package:flutter/material.dart';

class FlirtPoint {
  Widget build(double width, double height, double radius, Color sexAltColor,
      Color relationshipColor) {
    return SizedBox(
        width: width, // Width of the circle
        height:
            height, // Height of the circle (same as width for a perfect circle)
        child: Stack(
          children: [
            Container(
              width: width / 2,
              decoration: BoxDecoration(
                color: sexAltColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                ),
              ),
            ),
            // Second half color
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: width / 2, // Half the total width
                decoration: BoxDecoration(
                  color: relationshipColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
