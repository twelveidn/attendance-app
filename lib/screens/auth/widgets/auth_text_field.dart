// ignore: deprecated_member_use
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.isPassword = false,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool isPassword;
  final TextInputAction? textInputAction;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _obscureText,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _obscureText
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
    );
  }
}
