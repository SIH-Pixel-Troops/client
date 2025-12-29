import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar_suraksha/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TouristSafetyApp());
}

class TouristSafetyApp extends StatelessWidget {
  const TouristSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safar Suraksha',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.redAccent,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
