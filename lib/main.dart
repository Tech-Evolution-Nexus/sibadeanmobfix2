import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sibadeanmob_v2_fix/views/auth/aktivasi.dart';
import 'package:sibadeanmob_v2_fix/views/auth/register.dart';
import 'providers/auth_provider.dart';
import 'views/auth/aktivasi.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sibadean',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: RegisterScreen()
    );
  }
}
