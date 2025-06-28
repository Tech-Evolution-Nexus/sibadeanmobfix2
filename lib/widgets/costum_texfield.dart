import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField(
      {super.key,
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
      this.onTap,
      this.maxLines = 1,
      this.errorText = null});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        onTap: widget.onTap,
        obscuringCharacter: '*',
        validator: widget.validator,
        focusNode: _focusNode,
        style: TextStyle(fontSize: deviceWidth * 0.03),
        decoration: InputDecoration(
          errorText: widget.errorText,
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
          labelStyle: const TextStyle(fontSize: 14),
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04,
            vertical: deviceWidth * 0.035,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color:
                  Theme.of(context).primaryColor, // <- warna border saat fokus
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
