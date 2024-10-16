import 'package:flutter/material.dart';
import 'package:my_doctor/constants/app_colors.dart';
import 'package:my_doctor/services/secure_storage.dart';
import 'package:my_doctor/views/splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                'Home Page',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await SecureStorage().deleteSessionToken();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
                    (route) => false,
                  );
                },
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.accentColor,
        ),
      ),
    );
  }
}
