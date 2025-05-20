import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/views/auth/register.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rt_rw.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rw.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/views/auth/ResetPassword.dart';

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
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), () async {
      _checkTokenAndNavigate();
    });
  }

  Future<void> _checkTokenAndNavigate() async {
    final user = await Auth.user();
    String view;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => RegisterScreen()),
    // );
    // return;
    if (user != null && user['access_token'] != "") {
      final role = user['role'];

      var response = await API().cekuser();
      if (response.statusCode == 200) {
        // Token valid
        if (role == 'masyarakat') {
          view = "/dashboard_warga";
        } else if (role == 'rt') {
          view = "/dashboard_rt";
        } else if (role == 'rw') {
          view = "/dashboard_rw";
        } else {
          view = "/welcome";
        }
      } else {
        await DatabaseHelper().deleteUser();
        view = "/welcome";
      }
    } else {
      view = "/welcome";
    }

    context.go(view);
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
