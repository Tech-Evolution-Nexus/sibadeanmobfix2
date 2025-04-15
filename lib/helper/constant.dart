import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

// Mendapatkan ukuran layar dengan lebih efisien
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

// Warna utama aplikasi
final Color primaryColor = HexColor('#023B47');
final Color secondaryColor = HexColor('#1F7879');
final Color secondaryTextColor = HexColor('#658E92');

// API Url (gunakan final agar tidak berubah)
final String apiUrl = 'http://127.0.0.1:8000/api';

// Spacer yang fleksibel
Widget spacer({double width = 0, double height = 0}) {
  return SizedBox(width: width, height: height);
}

// Spacing yang lebih deskriptif
EdgeInsets spacing({double horizontal = 0, double vertical = 0}) {
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}
