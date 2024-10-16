import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_doctor/constants/app_colors.dart';
import 'package:my_doctor/features/authentication/bloc/auth_bloc.dart';
import 'package:my_doctor/features/authentication/ui/home_page.dart';
import 'package:my_doctor/features/authentication/ui/login_screen.dart';
import 'package:my_doctor/widgets/basic_button.dart';
import 'package:my_doctor/widgets/login_option_card.dart';
import 'package:my_doctor/widgets/text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Text Fields Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is SignUpProgressState) {
          isLoading = true;
        } else if (state is SignUpSucessState) {
          isLoading = false;
          //Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else if (state is SignUpErrorState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error.toString(),
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  height: screenHeight - AppBar().preferredSize.height,
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Spacer(),
                      Text(
                        'SignUp',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                          fontSize: 35,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Already Have an Account?",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrayColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
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
                      GestureDetector(
                        onTap: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter required details!',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else {
                            _authBloc.add(
                              SignUpButtonClickedEvent(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                          }
                        },
                        child: BasicButton(
                          buttonWidth: screenWidth,
                          buttonText: 'SignUp',
                          color: AppColors.accentColor,
                        ),
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
                        mainText: 'SignUp with Google',
                        width: screenWidth,
                        icon: 'google.png',
                      ),
                      LoginOptionCard(
                        mainText: 'SignUp with Facebook',
                        width: screenWidth,
                        icon: 'facebook.png',
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                isLoading
                    ? Container(
                        height: screenHeight,
                        width: screenWidth,
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
