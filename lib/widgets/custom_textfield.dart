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
  final String? Function(String?)? validator; // Custom validator function

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText; // Holds the error message

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
            fillColor: Color.fromARGB(255, 27, 27, 32), // Background color
            border: InputBorder.none, // Removes border
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
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
                : null, // Only show icon for password fields
          ),
          onChanged: _validate, // Validate input on change
        ),
        if (_errorText != null) // Show error message if not null
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
