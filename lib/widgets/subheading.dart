import 'package:flutter/material.dart';

class Subheading extends StatelessWidget {
    final Color color;
    final String title;

    Subheading({
        this.color,
        this.title
    });

    @override
    Widget build(BuildContext context) {
        return Text(
            title,
            style: TextStyle(
                color: color,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2
            ),
        );
    }
}
