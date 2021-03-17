import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamaket/constants/constants.dart';

class GeometryCheck extends StatelessWidget {
  const GeometryCheck({
    Key key,
  }) : super(key: key);

  static final userData = Hive.box("userData");

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userData.listenable(),
      builder: (context, box, _) {
        if (box.get("user").geometry == null) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/update-region");
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.orangeAccent,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: Text(
                  kGeometryCheck,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
