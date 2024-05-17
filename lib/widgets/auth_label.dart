import 'package:flutter/material.dart';

class AuthLabel extends StatelessWidget {
  const AuthLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey[700],
        ),
      ),
    );
  }
}
