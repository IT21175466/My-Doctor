import 'package:flutter/material.dart';
import 'package:my_doctor/constants/app_colors.dart';
import 'package:my_doctor/widgets/basic_button.dart';
import 'package:my_doctor/widgets/login_option_card.dart';
import 'package:my_doctor/widgets/text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //Text Fields Controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight - AppBar().preferredSize.height,
          width: screenWidth,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Spacer(),
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                  fontSize: 35,
                ),
              ),
              Text(
                'Enjoy with our dotor booking app!',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrayColor,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              CustomTextField(
                false,
                controller: emailController,
                labelText: "Email",
              ),
              CustomTextField(
                true,
                controller: passwordController,
                labelText: "Password",
              ),
              const SizedBox(
                height: 15,
              ),
              BasicButton(
                buttonWidth: screenWidth,
                buttonText: 'Login',
                color: AppColors.accentColor,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Container(
                    height: 1,
                    width: screenWidth / 3,
                    color: AppColors.borderGrayColor,
                  ),
                  Spacer(),
                  Text(
                    'Or',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrayColor,
                      fontSize: 15,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 1,
                    width: screenWidth / 3,
                    color: AppColors.borderGrayColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              LoginOptionCard(
                mainText: 'Login with Google',
                width: screenWidth,
                icon: 'google.png',
              ),
              LoginOptionCard(
                mainText: 'Login with Facebook',
                width: screenWidth,
                icon: 'facebook.png',
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
