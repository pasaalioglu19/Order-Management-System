import 'package:flutter/material.dart';

class FormBox extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final AlignmentGeometry alignment;
  final BoxConstraints constraints;
  final EdgeInsetsGeometry margin;

  const FormBox({
    Key? key,
    required this.controller,
    required this.labelText,
    this.alignment = Alignment.centerRight,
    this.constraints = const BoxConstraints(maxWidth: 150.0, maxHeight: 50.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 30.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        constraints: constraints,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromRGBO(209, 209, 209, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), //input header horizontality
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Color(0xFF0A6C0E),
                height: 4.5,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: -20.0),
            ),
          ),
        ),
      ),
    );
  }
}
