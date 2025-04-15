import 'package:flutter/material.dart';
import 'login.dart';
import 'verifikasi.dart';
import '../../costum_scaffold.dart';
import '../../widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/1.png",
      "title": "Selamat Datang!",
      "description": "Aplikasi yang membantu proses surat-menyurat lebih mudah."
    },
    {
      "image": "assets/images/2.png",
      "title": "Cepat & Mudah",
      "description": "Kelola dokumen dengan mudah dan aman di satu aplikasi."
    },
    {
      "image": "assets/images/4.png",
      "title": "Mulai Sekarang",
      "description": "Daftar dan gunakan fitur lengkap aplikasi e-Surat Badean!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          // Slider
          Expanded(
            flex: 8,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: slides.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      slides[index]["image"]!,
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      slides[index]["title"]!,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 249, 249, 249),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      slides[index]["description"]!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(221, 243, 243, 243),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),

          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Color.fromARGB(255, 84, 120, 211)
                      : const Color.fromARGB(255, 247, 247, 247),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Sign In & Sign Up
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Login',
                    onTap: const Login(),
                    color: Colors.transparent,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Register',
                    onTap: const Verifikasi(),
                    color: Colors.white,
                    textColor: Color(0xFF052158),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
