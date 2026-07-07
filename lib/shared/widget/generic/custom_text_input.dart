import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    super.key,
    this.controller,
    required this.label,
    this.labelStyle,
    this.initialValue,
    this.onChange,
  });

  final TextEditingController? controller;
  final String label;
  final TextStyle? labelStyle;
  final String? initialValue;
  final ValueChanged<String>? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: (value) => onChange,
      decoration: InputDecoration(
        label: Text(
          label,
          style: labelStyle,
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.all(10),
        focusColor: Colors.teal,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
          width: 1,
        )),
      ),
    );
  }
}
