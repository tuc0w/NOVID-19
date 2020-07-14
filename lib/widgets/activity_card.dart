import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActivityCard extends StatelessWidget {
    final Color cardColor;
    final double loadingPercent;
    final String title;
    final String subtitle;

    ActivityCard({
        this.cardColor,
        this.loadingPercent,
        this.title,
        this.subtitle,
    });

    @override
    Widget build(BuildContext context) {
        return Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(15.0),
                height: 180,
                decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircularPercentIndicator(
                                animation: true,
                                radius: 75.0,
                                percent: loadingPercent,
                                lineWidth: 5.0,
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: Colors.white10,
                                progressColor: Colors.white,
                                center: Text(
                                    '${(loadingPercent*100).round()}%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                            ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                    ),
                                ),
                                Text(
                                    subtitle,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w400,
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }
}
