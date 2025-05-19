import 'package:go_router/go_router.dart';
import 'package:sibadeanmob_v2_fix/views/auth/ResetPassword.dart';
import 'package:sibadeanmob_v2_fix/views/auth/login.dart';
import 'package:sibadeanmob_v2_fix/views/auth/welcome.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rt_rw.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rw.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/views/splash.dart';

class GoRouteHelper {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Splash(), // Halaman utama
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => WelcomeScreen(), // Halaman utama
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(), // Halaman utama
      ),
      GoRoute(
        path: '/reset-password/:token',
        builder: (context, state) {
          final token = state.pathParameters['token']!;
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPassword(token: token, email: email);
        },
      ),
      GoRoute(
        path: '/dashboard_warga',
        builder: (context, state) => const DashboardPage(), // Halaman utama
      ),
      GoRoute(
        path: '/dashboard_rt',
        builder: (context, state) => const DashboardRTRW(), // Halaman utama
      ),
      GoRoute(
        path: '/dashboard_rw',
        builder: (context, state) => const DashboardRW(), // Halaman utama
      ),
    ],
  );
}
