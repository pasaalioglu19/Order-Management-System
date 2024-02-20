import 'package:flutter/material.dart';

class StyledButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final double margin;
  final int flex;

  const StyledButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.margin = 5,    // varsayılan margin değeri
    this.flex = 0,      // varsayılan flex değeri
  }) : super(key: key);

  @override
  State<StyledButton> createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton> {
  @override
  Widget build(BuildContext context) {
    const Color buttonColor =  Color(0xFFC6D2C4);
    const Color borderColor =  Color(0xFF447057);

    return Expanded(
      flex: widget.flex,
      child: Container(
        margin: EdgeInsets.all(widget.margin),  // Butonların etrafındaki boşluk
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            primary: buttonColor,               // Butonun arka plan rengi
            onPrimary: Colors.black,          // Butonun yazı rengi
            side: BorderSide(color: borderColor, width: 1.0),               // Çerçeve rengi ve kalınlığı
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),                      // Yuvarlak kenarlar
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),    // İç boşluk
            elevation: 0,                       // Gölge kaldırıldı
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
