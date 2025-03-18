import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'welcome_page.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCbUe4UB-FYqlM7_uvfjG9ZHslXPmpO3Qc",
      authDomain: "stressai-653aa.firebaseapp.com",
      projectId: "stressai-653aa",
      storageBucket: "stressai-653aa.firebasestorage.app",
      messagingSenderId: "380210262564",
      appId: "1:380210262564:android:2f17a20842445e9b521eb1",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login App',
      theme: lightMode,
      home: const WelcomePage(),
    );
  }
}
