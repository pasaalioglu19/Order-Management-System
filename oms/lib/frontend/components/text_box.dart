import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String labelText;
  final AlignmentGeometry alignment;
  final BoxConstraints constraints;
  final EdgeInsetsGeometry margin;
  final double fontSize;
  final Color color;

  const TextBox({
    Key? key,
    required this.labelText,
    this.alignment = Alignment.centerRight,
    this.fontSize = 16.0,
    this.constraints = const BoxConstraints(maxWidth: 250.0, maxHeight: 40.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 0.0),
    this.color = const Color.fromRGBO(209, 209, 209, 1),
    
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
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Text(
              style: TextStyle(color: Colors.black, fontSize: fontSize),
              labelText,
            ),
          ),
        ),
      ),
    );
  }
}
