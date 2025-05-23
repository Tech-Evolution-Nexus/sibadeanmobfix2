import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool readOnly;
  final int? maxLength;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.readOnly = false,
    this.validator,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_scrollToField);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_scrollToField);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToField() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        obscuringCharacter: '*',
        validator: widget.validator,
        focusNode: _focusNode, // Tambahkan FocusNode
        style: TextStyle(fontSize: deviceWidth * 0.03),

        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon,
                  color: const Color.fromARGB(255, 3, 6, 71))
              : null,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  onPressed: widget.onSuffixPressed,
                )
              : null,
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: TextStyle(fontSize: 14),
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.04, vertical: deviceWidth * 0.035),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
