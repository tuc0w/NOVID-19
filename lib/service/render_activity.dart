import 'package:flutter/material.dart';
import 'package:NOVID_19/data/database.dart';
import 'package:NOVID_19/helper/localization.dart';
import 'package:NOVID_19/helper/math.dart';
import 'package:NOVID_19/helper/time.dart';
import 'package:NOVID_19/theme/colors/dark_colors.dart';
import 'package:NOVID_19/widgets/activity_card.dart';

class RenderActivity extends StatelessWidget {
    final BuildContext _context;
    final List<ContactWithNotifications> _contactsWithNotifications;

    RenderActivity(this._context, this._contactsWithNotifications);

    Text subheading(String title) {
        return Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
        );
    }

    Widget _buildHeadlineRow() {
        return Row(
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
                subheading(AppLocalizations.of(_context).translate('ACTIVE_CONTACTS')),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Divider(
                            color: Colors.white,
                        )
                    ),
                ),
            ],
        );
    }

    Widget _buildActivityColumn(List<ContactWithNotifications> contactsWithNotifications) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildActivityRows(contactsWithNotifications)
        );
    }

    List<Widget> _buildActivityRows(List<ContactWithNotifications> contactsWithNotifications) {
        List rows = new List<Widget>();
        List cards = new List<Widget>();

        rows.add(SizedBox(height: 25.0));
        rows.add(_buildHeadlineRow());
        rows.add(SizedBox(height: 15.0));

        contactsWithNotifications.forEach((element) {
            if (element.notifications.isNotEmpty) {
                final firstNotificationDate = element.notifications.first.date;
                final lastNotificationDate = element.notifications.last.date;

                Duration difference = lastNotificationDate.difference(firstNotificationDate);
                print("Contact with ${element.contact.identifier} for ${difference.inSeconds} seconds");

                if (difference.inSeconds >= 180) {
                    final rssiToContact = {for (var notification in element.notifications) notification.id: notification.rssi};
                    final rssis = rssiToContact.values;
                    final int averageRssi = (rssis.reduce((a, b) => a + b) / rssis.length).round();
                    final double averageDistance = roundDouble(calculateDistance(averageRssi), 2);

                    cards.add(
                        new ActivityCard(
                            cardColor: DarkColors.secondary,
                            progressPrimaryColor: DarkColors.success,
                            progressSecondaryColor: DarkColors.primary,
                            loadingPercent: 0.39,
                            title: '${element.contact.identifier}',
                            subtitle: "${formatDuration(difference)} / $averageDistance m",
                        )
                    );
                }
            }
        });

        List tempCards = new List<Widget>();
        for (var i = 0; i < cards.length; i++) {
            tempCards.add(cards[i]);
            if (tempCards.isNotEmpty && tempCards.length % 2 == 0) {
                rows.add(
                    Row(
                        children: <Widget>[
                            tempCards.first,
                            SizedBox(
                                width: 20.0
                            ),
                            tempCards.last,
                        ],
                    )
                );
                tempCards.clear();
            } else if (i == cards.length || cards.length == 1) {
                rows.add(
                    Row(
                        children: <Widget>[
                            tempCards.first,
                        ],
                    )
                );
                tempCards.clear();
                // return rows;
            }
        }

        return rows;
    }

    Widget _buildContainer(List<ContactWithNotifications> contactsWithNotifications) {
        return Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 10.0
            ),
            child: _buildActivityColumn(contactsWithNotifications)
        );
    }

    @override
    Widget build(BuildContext context) {
        return _buildContainer(_contactsWithNotifications);
    }
}