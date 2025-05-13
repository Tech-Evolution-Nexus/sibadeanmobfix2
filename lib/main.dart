import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/riwayatsurat/ForgotPasswordPage.dart';
import 'package:sibadeanmob_v2_fix/views/auth/ResetPasswordPage.dart';
import 'package:sibadeanmob_v2_fix/views/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';

void main() async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Minta izin
  await messaging.requestPermission();

  // Dapatkan token
  String? token = await messaging.getToken();
  print("FCM Token: $token");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showDialog(
        context: navigatorKey.currentContext!, // Pakai navigatorKey global
        builder: (context) => AlertDialog(
          title: Text(message.notification!.title ?? 'Notifikasi'),
          content: Text(message.notification!.body ?? 'Pesan masuk'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
          ],
        ),
      );
    }
  });

  await initializeDateFormatting('id', null);

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sibadean',
      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordPage(token: token);
        },
      ),
    ],
  );
