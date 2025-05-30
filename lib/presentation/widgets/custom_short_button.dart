import 'package:flutter/material.dart';

class CustomShortButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomShortButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 210, 161),
        minimumSize: const Size(40, 45),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: const Icon(
        Icons.check,
        color: Color.fromARGB(255, 126, 99, 76),
        size: 24,
      ),
    );
  }
}
