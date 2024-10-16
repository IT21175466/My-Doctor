import 'package:flutter/material.dart';
import 'package:my_doctor/constants/app_colors.dart';

class LoginOptionCard extends StatelessWidget {
  final String mainText;
  final double width;
  final String icon;
  const LoginOptionCard(
      {super.key,
      required this.mainText,
      required this.width,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.borderGrayColor,
          width: 0.3,
        ),
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Spacer(),
          Image.asset(
            'assets/icons/$icon',
            height: 25,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            '$mainText',
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500,
              color: AppColors.textGrayColor,
              fontSize: 16,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
