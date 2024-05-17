import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/widgets/auth_input.dart';
import 'package:user/widgets/auth_label.dart';
import 'package:user/widgets/primary_button.dart';
import 'utils/validation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      signUp();
    }
  }

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('http://10.0.2.2:3000/user/registre');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': nameController.text,
        'prenom': firstNameController.text,
        'adresse': addressController.text,
        'telephone': phoneNumberController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'aime': false,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      _showSuccessDialog(context);
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(context, "Failed to sign up.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration successful.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const SizedBox(height: 30.0),
            const Text(
              "Sign up",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Create your account",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            const AuthLabel("Last Name"),
            AuthInput(
              hintText: "e.g. John",
              controller: nameController,
              prefix: const Icon(Icons.person),
              validator: (value) => validString(value),
            ),
            const SizedBox(height: 20),
            const AuthLabel("First Name"),
            AuthInput(
              hintText: "e.g. Doe",
              controller: firstNameController,
              prefix: const Icon(Icons.person),
              validator: (value) => validString(value),
            ),
            const SizedBox(height: 20),
            const AuthLabel("Email"),
            AuthInput(
              hintText: "e.g. xyz@mail.com",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(Icons.email),
              validator: (value) => validEmail(value),
            ),
            const SizedBox(height: 20),
            const AuthLabel("Address"),
            AuthInput(
              hintText: "e.g. 1234, rue de la rue",
              controller: addressController,
              prefix: const Icon(Icons.location_on),
              validator: (value) => validAdresse(value),
            ),
            const SizedBox(height: 20),
            const AuthLabel("Phone Number"),
            AuthInput(
              hintText: "e.g. 12345678",
              controller: phoneNumberController,
              prefix: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (value) => validPhoneNum(value),
            ),
            const SizedBox(height: 20),
            const AuthLabel("Password"),
            AuthInput(
              hintText: "e.g. ********",
              controller: passwordController,
              prefix: const Icon(Icons.password),
              validator: (value) => validPassword(value),
            ),
            const SizedBox(height: 20),
            const AuthLabel("Confirm Password"),
            AuthInput(
              hintText: "e.g. ********",
              controller: confirmPasswordController,
              prefix: const Icon(Icons.password),
              validator: (value) =>
                  validConfirmPassword(value, passwordController.text),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(text: "Sign up", onPressed: onSubmit),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  child: const Text("Login",
                      style: TextStyle(color: Color(0xff19143b))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
