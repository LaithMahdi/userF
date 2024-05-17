import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  const AuthInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.suffix,
      this.prefix,
      this.keyboardType,
      this.validator,
      this.obscure,
      this.readOnly,
      this.maxLines,
      this.isSecond});

  final String hintText;
  final TextEditingController controller;
  final Widget? suffix, prefix;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final bool? obscure;
  final bool? readOnly;
  final int? maxLines;
  final bool? isSecond;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      obscureText: obscure ?? false,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: "Poppins",
        color: Colors.blueGrey,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins",
          color: Colors.blueGrey,
        ),
        errorStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: Colors.red[400],
        ),
        contentPadding:
            EdgeInsets.all(isSecond == null || isSecond == false ? 17 : 12),
        fillColor: isSecond == null || isSecond == false
            ? Colors.grey[100]
            : Colors.grey[200],
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              isSecond == null || isSecond == false ? 10 : 5),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              isSecond == null || isSecond == false ? 10 : 5),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              isSecond == null || isSecond == false ? 10 : 5),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              isSecond == null || isSecond == false ? 10 : 5),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
        ),
        suffixIcon: suffix ?? const SizedBox(),
        prefixIcon: prefix ?? const SizedBox(),
      ),
    );
  }
}
