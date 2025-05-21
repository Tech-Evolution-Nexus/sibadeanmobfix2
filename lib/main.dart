import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sibadeanmob_v2_fix/helper/GoRouteHelper.dart';
import 'package:sibadeanmob_v2_fix/models/Pengaturan.dart';
import 'package:sibadeanmob_v2_fix/theme/theme.dart';
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
  // print("Token: $token");
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
  final pengaturan = await Pengaturan.getPengaturan();

  final primaryColor = hexToColor(pengaturan.primaryColor);
  final secondaryColor = hexToColor(pengaturan.secondaryColor);

  final theme = buildTheme(primaryColor, secondaryColor);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(theme: theme),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: GoRouteHelper.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
