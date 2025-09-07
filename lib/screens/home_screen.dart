import 'package:flutter/material.dart';
import 'id_wallet_screen.dart';
import 'dashboard_screen.dart';
import 'panic_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tourist Safety App"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.badge), text: "ID Wallet"),
              Tab(icon: Icon(Icons.shield), text: "Dashboard"),
              Tab(icon: Icon(Icons.sos), text: "Panic"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IdWalletScreen(),
            DashboardScreen(),
            PanicScreen(),
          ],
        ),
      ),
    );
  }
}
