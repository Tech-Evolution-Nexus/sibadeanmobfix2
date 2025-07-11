import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? labelText;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final IconData? icon; // Tambahkan parameter ikon
  final Color? iconColor;

  const CustomDropdownField({
    Key? key,
    required this.items,
    required this.value,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.validator,
    this.icon, // Tambahkan parameter ikon
    this.iconColor,
  }) : super(key: key);

  @override
  _CustomDropdownFieldState<T> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        value: _selectedValue,
        items: widget.items,
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon,
                  color: widget.iconColor ?? const Color.fromRGBO(5, 3, 88, 1))
              : null, // Tambahkan ikon di sini
          contentPadding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.04, vertical: deviceWidth * 0.035),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromRGBO(5, 3, 88, 1), width: 2),
          ),
        ),
      ),
    );
  }
}
