import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: const Column(
          children: [
            // ✅ TAB BAR (VISIBLE ON WEB)
            Material(
              color: Colors.transparent,
              child: TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Foreign'),
                  Tab(text: 'DigiLocker'),
                  Tab(text: 'Email'),
                ],
              ),
            ),

            // ✅ TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  _ForeignTab(),
                  _DigiLockerTab(),
                  _EmailTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForeignTab extends StatelessWidget {
  const _ForeignTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'Visa Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _DigiLockerTab extends StatelessWidget {
  const _DigiLockerTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        icon: const Icon(Icons.lock),
        label: const Text('Login with DigiLocker'),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        },
      ),
    );
  }
}

class _EmailTab extends StatefulWidget {
  const _EmailTab();

  @override
  State<_EmailTab> createState() => _EmailTabState();
}

class _EmailTabState extends State<_EmailTab> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> login() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() => error = e.toString());
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading ? null : login,
            child: loading
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
        ],
      ),
    );
  }
}
