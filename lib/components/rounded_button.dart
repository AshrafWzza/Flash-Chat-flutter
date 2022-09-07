import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final String textButton;
  const RoundedButton(
      {Key? key,
      required this.color,
      required this.onPressed,
      required this.textButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // maximumSize: const Size(50.0, 50.0),
          elevation: 5.0,
          primary: color,
          padding: const EdgeInsets.all(16.0),
          // side: BorderSide(width: 5.0, color: Colors.red),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
        ),
        onPressed: onPressed,
        child: Text(
          textButton,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      /*child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            textButton,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),*/
    );
  }
}
