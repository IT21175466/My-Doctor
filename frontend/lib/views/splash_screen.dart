import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_doctor/constants/app_colors.dart';
import 'package:my_doctor/features/authentication/bloc/auth_bloc.dart';
import 'package:my_doctor/features/userdata/ui/home_page.dart';
import 'package:my_doctor/features/authentication/ui/login_screen.dart';
import 'package:my_doctor/services/secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SecureStorage secureStorage = SecureStorage();
  final AuthBloc _authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  // Check for session token on app startup
  void checkSession() async {
    String? token = await secureStorage.getSessionToken();

    if (token != null) {
      //Token exists
      //Validate session
      _authBloc.add(ValidatingSessionEvent(token: token));
    } else {
      //No token
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is ValidatingSessionSucessState) {
          if (state.isValiedSession == true) {
            Timer(const Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            });
          } else {
            Timer(const Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            });
          }
        } else if (state is ValidatingSessionErrorState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                CircularProgressIndicator(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Welcome to MyDoctor',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                    fontSize: 25,
                  ),
                ),
                Text(
                  'Enjoy with our dotor booking app!',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrayColor,
                    fontSize: 13,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
