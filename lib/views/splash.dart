import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rt.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rw.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_warga.dart';

import '../widgets/costum_color.dart';
import '../widgets/custom_icon_button.dart';
import 'auth/welcome.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () async {
      final userList = await DatabaseHelper().getUser();
      Widget view;

      if (userList.isNotEmpty) {
        final user = userList.first;

        if (user.role == "masyarakat") {
          view = DashboardPage();
        } else if (user.role == "rt") {
          view = DashboardRT();
        } else if (user.role == "rw") {
          view = DashboardRW();
        } else {
          view = WelcomeScreen();
        }
      } else {
        view = WelcomeScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => view),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              CustomIconButton.logoPath,
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'E-Surat Badean',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
