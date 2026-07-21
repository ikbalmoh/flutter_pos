import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    super.key,
    this.controller,
    required this.label,
    this.isRequired = false,
    this.labelStyle,
    this.initialValue,
    this.onChange,
    this.inputType = TextInputType.text,
    this.validator,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController? controller;
  final String label;
  final bool? isRequired;
  final TextStyle? labelStyle;
  final String? initialValue;
  final ValueChanged<String>? onChange;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final int? maxLines, minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChange,
      keyboardType: inputType,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        label: Text.rich(
          TextSpan(
            text: label,
            style: labelStyle,
            children: [
              TextSpan(
                text: isRequired ?? false ? ' *' : '',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.all(10),
        focusColor: Colors.teal,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey.shade100,
          width: 1,
        )),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
          width: 1,
        )),
      ),
    );
  }
}
