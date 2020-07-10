import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight = 50.0;

  const MainAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + barHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      shape: CustomShapeBorder(),
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            "Lenny Face Keyboard",
            style: TextStyle(fontSize: 20),
          ),

        ],
      ),
      actions: <Widget>[

      ],
    );
  }
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path path = Path();
    final point = rect.height - 30;

    path.lineTo(0, point);
    path.quadraticBezierTo(rect.width / 2, rect.height, rect.width, point);
    path.lineTo(rect.width, 0);
    path.close();

    return path;
  }
}
