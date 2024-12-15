import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final bool? enable; 
  final VoidCallback onTap;

  const FancyButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enable
    
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: onTap,
      child: Container(

        decoration: BoxDecoration(
          
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}