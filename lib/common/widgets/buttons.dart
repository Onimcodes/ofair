import 'package:flutter/material.dart';

class HighlightButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const HighlightButton({
    required this.text,
    required this.onPressed,

    });

  @override
  Widget build(BuildContext context) {
    return  FilledButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          48.0
        )
      )
      ,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}