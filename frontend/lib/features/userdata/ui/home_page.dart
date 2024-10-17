import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_doctor/constants/app_colors.dart';
import 'package:my_doctor/features/userdata/bloc/userdata_bloc.dart';
import 'package:my_doctor/services/secure_storage.dart';
import 'package:my_doctor/views/splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = '';

  bool isLoading = false;

  final UserdataBloc _userdataBloc = UserdataBloc();

  @override
  void initState() {
    super.initState();
    _userdataBloc.add(GettingUserDataRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<UserdataBloc, UserdataState>(
      bloc: _userdataBloc,
      listener: (context, state) {
        if (state is GettingLoggedUserDataState) {
          isLoading = true;
        } else if (state is GettingLoggedUserDataSucessState) {
          isLoading = false;
          //Navigate to home page
          email = state.email;
        } else if (state is GettingLoggedUserDataErrorState) {
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
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.transparent,
                  ),
                  Spacer(),
                  const Text(
                    'Home Page',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 22,
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
            body: Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login as,',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                          fontSize: 23,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrayColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Container(
                        height: screenHeight,
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            Text(
                              'Getting User Data...',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                                fontSize: 15,
                              ),
                            ),
                          ],
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
