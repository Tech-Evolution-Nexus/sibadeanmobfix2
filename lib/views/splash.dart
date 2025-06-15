import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/Pengaturan.dart';

import '../widgets/custom_icon_button.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Pengaturan? pengaturan;

  @override
  void initState() {
    super.initState();
    fetchPengaturan();

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? seen = prefs.getBool('seenOnboarding') ?? false;
      if (seen) {
        view = "/login";
      } else {
        view = "/welcome";
      }
    }
    print(view);
    context.go(view);
  }

  Future<void> fetchPengaturan() async {
    var res = await Pengaturan.getPengaturan();
    setState(() {
      pengaturan = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
              pengaturan?.appName ?? "",
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
