import 'package:flutter/material.dart';

class LogoColumn extends StatelessWidget {
    final String image;
    final Color imageBackgroundColor;
    final String title;
    final String subtitle;

    LogoColumn({
        this.image,
        this.imageBackgroundColor,
        this.title,
        this.subtitle,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                CircleAvatar(
                    radius: 27.0,
                    backgroundColor: imageBackgroundColor,
                    child: Image(
                        image: AssetImage(image)
                    ),
                ),
                SizedBox(width: 6.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Text(
                            title,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            ),
                        ),
                        Text(
                            subtitle,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white
                            ),
                        ),
                    ],
                )
            ],
        );
    }
}
