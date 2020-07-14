import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
    final double height;
    final double width;
    final Widget child;
    final Color color;
    final EdgeInsets padding;
    TopContainer({this.height, this.width, this.child, this.color, this.padding});

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: padding!=null ? padding : EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                color: color,
                // borderRadius: BorderRadius.only(
                //     bottomRight: Radius.circular(20.0),
                //     bottomLeft: Radius.circular(20.0),
                // ),
                boxShadow: [
                    BoxShadow(
                        // color: Colors.grey.withOpacity(0.5),
                        color: Colors.black87.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1), // changes position of shadow
                    ),
                ]
            ),
            height: height,
            width: width,
            child: child,
        );
    }
}
