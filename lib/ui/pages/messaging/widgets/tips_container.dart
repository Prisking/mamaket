import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';

class TipsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed("/tips-screen"),
      child: Container(
        width: double.infinity,
        color: kLightBlue,
        padding: EdgeInsets.all(8.0),
        child: Text("Chat Security Tips", textAlign: TextAlign.center),
      ),
    );
  }
}
