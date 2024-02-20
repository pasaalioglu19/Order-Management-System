import 'package:flutter/material.dart';

class AddAttribute extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final String buttonText;

  const AddAttribute({
    Key? key,
    required this.padding,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: padding,
            child: const Divider(
              height: 30.0,
              color: Color.fromARGB(255, 158, 154, 154),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 35.0, 0.0),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Color(0xFF0A6C0E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}