import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Email: ${auth.user?.email ?? "Guest"}'),
            const SizedBox(height: 20),
            if (auth.user != null)
              ElevatedButton(
                onPressed: () => context.read<AuthProvider>().logout(context),
                child: const Text('Logout'),
              ),
          ],
        ),
      ),
    );
  }
}
