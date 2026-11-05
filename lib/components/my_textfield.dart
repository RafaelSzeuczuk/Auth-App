import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && hide,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autocorrect: false,
          enableSuggestions: !widget.isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: hide ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(hide ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => hide = !hide),
                  )
                : null,
            hintText: widget.hintText,
          ),
        ),
      );
}
