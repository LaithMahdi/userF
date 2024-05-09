import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'signupPage.dart'; // Importer la page SignupPage.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Définir la route initiale
      routes: {
        '/': (context) => LoginPage(), // Route pour la LoginPage
        '/signup': (context) => SignupPage(), // Route pour la SignupPage
      },
    );
  }
}
