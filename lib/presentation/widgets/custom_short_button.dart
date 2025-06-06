import 'package:flutter/material.dart';

class CustomShortButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;

  const CustomShortButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: icon == "" ? const Color.fromARGB(255, 255, 210, 161) : const Color.fromARGB(255, 255, 161, 161),
        minimumSize: const Size(40, 45),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Icon(
        icon != "" ? Icons.remove : Icons.check,
        color: const Color.fromARGB(255, 126, 99, 76),
        size: 24,
      ),
    );
  }
}
