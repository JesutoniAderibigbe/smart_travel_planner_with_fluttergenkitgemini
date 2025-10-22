import 'package:flutter/material.dart';

class Coolbutton extends StatelessWidget {
  const Coolbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return coolButton();
  }
}

Widget coolButton() {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
    child: Text('Cool Button'),
  );
}
