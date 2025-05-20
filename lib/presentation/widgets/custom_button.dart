import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 210, 161),
        minimumSize: const Size(200, 45),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        )
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
            color: Color.fromARGB(255, 126, 99, 76), 
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
      ),
    );
  }
}
