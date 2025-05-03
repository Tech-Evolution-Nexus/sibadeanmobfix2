import 'package:flutter/material.dart';

class GantiEmailPage extends StatelessWidget {
  const GantiEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: "mnorkholit7@gmail.com");

    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Harap masukkan alamat email baru untuk\nmemperbarui informasi Anda"),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900]),
                child: const Text("Ubah Email"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
