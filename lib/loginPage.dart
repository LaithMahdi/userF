import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user/core/constant/app_cache.dart';

import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (AppCache().getToken().isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['mytoken'];

        // Stocker le token localement
        AppCache().setToken(token);

        // Extraire le userId du token
        String userId = _extractUserIdFromToken(token);
        AppCache().setUserId(userId);

        // Afficher l'ID de l'utilisateur dans la console
        print('--------------User ID ------------ $userId');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      } else {
        setState(() {
          _errorMessage = 'Error occurred';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
  }

  String _extractUserIdFromToken(String token) {
    try {
      List<String> tokenParts = token.split('.');
      String payload = tokenParts[1];

      // Ajouter des caractères de remplissage '=' si nécessaire
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      String decodedPayload = utf8.decode(base64Url.decode(payload));
      Map<String, dynamic> payloadMap = json.decode(decodedPayload);
      return payloadMap['_id'];
    } catch (e) {
      print('Error extracting user ID from token: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(context),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: const Color(0xff19143b).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: const Color(0xff19143b).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          obscureText: _obscureText,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xff19143b),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup'); // Navigate to SignupPage
          },
          child:
              const Text("Sign Up", style: TextStyle(color: Color(0xff19143b))),
        ),
      ],
    );
  }
}
