import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.nameController,
    required this.labelText,
    this.isPassword = false,
    this.validator,
  });

  final TextEditingController nameController;
  final String labelText;
  final bool isPassword;
  final String? Function(String?)? validator;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText;

  void _validate(String value) {
    setState(() {
      _errorText = widget.validator?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.nameController,
          obscureText: widget.isPassword ? _obscureText : false,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
            filled: true,
            fillColor: const Color.fromARGB(255, 27, 27, 32),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          onChanged: _validate,
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              _errorText!,
              style: TextStyle(color: Colors.red.shade400, fontSize: 14),
            ),
          ),
      ],
    );
  }
}