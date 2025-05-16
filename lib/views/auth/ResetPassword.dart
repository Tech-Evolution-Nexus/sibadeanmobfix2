import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart'; // asumsi kamu pakai go_router

class ResetPassword extends StatefulWidget {
  final String token;
  final String email;

  const ResetPassword({
    Key? key,
    required this.token,
    required this.email,
  }) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final url =
        'http://192.168.100.205:8000/reset-password/${widget.token}?email=${Uri.encodeComponent(widget.email)}&from=app';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PasswordResetSuccess',
        onMessageReceived: (message) {
          // Terima pesan dari JS Laravel -> langsung tutup WebView dan redirect ke login Flutter
          if (message.message == 'done') {
            if (mounted) {
              Navigator.of(context).pop(); // tutup WebView
              context
                  .go('/login'); // arahkan ke halaman login (gunakan go_router)
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
