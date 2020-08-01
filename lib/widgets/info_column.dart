import 'package:CoTrack/theme/colors/dark_colors.dart';
import 'package:flutter/material.dart';

class InfoColumn extends StatelessWidget {
    final IconData icon;
    final Color iconBackgroundColor;
    final String title;
    final String subtitle;

    InfoColumn({
        this.icon,
        this.iconBackgroundColor,
        this.title,
        this.subtitle,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
                color: DarkColors.secondary,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black45.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6
                    ),
                ]
            ),
            height: 80,
            child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    CircleAvatar(
                        radius: 20.0,
                        backgroundColor: iconBackgroundColor,
                        child: Icon(
                            icon,
                            size: 24.0,
                            color: Colors.white,
                        ),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                                title,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white
                                ),
                            ),
                            Text(
                                subtitle,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),
                            ),
                        ],
                    )
                ],
            )
        );
    }
}