import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_doctor/constants/app_colors.dart';
import 'package:my_doctor/features/authentication/bloc/auth_bloc.dart';
import 'package:my_doctor/features/userdata/ui/home_page.dart';
import 'package:my_doctor/features/authentication/ui/sign_up_page.dart';
import 'package:my_doctor/widgets/basic_button.dart';
import 'package:my_doctor/widgets/login_option_card.dart';
import 'package:my_doctor/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Text Fields Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is LoginProgressState) {
          isLoading = true;
        } else if (state is LoginSucessState) {
          isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else if (state is LoginErrorState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error.toString(),
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is LoginingWithGoogleState) {
          isLoading = true;
        } else if (state is LoginingWithGoogleSucessState) {
          isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else if (state is LoginingWithGoogleErrorState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error.toString(),
                style: const TextStyle(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const Spacer(),
                      const Text(
                        'Login',
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
                            "Don't Have an Account?",
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
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "SignUp",
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
                      const SizedBox(
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
                              const SnackBar(
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
                              LoginButtonClickedEvent(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                          }
                        },
                        child: BasicButton(
                          buttonWidth: screenWidth,
                          buttonText: 'Login',
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
                          const Spacer(),
                          const Text(
                            'Or',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrayColor,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
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
                      GestureDetector(
                        onTap: () {
                          _authBloc.add(LoginWithGoogleButtonClickedEvent());
                        },
                        child: LoginOptionCard(
                          mainText: 'Continue with Google',
                          width: screenWidth,
                          icon: 'google.png',
                        ),
                      ),
                      LoginOptionCard(
                        mainText: 'Continue with Facebook',
                        width: screenWidth,
                        icon: 'facebook.png',
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                isLoading
                    ? Container(
                        height: screenHeight,
                        width: screenWidth,
                        color: Colors.black.withOpacity(0.6),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
