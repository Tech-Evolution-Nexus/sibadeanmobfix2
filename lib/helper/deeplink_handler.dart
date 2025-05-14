import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  static const MethodChannel _channel = MethodChannel('com.example.sibadeanmob_v2_fix/deep_link');

  static Future<void> initDeepLinkListener(GoRouter router) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'deepLink') {
        final token = call.arguments as String?;
        if (token != null && token.isNotEmpty) {
          router.go('/reset-password?token=$token');
        }
      }
    });
  }
}
