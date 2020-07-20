import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'subheading.dart';

class CreditsRow extends StatelessWidget {
    final Color color;
    final String text;
    final String github;
    final String instagram;
    final String linkedIn;
    final String twitter;
    final String url;
    final String xing;

    CreditsRow({
        @required this.color,
        @required this.text,
        this.github,
        this.instagram,
        this.linkedIn,
        this.twitter,
        this.url,
        this.xing
    });

    List<Widget> _createSocialLinks() {
        Map<String, String> socialLinks = {
            'github': github,
            'instagram': instagram,
            'linkedIn': linkedIn,
            'twitter': twitter,
            'url': url,
            'xing': xing
        };

        List<Widget> rows = <Widget>[];

        socialLinks.forEach((key, value) {
            if (value != null) {
                FaIcon socialIcon;
                String socialLink;

                switch (key) {
                    case 'github':
                        socialIcon = FaIcon(FontAwesomeIcons.github, color: Colors.white);
                        socialLink = "https://github.com/$value";
                        break;
                    case 'instagram':
                        socialIcon = FaIcon(FontAwesomeIcons.instagram, color: Colors.white);
                        socialLink = "https://instagram.com/$value";
                        break;
                    case 'linkedIn':
                        socialIcon = FaIcon(FontAwesomeIcons.linkedin, color: Colors.white);
                        socialLink = "https://de.linkedin.com/in/$value";
                        break;
                    case 'twitter':
                        socialIcon = FaIcon(FontAwesomeIcons.twitter, color: Colors.white);
                        socialLink = "https://twitter.com/$value";
                        break;
                    case 'url':
                        socialIcon = FaIcon(FontAwesomeIcons.link, color: Colors.white);
                        socialLink = value;
                        break;
                    case 'xing':
                        socialIcon = FaIcon(FontAwesomeIcons.xing, color: Colors.white);
                        socialLink = "https://www.xing.com/profile/$value/portfolio";
                        break;
                    default:
                }

                rows.add(
                    IconButton(
                        icon: socialIcon,
                        onPressed: () async {
                            if (await canLaunch(socialLink)) {
                                await launch(socialLink);
                            } else {
                                throw 'Could not launch $socialLink';
                            }
                        }
                    )
                );
            }
        });

        return rows;
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: Divider(
                                        color: Colors.white,
                                    )
                                ),
                            ),
                            Subheading(color: Colors.white, title: text),
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Divider(
                                        color: Colors.white,
                                    )
                                ),
                            ),
                        ],
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _createSocialLinks(),
                    )
                ],
            ),
        );
    }
}
