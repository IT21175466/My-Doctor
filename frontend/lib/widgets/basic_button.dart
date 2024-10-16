import 'package:flutter/material.dart';

class BasicButton extends StatefulWidget {
  final double buttonWidth;
  final String buttonText;
  final Color color;
  const BasicButton(
      {super.key,
      required this.buttonWidth,
      required this.buttonText,
      required this.color});

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: widget.buttonWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color,
      ),
      child: Center(
        child: Text(
          widget.buttonText,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
