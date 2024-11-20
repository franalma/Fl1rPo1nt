import 'package:flutter/material.dart';

class SlideRowLeft extends StatelessWidget {
  Widget child;
  VoidCallback onSlide; 
  SlideRowLeft({Key? key, required this.child, required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart, // Swipe from right to left
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {  
          this.onSlide();                
        },
        child: child);
  }
}
