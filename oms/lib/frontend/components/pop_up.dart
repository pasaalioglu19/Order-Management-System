import 'package:flutter/material.dart';

class PopUpTitle extends StatelessWidget {
  final String labelText;

  const PopUpTitle({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              height: 30.0,
              color: Color.fromARGB(255, 158, 154, 154),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            labelText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              height: 30.0,
              color: Color.fromARGB(255, 158, 154, 154),
            ),
          ),
        ),
      ],
    );
  }
}

class PopUp extends StatefulWidget {
  final String labelText;
  final Widget bodyPart; 
  final List<Widget> buttonPart; 
  
  const PopUp({
    Key? key,
    required this.labelText,
    required this.bodyPart,
    required this.buttonPart,
  }) : super(key: key);

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column( 
        children: <Widget>[
          // Close button part
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          // Title part
          PopUpTitle(labelText: widget.labelText),
          const SizedBox(height: 20.0),
          // Body part
          Expanded(
            child: widget.bodyPart,
          ),
          // Button part
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.buttonPart,
            ),
          ),
        ],
      ),
    );
  }
}
