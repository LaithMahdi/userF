import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key});

  Future<void> signUp(String name, String firstName, String address, String phoneNumber, String email, String password, BuildContext context) async {
    if (name.isEmpty || firstName.isEmpty || address.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please fill in all fields.");
      return;
    }

    final url = Uri.parse('http://127.0.0.1:3000/user/registre');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'prenom': firstName,
        'adresse': address,
        'telephone': phoneNumber,
        'email': email,
        'password': password,
        'aime': false,
      }),
    );

    if (response.statusCode == 200) {
      // Afficher une alerte de succès si l'inscription réussit
      _showSuccessDialog(context);
    } else {
      // Afficher une alerte d'échec si l'inscription échoue
      _showErrorDialog(context, "Failed to sign up.");
    }
  }

 void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text('Registration successful.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Ferme l'alerte de succès
              Navigator.pushNamed(context, '/'); // Naviguer vers la page de connexion
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                hintText: "Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Color(0xff19143b).withOpacity(0.1),
                                filled: true,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                                hintText: "First Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Color(0xff19143b).withOpacity(0.1),
                                filled: true,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                                hintText: "Address",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Color(0xff19143b).withOpacity(0.1),
                                filled: true,
                                prefixIcon: const Icon(Icons.location_on)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                                hintText: "Phone Number",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Color(0xff19143b).withOpacity(0.1),
                                filled: true,
                                prefixIcon: const Icon(Icons.phone)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Color(0xff19143b).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email)),
                    ),
                    const SizedBox(height: 20),
                    buildPasswordTextField(passwordController, "Password"),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 3),
                  child: ElevatedButton(
                    onPressed: () {
                      signUp(
                        nameController.text,
                        firstNameController.text,
                        addressController.text,
                        phoneNumberController.text,
                        emailController.text,
                        passwordController.text,
                        context,
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xff19143b),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/'); // Naviguer vers la page de connexion
                      },
                      child: const Text("Login", style: TextStyle(color: Color(0xff19143b))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField(TextEditingController controller, String hintText) {
    bool _obscureText = true;
    return TextField(
      controller: controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Color(0xff19143b).withOpacity(0.1),
        filled: true,
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            _obscureText = !_obscureText;
          },
        ),
      ),
    );
  }
}
