import 'package:flutter/material.dart';
import 'package:my_doctor/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;

  const CustomTextField(
    this.isPassword, {
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 50,
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.borderGrayColor,
              width: 0.5,
            ),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            color: AppColors.textGrayColor,
          ),
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
      ),
    );
  }
}
