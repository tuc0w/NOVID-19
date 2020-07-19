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
    final int _maxPercentInSeconds = 900;
    final int _warningThreshold = 300;
    final int _dangerThreshold = 600;

    RenderActivity(this._context, this._contactsWithNotifications);

    List<Widget> _buildLoadingColumn() {
        List<Widget> _activityRows = _buildActivityRows(_contactsWithNotifications);

        if (_activityRows.isEmpty) {
            return <Widget>[
                Text(AppLocalizations.of(_context).translate('NO_ACTIVE_CONTACTS'))
            ];
        }

        return _activityRows;
    }

    Widget _buildActivityColumn() {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildLoadingColumn()
        );
    }

    List<Widget> _buildActivityRows(List<ContactWithNotifications> contactsWithNotifications) {
        List rows = new List<Widget>();
        List cards = new List<Widget>();

        contactsWithNotifications.forEach((element) {
            if (element.notifications.isNotEmpty) {
                final firstNotificationDate = element.notifications.first.date;
                final lastNotificationDate = element.notifications.last.date;
                Duration difference = lastNotificationDate.difference(firstNotificationDate);

                if (difference.inSeconds >= 180) {
                    final rssiToContact = {for (var notification in element.notifications) notification.id: notification.rssi};
                    final rssis = rssiToContact.values;
                    final int averageRssi = (rssis.reduce((a, b) => a + b) / rssis.length).round();
                    final double averageDistance = roundDouble(calculateDistance(averageRssi), 2);
                    final double percentIndicator = (1/_maxPercentInSeconds) * difference.inSeconds;
                    Color progressIndicatorColor = DarkColors.success;

                    if (difference.inSeconds >= _dangerThreshold) {
                        progressIndicatorColor = DarkColors.danger;
                    } else if (difference.inSeconds >= _warningThreshold) {
                        progressIndicatorColor = DarkColors.warning;
                    }

                    cards.add(
                        new ActivityCard(
                            cardColor: DarkColors.secondary,
                            progressPrimaryColor: progressIndicatorColor,
                            progressSecondaryColor: DarkColors.primary,
                            loadingPercent: percentIndicator,
                            loadingText: "${formatDuration(difference)}",
                            title:  AppLocalizations.of(_context).translate('AVERAGE_DISTANCE'),
                            subtitle: '$averageDistance m',
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
            } else if (i == cards.length-1 || cards.length == 1) {
                rows.add(
                    Row(
                        children: <Widget>[
                            tempCards.first,
                        ],
                    )
                );
                tempCards.clear();
            }
        }

        return rows;
    }

    @override
    Widget build(BuildContext context) {
        return _buildActivityColumn();
    }
}